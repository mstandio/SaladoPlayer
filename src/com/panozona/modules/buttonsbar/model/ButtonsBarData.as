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
package com.panozona.modules.buttonsbar.model{
	
	import com.panozona.modules.buttonsbar.model.structure.Bar;
	import com.panozona.modules.buttonsbar.model.structure.Buttons;
	import com.panozona.modules.navigationbar.data.ExtraButton;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.ModuleNode;
	import com.panozona.player.module.utils.ModuleDataTranslator;
	
	public class ButtonsBarData {
		
		public var bar:Bar = new Bar();
		public var barData:BarData = new BarData();
		
		public function ButtonsBarData(moduleData:ModuleData, saladoPlayer:Object){
			
			var translator:ModuleDataTranslator = new ModuleDataTranslator(saladoPlayer.managerData.debugMode);
			
			for each(var moduleNode:ModuleNode in moduleData.nodes) {
				if (moduleNode.name == "bar") {
					translator.moduleNodeToObject(moduleNode, bar);
				}else if (moduleNode.name == "buttons") {
					translator.moduleNodeToObject(moduleNode, barData.buttons);
				}else {
					throw new Error("Unrecognized node: " + moduleNode.name);
				}
			}
			
			if (saladoPlayer.managerData.debugMode) {
				for each(var extraButton:ExtraButton in barData.buttons.getChildrenOfGivenClass(ExtraButton)) {
					if (saladoPlayer.managerData.getActionById(extraButton.action) == null) {
						throw new Error("Invalid action in: " + extraButton.name);
					}
				}
			}
		}
	}
}