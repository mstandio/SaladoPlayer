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
*/s
package com.panozona.player.module.data {
	
			
	/**
	 * ...
	 * @author mstandio
	 */
	public class ModuleNode{
		
		private var _nodeName:String;
		private var _attributes:Object;
		private var _moduleNodes:Vector.<ModuleNode>;
		
		public function ModuleNode(abstractModuleNode:Object) {
			_attributes = abstractModuleNode.attributes;
			_moduleNodes = new Vector.<ModuleNode>(); 
			
			var abstarctModuleNodes:Array = abstractModuleNode.abstarctModuleNodes as Array;
			var moduleNode:ModuleNode;
			for each(var abstarctModuleNode:Object in abstarctModuleNodes) {
				moduleNode = new ModuleNode(abstarctModuleNode);
				_moduleNodes.push(moduleNode);
			}								
		}	
		
		
		public function getModuleNodeByName(nodeName:String):ModuleNode {
			for each( var moduleNode:ModuleNode in _moduleNodes) {
				if (moduleNode._nodeName == nodeName) {
					return moduleNode;
				}
			}
			return null;
		}
		
		public function getAttributeByName(attrName:String, requiredClass:Class, defaultValue:*, throwError:Boolean = false):*{
			if (attrName != null && _attributes.hasOwnProperty(attrName) && _attributes[attrName] is requiredClass) {								
				return	_attributes[attrName];								
			}			
			if (throwError) {
				throw new Error("Not matching types in: "+attrName+" expeced: "+requiredClass);
			}			
			return defaultValue;			
		}		
		
		public function get nodeName():String {
			return _nodeName;
		}
		
		public function get attributes():Object {
			return _attributes;
		}
						
		public function get moduleNodes():Vector.<ModuleNode> {
			return _moduleNodes;
		}
	}
}