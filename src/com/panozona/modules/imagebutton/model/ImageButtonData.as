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
package com.panozona.modules.imagebutton.model{
	
	import com.panozona.modules.imagebutton.model.structure.Button;
	import com.panozona.modules.imagebutton.model.structure.Butttons;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class ImageButtonData{
		
		public const buttons:Butttons = new Butttons();
		
		public function ImageButtonData(moduleData:ModuleData, saladoPlayer:Object){
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			for each(var dataNode:DataNode in moduleData.nodes){
				if (dataNode.name == "buttons"){
					tarnslator.dataNodeToObject(dataNode, buttons);
				}else {
					throw new Error("Unrecognized node: " + moduleData.name);
				}
			}
			
			if (saladoPlayer.managerData.debugMode){
				var buttonIds:Object = new Object();
				for each (var button:Button in buttons.getChildrenOfGivenClass(Button)){
					if (button.id == null) throw new Error("Button id not specified.");
					if (button.path == null || !button.path.match(/^(.+)\.(png|gif|jpg|jpeg|swf)$/i))
						throw new Error("Invalid button path: " + button.path);
					if (buttonIds[button.id] != undefined) {
						throw new Error("Repeating button id: " + button.id);
					}else {
						buttonIds[button.id] = ""; // something
						if (button.onOpen && !saladoPlayer.managerData.getActionDataById(button.onOpen)) {
							throw new Error("Action does not exist: " + button.onOpen);
						}
						if (button.onClose && !saladoPlayer.managerData.getActionDataById(button.onClose)) {
							throw new Error("Action does not exist: " + button.onClose);
						}
						if (button.mouse.onClick && !saladoPlayer.managerData.getActionDataById(button.mouse.onClick)) {
							throw new Error("Action does not exist: " + button.mouse.onClick);
						}
						if (button.mouse.onOut && !saladoPlayer.managerData.getActionDataById(button.mouse.onOut)) {
							throw new Error("Action does not exist: " + button.mouse.onOut);
						}
						if (button.mouse.onOver && !saladoPlayer.managerData.getActionDataById(button.mouse.onOver)) {
							throw new Error("Action does not exist: " + button.mouse.onOver);
						}
						if (button.mouse.onPress && !saladoPlayer.managerData.getActionDataById(button.mouse.onPress)) {
							throw new Error("Action does not exist: " + button.mouse.onPress);
						}
						if (button.mouse.onRelease && !saladoPlayer.managerData.getActionDataById(button.mouse.onRelease)) {
							throw new Error("Action does not exist: " + button.mouse.onRelease);
						}
					}
				}
			}
		}
	}
}