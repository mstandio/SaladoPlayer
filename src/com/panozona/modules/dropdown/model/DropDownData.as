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
	import com.panozona.modules.dropdown.model.structure.Group;
	import com.panozona.modules.dropdown.model.structure.RawElement;
	import com.panozona.modules.dropdown.model.structure.Settings;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class DropDownData{
		
		public const windowData:WindowData = new WindowData();
		public const settings:Settings = new Settings();
		public const boxData:BoxData = new BoxData();
		
		public function DropDownData(moduleData:ModuleData, saladoPlayer:Object){
			
			var translator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "window") {
					translator.dataNodeToObject(dataNode, windowData.window);
				}else if (dataNode.name == "settings") {
					translator.dataNodeToObject(dataNode, settings);
				}else if (dataNode.name == "groups") {
					translator.dataNodeToObject(dataNode, boxData.groups);
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
				var groupIds:Object = new Object();
				var elementTargets:Object = new Object();
				var extraElementIds:Object = new Object();
				
				for each (var group:Group in boxData.groups.getChildrenOfGivenClass(Group)) {
					if (group.id == null) throw new Error("Group id not specified.");
					if (groupIds[group.id] != undefined) {
						throw new Error("Repeating group id: " + group.id);
					}else {
						groupIds[group.id] = ""; // somethig
					}
					for each (var rawElement:RawElement in group.getAllChildren()) {
						if (rawElement is Element) {
							var element:Element = rawElement as Element;
							if (element.target == null) throw new Error("Element target not specified.");
							if (saladoPlayer.managerData.getPanoramaDataById(element.target) == null) {
								throw new Error("Invalid element target: " + element.target);
							}
							if (elementTargets[element.target] != undefined) {
								throw new Error("Repeating element target: " + element.target);
							}else {
								elementTargets[element.target] = ""; // something
							}
						}else {
							var extraElement:ExtraElement = rawElement as ExtraElement;
							if (extraElement.id == null) throw new Error("ExtraElement id not specified.");
							if (extraElementIds[extraElement.id] != undefined) throw new Error("Repeating extraElement id: " + extraElement.id);
							extraElementIds[extraElement.id] = ""; // somethig
							if (extraElement.action !=null && saladoPlayer.managerData.getActionDataById(extraElement.action) == null){
								throw new Error("Action in extraElement does not exist: " + extraElement.action);
							}
						}
					}
				}
			}
		}
	}
}