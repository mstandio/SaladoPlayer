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
package com.panozona.modules.infobubble.data{
	
	import com.panozona.modules.infobubble.data.structure.Bubble;
	import com.panozona.modules.infobubble.data.structure.Bubbles;
	import com.panozona.modules.infobubble.data.structure.Settings;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.ModuleNode;
	import com.panozona.player.module.utils.ModuleDataTranslator;
	
	public class InfoBubbleData{
		
		public var settings:Settings = new Settings();
		public var bubbles:Bubbles = new Bubbles();
		
		public function InfoBubbleData(moduleData:ModuleData, saladoPlayer:Object):void {
			
			var tarnslator:ModuleDataTranslator = new ModuleDataTranslator(saladoPlayer.managerData.debugMode);
			
			for each(var moduleNode:ModuleNode in moduleData.nodes){
				if(moduleNode.name == "settings") {
					tarnslator.moduleNodeToObject(moduleNode, settings);
				}else if(moduleNode.name == "bubbles") {
					tarnslator.moduleNodeToObject(moduleNode, bubbles);
				}else {
					throw new Error("Invalid node name: "+moduleNode.name);
				}
			}
			
			if (saladoPlayer.managerData.debugMode) {
				var bubbleIds:Object = new Object();
				for each (var bubble:Bubble in bubbles.getChildrenOfGivenClass(Bubble)) {
					if (bubble.id == null) throw new Error("Bubble id not specified.");
					if (bubble.path == null) throw new Error("Bubble path not specified.");
					if (bubbleIds[bubble.id] != undefined) {
						throw new Error("Repeating bubble id: " + bubble.id);
					}else {
						bubbleIds[bubble.id] = ""; // something
					}
				}
			}
		}
	}
}