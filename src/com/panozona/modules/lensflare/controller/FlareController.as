/*
Copyright 2012 Igor Zevako.

This file is part of SaladoPlayer.

SaladoPlayer is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published
by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.

SaladoPlayer is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty
of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with SaladoPlayer. If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.modules.lensflare.controller {
	
	import com.panozona.modules.lensflare.view.FlareView;
	import com.panozona.player.module.Module;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	public class FlareController {
		
		private var positions:Vector.<Number>;
		protected var _maxFlaresDistance:Number = 20;
		protected var _fadeDistance:int = 50;
		
		private var _flareView:FlareView;
		private var _module:Module;
		
		public function FlareController(flareView:FlareView, module:Module) {
			_flareView = flareView;
			_module = module;
			
			positions = new Vector.<Number>();
			
			var loader:Loader = new Loader(); 
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLost, false, 0, true);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded, false, 0, true);
			loader.load(new URLRequest(_flareView.flareData.flare.path));
		}
		
		public function imageLost(e:IOErrorEvent):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, imageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, imageLoaded);
			_module.printError("Unable to load: " + _flareView.flareData.flare.path);
		}
		
		private function imageLoaded(e:Event):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, imageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, imageLoaded);
			var bitmapData:BitmapData = new BitmapData((e.target as LoaderInfo).width, (e.target as LoaderInfo).height, true, 0);
			bitmapData.draw((e.target as LoaderInfo).content);
			
			var cellsCount:Number = Math.round((bitmapData.width) / (bitmapData.height));
			var cellSide:int = bitmapData.height;
			
			for (var i:int = 0; i < cellsCount; i++) {
				var flareBmData:BitmapData = new BitmapData(cellSide, cellSide, true, 0);
				flareBmData.copyPixels(bitmapData, new Rectangle((cellSide * i + i), 0, cellSide, cellSide), new Point(0, 0), null, null, true);
				var flare:Bitmap = new Bitmap(flareBmData, "auto", true);
				flare.alpha = 0;
				_flareView.addChild(flare);
			}
			if (_flareView.flareData.flare.positions == null) {
				var minPos:Number = 0.5;
				var maxPos:Number = 2.5;
				for (var j:int = 0; j < cellsCount; j++) {
					positions[j] = minPos + (maxPos - minPos) / cellsCount * j;
				}
			} else {
				for each(var position:String in _flareView.flareData.flare.positions.split("|")) {
					positions.push(position);
				}
			}
			_module.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		}
		
		private function onEnterFrame(event:Event):void {
			var panDist:Number = Math.abs(_module.saladoPlayer.manager._pan - _flareView.flareData.flare.location.pan);
			if (panDist > 180) {
				panDist = 360 - panDist;
			}
			var _fDistance:Number = Math.sqrt(Math.pow(panDist, 2) 
				+ Math.pow(Math.abs(_module.saladoPlayer.manager._tilt - _flareView.flareData.flare.location.tilt), 2));
				
			var level:Number = _flareView.flareData.flare.brightness.level;
			var distance:Number = _flareView.flareData.flare.brightness.distance;
			if (_fDistance == 0) {
				_flareView.flareData.brightness = level;
			} else if(_fDistance <= distance) {
				_flareView.flareData.brightness = level - Math.round(_fDistance * level / distance);
			} else {
				if (_flareView.flareData.brightness != 0) {
					_flareView.flareData.brightness = 0;
				}
			}
			
			var fx:int = panToX(_flareView.flareData.flare.location.pan);
			var fy:int = tiltToY(_flareView.flareData.flare.location.tilt);
			var w:int = _module.saladoPlayer.manager.boundsWidth;
			var h:int = _module.saladoPlayer.manager.boundsHeight;
			var fDistanceToBounds:int = Math.max(0, Math.round(Math.min(fx, fy, (w - fx), (h - fy))));
			if (fx <= w && fx > 0 && fy <= h && fy > 0) {
				_flareView.visible = true;
				for (var i:int = 0; i < _flareView.numChildren; i++) {
					var flare:Bitmap = _flareView.getChildAt(i) as Bitmap;
					var flarePan:Number = validatePanTilt(_flareView.flareData.flare.location.pan 
						+ validatePanTilt(_module.saladoPlayer.manager._pan - _flareView.flareData.flare.location.pan) * positions[i]);
					var flareTilt:Number = validatePanTilt(_flareView.flareData.flare.location.tilt 
						+ validatePanTilt(_module.saladoPlayer.manager._tilt - _flareView.flareData.flare.location.tilt) * positions[i]);
					flare.x = panToX(flarePan) - flare.width * 0.5
					flare.y = tiltToY(flareTilt) - flare.height * 0.5
					if (fDistanceToBounds <= _fadeDistance) {
						flare.alpha = fDistanceToBounds / _fadeDistance;
					} else {
						if (_fDistance <= _maxFlaresDistance) {
							flare.alpha = _fDistance / _maxFlaresDistance;
						} else {
							flare.alpha = 1;
						}
					}
				}
			} else {
				_flareView.visible = false;
			}
		}
		
		private function panToX(pan:Number):Number {
			var w:Number = _module.saladoPlayer.manager.boundsWidth;
			var cPan:Number = _module.saladoPlayer.manager._pan;
			var fov:Number = _module.saladoPlayer.manager._fieldOfView;
			pan = validatePanTilt(pan);
			if (inAngleBounds(pan, validatePanTilt(cPan - fov / 2), validatePanTilt(cPan + fov / 2))) {
				return Math.round( w * 0.5 + (Math.tan((pan - cPan) * __toRadians) * w * 0.5) /
					(Math.tan(fov * 0.5 * __toRadians)));
			} else {
				return -99999;
			}
		}
		
		private function tiltToY(tilt:Number):Number {
			var w:Number = _module.saladoPlayer.manager.boundsWidth;
			var h:Number = _module.saladoPlayer.manager.boundsHeight;
			var cTilt:Number = _module.saladoPlayer.manager._tilt;
			var fov:Number = _module.saladoPlayer.manager._fieldOfView;
			var vFov:Number = __toDegrees * 2 * Math.atan((h / w)
				* Math.tan(__toRadians * 0.5 * fov));
			tilt = validatePanTilt(tilt);
			if (inAngleBounds(tilt, validatePanTilt(cTilt - vFov / 2), validatePanTilt(cTilt + vFov / 2))) {
				return Math.round(h * 0.5 + (Math.tan((cTilt - tilt) * __toRadians) * h * 0.5) /
					(Math.tan(vFov * 0.5 * __toRadians)));
			} else {
				return -99999;
			}
		}
		
		private function inAngleBounds(value:Number, from:Number, to:Number):Boolean {
			if (from > 0 && to < 0) {
				if ((value >= from && value <= 180) || (value >= -180 && value <= to)) {
					return true;
				}
			} else {
				if (value >= from && value <= to) {
					return true; 
				}
			}
			return false;
		}
		
		private function validatePanTilt(value:Number):Number {
			if (value <= -180) value = (((value + 180) % 360) + 180);
			if (value > 180) value = (((value + 180) % 360) - 180);
			return value;
		}
		
		private var __toDegrees:Number = 180 / Math.PI;
		private var __toRadians:Number = Math.PI / 180;
	}
}