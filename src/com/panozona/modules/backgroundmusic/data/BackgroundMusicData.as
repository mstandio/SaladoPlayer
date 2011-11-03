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
package com.panozona.modules.BackgroundMusic.data{
	
	import com.panozona.modules.BackgroundMusic.data.structure.Settings;
	import com.panozona.modules.BackgroundMusic.data.structure.Track;
	import com.panozona.modules.BackgroundMusic.data.structure.Tracks;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class BackgroundMusicData {
		
		public var settings:Settings = new Settings();
		public var tracks:Tracks = new Tracks();
		
		public function BackgroundMusicData(moduleData:ModuleData, saladoPlayer:Object):void {
			
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes){
				if(dataNode.name == "settings") {
					tarnslator.dataNodeToObject(dataNode, settings);
				}else if(dataNode.name == "tracks") {
					tarnslator.dataNodeToObject(dataNode, tracks);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			if (saladoPlayer.managerData.debugMode) {
				if (tracks.getChildrenOfGivenClass(Track).length == 0) throw new Error("No Tracks found.");
				if (settings.onPlay != null && saladoPlayer.managerData.getActionDataById(settings.onPlay) == null)
					throw new Error("Action does not exist: " + settings.onPlay);
				if (settings.onStop != null && saladoPlayer.managerData.getActionDataById(settings.onStop) == null)
					throw new Error("Action does not exist: " + settings.onStop);
				var trackIds:Object = new Object();
				for each (var track:Track in tracks.getChildrenOfGivenClass(Track)) {
					if (track.id == null) throw new Error("Track id not specified.");
					if (track.path == null) throw new Error("Path not specified in track: " + track.id);
					if (!track.path.match(/^.+\.mp3$/i)) throw new Error("Invalid path in track: " + track.id);
					if (trackIds[track.id] != undefined) {
						throw new Error("Repeating track id: " + track.id);
					}else {
						trackIds[track.id] = ""; // something
					}
				}
				for each (track in tracks.getChildrenOfGivenClass(Track)) {
					if (track.next != null && trackIds[track.next] == undefined) {
						throw new Error("Track does not exist: " + track.next);
					}
				}
			}
		}
	}
}