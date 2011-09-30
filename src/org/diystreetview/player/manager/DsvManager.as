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
	import com.panozona.player.manager.data.panoramas.PanoramaData;
	import com.panozona.player.manager.Manager;
	import com.panozona.player.manager.utils.Trace;
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
		
		private function callPano(panoIdentifyier:String):void {
			if (!panoWasLoaded){
				calledPano = panoIdentifyier;
				return;
			}
			var panoramaData:DsvPanoramaData = new DsvPanoramaData(panoIdentifyier, panoIdentifyier + ".xml" );
			_managerData.panoramasData.push(panoramaData);
			loadPano(panoIdentifyier);
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
				// checks if there is data in url (for instance [...]/index.html?pano=1281729751-472798&pan=90&tilt=20&fov=60)
				var urlParser:UrlParser = new UrlParser(ExternalInterface.call("window.location.href.toString"));
				if(urlParser.pano != null){
					var panoramaData:DsvPanoramaData = new DsvPanoramaData(urlParser.pano, urlParser.pano + ".xml");
					panoramaData.params.pan = urlParser.pan;
					panoramaData.params.tilt = urlParser.tilt;
					panoramaData.params.fov = urlParser.fov;
					_managerData.panoramasData.push(panoramaData);
					loadPano(urlParser.pano);
				// otherwise it reads "start" pano from configuration
				}else {
					if(_managerData.getPanoramaDataById() != null){
						loadPano("start");
					}
				}
				// if there is no "start" panorama it waits for externalinterface callback for panorama id
			}catch (error:Error) {
				Trace.instance.printError("Invalid url configuration: " + error.message);
			}
		}
		
		override public function loadPano(panoramaId:String):void {
			xmlLoader = new URLLoader_();
			xmlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			try {
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlLost, false, 0, true);
				xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded, false, 0, true);
				xmlLoader.load( new URLRequest(buildPath(_managerData.getPanoramaDataById(panoramaId).params.path)));
			}catch (error:Error) {
				Trace.instance.printError("Security error, cannot access local resources: " + xmlLoader.urlRequest.url);
				trace(error.getStackTrace());
			}
		}
		
		private function xmlLost(error:IOErrorEvent):void {
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, xmlLost);
			xmlLoader.removeEventListener(Event.COMPLETE, xmlLoaded);
			Trace.instance.printError("Failed to load configuration file: " + xmlLoader.urlRequest.url);
		}
		
		private function xmlLoaded(event:Event):void {
			var input:ByteArray = event.target.data;
			try {input.uncompress()}catch (error:Error) {}
			try {
				var panoxml:XML = XML(input);
				var panoramaData:DsvPanoramaData;
				
				
				/*
				_previusDirection = _currentDirection;
				_currentDirection = Number(panoxml.pano.@direction);
				
				// create first and main panorama
				panoramaData = new DsvPanoramaData("main", (event.target as URLLoader_).urlRequest.url.replace(".xml", "_f.xml"));
				panoramaData.label = extractFromPath(panoramaData.path);
				panoramaData.params.pan = pan - (_previusDirection - _currentDirection);
				
				if (_managerData.panoramasData[0] != undefined && 
				 panoramaData.path == _managerData.panoramasData[0].path) {
					return;
				}
				
				for (var cleanedPanoramaData:PanoramaData in _managerData.panoramasData) {
					
				}
				
				_managerData.panoramasData.push(panoramaData);
				
				var mainGpsData:GpsData = new GpsData();
				mainGpsData.latitude = Number(panoxml.pano.@latitude);
				mainGpsData.longitude = Number(panoxml.pano.@longitude);
				mainGpsData.altitude = Number(panoxml.pano.@altitude);
				
				Trace.instance.printInfo("main lat: "+panoxml.pano.@latitude+" lon: "+panoxml.pano.@longitude);
				
				// add hotspots to main panorama, create neighbour panoramas
				
				var counter:int = 0;
				var hotspotData:com.diystreetview.player.manager.data.hotspot.HotspotData;
				var hotspotGpsData:GpsData;
				var hotspotDistanceAway:Number;
				
				for each(var neighbour:XML in panoxml.neighbours.children()){
					hotspotData = new DsvHotspotData("?", neighbour.@path);
					hotspotData.id = String(counter);
					hotspotData.path = (_managerData as ManagerData).locationData.hotspot;
					
					hotspotData.mouse.onClick = String(counter); // child with id "n" when clikcked triggers action with id "n"
					hotspotData.mouse.onOver = String(counter) + "over"; 
					hotspotData.mouse.onOut = "hide"; 
					
					hotspotGpsData = new GpsData();
					hotspotGpsData.latitude = Number(neighbour.@latitude);
					hotspotGpsData.longitude = Number(neighbour.@longitude);
					hotspotGpsData.altitude = Number(neighbour.@altitude);
					
					hotspotDistanceAway = distance(mainGpsData.latitude, mainGpsData.longitude, hotspotGpsData.latitude, hotspotGpsData.longitude);
					
					hotspotData.position.pan = Math.atan2(
						distance(mainGpsData.latitude, 0, hotspotGpsData.latitude, 0, true),
						distance(0, mainGpsData.longitude, 0, hotspotGpsData.longitude, true)
					) * 180 / Math.PI;
					
					hotspotData.position.pan += Number(panoxml.pano.@direction) - 90;
					hotspotData.position.tilt = -90 + (180 / Math.PI) * Math.atan(hotspotDistanceAway / 0.0019); // 0.0019 is camera height in kilometers
					hotspotData.position.distance = 30000 * hotspotDistanceAway;
					
					if ( hotspotData.position.pan <= -180 ) hotspotData.position.pan = (((hotspotData.position.pan + 180) % 360) + 180);
					if ( hotspotData.position.pan >   180 ) hotspotData.position.pan = (((hotspotData.position.pan + 180) % 360) - 180);
					
					hotspotData.gps.latitude = Number(neighbour.@latitude);
					hotspotData.gps.longitude = Number(neighbour.@longitude);
					hotspotData.gps.altitude = Number(neighbour.@altitude);
					
					_managerData.panoramasData[0].hotspotsData.push(hotspotData);
					
					// create neighbour panoramas 
					panoramaData = new DsvPanoramaData(String(counter), neighbour.@path);
					_managerData.panoramasData.push(panoramaData);
					
					counter++;
				}
				
				//_managerData.populateGlobalParams();
				
				super.loadPanoramaById(_managerData.panoramasData[0].id);
				
				ExternalInterface.call("panoChanged", _managerData.panoramasData[0].id);
				*/
			}catch (error:Error) {
				Trace.instance.printError("Error in new configuration file structure: " + error.message);
				trace(error.getStackTrace());
			}
		}
		
		private function buildPath(path:String):String {
			var name:String = path.substr(0, path.lastIndexOf("."));
			var result:String = "";
			result += (_managerData as DsvManagerData).diyStreetviewData.resources.directory;
			if ((_managerData as DsvManagerData).diyStreetviewData.resources.prefix != null) {
				result += (_managerData as DsvManagerData).diyStreetviewData.resources.prefix;
			}
			result += name +"/" + path;
			return result;
		}
		
		private function cleanPanoramasData():void {
			var tmpPanoramasData:Vector.<PanoramaData> = new Vector.<PanoramaData>();
			for each(var panoramaData:PanoramaData in _managerData.panoramasData) {
				if (!panoramaData is DsvPanoramaData) {
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
				if (!actionData is DsvActionData) {
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
		
		private function extractFromPath(path:String):String {
			return path.substring(path.lastIndexOf("/")+1, path.lastIndexOf("_"));
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
			var minDistance:Number =  Number.POSITIVE_INFINITY;
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
		
		private function deg2rad(deg:Number):Number {
			return (deg * Math.PI / 180.0);
		}
		
		private function rad2deg(rad:Number):Number {
			return (rad / Math.PI * 180.0);
		}
	}
}