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
package com.panozona.modules.infobubble.data{
	
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.ModuleNode;
	import com.panozona.player.module.data.structure.Master;
	
	import com.panozona.modules.infobubble.data.structure.Settings;
	import com.panozona.modules.infobubble.data.structure.Bubbles;
	import com.panozona.modules.infobubble.data.structure.Bubble;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class InfoBubbleData extends Master{
		
		public var settings:Settings = new Settings();
		public var bubbles:Bubbles = new Bubbles();
		
		public function InfoBubbleData(moduleData:ModuleData, debugMode:Boolean) {
			super(debugMode);
			
			for each(var moduleNode:ModuleNode in moduleData.moduleNodes){
				switch(moduleNode.nodeName) {
					case "settings": 
						readRecursive(settings, moduleNode);
					break;
					case "bubbles": 
						readRecursive(bubbles, moduleNode);
					break;
					default:
						throw new Error("Invalid node name: "+moduleNode.nodeName);
				}
			}
			
			if (debugMode) {
				var bubbleIds:Object = new Object();
				for each (var bubble:Bubble in bubbles.getChildrenOfGivenClass(Bubble)) {
					if (bubble.id == null) throw new Error("Bubble id not specified.");
					if (bubble.path == null) throw new Error("Bubble path not specified.");
					if (bubbleIds[bubble.id] != undefined) {
						throw new Error("Repeating bubble id: "+bubble.id);
					}else {
						bubbleIds[bubble.id] = ""; // something
					}
				}
			}
		}
	}
}