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
	import com.panozona.player.component.data.ComponentData;
	import com.panozona.player.component.data.ComponentNode;
	import com.panozona.player.component.utils.ComponentDataTranslator;
	
	public class ImageMapData {
		
		public var windowData:WindowData = new WindowData();
		public var contentViewerData:ContentViewerData = new ContentViewerData();
		public var mapData:MapData = new MapData();
		
		public function ImageMapData(componentData:ComponentData, debugMode:Boolean) {
			var tarnslator:ComponentDataTranslator = new ComponentDataTranslator(debugMode);
			for each(var componentNode:ComponentNode in componentData.nodes) {
				if (componentNode.name == "window") {
					tarnslator.translateComponentNodeToObject(componentNode, windowData);
				}else if (componentNode.name == "viewer") {
					tarnslator.translateComponentNodeToObject(componentNode, contentViewerData.viewer);
				}else if (componentNode.name == "maps") {
					tarnslator.translateComponentNodeToObject(componentNode, mapData.maps);
				}else {
					throw new Error("Invalid node name: " + componentNode.name);
				}
			}
			
			if (debugMode) {
				var imageMapDataValidator:ImageMapDataValidator = new ImageMapDataValidator();
				imageMapDataValidator.validate(this);
			}
		}
	}
}