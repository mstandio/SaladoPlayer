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
package com.panozona.player.component.data.structure{
	
	import com.panozona.player.component.ComponentNode;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class Translator {
		
		public static function translateComponentToObject(componentNode:ComponentNode, object:Object, debugMode = false):void {
			if (!debugMode) {
				// read all attributes 
				for (var name:String in componentNode.attributes) {
					if (getClass(componentNode.attributes[name]) === Object) {
						for (var subName:String in componentNode.attributes[name]) {
							object[name][subName] = componentNode.attributes[name][subName];
						}
					}else {
						object[name] = componentNode.attributes[name]
					}
				}
			}else {
				// read all attributes 
				for (name in componentNode.attributes) {
					if (object.hasOwnProperty(name)) {
						if (object[name] is Boolean) {
							if (componentNode.attributes[name] is Boolean) {
								object[name] = componentNode.attributes[name];
							}else {
								throw new Error("Invalid attribute value (Boolean expected): " + componentNode.attributes[name]);
							}
						}else if (object[name] is Number) {
							if (componentNode.attributes[name] is Number ){
								object[name] = componentNode.attributes[name];
							}else {
								throw new Error("Invalid attribute value (Number expected): " + componentNode.attributes[name]);
							}
						}else if (object[name] is Function) { // assuming Function var has allways default value
							if (componentNode.attributes[name] is Function){
								object[name] = componentNode.attributes[name];
							}else {
								throw new Error("Invalid attribute value (Function expected): " + componentNode.attributes[name]);
							}
						}else if (object[name] == null || (object[name] is String)) { // String var may not be initialised
							if (componentNode.attributes[name] is String) {
								object[name] = componentNode.attributes[name];
							}else {
								throw new Error("Invalid attribute value (String expected): " + componentNode.attributes[name]);
							}
						}else if (getClass(componentNode.attributes[name]) === Object) {
							applySubAttributes(object[name], componentNode.attributes[name]);
						}else {
							throw new Error("Invalid attribute value (Object expected): " + componentNode.attributes[name]);
						}
					}else {
						throw new Error("Unrecognized attribute: " + name);
					}
				}
			}
			//read children
			if (componentNode.childNodes.length > 0){
				var structureParent:Parent;
				var child:Object;
				var classVector:Vector.<Class>;
				if (object is Parent) {
					structureParent = object as Parent;
					for each(var cNode:ComponentNode in componentNode.componentNodes) {
						classVector = structureParent.getChildrenTypes();
						for (var i:int = 0; i < classVector.length; i++) {
							if (cNode.name.toLowerCase() == getQualifiedClassName(structureParent.getChildrenTypes()[i]).match(/[^:]+$/)[0].toLowerCase()){
								child = new classVector[i]();
								readRecursive(child, cNode);
								structureParent.getAllChildren().push(child);
								break;
							}
							if (i == classVector.length - 1) {
								throw new Error("Unrecognized child: " + cNode.name);
							}
						}
					}
				}else {
					throw new Error("Redundant children for: "+componentNode.name);
				}
			}
		}
		
		private static function applySubAttributes(target:Object, source:Object):void {
			for (var name:String in source) {
				if (target.hasOwnProperty(name)) {
					if (target[name] is Boolean){
						if (source[name] is Boolean) {
							target[name] = source[name];
						}else {
							throw new Error("Invalid subattribute value (Boolean expected): " + source[name]);
						}
					}else if(target[name] is Number) {
						if(source[name] is Number){
							target[name] = source[name];
						}else {
							throw new Error("Invalid subattribute value (Number expected): " + source[name]);
						}
					}else if(target[name] is Function) { // assuming Function var has allways default value
						if(source[name] is Function){
							target[name] = source[name];
						}else {
							throw new Error("Invalid subattribute value (Function expected): " + source[name]);
						}
					}else if (target[name] == null || target[name] is String) { // String var may not be initialised
						if (source[name] is String) {
							target[name] = source[name]; 
						}else {
							throw new Error("Invalid subattribute value (String expected): " + source[name]);
						}
					}
				}else {
					// check if creation of new atribute in object is possible
					try{
						target[name] = source[name];
					}catch (e:Error){
						throw new Error("Invalid subattribute name: "+name);
					}
				}
			}
		}
		
		private static function getClass(obj:Object):Class {
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
	}
}