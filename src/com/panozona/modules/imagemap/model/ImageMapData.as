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
	
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.ModuleNode;
	import com.panozona.player.module.data.structure.Master
	
	import com.panozona.modules.imagemap.utils.ImageMapDataValidator;
	
	/**
	 * @author mstandio
	 */
	public class ImageMapData extends Master {
		
		public var windowData:WindowData = new WindowData();
		public var contentViewerData:ContentViewerData = new ContentViewerData();
		public var mapData:MapData = new MapData();
		
		public function ImageMapData(moduleData:ModuleData, debugMode:Boolean) {
			super(debugMode);
			
			for each(var moduleNode:ModuleNode in moduleData.moduleNodes){
				switch(moduleNode.nodeName) {
					case "window": 
						readRecursive(windowData, moduleNode);
					break;
					case "viewer":
						readRecursive(contentViewerData.viewer, moduleNode);
					break;
					case "maps": 
						readRecursive(mapData.maps, moduleNode);
					break;
					default:
						throw new Error("Invalid node name: "+moduleNode.nodeName);
				}
			}
			
			if (debugMode) {
				var imageMapDataValidator:ImageMapDataValidator = new ImageMapDataValidator();
				imageMapDataValidator.validate(this);
			}
		}
	}
}