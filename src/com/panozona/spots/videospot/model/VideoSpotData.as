/*
Copyright 2010 Marek Standio.

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
along with SaladoPlayer.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.spots.videospot.model {
	
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class VideoSpotData {
		
		public var settings:Settings = new Settings();
		public var streamData:StreamData = new StreamData();
		public var playerData:PlayerData = new PlayerData();
		public var soundData:SoundData = new SoundData();
		public var barData:BarData = new BarData();
		
		public function VideoSpotData (hotspotDataSwf:Object, saladoPlayer:Object) {
			
			var translator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in (hotspotDataSwf.nodes as Vector.<DataNode>)) {
				if ( dataNode.name == "settings") {
					translator.dataNodeToObject(dataNode, settings);
				}else {
					throw new Error("Unrecognized node name: " + dataNode.name);
				}
			}
			
			if (saladoPlayer.managerData.debugMode) {
				if (settings.splashPath != null && !settings.splashPath.match(/^.+(.jpg|.jpeg|.png|.gif)$/i)) {
					throw new Error("Invalid path to splash.");
				}
			}
		}
	}
}