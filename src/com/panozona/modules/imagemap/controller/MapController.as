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
package com.panozona.modules.imagemap.controller {
	
	import com.panozona.modules.imagemap.events.ContentViewerEvent;
	import com.panozona.modules.imagemap.events.MapEvent;
	import com.panozona.modules.imagemap.model.structure.Map;
	import com.panozona.modules.imagemap.model.structure.Waypoint;
	import com.panozona.modules.imagemap.model.WaypointData;
	import com.panozona.modules.imagemap.view.MapView;
	import com.panozona.modules.imagemap.view.WaypointView;
	import com.panozona.player.module.Module;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	public class MapController {
		
		private var _mapView:MapView; 
		private var _module:Module;
		
		private var waypointControlers:Array;
		private var arrListeners:Array;
		
		private var mapImageLoader:Loader;
		
		public function MapController(mapView:MapView, module:Module){
			_mapView = mapView;
			_module = module;
			
			waypointControlers = new Array();
			arrListeners = new Array();
			
			_mapView.imageMapData.mapData.addEventListener(MapEvent.CHANGED_CURRENT_MAP_ID, handleCurrentMapIdChange, false, 0, true);
			_mapView.imageMapData.mapData.addEventListener(ContentViewerEvent.FOCUS_LOST, handleFocusLost, false, 0, true);
		}
		
		public function loadFirstMap():void {
			_mapView.imageMapData.mapData.currentMapId = (_mapView.imageMapData.mapData.maps.getChildrenOfGivenClass(Map)[0]).id;
		}
		
		private function handleCurrentMapIdChange(e:Event):void {
			if (mapImageLoader == null) {
				mapImageLoader = new Loader();
				mapImageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, mapImageLost, false, 0, true);
				mapImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, mapImageLoaded, false, 0, true);
			}else {
				mapImageLoader.unload();
			}
			_mapView.waypointsContainer.visible = false;
			buildWaypoints();
			mapImageLoader.load(new URLRequest(_mapView.imageMapData.mapData.getMapById(_mapView.imageMapData.mapData.currentMapId).path));
			// TODO: loading bar or something
		}
		
		private function handleFocusLost(e:Event):void {
			for each( var waypointController:WaypointController in waypointControlers) {
				waypointController.lostFocus();
			}
		}
		
		private function mapImageLost(e:IOErrorEvent):void {
			_module.printError(e.text);
			// TODO: retry 
		}
		
		private function mapImageLoaded(e:Event):void {
			_mapView.mapImage.bitmapData = (mapImageLoader.content as Bitmap).bitmapData;
			_mapView.parent.dispatchEvent(new MapEvent(MapEvent.MAP_IMAGE_LOADED));
			_mapView.waypointsContainer.visible = true;
		}
		
		private function buildWaypoints():void{
			while (_mapView.waypointsContainer.numChildren) {
				_mapView.waypointsContainer.removeChildAt(0);
			}
			while (waypointControlers.length) {
				waypointControlers.pop();
			}
			var waypointView:WaypointView;
			var waypointController:WaypointController;
			var map:Map = _mapView.imageMapData.mapData.getMapById(_mapView.imageMapData.mapData.currentMapId);
			for each(var waypoint:Waypoint in map.getChildrenOfGivenClass(Waypoint)) {
				waypointView = new WaypointView(_mapView.imageMapData, new WaypointData(waypoint, map.buttons, map.radars));
				_mapView.waypointsContainer.addChild(waypointView);
				waypointController = new WaypointController(waypointView, _module);
				waypointControlers.push(waypointController);
				
				if (waypoint.mouse.onClick != null) {
					waypointView.button.addEventListener(MouseEvent.CLICK, getMouseEventHandler(waypoint.mouse.onClick));
					arrListeners.push({type:MouseEvent.CLICK, listener:getMouseEventHandler(waypoint.mouse.onClick)});
				}
				if (waypoint.mouse.onPress != null) {
					waypointView.button.addEventListener(MouseEvent.MOUSE_DOWN, getMouseEventHandler(waypoint.mouse.onPress));
					arrListeners.push({type:MouseEvent.MOUSE_DOWN, listener:getMouseEventHandler(waypoint.mouse.onPress)});
				}
				if (waypoint.mouse.onRelease != null) {
					waypointView.button.addEventListener(MouseEvent.MOUSE_UP, getMouseEventHandler(waypoint.mouse.onRelease));
					arrListeners.push({type:MouseEvent.MOUSE_UP, listener:getMouseEventHandler(waypoint.mouse.onRelease)});
				}
				if (waypoint.mouse.onOver != null) {
					waypointView.button.addEventListener(MouseEvent.ROLL_OVER, getMouseEventHandler(waypoint.mouse.onOver));
					arrListeners.push({type:MouseEvent.ROLL_OVER, listener:getMouseEventHandler(waypoint.mouse.onOver)});
				}
				if (waypoint.mouse.onOut != null) {
					waypointView.button.addEventListener(MouseEvent.ROLL_OUT, getMouseEventHandler(waypoint.mouse.onOut));
					arrListeners.push({type:MouseEvent.ROLL_OUT, listener:getMouseEventHandler(waypoint.mouse.onOut)});
				}
			}
		}
		
		private function getMouseEventHandler(actionId:String):Function{
			return function(e:MouseEvent):void {
				_module.saladoPlayer.manager.runAction(actionId);
			}
		}
		
		// TODO: remove hotspots on map change aim for buttons
		private function destroyWaypoints():void {
			for (var i:int = 0; i < _mapView.waypointsContainer.numChildren; i++ ) {
				for(var j:Number = 0; j < arrListeners.length; j++){
					//if (_mapView.waypointsContainer.getChildAt(i).hasEventListener(arrListeners[j].type)) {
						//_mapView.waypointsContainer.getChildAt(i).removeEventListener(arrListeners[j].type, arrListeners[j].listener);
					//}
				}
			}
		}
	}
}