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
	
	import com.panozona.modules.panolink.view.LinkView;
	import com.panozona.player.module.Module;
	import flash.external.ExternalInterface;
	
	public class LinkController{
		
		private var linkView:LinkView;
		private var module:Module;
		
		private var paramsFirstClone:Object;
		private var paramsGlobalClone:Object;
		
		public function LinkController(linkView:LinkView, module:Module) {
			var recognizedValues:Object = recognizeURL(ExternalInterface.call("window.location.href.toString"));
			if (recognizedValues != null) {
				var paramsReference:Object = module.saladoPlayer.managerData.getPanoramaDataById(recognizedValues.id);
				if (paramsReference != null) {
					stashOriginalParams();
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
					_module.saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0, true);
				}
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
			result += "pano=" + module.saladoPlayer.manager.currentPanoramaData.params.id;
			result += "&cam=";
			result += (module.saladoPlayer.pan as Number).toFixed(2) + ",";
			result += (module.saladoPlayer.tilt as Number).toFixed(2) + ",";
			result += (module.saladoPlayer.fov as Number).toFixed(2);
			return result;
		}
		
		private function onPanoramaStartedLoading(loadPanoramaEvent:Object):void {
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading);
			setOriginalParams();
		}
		
		private function recognizeURL(url:String):Object{
			var id:String;
			var pan:Number;
			var tilt:Number;
			var fov:Number;
			if (url.indexOf("?") > 0) {
				url = url.slice(url.indexOf("?"), url.length);
				var params:Array = url.split("&");
				var temp:Array;
				for each(var param:String in params){
					temp = setting.split("=");
					if (temp.length != 2) continue;
					if(temp[0] == "pano"){
						id = (temp[1]);
					}else if (temp[0] == "cam") {
						var values:Array = temp[1].split(",");
						if (values.length > 0) {
							pan = Number(values[0]);
						}
						if (values.length > 1) {
							tilt = Number(values[1]);
						}
						if (values.length > 2) {
							fov = Number(values[2]);
						}
					}
				}
			}
			if (pano != null){
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
			var paramsReference:Object = module.saladoPlayer.managerData.getPanoramaDataById(panoramaId);
			if (paramsReference != null) {
				paramsFirstClone = paramsReference.clone();
				paramsGlobalClone = module.saladoPlayer.managerData.allPanoramasData.params.clone();
			}
		}
		
		private function setOriginalParams():void {
			var paramsReference:Object = module.saladoPlayer.managerData.getPanoramaDataById(panoramaId);
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

