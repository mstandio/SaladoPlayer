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
package com.panozona.modules.jsgooglemap.data {
	
	import com.panozona.modules.jsgooglemap.data.structure.*;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class JSGoogleMapData {
		
		public var settings:Settings = new Settings();
		public var waypoints:Waypoints = new Waypoints();
		public var tracks:Tracks = new Tracks();
		
		public function JSGoogleMapData(moduleData:ModuleData, saladoPlayer:Object) {
			
			var translator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "settings") {
					translator.dataNodeToObject(dataNode, settings);
				}else if (dataNode.name == "waypoints") {
					translator.dataNodeToObject(dataNode, waypoints);
				}else if (dataNode.name == "tracks") {
					translator.dataNodeToObject(dataNode, tracks);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			if (saladoPlayer.managerData.debugMode) {
				if (settings.onShow != null) {
					if (saladoPlayer.managerData.getActionDataById(settings.onShow) == null) {
						throw new Error("Action: does not exist: " +settings.onShow );
					}
				}
				if (settings.onHide != null) {
					if (saladoPlayer.managerData.getActionDataById(settings.onHide) == null) {
						throw new Error("Action: does not exist: " + settings.onHide);
					}
				}
			}
		}
	}
}