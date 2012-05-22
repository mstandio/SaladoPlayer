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
package com.panozona.modules.lensflare{
	
	import com.panozona.player.SaladoPlayer;
	import com.panozona.modules.lensflare.model.*;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	import flash.system.ApplicationDomain;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class LensFlare extends Module {
		
		private var lensFlareData:LensFlareData;
		private var colorTransform:ColorTransform = new ColorTransform();
		private var brightness:int;
		
		private var panoramaEventClass:Class;
		
		/* 
		 * Current panorama data
		 */
		private var fPan:Number;
		private var fTilt:Number;
		private var curPositions:String;
			
		/* 
		 * Panoramas and flares settings
		 */
		protected var _panos:Object = new Object();
		protected var _flares:Array = new Array();
		protected var _flaresLoaded:Boolean = false;
		protected var _flareDefaultPosition:Number = 1;
		
		protected var _flaresLocal:Object = new Object();
		protected var _flaresLocalLoaded:Array = new Array();
		
		protected var _flaresAreShown:Boolean = false;	
		protected var _fDistance:Number = 0;
		protected var _maxFlaresDistance:Number = 20;
		protected var _fadeDistance:int = 50;
		
		/*
		 * Constructor
		 */
		public function LensFlare():void {
			
			super("LensFlare", "1.0", "http://panozona.com/wiki/Module:LensFlare");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			lensFlareData = new LensFlareData(moduleData, saladoPlayer);
			panoramaEventClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			
			// save panoramas settings
			for each (var panorama:Panorama in lensFlareData.panoramas.getChildrenOfGivenClass(Panorama)) {
				_panos[panorama.id] = panorama;
				_flaresLocalLoaded[panorama.id] = false;
			}
			
			mouseEnabled = false;
			
			saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
		}
		
		private function onPanoramaLoaded(e:Event):void {
			var currentPano:String = saladoPlayer.manager.currentPanoramaData.id;
			if (_panos[currentPano]) {
				hideFlares();
				var loader:Loader;
				if (_panos[currentPano].path) {
					if (!_flaresLocalLoaded[currentPano]) {
						_flaresLocal[currentPano] = new Array();
						loader = new Loader(); 
						loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLost);
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
						loader.load(new URLRequest(_panos[currentPano].path));
					} else {
						setPositions();
					}
				} else {
					if (!_flaresLoaded) {
						loader = new Loader();
						loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLost);
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
						loader.load(new URLRequest(lensFlareData.settings.path));
					} else {
						setPositions();
					}
				}
				fPan = _panos[currentPano].location.pan;
				fTilt = _panos[currentPano].location.tilt;
				stage.addEventListener(Event.ENTER_FRAME, lensFlareEffect, false, 0, true);
			} else {
				if (stage.hasEventListener(Event.ENTER_FRAME)) {
					stage.removeEventListener(Event.ENTER_FRAME, lensFlareEffect);
				}
				hideFlares();
			}
		}
		
		public function imageLost(e:IOErrorEvent):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, imageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, imageLoaded);
			printError("Unable to load: " + (e.target as LoaderInfo).url);
		}
		
		private function imageLoaded(e:Event):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, imageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, imageLoaded);
			
			var currentPano:String = saladoPlayer.manager.currentPanoramaData.id;
			
			var cellsCount:int = Math.round(((e.target as LoaderInfo).width + 1) / ((e.target as LoaderInfo).height + 1));
			if (cellsCount == ((e.target as LoaderInfo).width + 1) / ((e.target as LoaderInfo).height + 1)) {

				var bitmapData:BitmapData = new BitmapData((e.target as LoaderInfo).width, (e.target as LoaderInfo).height, true, 0);
				bitmapData.draw((e.target as LoaderInfo).content);
				
				var cellSide:int = (e.target as LoaderInfo).height;
				
				for (var i:int = 0; i < cellsCount; i++) {
					var flare:Object = new Object();
					flare.image = new Sprite();
					
					var flareBmData:BitmapData = new BitmapData(cellSide, cellSide, true, 0);
					flareBmData = new BitmapData(cellSide, cellSide, true, 0);
					flareBmData.copyPixels(bitmapData, new Rectangle((cellSide * i + i), 0, cellSide, cellSide), new Point(0, 0), null, null, true);
					
					var flareBm:Bitmap = new Bitmap(flareBmData, "auto", true);
					flareBm.x = -cellSide * 0.5;
					flareBm.y = -cellSide * 0.5;
					flare.image.addChild(flareBm);
					flare.image.alpha = 0;
					
					if (_panos[currentPano].path) {
						_flaresLocal[currentPano][i] = flare;
						saladoPlayer.manager.addChild(_flaresLocal[currentPano][i].image);
					} else {
						_flares[i] = flare;
						saladoPlayer.manager.addChild(_flares[i].image);
					}
				}
				
				setPositions();
				
				if (_panos[currentPano].path) {
					_flaresLocalLoaded[currentPano] = true;
				} else {
					_flaresLoaded = true;
				}
				
			} else {
				if (_panos[currentPano].path) {
					_flaresLocalLoaded[currentPano] = false;
				} else {
					_flaresLoaded = false;
				}
				printError("Incorrect grid size");
			}
		}
		
		private function setPositions():void {
			var currentPano:String = saladoPlayer.manager.currentPanoramaData.id;
			var positions:Array = new Array();
			
			curPositions = _panos[currentPano].positions ? 
				_panos[currentPano].positions : lensFlareData.settings.positions;
			var cellsCount:int = _panos[currentPano].path ? 
				_flaresLocal[currentPano].length : _flares.length;
			
			if (curPositions == null) {
				// automatically set positions
				var minPos:Number = 0.5;
				var maxPos:Number = 2.5;
				for (var i:int = 0; i < cellsCount; i++) {
					positions[i] = minPos + (maxPos - minPos) / cellsCount * i;
				}
			} else {
				positions = curPositions.split("|");
			}
			
			for (i = 0; i < cellsCount; i++) {
				if (_panos[currentPano].path) {
					_flaresLocal[currentPano][i].position = (positions[i] == null) ? _flareDefaultPosition : positions[i];
				} else {
					_flares[i].position = (positions[i] == null) ? _flareDefaultPosition : positions[i];
				}
			}
		}
		
		private function lensFlareEffect(event:Event):void {
			if (_panos[saladoPlayer.manager.currentPanoramaData.id]) {
				
				var panDist:Number = Math.abs(saladoPlayer.manager._pan - fPan);
				if (panDist > 180) {
					panDist = 360 - panDist;
				}
				
				_fDistance = Math.sqrt(Math.pow(panDist, 2) + Math.pow(Math.abs(saladoPlayer.manager._tilt - fTilt), 2));
				
				var level:Number = _panos[saladoPlayer.manager.currentPanoramaData.id].brightness.level == -1 ?
					lensFlareData.settings.brightness.level : _panos[saladoPlayer.manager.currentPanoramaData.id].brightness.level;	
					
				var distance:Number = _panos[saladoPlayer.manager.currentPanoramaData.id].brightness.distance == -1 ?
					lensFlareData.settings.brightness.distance : _panos[saladoPlayer.manager.currentPanoramaData.id].brightness.distance;
				
				if (_fDistance == 0) {
					if (brightness != level) {
						setBrightness(level);
					}
				} else if(_fDistance <= distance) {
					setBrightness(level - Math.round(_fDistance * level / distance));
					
				} else {
					if (brightness != 0) {
						setBrightness(0);
					}
				}
				
				showFlares();
			}
		}
		
		private function showFlares():void{
			var currentPano:String = saladoPlayer.manager.currentPanoramaData.id;
			
			var fx:int = panToX(fPan);
			var fy:int = tiltToY(fTilt);
			var w:int = saladoPlayer.manager.boundsWidth;
			var h:int = saladoPlayer.manager.boundsHeight;
			
			//printInfo("fpan=" + fPan.toFixed() + "; ftilt=" + fTilt.toFixed());
			//printInfo("fx=" + fx.toFixed() + "; fy=" + fy.toFixed() + "; w=" + w.toFixed() + "; h=" + h.toFixed());
			
			var fDistanceToBounds:int = Math.max(0, Math.round(Math.min(fx, fy, (w - fx), (h - fy))));
			
			if (fx <= w && fx > 0 && fy <= h && fy > 0) {
				
				if (!_flaresAreShown) {
					_flaresAreShown = true;
				}
				
				var flares:Array = _panos[currentPano].path ? _flaresLocal[currentPano] : _flares;
				
				for each(var flare:Object in flares) {
					var flarePan:Number = validatePanTilt(fPan + validatePanTilt(saladoPlayer.manager._pan - fPan) * flare.position);
					var flareTilt:Number = validatePanTilt(fTilt + validatePanTilt(saladoPlayer.manager._tilt - fTilt) * flare.position);				
					
					flare.image.x = panToX(flarePan);
					flare.image.y = tiltToY(flareTilt);
					
					if (fDistanceToBounds <= _fadeDistance) {
						flare.image.alpha = fDistanceToBounds / _fadeDistance;
					} else {
						if (_fDistance <= _maxFlaresDistance) {
							flare.image.alpha = _fDistance / _maxFlaresDistance;
						} else {
							flare.image.alpha = 1;
						}
					}
				
					//printInfo("fd=" + _fDistance.toFixed(2) + "; a=" + flare.image.alpha.toFixed(2));
					//printInfo("p=" + flarePan.toFixed(2) + "; t=" + flareTilt.toFixed(2) + ";");
					//printInfo("x=" + flare.image.x.toFixed(0) + "; y=" + flare.image.y.toFixed(0) + ";");
				}
			} else {
				
				if (_flaresAreShown) {
					hideFlares();
					_flaresAreShown = false;
				}
			}
		}
		
		private function hideFlares():void 
		{
			for each(var flare:Object in _flares) {
				flare.image.alpha = 0;
			}
			for each(var pano:Panorama in _panos) {
				if (pano.path) {
					for each (flare in _flaresLocal[pano.id]) {
						flare.image.alpha = 0;
					}
				}
			}
		}
		
		/*
		 * Set flare brightness
		 * level == 0 -> default brightness
		 * level > 0 -> lighter
		 * level < 0 -> darker
		 */
		private function setBrightness(level:int):void {
			
			colorTransform.redOffset = level;
			colorTransform.greenOffset = level;
			colorTransform.blueOffset = level;
			saladoPlayer.manager.canvas.transform.colorTransform = colorTransform;
			brightness = level;
		}
		
		private function validatePanTilt(value:Number):Number {
			if (value <= -180) value = (((value + 180) % 360) + 180);
			if (value > 180) value = (((value + 180) % 360) - 180);
			return value;
		}
		
		/* 
		 * Check if point (pan or tilt) is within an angle of view (fov or vfov)
		 */
		private function inAngleBounds(value:Number, from:Number, to:Number):Boolean
		{
			var result:Boolean = false;
			if (from > 0 && to < 0) {
				if ((value >= from && value <= 180) || (value >= -180 && value <= to)) {
					result = true;
				}
			} else {
				if (value >= from && value <= to) {
					result = true; 
				}
			}
			return result;
		}
		
		/*
		 * Convert pan to x coordinate
		 */
		private function panToX(pan:Number):int {
			var w:Number = saladoPlayer.manager.boundsWidth;
			var cPan:Number = saladoPlayer.manager._pan;
			var fov:Number = saladoPlayer.manager._fieldOfView;
			pan = validatePanTilt(pan);
			
			if (inAngleBounds(pan, validatePanTilt(cPan - fov / 2), validatePanTilt(cPan + fov / 2))) {
				return Math.round(
					w * 0.5 + 
					(Math.tan((pan - cPan) * __toRadians) * w * 0.5) /
					(Math.tan(fov * 0.5 * __toRadians))
					);
			} else {
				return -99999;
			}
		}
		
		/*
		 * Convert tilt to y coordinate
		 */		
		private function tiltToY(tilt:Number):int {
			var w:Number = saladoPlayer.manager.boundsWidth;
			var h:Number = saladoPlayer.manager.boundsHeight;
			var cTilt:Number = saladoPlayer.manager._tilt;
			var fov:Number = saladoPlayer.manager._fieldOfView;
			var vFov:Number = __toDegrees * 2 * Math.atan((h / w)
				* Math.tan(__toRadians * 0.5 * fov));
			tilt = validatePanTilt(tilt);
			
			if (inAngleBounds(tilt, validatePanTilt(cTilt - vFov / 2), validatePanTilt(cTilt + vFov / 2))) {
				return Math.round(
					h * 0.5 + 
					(Math.tan((cTilt - tilt) * __toRadians) * h * 0.5) /
					(Math.tan(vFov * 0.5 * __toRadians))
					);
			} else {
				return -99999;
			}
		}
		
		private var __toDegrees:Number = 180 / Math.PI;
		private var __toRadians:Number = Math.PI / 180;
	}
}
