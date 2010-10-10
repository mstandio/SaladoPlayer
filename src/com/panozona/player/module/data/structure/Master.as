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
package com.panozona.player.module.data.structure{
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import com.panozona.player.module.data.*
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class Master {
		
		private var _debugMode:Boolean;
		
		public function Master(debugMode:Boolean) {
			_debugMode = debugMode
		}
		
		protected function readRecursive(object:Object, moduleNode:ModuleNode):void {
			
			var name:String;
			
			if (!_debugMode) {
				
				// read all attributes 
				for (name in  moduleNode.attributes) {
					if (getClass(moduleNode.attributes[name]) === Object) {
						for (var subName:String in moduleNode.attributes[name]) {
							object[name][subName] = moduleNode.attributes[name][subName];
						}
					}else {
						object[name] = moduleNode.attributes[name]
					}
				}
				
			}else {
				
				// read all attributes 
				for (name in  moduleNode.attributes) {
					if (object.hasOwnProperty(name)) {
						if (object[name] is Boolean) {
							if (moduleNode.attributes[name] is Boolean) {
								object[name] = moduleNode.attributes[name];
							}else {
								throw new Error("Invalid attribute value (Boolean expected): "+moduleNode.attributes[name]);
							}
						}else if (object[name] is Number) {
							if (moduleNode.attributes[name] is Number ){
								object[name] = moduleNode.attributes[name];
							}else {
								throw new Error("Invalid attribute value (Number expected): "+moduleNode.attributes[name]);
							}
						}else if (object[name] is Function) {
							if (moduleNode.attributes[name] is Function){
								object[name] = moduleNode.attributes[name];
							}else {
								throw new Error("Invalid attribute value (Function expected): "+moduleNode.attributes[name]);
							}
						}else if (getClass(moduleNode.attributes[name]) === Object) {
							applySubAttributes(object[name], moduleNode.attributes[name]);
						}else {
							object[name] = (moduleNode.attributes[name] as String);
						}
					}else {
						throw new Error("Unrecognized attribute: "+name);
					}
				}
			}
			
			//read children
			if (moduleNode.moduleNodes.length > 0){
				var structureParent:Parent;
				var child:Object;
				var classVector:Vector.<Class>;
				if (object is Parent) {
					structureParent = object as Parent;
					for each(var mNode:ModuleNode in moduleNode.moduleNodes) {
						classVector = structureParent.getChildrenTypes();
						for (var i:int = 0; i < classVector.length; i++) {
							if (mNode.nodeName.toLowerCase() == 
									getQualifiedClassName(structureParent.getChildrenTypes()[i]).match(/[^:]+$/)[0].toLowerCase()){
								child = new classVector[i]();
								readRecursive(child, mNode);
								structureParent.getAllChildren().push(child);
								break;
							}
							if (i == classVector.length - 1) {
								throw new Error("Unrecognized child: "+mNode.nodeName);
							}
						}
					}
				}else {
					throw new Error("Redundant children for: "+moduleNode.nodeName);
				}
			}
		}
		
		private function applySubAttributes(target:Object, source:Object):void {
			for (var name:String in source) {
				if (target.hasOwnProperty(name)) {
					if (target[name] is Boolean){
						if (source[name] is Boolean) {
							target[name] = source[name];
						}else {
							throw new Error("Invalid attribute value (Boolean expected): "+source[name]);
						}
					}else if(target[name] is Number) {
						if(source[name] is Number){
							target[name] = source[name];
						}else {
							throw new Error("Invalid attribute value (Number expected): "+source[name]);
						}
					}else if(target[name] is Function) {
						if(source[name] is Function){
							target[name] = source[name];
						}else {
							throw new Error("Invalid attribute value (Function expected): "+source[name]);
						}
					}else{
						target[name] = (source[name] as String); 
					}
				}
				else {
					throw new Error("Invalid subattribute name: "+name);
				}
			}
		}
		
		private function getClass(obj:Object):Class {
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
	}
}