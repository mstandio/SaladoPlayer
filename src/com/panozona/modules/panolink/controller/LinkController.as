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
package com.panozona.modules.panolink.controller{
	
	import com.panozona.modules.panolink.events.WindowEvent;
	import com.panozona.modules.panolink.view.LinkView;
	import com.panozona.player.module.Module;
	import flash.external.ExternalInterface;
	import flash.system.ApplicationDomain;
	
	public class LinkController{
		
		private var linkView:LinkView;
		private var module:Module;
		
		private var paramsFirstClone:Object;
		private var paramsGlobalClone:Object;
		
		public function LinkController(linkView:LinkView, module:Module){
			
			this.linkView = linkView;
			this.module = module;
			
			linkView.panoLinkData.windowData.addEventListener(WindowEvent.CHANGED_OPEN, onOpenChange, false, 0, true);
			
			var recognizedValues:Object = recognizeURL(ExternalInterface.call("window.location.href.toString"));
			if (recognizedValues != null){
				var panoDataReference:Object = module.saladoPlayer.managerData.getPanoramaDataById(recognizedValues.id);
				if (panoDataReference == null) {
					module.printWarning("Nonexistant panorama: " + recognizedValues.id);
				}else {
					var paramsReference:Object = panoDataReference.params;
					stashOriginalParams(recognizedValues.id);
					module.saladoPlayer.managerData.allPanoramasData.firstPanorama = recognizedValues.id;
					if (!isNaN(recognizedValues.pan)) {
						paramsReference.pan = recognizedValues.pan;
						module.saladoPlayer.managerData.allPanoramasData.params.pan = NaN;
					}
					if (!isNaN(recognizedValues.tilt)) {
						paramsReference.tilt = recognizedValues.tilt;
						module.saladoPlayer.managerData.allPanoramasData.params.tilt = NaN;
					}
					if (!isNaN(recognizedValues.fov)) {
						paramsReference.fov = recognizedValues.fov;
						module.saladoPlayer.managerData.allPanoramasData.params.fov = NaN;
					}
					
					var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
					module.saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
				}
			}
		}
		
		private function onPanoramaLoaded(loadPanoramaEvent:Object):void {
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			module.saladoPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded);
			setOriginalParams();
			onOpenChange();
		}
		
		private function onOpenChange(WindowEvent:Object = null):void {
			if (linkView.panoLinkData.windowData.open){
				trace(getUrlLink(ExternalInterface.call("window.location.href.toString")));
				linkView.setText(getUrlLink(ExternalInterface.call("window.location.href.toString")));
			}
		}
		
		public function getUrlLink(url:String):String {
			var result:String = "";
			if (url.indexOf("?") > 0) {
				result += url.substr(0, url.indexOf("?"));
				var params:Array = url.substring(url.indexOf("?"), url.length).split("&");
				for each(var param:String in params) {
					if (!param.match(/^pano=.+/) && !param.match(/^cam=.+/)) {
						result += param +"&";
					}
				}
			}else {
				result = url;
				result += "?";
			}
			result += "pano=" + module.saladoPlayer.manager.currentPanoramaData.id;
			result += "&cam=";
			result += (module.saladoPlayer.manager.pan as Number).toFixed(0) + ",";
			result += (module.saladoPlayer.manager.tilt as Number).toFixed(0) + ",";
			result += (module.saladoPlayer.manager.fieldOfView as Number).toFixed(0);
			return result;
		}
		
		private function recognizeURL(url:String):Object {
			var id:String;
			var pan:Number;
			var tilt:Number;
			var fov:Number;
			if (url.indexOf("?") > 0) {
				url = url.slice(url.indexOf("?")+1, url.length);
				var params:Array = url.split("&");
				for each(var param:String in params) {
					var temp:Array = param.split("=");
					if(temp.length != 2) continue;
					if(temp[0] == "pano"){
						id = (temp[1]);
					}else if (temp[0] == "cam") {
						
						var values:Array = temp[1].split(",");
						try{
							pan = Number(values[0]);
							tilt = Number(values[1]);
							fov = Number(values[2]);
						}catch (e:Error){
							module.printWarning("Invalid cam values: " + temp[1]);
						}
					}
				}
			}
			if (id != null){
				var result:Object = new Object();
				result.id = id;
				result.pan = pan;
				result.tilt = tilt;
				result.fov = fov;
				return result;
			}
			return null;
		}
		
		private function stashOriginalParams(panoramaId:String):void{
			var paramsReference:Object = module.saladoPlayer.managerData.getPanoramaDataById(panoramaId).params;
			if (paramsReference != null) {
				paramsFirstClone = paramsReference.clone();
				paramsGlobalClone = module.saladoPlayer.managerData.allPanoramasData.params.clone();
			}
		}
		
		private function setOriginalParams():void {
			var paramsReference:Object = module.saladoPlayer.managerData.getPanoramaDataById(module.saladoPlayer.managerData.allPanoramasData.firstPanorama).params;
			if (paramsReference != null && paramsFirstClone != null) {
				paramsReference.pan = paramsFirstClone.pan;
				paramsReference.tilt = paramsFirstClone.tilt;
				paramsReference.fov = paramsFirstClone.fov;
			}
			if(paramsGlobalClone != null){
				module.saladoPlayer.managerData.allPanoramasData.params.pan = paramsGlobalClone.pan;
				module.saladoPlayer.managerData.allPanoramasData.params.tilt = paramsGlobalClone.tilt;
				module.saladoPlayer.managerData.allPanoramasData.params.fov = paramsGlobalClone.fov;
			}
		}
	}
}
