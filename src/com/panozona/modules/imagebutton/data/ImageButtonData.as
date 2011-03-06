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
package com.panozona.modules.imagebutton.data{
	
	import com.panozona.modules.imagebutton.data.structure.Button;
	import com.panozona.modules.imagebutton.data.structure.Butttons;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class ImageButtonData{
		
		public var buttons:Butttons = new Butttons();
		
		public function ImageButtonData(moduleData:ModuleData, saladoPlayer:Object) {
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "buttons") {
					tarnslator.dataNodeToObject(dataNode, buttons);
				}else {
					throw new Error("Unrecognized node: " + moduleData.name);
				}
			}
			
			if (saladoPlayer.managerData.debugMode) {
				var buttonIds:Object = new Object();
				for each (var button:Button in buttons.getChildrenOfGivenClass(Button)) {
					if (button.id == null) throw new Error("Button id not specified.");
					if (button.path == null) throw new Error("Button path not specified.");
					if (buttonIds[button.id] != undefined) {
						throw new Error("Repeating button id: " + button.id);
					}else {
						buttonIds[button.id] = ""; // something
					}
				}
			}
		}
	}
}