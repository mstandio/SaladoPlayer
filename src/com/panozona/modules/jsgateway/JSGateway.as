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
package com.panozona.modules.jsgateway {
	
	import com.panozona.modules.jsgateway.data.JSGatewayData;
	import com.panozona.modules.jsgateway.data.structure.ASFunction;
	import com.panozona.modules.jsgateway.data.structure.JSFunction;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.ApplicationDomain;
	
	public class JSGateway extends Module{
		
		private var jsgatewayData:JSGatewayData;
		
		public function JSGateway(){
			super("JSGateway", "1.3.2", "http://panozona.com/wiki/Module:JSGateway");
			moduleDescription.addFunctionDescription("run", String);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			visible = false;
			
			if (!ExternalInterface.available) {
				printError("ExternalInterface not avaible");
				return;
			}
			
			jsgatewayData = new JSGatewayData(moduleData, saladoPlayer);
			
			ExternalInterface.addCallback("runAction", saladoPlayer.manager.runAction);
			
			for each (var asfunction:ASFunction in jsgatewayData.asfuncttions.getChildrenOfGivenClass(ASFunction)) {
				try {
					ExternalInterface.addCallback(asfunction.name, getReference(asfunction.callback) as Function);
				}catch (e:Error) {
					printWarning("Could not expose asfunction: " + asfunction.name +", " + e.message);
				}
			}
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			
			
			if(jsgatewayData.settings.callOnEnter){
				saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			}
			if(jsgatewayData.settings.callOnTransitionEnd){
				saladoPlayer.manager.addEventListener(panoramaEventClass.TRANSITION_ENDED, onTransitionEnded, false, 0, true);
			}
			if(jsgatewayData.settings.callOnMoveEnd){
				var panoSaladoEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.PanoSaladoEvent") as Class;
				saladoPlayer.manager.addEventListener(panoSaladoEventClass.SWING_TO_COMPLETE, onMoveEnded, false, 0, true);
				saladoPlayer.manager.addEventListener(panoSaladoEventClass.SWING_TO_CHILD_COMPLETE, onMoveEnded, false, 0, true);
			}
			if(jsgatewayData.settings.callOnViewChange){
				saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0, true);
				stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}
		}
		
		private function onPanoramaStartedLoading(panoramaEvent:Object):void {
			__currentDirection = saladoPlayer.manager.currentPanoramaData.direction;
		}
		
		private function onPanoramaLoaded(panoramaEvent:Object):void {
			ExternalInterface.call("onEnter", saladoPlayer.manager.currentPanoramaData.id);
		}
		
		private function onTransitionEnded(panoramaEvent:Object):void {
			ExternalInterface.call("onTransitionEnd", saladoPlayer.manager.currentPanoramaData.id);
		}
		
		private function onMoveEnded(panoSaladoEvent:Object):void {
			ExternalInterface.call("onMoveEnd", saladoPlayer.manager.currentPanoramaData.id);
		}
		
		private var __pan:Number = 0;
		private var __tilt:Number = 0;
		private var __fov:Number = 0;
		private var __currentDirection:Number = 0;
		private function onEnterFrame(e:Event):void {
			if (__pan == saladoPlayer.manager._pan && __tilt == saladoPlayer.manager._tilt && __fov == saladoPlayer.manager._fieldOfView) return;
			__pan = saladoPlayer.manager._pan;
			__tilt = saladoPlayer.manager._tilt;
			__fov = saladoPlayer.manager._fieldOfView;
			
			var precision:uint = jsgatewayData.settings.viewChangePrecision;
			
			ExternalInterface.call("onViewChange", __pan.toFixed(precision), __tilt.toFixed(precision), __fov.toFixed(precision), __currentDirection.toFixed(precision));
		}
		
		private function getReference(input:String):Object {
			return getReferenceR(input.split("."), 0, this);
		}
		
		private function getReferenceR(path:Array, currentIndex:int, inputObject:Object):Object {
			if (currentIndex < path.length) {
				return getReferenceR(path, currentIndex + 1, autocall(inputObject, path[currentIndex]));
			}else {
				return inputObject;
			}
		}
		
		private function autocall(obj:Object, next:String):Object {
			if (next.match(/^.+\(.*\)$/)) {
				return (obj[next.match(/^.+(?=\()/)[0]] as Function).apply(this, ((next.match(/(?<=\()(.+)(?=\))/)[0]) as String).split(","));
			}else {
				return obj[next];
			}
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function run(jsfunctionId:String):void {
			for each(var jsfunction:JSFunction in jsgatewayData.jsfuncttions.getChildrenOfGivenClass(JSFunction)) {
				if (jsfunction.id == jsfunctionId) {
					if (jsfunction.text == null){
						ExternalInterface.call(jsfunction.name);
					}else {
						ExternalInterface.call(jsfunction.name, jsfunction.text);
					}
					return;
				}
			}
			printWarning("Calling nonexistant jsfunction: " + jsfunctionId);
		}
	}
}