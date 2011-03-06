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
	
	import com.panozona.modules.buttonbar.model.structure.Bar;
	import com.panozona.modules.buttonbar.model.structure.Buttons;
	import com.panozona.modules.buttonbar.model.structure.ExtraButton;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class ButtonBarData {
		
		public var bar:Bar = new Bar();
		public var barData:BarData = new BarData();
		
		public function ButtonBarData(moduleData:ModuleData, saladoPlayer:Object){
			
			var translator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "bar") {
					translator.dataNodeToObject(dataNode, bar);
				}else if (dataNode.name == "buttons") {
					translator.dataNodeToObject(dataNode, barData.buttons);
				}else {
					throw new Error("Unrecognized node: " + dataNode.name);
				}
			}
			
			if (saladoPlayer.managerData.debugMode) {
				for each(var extraButton:ExtraButton in barData.buttons.getChildrenOfGivenClass(ExtraButton)) {
					if (saladoPlayer.managerData.getActionDataById(extraButton.action) == null) {
						throw new Error("Invalid action id in: " + extraButton.name);
					}
				}
			}
		}
	}
}