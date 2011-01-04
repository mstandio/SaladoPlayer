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
package com.panozona.modules.viewfinder.data{
	
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.ModuleNode;
	import com.panozona.player.module.data.structure.Master;
	
	/**
	 * Part od ViewFinder module, translates moduleData into module internal data structure.
	 */
	public class ViewFinderData extends Master{
		
		/**
		 * Part of module data structure determinig text field position.
		 */
		public const settings:Settings = new Settings();
		
		/**
		 * Constructor. Uses inherited functions to validate and translate moduleData into module internal data structure.
		 * 
		 * @param	moduleData Structure containing module configuration data.
		 * @param	debugMode Determines if additional validation is performed.
		 * 
		 * @see com.panozona.player.module.data.structure.Master#readRecursive()
		 */
		public function ViewFinderData(moduleData:ModuleData, debugMode:Boolean){
			super(debugMode);
			
			for each(var moduleNode:ModuleNode in moduleData.moduleNodes) {
				if (moduleNode.nodeName == "settings") {
					readRecursive(settings, moduleNode);
				}else {
					throw new Error("Could not recognize: "+moduleNode.nodeName);
				}
			}
			
			// no additional validation required
		}
	}
}