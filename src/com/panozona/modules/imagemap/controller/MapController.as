/*
Copyright 2012 Marek Standio.

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
	
	import com.panozona.modules.imagemap.events.MapEvent;
	import com.panozona.modules.imagemap.events.ViewerEvent;
	import com.panozona.modules.imagemap.events.WaypointEvent;
	import com.panozona.modules.imagemap.model.ExtraWaypointData;
	import com.panozona.modules.imagemap.model.RawWaypointData;
	import com.panozona.modules.imagemap.model.structure.ExtraWaypoint;
	import com.panozona.modules.imagemap.model.structure.Map;
	import com.panozona.modules.imagemap.model.structure.RawWaypoint;
	import com.panozona.modules.imagemap.model.structure.Waypoint;
	import com.panozona.modules.imagemap.model.structure.Waypoints;
	import com.panozona.modules.imagemap.model.WaypointData;
	import com.panozona.modules.imagemap.view.ExtraWaypointView;
	import com.panozona.modules.imagemap.view.MapView;
	import com.panozona.modules.imagemap.view.RawWaypointView;
	import com.panozona.modules.imagemap.view.WaypointView;
	import com.panozona.player.manager.events.LoadLoadableEvent;
	import com.panozona.player.manager.utils.loading.ILoadable;
	import com.panozona.player.manager.utils.loading.LoadablesLoader;
	import com.panozona.player.module.data.property.Size;
	import com.panozona.player.module.Module;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class MapController {
		
		private var _mapView:MapView;
		private var _module:Module;
		
		private var rawWaypointControlers:Vector.<RawWaypointController>;
		private var arrListeners:Array;
		
		private var mapContentLoader:Loader;
		private var waypointsLoader:LoadablesLoader;
		
		private var previousMapId:String;
		
		public function MapController(mapView:MapView, module:Module){
			_mapView = mapView;
			_module = module;
			
			rawWaypointControlers = new Vector.<RawWaypointController>();
			arrListeners = new Array();
			
			mapContentLoader = new Loader();
			mapContentLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, mapContentLost, false, 0, true);
			mapContentLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, mapContentLoaded, false, 0, true);
			
			waypointsLoader = new LoadablesLoader();
			waypointsLoader.addEventListener(LoadLoadableEvent.LOST, waypointsLost);
			waypointsLoader.addEventListener(LoadLoadableEvent.LOADED, waypointsLoaded);
			
			_mapView.imageMapData.mapData.addEventListener(MapEvent.CHANGED_CURRENT_MAP_ID, handleCurrentMapIdChange, false, 0, true);
			_mapView.imageMapData.mapData.addEventListener(MapEvent.CHANGED_RADAR_FIRST, handleRadarFirstChange, false, 0, true);
			_mapView.imageMapData.viewerData.addEventListener(ViewerEvent.FOCUS_LOST, handleFocusLost, false, 0, true);
			_mapView.imageMapData.viewerData.addEventListener(ViewerEvent.CHANGED_SCALE, handleScaleChanged, false, 0, true);
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
		}
		
		private function onPanoramaLoaded(loadPanoramaEvent:Object):void {
			if (_mapView.imageMapData.viewerData.viewer.autoSwitch) {
				if (_mapView.imageMapData.mapData.currentMapId != null) {
					// check current map
					var currentMap:Map = _mapView.imageMapData.mapData.getMapById(_mapView.imageMapData.mapData.currentMapId);
					for each(var waypoints_a:Waypoints in currentMap.getChildrenOfGivenClass(Waypoints)) {
						for each(var waypoint_a:Waypoint in waypoints_a.getChildrenOfGivenClass(Waypoint)) {
							if (waypoint_a.target == _module.saladoPlayer.manager.currentPanoramaData.id) {
								return;
							}
						}
					}
					// check all maps
					for each(var map:Map in _mapView.imageMapData.mapData.maps.getChildrenOfGivenClass(Map)) {
						for each(var waypoints_b:Waypoints in map.getChildrenOfGivenClass(Waypoints)) {
							for each(var waypoint_b:Waypoint in waypoints_b.getChildrenOfGivenClass(Waypoint)) {
								if (waypoint_b.target == _module.saladoPlayer.manager.currentPanoramaData.id) {
									_mapView.imageMapData.mapData.currentMapId = map.id;
									return;
								}
							}
						}
					}
				}
			}
			if(_mapView.imageMapData.mapData.currentMapId == null){
				_mapView.imageMapData.mapData.currentMapId = (_mapView.imageMapData.mapData.maps.getChildrenOfGivenClass(Map)[0]).id;
			}
		}
		
		private function handleCurrentMapIdChange(e:Event):void {
			mapContentLoader.unload();
			destroyWaypoints();
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			context.checkPolicyFile = true;
			mapContentLoader.load(new URLRequest(_mapView.imageMapData.mapData.getMapById(_mapView.imageMapData.mapData.currentMapId).path), context);
			if (previousMapId != null) {
				_module.saladoPlayer.manager.runAction(_mapView.imageMapData.mapData.getMapById(previousMapId).onUnset);
			}
			previousMapId = _mapView.imageMapData.mapData.currentMapId;
			_module.saladoPlayer.manager.runAction(_mapView.imageMapData.mapData.getMapById(_mapView.imageMapData.mapData.currentMapId).onSet);
		}
		
		private function handleRadarFirstChange(e:Event):void {
			_mapView.placeContainers();
		}
		
		private function handleFocusLost(e:Event):void {
			for (var i:int = 0; i < _mapView.waypointsContainer.numChildren; i++) {
				(_mapView.waypointsContainer.getChildAt(i) as RawWaypointView).rawWaypointData.hasFocus = false;
			}
		}
		
		private function handleFocusGained(e:Event=null):void {
			var rawWaypointView:RawWaypointView = null;
			for (var i:int = 0; i < _mapView.waypointsContainer.numChildren; i++) {
				rawWaypointView = (_mapView.waypointsContainer.getChildAt(i) as RawWaypointView);
				if (rawWaypointView.rawWaypointData.isActive) {
					rawWaypointView.viewerData.focusPoint = new Point(rawWaypointView.x, rawWaypointView.y);
					break;
				}
			}
		}
		
		private function handleScaleChanged(e:Event):void {
			placeWaypoints();
		}
		
		private function mapContentLost(e:IOErrorEvent):void {
			_module.printError(e.text);
		}
		
		private function mapContentLoaded(e:Event):void {
			_mapView.imageMapData.viewerData.currentZoom = _mapView.imageMapData.mapData.getMapById(_mapView.imageMapData.mapData.currentMapId).zoom;
			_mapView.imageMapData.mapData.size = new Size(mapContentLoader.content.width, mapContentLoader.content.height);
			_mapView.content = mapContentLoader.content;
			buildWaypoints();
		}
		
		private function buildWaypoints():void {
			var waypointsGroup:Vector.<ILoadable> = new Vector.<ILoadable>();
			for each (var waypoints:Waypoints in _mapView.imageMapData.mapData.getMapById(_mapView.imageMapData.mapData.currentMapId).getChildrenOfGivenClass(Waypoints)) {
				waypointsGroup.push(waypoints);
			}
			waypointsLoader.load(waypointsGroup);
		}
		
		protected function waypointsLost(event:LoadLoadableEvent):void {
			_module.printError("Could not load waypoints: " + event.loadable.path);
		}
		
		protected function waypointsLoaded(event:LoadLoadableEvent):void {
			var bitmapData:BitmapData = new BitmapData(event.content.width, event.content.height, true, 0);
			bitmapData.draw((event.content as Bitmap).bitmapData);
			
			var cellHeight:int = Math.ceil((bitmapData.height - 2) / 3);
			
			var bitmapDataPlain:BitmapData = new BitmapData(bitmapData.width, cellHeight, true, 0);
			bitmapDataPlain.copyPixels(bitmapData, new Rectangle(0, 0, bitmapData.width, cellHeight), new Point(0, 0), null, null, true);
			
			var bitmapDataHover:BitmapData = new BitmapData(bitmapData.width, cellHeight, true, 0);
			bitmapDataHover.copyPixels(bitmapData, new Rectangle(0, cellHeight + 1, bitmapData.width, cellHeight), new Point(0, 0), null, null, true);
			
			var bitmapDataActive:BitmapData = new BitmapData(bitmapData.width, cellHeight, true, 0);
			bitmapDataActive.copyPixels(bitmapData, new Rectangle(0, cellHeight * 2 + 2, bitmapData.width, cellHeight), new Point(0, 0), null, null, true);
			
			var rawWaypointData:RawWaypointData;
			var rawWaypointView:RawWaypointView;
			var rawWaypointController:RawWaypointController
			var map:Map = _mapView.imageMapData.mapData.getMapById(_mapView.imageMapData.mapData.currentMapId);
			var waypoints:Waypoints = (event.loadable as Waypoints);
			
			if (map.getChildrenOfGivenClass(Waypoints).indexOf(waypoints) < 0) return;
			
			for each(var rawWaypoint:RawWaypoint in waypoints.getAllChildren()) {
				if (rawWaypoint is Waypoint) {
					rawWaypointData = new WaypointData(rawWaypoint as Waypoint, waypoints.move, bitmapDataPlain, bitmapDataHover, bitmapDataActive, waypoints.radar, map.panShift);
					rawWaypointView = new WaypointView(_mapView.imageMapData, rawWaypointData as WaypointData, _mapView);
					rawWaypointController = new WaypointController(rawWaypointView as WaypointView, _module);
					rawWaypointControlers.push(rawWaypointController);
				}else {
					rawWaypointData = new ExtraWaypointData(rawWaypoint as ExtraWaypoint, waypoints.move, bitmapDataPlain, bitmapDataHover, bitmapDataActive);
					rawWaypointView = new ExtraWaypointView(_mapView.imageMapData, rawWaypointData as ExtraWaypointData, _mapView.imageMapData.mapData);
					rawWaypointController = new ExtraWaypointController(rawWaypointView as ExtraWaypointView, _module);
					rawWaypointControlers.push(rawWaypointController);
				}
				var added:Boolean = false;
				for (var i:int = 0; i < _mapView.waypointsContainer.numChildren && !added; i++) {
					if ((_mapView.waypointsContainer.getChildAt(i) as RawWaypointView).rawWaypointData.rawWaypoint.position.y > rawWaypointView.rawWaypointData.rawWaypoint.position.y) {
						_mapView.waypointsContainer.addChildAt(rawWaypointView, i);
						added = true;
					}
				}
				if (!added) {
					_mapView.waypointsContainer.addChild(rawWaypointView);
				}
				rawWaypointData.addEventListener(WaypointEvent.FOCUS_GAINED, handleFocusGained, false, 0, true);
				var handlerTmp:Function;
				if (rawWaypoint.mouse.onOver != null) {
					handlerTmp = getMouseEventHandler(rawWaypoint.mouse.onOver);
					rawWaypointView.button.addEventListener(MouseEvent.ROLL_OVER, handlerTmp);
					arrListeners.push({type:MouseEvent.ROLL_OVER, listener:handlerTmp});
				}
				if (rawWaypoint.mouse.onOut != null) {
					handlerTmp = getMouseEventHandler(rawWaypoint.mouse.onOut);
					rawWaypointView.button.addEventListener(MouseEvent.ROLL_OUT, handlerTmp);
					arrListeners.push({type:MouseEvent.ROLL_OUT, listener:handlerTmp});
				}
			}
			placeWaypoints();
			handleFocusGained();
		}
		
		private function getMouseEventHandler(actionId:String):Function{
			return function(e:MouseEvent):void {
				_module.saladoPlayer.manager.runAction(actionId);
			}
		}
		
		private function placeWaypoints():void {
			for (var i:int = 0; i < _mapView.waypointsContainer.numChildren; i++) {
				(_mapView.waypointsContainer.getChildAt(i) as RawWaypointView).placeWaypoint();
			}
		}
		
		private function destroyWaypoints():void {
			for (var i:int = 0; i < _mapView.waypointsContainer.numChildren; i++ ) {
				for (var j:Number = 0; j < arrListeners.length; j++) {
					if (_mapView.waypointsContainer.getChildAt(i).hasEventListener(arrListeners[j].type)) {
						_mapView.waypointsContainer.getChildAt(i).removeEventListener(arrListeners[j].type, arrListeners[j].listener);
					}
				}
			}
			while (_mapView.waypointsContainer.numChildren) {
				_mapView.waypointsContainer.removeChildAt(0);
			}
			while (_mapView.radarContainer.numChildren) {
				_mapView.radarContainer.removeChildAt(0);
			}
			while (rawWaypointControlers.length) {
				rawWaypointControlers.pop();
			}
		}
	}
}
