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
package com.panozona.modules.viewfinder.data{
	
	import com.panozona.player.component.ComponentData;
	import com.panozona.player.component.ComponentNode;
	import com.panozona.player.component.utils.ComponentDataTranslator;
	
	/**
	 * Part od ViewFinder module, translates moduleData 
	 * into module internal data structure.
	 */
	public class ViewFinderData {
		
		public const settings:Settings = new Settings();
		
		public function ViewFinderData(componentData:ComponentData, debugMode:Boolean){
			
			var tarnslator:ComponentDataTranslator = new ComponentDataTranslator(debugMode);
			
			for each(var componentNode:ComponentNode in componentData.nodes) {
				if (componentNode.name == "settings") {
					tarnslator.translateComponentNodeToObject(componentNode, settings);
				}else {
					throw new Error("Could not recognize: "+componentNode.name);
				}
			}
			// no additional validation required
		}
	}
}