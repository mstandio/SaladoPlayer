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
	import com.panozona.modules.infobubble.model.structure.Text;
	import com.panozona.modules.infobubble.model.structure.Style;
	import com.panozona.modules.infobubble.model.structure.Styles;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class InfoBubbleData{
		
		public const settings:Settings = new Settings();
		public const bubbles:Bubbles = new Bubbles();
		public const styles:Styles = new Styles();
		public const bubbleData:BubbleData = new BubbleData();
		
		public function InfoBubbleData(moduleData:ModuleData, saladoPlayer:Object):void {
			
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes){
				if(dataNode.name == "settings") {
					tarnslator.dataNodeToObject(dataNode, settings);
				}else if(dataNode.name == "bubbles") {
					tarnslator.dataNodeToObject(dataNode, bubbles);
				}else if(dataNode.name == "styles") {
					tarnslator.dataNodeToObject(dataNode, styles);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			bubbleData.enabled = settings.enabled;
			
			if (saladoPlayer.managerData.debugMode) {
				var bubbleIds:Object = new Object();
				var styleFound:Boolean;
				var stylesArray:Array = styles.getChildrenOfGivenClass(Style);
				for each (var bubble:Bubble in bubbles.getChildrenOfGivenClass(Bubble)) {
					if (bubble.id == null) throw new Error("Bubble id not specified.");
					if (bubble.angle > 180 || bubble.angle < -180) throw new Error("Invalid bubble angle in: " + bubble.id);
					if (bubble is Image && ((bubble as Image).path == null || !(bubble as Image).path.match(/^(.+)\.(png|gif|jpg|jpeg|swf)$/i))) {
						throw new Error("Invalid image path: " + (bubble as Image).path);
					}else if (bubble is Text && ((bubble as Text).style != null)) {
						styleFound = false;
						for each (var style:Style in stylesArray) {
							if ((bubble as Text).style == style.id) {
								styleFound = true;
								break;
							}
						}
						if (!styleFound) {
							throw new Error("style does not exist: " + (bubble as Text).style);
						}
					}
					if (bubbleIds[bubble.id] != undefined) {
						throw new Error("Repeating bubble id: " + bubble.id);
					}else {
						bubbleIds[bubble.id] = ""; // something
					}
				}
				var styleIds:Object = new Object();
				for each (style in stylesArray) {
					if (style.id == null) throw new Error("style id not specified.");
					if (styleIds[style.id] != undefined) {
						throw new Error("Repeating style id: " + style.id)
					}else {
						styleIds[style.id] = ""; // something
					}
				}
			}
		}
	}
}