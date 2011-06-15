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
package com.panozona.modules.panolink.model {
	
	import com.panozona.modules.panolink.model.structure.Settings;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class PanoLinkData {
		
		public var settings:Settings = new Settings();
		public var windowData:WindowData;
		
		public function PanoLinkData(moduleData:ModuleData, saladoPlayer:Object) {
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "settings") {
					tarnslator.dataNodeToObject(dataNode, settings);
				}else{
					throw new Error("Could not recognize: " + dataNode.name);
				}
			}
			
			windowData = new WindowData(settings);
			
			if (saladoPlayer.managerData.debugMode) {
				if (settings.onOpen != null) {
					if (saladoPlayer.managerData.getActionDataById(settings.onOpen) == null) {
						throw new Error("Action does not exist: " +settings.onOpen );
					}
				}
				if (settings.onClose != null) {
					if (saladoPlayer.managerData.getActionDataById(settings.onClose) == null) {
						throw new Error("Action does not exist: " + settings.onClose);
					}
				}
			}
		}
	}
}