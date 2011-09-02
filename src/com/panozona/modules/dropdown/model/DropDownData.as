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
package com.panozona.modules.dropdown.model{
	
	import com.panozona.modules.dropdown.model.structure.Element;
	import com.panozona.modules.dropdown.model.structure.ExtraElement;
	import com.panozona.modules.dropdown.model.structure.RawElement;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class DropDownData{
		
		public const windowData:WindowData = new WindowData();
		public const boxData:BoxData = new BoxData();
		
		public function DropDownData(moduleData:ModuleData, saladoPlayer:Object){
			
			var translator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "window") {
					translator.dataNodeToObject(dataNode, windowData.window);
				}else if (dataNode.name == "box") {
					translator.dataNodeToObject(dataNode, boxData.box);
				}else if (dataNode.name == "elements") {
					translator.dataNodeToObject(dataNode, boxData.elements);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			windowData.open = windowData.window.open;
			
			if (saladoPlayer.managerData.debugMode) {
				if (windowData.window.onOpen != null && saladoPlayer.managerData.getActionDataById(windowData.window.onOpen) == null) {
					throw new Error("Action does not exist: " + windowData.window.onOpen);
				}
				if (windowData.window.onClose != null && saladoPlayer.managerData.getActionDataById(windowData.window.onClose) == null) {
					throw new Error("Action does not exist: " + windowData.window.onClose);
				}
				
				var elementTargets:Object = new Object();
				var extraElementIds:Object = new Object();
				for each (var rawElement:RawElement in boxData.elements.getAllChildren()) {
					if (rawElement is Element) {
						if ((rawElement as Element).target == null) throw new Error("Element target not specified.");
						if (saladoPlayer.managerData.getPanoramaDataById((rawElement as Element).target) == null) {
							throw new Error("Invalid element target: " + (rawElement as Element).target);
						}
						if (elementTargets[(rawElement as Element).target] != undefined) {
							throw new Error("Repeating element target: " + (rawElement as Element).target);
						}else {
							elementTargets[(rawElement as Element).target] = ""; // something
						}
					}else {
						if ((rawElement as ExtraElement).id == null) throw new Error("ExtraElement id not specified.");
						if (extraElementIds[(rawElement as ExtraElement).id] != undefined) throw new Error("Repeating extraElement id: " + (rawElement as ExtraElement).id);
						extraElementIds[(rawElement as ExtraElement).id] = ""; // somethig
						if (saladoPlayer.managerData.getActionDataById((rawElement as ExtraElement).action) == null){
							throw new Error("Action in extraElement does not exist: " + (rawElement as ExtraElement).action);
						}
					}
				}
			}
		}
	}
}