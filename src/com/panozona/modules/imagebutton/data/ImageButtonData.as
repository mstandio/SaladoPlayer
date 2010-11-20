/*
Copyright 2010 Marek Standio.

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
along with SaladoPlayer.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.modules.imagebutton.data{
	
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.ModuleNode;
	import com.panozona.player.module.data.structure.Master;
	
	import com.panozona.modules.imagebutton.data.structure.Button;
	import com.panozona.modules.imagebutton.data.structure.Butttons;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class ImageButtonData extends Master {
		
		public var buttons:Butttons = new Butttons();
		
		public function ImageButtonData(moduleData:ModuleData, debugMode:Boolean) {
			super(debugMode);
			
			for each(var moduleNode:ModuleNode in moduleData.moduleNodes){
				switch(moduleNode.nodeName) {
					case "buttons": 
						readRecursive(buttons, moduleNode);
					break;
					default:
						throw new Error("Invalid node name: "+moduleNode.nodeName);
				}
			}
			
			if (debugMode) {
				var buttonIds:Object = new Object();
				for each (var button:Button in buttons.getChildrenOfGivenClass(Button)) {
					if (button.id == null) throw new Error("Button id not specified.");
					if (button.path == null) throw new Error("Button path not specified.");
					if (buttonIds[button.id] != undefined) {
						throw new Error("Repeating button id: "+button.id);
					}else {
						buttonIds[button.id] = ""; // something
					}
				}
			}
		}
	}
}