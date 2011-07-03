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
	
	import com.panozona.modules.menuscroller.model.structure.Element;
	import com.panozona.modules.menuscroller.model.structure.Elements;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class MenuScrollerData {
		
		public const windowData:WindowData = new WindowData();
		public const scrollerData:ScrollerData = new ScrollerData();
		public const elements:Elements = new Elements();
		
		public function MenuScrollerData(moduleData:ModuleData, saladoPlayer:Object) {
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "window") {
					tarnslator.dataNodeToObject(dataNode, windowData.window);
				}else if (dataNode.name == "scroller") {
					tarnslator.dataNodeToObject(dataNode, scrollerData.scroller);
				}else if (dataNode.name == "elements") {
					tarnslator.dataNodeToObject(dataNode, elements);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			windowData.open = windowData.window.open;
			windowData.elasticWidth = windowData.window.size.width;
			windowData.elasticHeight = windowData.window.size.height;
			
			if (saladoPlayer.managerData.debugMode) {
				if (windowData.window.onOpen != null && saladoPlayer.managerData.getActionDataById(windowData.window.onOpen) == null) {
					throw new Error("Action does not exist: " + windowData.window.onOpen);
				}
				if (windowData.window.onClose != null && saladoPlayer.managerData.getActionDataById(windowData.window.onClose) == null) {
					throw new Error("Action does not exist: " + windowData.window.onClose);
				}
				var elementTargets:Object = new Object();
				for each (var element:Element in elements.getChildrenOfGivenClass(Element)) {
					if (element.target == null) throw new Error("Element target not specified.");
					if (saladoPlayer.managerData.getPanoramaDataById(element.target) == null) throw new Error("Invalid waypoint target: " + element.target);
					if (elementTargets[element.target] != undefined) {
						throw new Error("Repeating element target: " + element.target);
					}else {
						elementTargets[element.target] = ""; // something
					}
				}
			}
		}
	}
}