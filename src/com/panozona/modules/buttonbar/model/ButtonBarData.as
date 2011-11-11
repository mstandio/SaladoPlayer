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
package com.panozona.modules.buttonbar.model{
	
	import com.panozona.modules.buttonbar.model.structure.Button;
	import com.panozona.modules.buttonbar.model.structure.Buttons;
	import com.panozona.modules.buttonbar.model.structure.ExtraButton;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class ButtonBarData {
		
		public const windowData:WindowData = new WindowData();
		public const buttons:Buttons = new Buttons();
		
		public function ButtonBarData(moduleData:ModuleData, saladoPlayer:Object){
			
			var translator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "window") {
					translator.dataNodeToObject(dataNode, windowData.window);
				}else if (dataNode.name == "buttons") {
					translator.dataNodeToObject(dataNode, buttons);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			windowData.open = windowData.window.open;
			
			if (saladoPlayer.managerData.debugMode) {
				if (buttons.path == null || !buttons.path.match(/^(.+)\.(png|gif|jpg|jpeg)$/i)) throw new Error("Invalid buttons path: " + buttons.path);
				var buttonNames:Object = new Object();
				for each(var button:Button in buttons.getChildrenOfGivenClass(Button)) {
					if (button.name == null) throw new Error("Button name not specified.");
					if (buttonNames[button.name] != undefined) {
						throw new Error("Repeating button name: " + button.name);
					}else {
						buttonNames[button.name] = ""; // something
						if (button.mouse.onOver != null && saladoPlayer.managerData.getActionDataById(button.mouse.onOver) == null){
							throw new Error("Action does not exist: " + button.mouse.onOver);
						}
						if (button.mouse.onOut != null && saladoPlayer.managerData.getActionDataById(button.mouse.onOut) == null){
							throw new Error("Action does not exist: " + button.mouse.onOut);
						}
						if (button is ExtraButton && saladoPlayer.managerData.getActionDataById((button as ExtraButton).action) == null){
							throw new Error("Action does not exist: " + (button as ExtraButton).action);
						}
					}
				}
			}
		}
	}
}