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
package com.panozona.modules.examplemodule.data {
	
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.ModuleNode;
	import com.panozona.player.module.utils.ModuleDataTranslator;
	
	public class ExampleModuleData{
		
		public var settings:Settings = new Settings();
		public var someParent:SomeParent = new SomeParent();
		
		/**
		 * This class reads settings from ModuleData object and translates them 
		 * to internal settings structure. It also validates obtained data against
		 * its internal rules as well as against saladoPlayer data structure.
		 * 
		 * This class defines how nodes that are direct childen nodes of <module/>
		 * node are interpreted. It decides what node names are allowed and uses 
		 * ModuleDataTranslator instance to recurrently read ModuleData object
		 * into proper configuration objects. For example:
		 * 
		 * <module name="ExampleModule">
		 *  <settings/>
		 *  <someParent/>
		 * </module>
		 * 
		 * Constructor throws errors that are not supposed to be cought. 
		 * They are supposed to bubble up to com.panozna.player.module.Module 
		 * stageReady() function where catching such error will result in removing module.
		 * 
		 * @param	moduleData
		 * @param	saladoPlayer
		 */
		public function ExampleModuleData(moduleData:ModuleData, saladoPlayer:Object) {
			
			var translator:ModuleDataTranslator = new ModuleDataTranslator(saladoPlayer.managerData.debugMode);
			
			for each(var moduleNode:ModuleNode in moduleData.nodes) {
				if (moduleNode.name == "settings") {
					translator.moduleNodeToObject(moduleNode, settings);
				}else if (moduleNode.name == "someParent") {
					translator.moduleNodeToObject(moduleNode, someParent);
				}else {
					throw new Error("Invalid node name: " + moduleNode.name);
				}
			}
			
			if (saladoPlayer.managerData.debugMode){
				for each(var someChild:SomeChild in someParent.getChildrenOfGivenClass(SomeChild)) {
					if ((!someChild.happy)) {
						throw new Error("someChild is not happy.");
					}
				}
				if (settings.onOpen != null) {
					if (saladoPlayer.managerData.getActionDataById(settings.onOpen) == null) {
						throw new Error("Action " + settings.onOpen + "does not exist.");
					}
				}
				if (settings.onClose != null) {
					if (saladoPlayer.managerData.getActionDataById(settings.onClose) == null) {
						throw new Error("Action " + settings.onClose + "does not exist.");
					}
				}
				// ect. check for validity of settings values and throw informative Errors.
			}
		}
	}
}