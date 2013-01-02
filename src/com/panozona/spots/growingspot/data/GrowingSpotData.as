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
package com.panozona.spots.growingspot.data{
	
	import com.panozona.spots.growingspot.data.structure.Settings;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class GrowingSpotData{
		
		public var settings:Settings = new Settings();
		
		public function GrowingSpotData(hotspotDataSwf:Object, saladoPlayer:Object) {
			
			var translator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in (hotspotDataSwf.nodes as Vector.<DataNode>)) {
				if ( dataNode.name == "settings") {
					translator.dataNodeToObject(dataNode, settings);
				}else {
					throw new Error("Unrecognized node name: " + dataNode.name);
				}
			}
			
			if (saladoPlayer.managerData.debugMode) {
				if (!settings.path.match(/^.+(.jpg|.jpeg|.png|.gif)$/i)) {
					throw new Error("Invalid path to image.");
				}
			}
		}
	}
}