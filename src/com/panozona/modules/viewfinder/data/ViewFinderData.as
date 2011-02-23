﻿/*
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
package com.panozona.modules.viewfinder.data{
	
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.ModuleNode;
	import com.panozona.player.module.utils.ModuleDataTranslator;
	
	/**
	 * Part od ViewFinder module, translates moduleData 
	 * into module internal data structure.
	 */
	public class ViewFinderData {
		
		public const settings:Settings = new Settings();
		
		public function ViewFinderData(moduleData:ModuleData, debugMode:Boolean){
			
			var tarnslator:ModuleDataTranslator = new ModuleDataTranslator(debugMode);
			
			for each(var moduleNode:ModuleNode in moduleData.nodes) {
				if (moduleNode.name == "settings") {
					tarnslator.translateModuleNodeToObject(moduleNode, settings);
				}else {
					throw new Error("Could not recognize: "+moduleNode.name);
				}
			}
			// no additional validation required
		}
	}
}