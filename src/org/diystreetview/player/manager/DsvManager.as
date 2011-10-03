/*
Copyright 2011 Marek Standio.

This file is part of DIY streetview player.

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
package org.diystreetview.player.manager {
	
	import com.panozona.player.manager.data.actions.ActionData;
	import com.panozona.player.manager.data.actions.FunctionData;
	import com.panozona.player.manager.data.panoramas.PanoramaData;
	import com.panozona.player.manager.Manager;
	import com.panozona.player.manager.utils.Trace;
	import com.panozona.player.module.data.property.Geolocation;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import org.diystreetview.player.manager.data.actions.DsvActionData;
	import org.diystreetview.player.manager.data.DsvManagerData;
	import org.diystreetview.player.manager.data.panoramas.DsvHotspotData;
	import org.diystreetview.player.manager.data.panoramas.DsvPanoramaData;
	import org.diystreetview.player.manager.utils.loading.URLLoader_;
	import org.diystreetview.player.manager.utils.UrlParser;
	
	public class DsvManager extends com.panozona.player.manager.Manager {
		
		private var xmlLoader:URLLoader_;
		private var calledPano:String;
		private var panoWasLoaded:Boolean;
		
		public function DsvManager(){
			super();
			ExternalInterface.addCallback("callPano", callPano);
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		}
		
		// this is starting point 
		override public function loadFirstPanorama():void {
			panoWasLoaded = true;
			// if javascript was called 
			if (calledPano != null){
				callPano(calledPano);
				calledPano = null;
			}
			try {
				// checks if there is data in url (for instance [...]/index.html?pano=1281729751-472798&cam=90,20,60 (pan, tilt, fov)
				var urlParser:UrlParser = new UrlParser(ExternalInterface.call("window.location.href.toString"));
				if(urlParser.pano != null){
					var panoramaData:DsvPanoramaData = new DsvPanoramaData(urlParser.pano, buildPath(urlParser.pano) + "_f.xml");
					panoramaData.params.pan = urlParser.pan;
					panoramaData.params.tilt = urlParser.tilt;
					panoramaData.params.fov = urlParser.fov;
					_managerData.panoramasData.push(panoramaData);
					loadPano(urlParser.pano);
				// otherwise it reads "start" pano from configuration
				}else if ((_managerData as DsvManagerData).diyStreetviewData.resources.start != null) {
					var start:String = (_managerData as DsvManagerData).diyStreetviewData.resources.start;
					var panoramaData2:DsvPanoramaData = new DsvPanoramaData(start, buildPath(start) + "_f.xml");
					_managerData.panoramasData.push(panoramaData2);
					loadPano(start);
				}
			}catch (error:Error) {
				Trace.instance.printError("Invalid url configuration: " + error.getStackTrace());
			}
		}
		
		private function callPano(panoIdentifyier:String):void {
			if (!panoWasLoaded){
				calledPano = panoIdentifyier;
				return;
			}
			var panoramaData:DsvPanoramaData = new DsvPanoramaData(panoIdentifyier, buildPath(panoIdentifyier) + "_f.xml");
			_managerData.panoramasData.push(panoramaData);
			loadPano(panoIdentifyier);
		}
		
		private var loadedId:String;
		override public function loadPano(panoramaId:String):void {
			if (!_managerData.getPanoramaDataById(panoramaId) is DsvPanoramaData) {
				super.loadPano(panoramaId);
				return;
			}
			loadedId = panoramaId;
			xmlLoader = new URLLoader_();
			xmlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			try {
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlLost, false, 0, true);
				xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded, false, 0, true);
				xmlLoader.load(new URLRequest(buildPath(panoramaId) + ".xml"));
			}catch (error:Error) {
				Trace.instance.printError("Security error, cannot access local resources: " + xmlLoader.urlRequest.url);
				trace(error.message);
			}
		}
		
		private function xmlLost(error:IOErrorEvent):void {
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, xmlLost);
			xmlLoader.removeEventListener(Event.COMPLETE, xmlLoaded);
			Trace.instance.printError("Failed to load configuration file: " + xmlLoader.urlRequest.url);
		}
		
		private function xmlLoaded(event:Event):void {
			cleanPanoramasData(loadedId);
			var input:ByteArray = event.target.data;
			try {input.uncompress()}catch (error:Error) {}
			try {
				var panoxml:XML = XML(input);
				var dsvPanoramaData:DsvPanoramaData;
				for each(var panoramaData:PanoramaData in _managerData.panoramasData) {
					if (panoramaData is DsvPanoramaData) {
						dsvPanoramaData = panoramaData as DsvPanoramaData;
						break;
					}
				}
				
				dsvPanoramaData.direction = Number(panoxml.pano.@direction);
				
				var mainGpsData:Geolocation = new Geolocation();
				mainGpsData.latitude = Number(panoxml.pano.@latitude);
				mainGpsData.longitude = Number(panoxml.pano.@longitude);
				mainGpsData.elevation = Number(panoxml.pano.@altitude);
				
				Trace.instance.printInfo("main lat: "+panoxml.pano.@latitude+" lon: "+panoxml.pano.@longitude);
				
				// add hotspots to main panorama, create neighbour panoramas
				
				cleanActionsData();
				for each(var neighbour:XML in panoxml.neighbours.children()) {
					var neighbourName:String = neighbour.@path.substr(0, neighbour.@path.lastIndexOf("."));
					
					var functionData:FunctionData = new FunctionData("SaladoPlayer", "loadPano");
					functionData.args.push(neighbourName);
					var dsvActionData:DsvActionData = new DsvActionData(neighbourName);
					dsvActionData.functions.push(functionData);
					_managerData.actionsData.push(dsvActionData);
					var hotspotData:DsvHotspotData = new DsvHotspotData(neighbourName, 
						(_managerData as DsvManagerData).diyStreetviewData.settings.hotspots, neighbourName);
					hotspotData.mouse.onClick = neighbourName;
					
					var hotspotGeolocation:Geolocation = new Geolocation();
					hotspotGeolocation.latitude = Number(neighbour.@latitude);
					hotspotGeolocation.longitude = Number(neighbour.@longitude);
					hotspotGeolocation.elevation = Number(neighbour.@altitude);
					
					var hotspotDistanceAway:Number = distance(mainGpsData.latitude, mainGpsData.longitude, hotspotGeolocation.latitude, hotspotGeolocation.longitude);
					
					hotspotData.location.pan = Math.atan2(
						distance(mainGpsData.latitude, 0, hotspotGeolocation.latitude, 0, true),
						distance(0, mainGpsData.longitude, 0, hotspotGeolocation.longitude, true)
					) * 180 / Math.PI;
					
					hotspotData.location.pan += Number(panoxml.pano.@direction) - 90;
					hotspotData.location.tilt = -90 + (180 / Math.PI) * Math.atan(hotspotDistanceAway / 0.0019); // 0.0019 is camera height in kilometers
					hotspotData.location.distance = 30000 * hotspotDistanceAway;
					
					if ( hotspotData.location.pan <= -180 ) hotspotData.location.pan = (((hotspotData.location.pan + 180) % 360) + 180);
					if ( hotspotData.location.pan >   180 ) hotspotData.location.pan = (((hotspotData.location.pan + 180) % 360) - 180);
					
					// for debugging
					hotspotData.gps.latitude = Number(neighbour.@latitude);
					hotspotData.gps.longitude = Number(neighbour.@longitude);
					hotspotData.gps.elevation = Number(neighbour.@altitude);
					
					dsvPanoramaData.hotspotsData.push(hotspotData);
					
					_managerData.panoramasData.push(new DsvPanoramaData(neighbourName, buildPath(neighbourName) + "_f.xml"));
				}
				super.loadPanoramaById(dsvPanoramaData.id);
				ExternalInterface.call("panoChanged", dsvPanoramaData.id);
				
			}catch (error:Error) {
				Trace.instance.printError("Error in new configuration file structure: " + error.message);
				trace(error.getStackTrace());
			}
		}
		
		private function buildPath(path:String):String {
			var result:String = "";
			result += (_managerData as DsvManagerData).diyStreetviewData.resources.directory;
			if ((_managerData as DsvManagerData).diyStreetviewData.resources.prefix != null) {
				result += (_managerData as DsvManagerData).diyStreetviewData.resources.prefix;
			}
			result += path +"/" + path;
			return result;
		}
		
		private function distance(lat1:Number, lon1:Number, lat2:Number, lon2:Number, noAbs:Boolean = false):Number {
			var theta:Number  = lon1 - lon2;
			var dist:Number = Math.sin(deg2rad(lat1)) 
				* Math.sin(deg2rad(lat2)) + Math.cos(deg2rad(lat1))
				* Math.cos(deg2rad(lat2)) * Math.cos(deg2rad(theta));
			dist = Math.acos(dist);
			dist = rad2deg(dist);
			dist = dist * 60 * 1.1515;
			dist = dist * 1.609344;
			
			if (noAbs){
				if (lat1 - lat2 > 0) return - dist
				if (lon1 - lon2 > 0) return - dist
			}
			return dist;
		}
		
		public function clickForwardHotspot():void {
			var minDistance:Number = Number.POSITIVE_INFINITY;
			var closestHotspot:DsvHotspotData;
			var distance:Number;
			for each (var hotspotData:DsvHotspotData in (_managerData.panoramasData[0] as PanoramaData).hotspotsData) {
				distance = Math.abs(_pan - hotspotData.location.pan);
				if (distance > 180) distance = 360 - distance;
				if (distance < minDistance) {
					closestHotspot = hotspotData;
					minDistance = distance;
				}
			}
			if (closestHotspot != null) {
				runAction(closestHotspot.mouse.onClick);
			}
		}
		
		public function clickBackwardHotspot():void {
			var minDistance:Number =  Number.POSITIVE_INFINITY;
			var closestHotspot:DsvHotspotData;
			var distance:Number;
			var panReverse:Number = _pan - 180;
			if ( panReverse <= -180 ) panReverse = (((panReverse + 180) % 360) + 180);
			for each (var hotspotData:DsvHotspotData in (_managerData.panoramasData[0] as PanoramaData).hotspotsData) {
				distance = Math.abs(panReverse - hotspotData.location.pan);
				if (distance > 180) distance = 360 - distance;
				if (distance < minDistance) {
					closestHotspot = hotspotData;
					minDistance = distance;
				}
			}
			if (closestHotspot != null) {
				runAction(closestHotspot.mouse.onClick);
			}
		}
		
		private function cleanPanoramasData(excpetion:String):void {
			var tmpPanoramasData:Vector.<PanoramaData> = new Vector.<PanoramaData>();
			for each(var panoramaData:PanoramaData in _managerData.panoramasData) {
				if (!(panoramaData is DsvPanoramaData) || panoramaData.id == excpetion) {
					tmpPanoramasData.push(panoramaData);
				}
			}
			while (_managerData.panoramasData.length > 0) {
				_managerData.panoramasData.pop();
			}
			for each(panoramaData in tmpPanoramasData) {
				_managerData.panoramasData.push(panoramaData);
			}
		}
		
		private function cleanActionsData():void {
			var tmpActionsData:Vector.<ActionData> = new Vector.<ActionData>();
			for each(var actionData:ActionData in _managerData.actionsData) {
				if (!(actionData is DsvActionData)) {
					tmpActionsData.push(actionData);
				}
			}
			while (_managerData.actionsData.length > 0) {
				_managerData.actionsData.pop();
			}
			for each(actionData in tmpActionsData) {
				_managerData.actionsData.push(actionData);
			}
		}
		
		private var tmpPan:Number;
		private var tmpTilt:Number;
		private var tmpfov:Number;
		private function onEnterFrame(e:Event):void {
			if (tmpPan == Math.round(pan) && tmpTilt == Math.round(tilt) && tmpfov == Math.round(fieldOfView)) return;
			tmpPan = Math.round(pan);
			tmpTilt = Math.round(tilt);
			tmpfov = Math.round(fieldOfView);
			ExternalInterface.call("viewChanged", tmpPan, tmpTilt, tmpfov);
		}
		
		override protected function panoramaLoaded(e:Event):void {
			super.panoramaLoaded(e);
			ExternalInterface.call("viewChanged", Math.round(pan), Math.round(tilt), Math.round(fieldOfView));
		}
		
		private function deg2rad(deg:Number):Number {
			return (deg * Math.PI / 180.0);
		}
		
		private function rad2deg(rad:Number):Number {
			return (rad / Math.PI * 180.0);
		}
	}
}