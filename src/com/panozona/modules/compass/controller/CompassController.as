/*
Copyright 2011 Marek Standio.

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
package com.panozona.modules.compass.controller {
	
	import com.panozona.modules.compass.model.CompassData;
	import com.panozona.modules.compass.view.CompassView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Size;
	import com.panozona.player.module.Module;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	public class CompassController {
		
		private var _compassView:CompassView;
		private var _module:Module;
		
		private var currentDirection:Number = 0;
		
		public function CompassController(compassView:CompassView, module:Module) {
			
			_compassView = compassView;
			_module = module;
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0, true);
			_module.saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading2, false, 0, true);
			
			if (_compassView.compassData.settings.path != null){
				var compassLoader:Loader = new Loader();
				compassLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, compassImageLost, false, 0, true);
				compassLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, compassImageLoaded, false, 0, true);
				compassLoader.load(new URLRequest(compassView.compassData.settings.path));
			}
		}
		
		private function onPanoramaStartedLoading(loadPanoramaEvent:Object):void {
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading);
			if (_compassView.compassData.windowData.open) {
				_module.saladoPlayer.manager.runAction(_compassView.compassData.windowData.window.onOpen);
			}else {
				_module.saladoPlayer.manager.runAction(_compassView.compassData.windowData.window.onClose);
			}
		}
		
		private function onPanoramaStartedLoading2(e:Event):void {
			currentDirection = _module.saladoPlayer.manager.currentPanoramaData.direction;
		}
		
		protected function compassImageLost(error:IOErrorEvent):void {
			error.target.removeEventListener(IOErrorEvent.IO_ERROR, compassImageLost);
			error.target.removeEventListener(Event.COMPLETE, compassImageLoaded);
			_module.printError(error.text);
		}
		
		protected function compassImageLoaded(e:Event):void {
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, compassImageLost);
			e.target.removeEventListener(Event.COMPLETE, compassImageLoaded);
			
			var bitmapData:BitmapData = new BitmapData((e.target as LoaderInfo).width, (e.target as LoaderInfo).height, true, 0);
			bitmapData.draw((e.target as LoaderInfo).content);
			
			var dialBitmapdata:BitmapData = new BitmapData(bitmapData.height, bitmapData.height, true, 0);
			dialBitmapdata.copyPixels(bitmapData, new Rectangle(0, 0, bitmapData.height, bitmapData.height), new Point(0, 0), null, null, true)
			
			var needleBitmapdata:BitmapData = new BitmapData(bitmapData.width - bitmapData.height - 1, bitmapData.height, true, 0);
			needleBitmapdata.copyPixels(bitmapData, new Rectangle(bitmapData.height + 1, 0, bitmapData.width - bitmapData.height - 1, bitmapData.height), new Point(0, 0), null, null, true);
			
			_compassView.setBitmapsData(dialBitmapdata, needleBitmapdata);
			
			_compassView.compassData.windowData.size = new Size(dialBitmapdata.width, dialBitmapdata.height);
			
			_module.stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true );
		}
		
		private function enterFrameHandler(event:Event):void{
			_compassView.axis.rotationZ = _module.saladoPlayer.manager._pan + currentDirection;
		}
	}
}