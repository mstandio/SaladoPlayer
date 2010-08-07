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

	/**
	 * ...
	 * @author mstandio
	 */
	public class ExampleModuleData {		
				
		public var settings:SettingsData;
		public var someChildrenData:Vector.<SomeChildData>;
		
		public function ExampleModuleData(moduleData:ModuleData) {
			
			settings = new SettingsData();			
			someChildrenData = new Vector.<SomeChildData>();        		
						
			var settingsModuleNode:ModuleNode;
			
			settingsModuleNode = moduleData.getModuleNodeByName("settings");			
			
			if (settingsModuleNode == null) {	
				throw new Error("settings node missing");
			}else{				
				settings.numberValue= settingsModuleNode.getAttributeByName("numberValue", Number, 0); 
				settings.booleanValue = settingsModuleNode.getAttributeByName("booleanValue", Boolean, false);
				settings.arrayValue = settingsModuleNode.getAttributeByName("arrayValue", Array, new Array());
				settings.stringValue = settingsModuleNode.getAttributeByName("stringValue", String, "");				
			}		
						
			
			var parentModuleNode:ModuleNode;			
			
			parentModuleNode = moduleData.getModuleNodeByName("someParent");
			
			if (parentModuleNode == null) {
				throw new Error("someParent node missing");
			}else{	
				var someChildData:SomeChildData;
				var someGrandchildData:SomeGrandchildData;
				for each(var someChildModuleNode:ModuleNode in parentModuleNode.moduleNodes){
					someChildData = new SomeChildData(someChildModuleNode.getAttributeByName("id", String, null));
					for each(var someGrandhildModuleNode:ModuleNode in someChildModuleNode.moduleNodes) {
						someGrandchildData = new SomeGrandchildData(
							someGrandhildModuleNode.getAttributeByName("name",String, ""),
							someGrandhildModuleNode.getAttributeByName("isMale", Boolean, "false"),
							someGrandhildModuleNode.getAttributeByName("age", Number, 0 ),
							someGrandhildModuleNode.getAttributeByName("pets", Array, new Array()));
						someChildData.someGrandchildren.push(someGrandchildData);
					}
					someChildrenData.push(someChildData);
				}				
			}		
		}	
	}
}