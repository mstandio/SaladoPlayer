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
package com.panozona.modules.jsgooglemap {
	
	import com.panozona.modules.jsgooglemap.data.*;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.external.ExternalInterface;
	
	public class JSGoogleMap extends Module {
		
		private var __fov:Number = 0;
		private var __pan:Number = 0;
		private var currentDirection:Number = 0;
		
		private var panoramaEventClass:Class;
		
		private var jsGooglemapData:JSGoogleMapData;
		
		public function JSGoogleMap() {
			super("JSGoogleMap", "1.0", "http://panozona.com/wiki/Module:JSGoogleMap");
			
			moduleDescription.addFunctionDescription("toggle");
			moduleDescription.addFunctionDescription("hide");
			moduleDescription.addFunctionDescription("show");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			jsGooglemapData = new JSGoogleMapData(moduleData, saladoPlayer); // allways read data first 
			
			// add listeners 
			panoramaEventClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onFirstPanoramaStartedLoading, false, 0 , true);
			saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0 , true);
			
			stage.addEventListener(Event.ENTER_FRAME, onCameraMove, false, 0, true);
			
			visible = false;
		}
		
		private function onFirstPanoramaStartedLoading(e:Event):void {
			saladoPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onFirstPanoramaStartedLoading);
			ExternalInterface.call("initJSGoogleMap", new ToJSON().translate(jsGooglemapData));
			callActions();
		}
		
		private function onPanoramaLoaded(e:Event):void {
			__fov = saladoPlayer.manager._fieldOfView;
			__pan = saladoPlayer.manager._pan;
			currentDirection = saladoPlayer.manager.currentPanoramaData.direction;
			
			ExternalInterface.call(jsGooglemapData.settings.jsRadarCallback, __fov, __pan + currentDirection);
		}
		
		private function onCameraMove(e:Event):void {
			if (__fov == saladoPlayer.manager._fieldOfView && __pan == saladoPlayer.manager._pan) return;
			
			__fov = saladoPlayer.manager._fieldOfView;
			__pan = saladoPlayer.manager._pan;
			
			ExternalInterface.call(jsGooglemapData.settings.jsRadarCallback, __fov, __pan + currentDirection);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function hide():void {
			jsGooglemapData.settings.open = false;
			callActions();
		}
		
		public function show():void {
			jsGooglemapData.settings.open = true;
			callActions();
		}
		
		public function toggle():void {
			jsGooglemapData.settings.open = !jsGooglemapData.settings.open;
			callActions();
		}
		
		private function callActions():void {
			if (jsGooglemapData.settings.open && jsGooglemapData.settings.onShow) {
				saladoPlayer.manager.runAction(jsGooglemapData.settings.onShow);
			} 
			if(!jsGooglemapData.settings.open && jsGooglemapData.settings.onHide) {
				saladoPlayer.manager.runAction(jsGooglemapData.settings.onHide);
			}
		}
	}
}