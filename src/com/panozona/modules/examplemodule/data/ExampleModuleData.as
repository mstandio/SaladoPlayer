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
package com.panozona.modules.examplemodule.data {
	
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.ModuleNode;
	import com.panozona.player.module.data.StructureMaster;

	/**
	 * ...
	 * @author mstandio
	 */
	public class ExampleModuleData extends StructureMaster{

		// These var names are not important
		// HOWEVER Check comments for SomeParent, SomeChild and SomeGrandChild
		public var settings:Settings = new Settings();
		public var someParent:SomeParent = new SomeParent();
		
		public function ExampleModuleData(moduleData:ModuleData, debugging:Boolean) {
			super(debugging);
			
			for each(var moduleNode:ModuleNode in moduleData.moduleNodes){
				switch(moduleNode.nodeName) {
					case "settings": 
						readRecursive(settings, moduleNode);
					break;
					case "someParent": 
						readRecursive(someParent, moduleNode);
					break;
					default:
						throw new Error("Could not recognize: "+moduleNode.nodeName);
				}
			}
			
			if (debugging){			
				// throw errors if inspection shows that not all vital data was recieved
				for each(var someChild:SomeChild in someParent.getChildren()) {
					if (someChild.id == null || someChild.id == "") {
						throw new Error("someChild id is not specified.");
					}
				}
				// ect.
				// check for validity of settings values and throw informative Errors. 
			}
		}
	}
}