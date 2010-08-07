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
package com.panozona.player.module.data {
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class ModuleData {		
		
		private var _moduleNodes:Vector.<ModuleNode>;
		
		public function ModuleData(abstractModuleData:Object) {
			_moduleNodes =  new Vector.<ModuleNode>();
			
			var abstractModuleNodes:Array = abstractModuleData.abstractModuleNodes;
			var moduleNode:ModuleNode;
			for each(var abstractModuleNode:Object in abstractModuleNodes) {				
				moduleNode = new ModuleNode(abstractModuleNode);				
				_moduleNodes.push(moduleNode);
			}		
		}			
		
		public function get moduleNodes():Vector.<ModuleNode> {
			return _moduleNodes;			
		}						
		
		public function getModuleNodeByName(nodeName:String):ModuleNode {
			for each(var moduleNode:ModuleNode in _moduleNodes) {
				if (moduleNode.nodeName == nodeName) {
					return moduleNode;
				}
			}
			return null;
		}
	}
}