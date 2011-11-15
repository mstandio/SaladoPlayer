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
	import com.panozona.modules.imagebutton.model.structure.SubButton;
	import com.panozona.modules.imagebutton.model.structure.SubButtons;
	import com.panozona.modules.imagebutton.model.structure.Window;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class ImageButtonData{
		
		public const buttons:Vector.<Button> = new Vector.<Button>();
		
		public function ImageButtonData(moduleData:ModuleData, saladoPlayer:Object){
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "button") {
					var button:Button = new Button();
					tarnslator.dataNodeToObject(dataNode, button);
					
					if (button.getChildrenOfGivenClass(Window).length == 1) {
						button.window = button.getChildrenOfGivenClass(Window).pop();
					}else if (button.getChildrenOfGivenClass(Window).length == 0) {
						button.window = new Window();
					}
					if (button.getChildrenOfGivenClass(SubButtons).length == 1) {
						button.subButtons = button.getChildrenOfGivenClass(SubButtons).pop();
					}else if (button.getChildrenOfGivenClass(SubButtons).length == 0) {
						button.subButtons = new SubButtons();
					}
					buttons.push(button);
				}else {
					throw new Error("Unrecognized node: " + moduleData.name);
				}
			}
			
			if (saladoPlayer.managerData.debugMode){
				var buttonIds:Object = new Object();
				var subButtonIds:Object = new Object();
				for each (button in buttons){
					if (button.id == null) {
						throw new Error("Button id not specified.");
					}
					if (button.path == null || !button.path.match(/^(.+)\.(png|gif|jpg|jpeg|swf)$/i)){
						throw new Error("Invalid button path: " + button.path);
					}
					if (button.action != null && saladoPlayer.managerData.getActionDataById(button.action) == null){
						throw new Error("Action does not exist: " + button.action);
					}
					if (button.mouse.onOver != null && saladoPlayer.managerData.getActionDataById(button.mouse.onOver) == null){
						throw new Error("Action does not exist: " + button.mouse.onOver);
					}
					if (button.mouse.onOut != null && saladoPlayer.managerData.getActionDataById(button.mouse.onOut) == null){
						throw new Error("Action does not exist: " + button.mouse.onOut);
					}
					if (buttonIds[button.id] != undefined) {
						throw new Error("Repeating button id: " + button.id);
					}else {
						buttonIds[button.id] = ""; // something
						for each (var subButton:SubButton in button.subButtons.getChildrenOfGivenClass(SubButton)) {
							if (subButton.id == null) {
								throw new Error("subButton id not specified.");
							}
							if (subButton.path == null || !subButton.path.match(/^(.+)\.(png|gif|jpg|jpeg|swf)$/i)){
								throw new Error("Invalid subButton path: " + subButton.path);
							}
							if (subButton.action != null && saladoPlayer.managerData.getActionDataById(subButton.action) == null){
								throw new Error("Action does not exist: " + subButton.action);
							}
							if (subButton.mouse.onOver != null && saladoPlayer.managerData.getActionDataById(subButton.mouse.onOver) == null){
								throw new Error("Action does not exist: " + subButton.mouse.onOver);
							}
							if (subButton.mouse.onOut != null && saladoPlayer.managerData.getActionDataById(subButton.mouse.onOut) == null){
								throw new Error("Action does not exist: " + subButton.mouse.onOut);
							}
							if (subButtonIds[subButton.id] != undefined) {
								throw new Error("Repeating subButton id: " + subButton.id);
							}else {
								subButtonIds[subButton.id] = ""; // something
							}
						}
					}
				}
			}
		}
	}
}