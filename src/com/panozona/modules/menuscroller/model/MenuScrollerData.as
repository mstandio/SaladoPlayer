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
package com.panozona.modules.menuscroller.model {
	
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class MenuScrollerData {
		
		public var windowData:WindowData = new WindowData();
		
		public function MenuScrollerData(moduleData:ModuleData, debugMode:Boolean) {
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(debugMode);
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "window") {
					tarnslator.dataNodeToObject(dataNode, windowData.window);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			windowData.open = windowData.window.open;
			windowData.elasticWidth = windowData.window.size.width;
			windowData.elasticHeight = windowData.window.size.height;
			
			if (debugMode) {
				// something something 
			}
		}
	}
}