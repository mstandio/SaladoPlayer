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
package com.panozona.player.module.utils{
	
	import com.panozona.player.module.data.ModuleNode;
	import com.panozona.player.module.data.structure.DataParent;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class ModuleDataTranslator{
		
		protected var debugMode:Boolean;
		
		public function ModuleDataTranslator (debugMode:Boolean):void {
			this.debugMode = debugMode;
		}
		
		public function translateModuleNodeToObject(moduleNode:ModuleNode, object:Object):void {
			if (!debugMode) {
				// read all attributes 
				for (var name:String in moduleNode.attributes) {
					if (getClass(moduleNode.attributes[name]) === Object) {
						for (var subName:String in moduleNode.attributes[name]) {
							object[name][subName] = moduleNode.attributes[name][subName];
						}
					}else {
						object[name] = moduleNode.attributes[name]
					}
				}
				
			}else{
				// read all attributes 
				for (name in moduleNode.attributes) {
					if (!object.hasOwnProperty(name)) {
						throw new Error("Unrecognized attribute: " + name);
						return;
					}
					if (object[name] is Boolean) {
						if (moduleNode.attributes[name] is Boolean) {
							object[name] = moduleNode.attributes[name];
						}else {
							throw new Error("Invalid attribute value (Boolean expected): " + moduleNode.attributes[name]);
						}
					}else if (object[name] is Number) {
						if (moduleNode.attributes[name] is Number ){
							object[name] = moduleNode.attributes[name];
						}else {
							throw new Error("Invalid attribute value (Number expected): " + moduleNode.attributes[name]);
						}
					}else if (object[name] is Function) { // assuming Function var has allways default value
						if (moduleNode.attributes[name] is Function){
							object[name] = moduleNode.attributes[name];
						}else {
							throw new Error("Invalid attribute value (Function expected): " + moduleNode.attributes[name]);
						}
					}else if (object[name] == null || (object[name] is String)) { // String var may not be initialised
						if (moduleNode.attributes[name] is String) {
							object[name] = moduleNode.attributes[name];
						}else {
							throw new Error("Invalid attribute value (String expected): " + moduleNode.attributes[name]);
						}
					}else if (getClass(moduleNode.attributes[name]) === Object) {
						applySubAttributes(object[name], moduleNode.attributes[name]);
					}else {
						throw new Error("Invalid attribute value (Object expected): " + moduleNode.attributes[name]);
					}
				}
			}
			//read children
			if (moduleNode.childNodes.length > 0){
				var structureParent:DataParent;
				var child:Object;
				var classVector:Vector.<Class>;
				if (object is DataParent) {
					structureParent = object as DataParent;
					for each(var cNode:ModuleNode in moduleNode.childNodes) {
						classVector = structureParent.getChildrenTypes();
						for (var i:int = 0; i < classVector.length; i++) {
							if (cNode.name.toLowerCase() == getQualifiedClassName(structureParent.getChildrenTypes()[i]).match(/[^:]+$/)[0].toLowerCase()){
								child = new classVector[i]();
								translateModuleNodeToObject(cNode, child);
								structureParent.getAllChildren().push(child);
								break;
							}
							if (i == classVector.length - 1) {
								throw new Error("Unrecognized child: " + cNode.name);
							}
						}
					}
				}else {
					throw new Error("Redundant children for: "+moduleNode.name);
				}
			}
		}
		
		protected function applySubAttributes(target:Object, source:Object):void {
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
					}else if(target[name] is Function) { // assuming Function has allways default value
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
		
		protected function getClass(obj:Object):Class {
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
	}
}