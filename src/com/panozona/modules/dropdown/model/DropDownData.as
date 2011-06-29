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
	
	import com.panozona.modules.dropdown.model.structure.Elements;
	import com.panozona.modules.dropdown.model.structure.Element;
	import com.panozona.modules.dropdown.model.structure.Settings;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class DropDownData{
		
		public const settings:Settings = new Settings();
		public const boxData:BoxData = new BoxData();
		
		public function DropDownData(moduleData:ModuleData, saladoPlayer:Object){
			
			var translator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "settings") {
					translator.dataNodeToObject(dataNode, settings);
				}else if (dataNode.name == "elements") {
					translator.dataNodeToObject(dataNode, boxData.elements);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			if (saladoPlayer.managerData.debugMode) {
				var elementTargets:Object = new Object();
				for each(var element:Element in boxData.elements.getChildrenOfGivenClass(Element)) {
					if (element.target == null) throw new Error("Element target not specified.");
					if (saladoPlayer.managerData.getPanoramaDataById(element.target) == null) throw new Error("Invalid element target: " + element.target);
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