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
package com.panozona.modules.imagemap.model {
	
	import com.panozona.modules.imagemap.utils.ImageMapDataValidator;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.ModuleNode;
	import com.panozona.player.module.utils.ModuleDataTranslator;
	
	public class ImageMapData {
		
		public var windowData:WindowData = new WindowData();
		public var contentViewerData:ContentViewerData = new ContentViewerData();
		public var mapData:MapData = new MapData();
		
		public function ImageMapData(moduleData:ModuleData, debugMode:Boolean) {
			var tarnslator:ModuleDataTranslator = new ModuleDataTranslator(debugMode);
			for each(var moduleNode:ModuleNode in moduleData.nodes) {
				if (moduleNode.name == "window") {
					tarnslator.translateModuleNodeToObject(moduleNode, windowData);
				}else if (moduleNode.name == "viewer") {
					tarnslator.translateModuleNodeToObject(moduleNode, contentViewerData.viewer);
				}else if (moduleNode.name == "maps") {
					tarnslator.translateModuleNodeToObject(moduleNode, mapData.maps);
				}else {
					throw new Error("Invalid node name: " + moduleNode.name);
				}
			}
			
			if (debugMode) {
				var imageMapDataValidator:ImageMapDataValidator = new ImageMapDataValidator();
				imageMapDataValidator.validate(this);
			}
		}
	}
}