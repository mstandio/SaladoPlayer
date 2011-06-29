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
package com.panozona.modules.infobubble.model{
	
	import com.panozona.modules.infobubble.model.structure.Bubble;
	import com.panozona.modules.infobubble.model.structure.Bubbles;
	import com.panozona.modules.infobubble.model.structure.Image;
	import com.panozona.modules.infobubble.model.structure.Settings;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class InfoBubbleData{
		
		public var settings:Settings = new Settings();
		public var bubbles:Bubbles = new Bubbles();
		public var bubbleData:BubbleData = new BubbleData();
		
		public function InfoBubbleData(moduleData:ModuleData, saladoPlayer:Object):void {
			
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes){
				if(dataNode.name == "settings") {
					tarnslator.dataNodeToObject(dataNode, settings);
				}else if(dataNode.name == "bubbles") {
					tarnslator.dataNodeToObject(dataNode, bubbles);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			bubbleData.enabled = settings.enabled;
			
			if (saladoPlayer.managerData.debugMode) {
				var bubbleIds:Object = new Object();
				for each (var bubble:Bubble in bubbles.getChildrenOfGivenClass(Bubble)) {
					if (bubble.id == null) throw new Error("Bubble id not specified.");
					if ( bubble is Image && ((bubble as Image).path == null || !(bubble as Image).path.match(/^(.+)\.(png|gif|jpg|jpeg|swf)$/i)))
						throw new Error("Invalid image path: " + (bubble as Image).path);
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