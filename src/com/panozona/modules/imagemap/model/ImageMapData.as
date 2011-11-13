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
package com.panozona.modules.imagemap.model {
	
	import com.panozona.modules.imagemap.model.structure.Close;
	import com.panozona.modules.imagemap.model.structure.Map;
	import com.panozona.modules.imagemap.model.structure.Waypoint;
	import com.panozona.modules.imagemap.model.structure.Waypoints;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class ImageMapData {
		
		public const windowData:WindowData = new WindowData();
		public const close:Close = new Close();
		public const viewerData:ViewerData = new ViewerData();
		public const mapData:MapData = new MapData();
		
		public function ImageMapData(moduleData:ModuleData, saladoPlayer:Object) {
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "window") {
					tarnslator.dataNodeToObject(dataNode, windowData.window);
				}else if (dataNode.name == "close") {
					tarnslator.dataNodeToObject(dataNode, close);
				}else if (dataNode.name == "viewer") {
					tarnslator.dataNodeToObject(dataNode, viewerData.viewer);
				}else if (dataNode.name == "maps") {
					tarnslator.dataNodeToObject(dataNode, mapData.maps);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			windowData.open = windowData.window.open;
			
			if (saladoPlayer.managerData.debugMode) {
				if (viewerData.viewer.moveEnabled || viewerData.viewer.zoomEnabled || viewerData.viewer.dragEnabled) {
					if (viewerData.viewer.path == null || !viewerData.viewer.path.match(/^(.+)\.(png|gif|jpg|jpeg|swf)$/i))
						throw new Error("Invalid viewer path: " + viewerData.viewer.path);
				}
				if (windowData.window.onOpen != null && saladoPlayer.managerData.getActionDataById(windowData.window.onOpen) == null) {
					throw new Error("Action does not exist: " + windowData.window.onOpen);
				}
				if (windowData.window.onClose != null && saladoPlayer.managerData.getActionDataById(windowData.window.onClose) == null) {
					throw new Error("Action does not exist: " + windowData.window.onClose);
				}
				if (mapData.maps.getChildrenOfGivenClass(Map).length == 0) {
					throw new Error("No maps found.");
				}
				var mapIds:Object = new Object();
				var waypointTargets:Object = new Object();
				for each(var map:Map in mapData.maps.getChildrenOfGivenClass(Map)) {
					if (map.id == null) {
						throw new Error("Map id not specified.");
					}
					if (map.path == null || !map.path.match(/^(.+)\.(png|gif|jpg|jpeg|swf)$/i)) {
						throw new Error("Invalid map path: " + map.path);
					}
					if (map.onSet != null && saladoPlayer.managerData.getActionDataById(map.onSet) == null) {
						throw new Error("Action does not exist: " + map.onSet);
					}
					if (mapIds[map.id] != undefined) {
						throw new Error("Repeating map id: " + map.id);
					}else {
						mapIds[map.id] = ""; // something
						for each(var waypoints:Waypoints in map.getChildrenOfGivenClass(Waypoints)) {
							if (waypoints.path == null || !waypoints.path.match(/^(.+)\.(png|gif|jpg|jpeg|)$/i)) {
								throw new Error("Invalid waypoints path: " + waypoints.path);
							}
							for each(var waypoint:Waypoint in waypoints.getChildrenOfGivenClass(Waypoint)) {
								if (waypoint.target == null) {
									throw new Error("Waypoint target not specified in map: " + map.id);
								}
								if (saladoPlayer.managerData.getPanoramaDataById(waypoint.target) == null) {
									throw new Error("Invalid waypoint target: " + waypoint.target);
								}
								if (waypoint.mouse.onOver != null && saladoPlayer.managerData.getActionDataById(waypoint.mouse.onOver) == null){
									throw new Error("Action does not exist: " + waypoint.mouse.onOver);
								}
								if (waypoint.mouse.onOut != null && saladoPlayer.managerData.getActionDataById(waypoint.mouse.onOut) == null){
									throw new Error("Action does not exist: " + waypoint.mouse.onOut);
								}
								if (waypointTargets[waypoint.target] != undefined) {
									throw new Error("Repeating waypoint target: " + waypoint.target);
								}else {
									waypointTargets[waypoint.target] = ""; // something
								}
							}
						}
					}
				}
			}
		}
	}
}