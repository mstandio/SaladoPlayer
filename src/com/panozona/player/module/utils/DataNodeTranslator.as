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
	
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.structure.DataParent;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class DataNodeTranslator{
		
		protected var debugMode:Boolean;
		
		public function DataNodeTranslator (debugMode:Boolean):void {
			this.debugMode = debugMode;
		}
		
		public function dataNodeToObject(dataNode:DataNode, object:Object):void {
			if (!debugMode) {
				// read all attributes 
				for (var name:String in dataNode.attributes) {
					if (getClass(dataNode.attributes[name]) === Object) {
						for (var subName:String in dataNode.attributes[name]) {
							object[name][subName] = dataNode.attributes[name][subName];
						}
					}else {
						object[name] = dataNode.attributes[name]
					}
				}
				
			}else{
				// read all attributes 
				for (name in dataNode.attributes) {
					if (!object.hasOwnProperty(name)) {
						throw new Error("Unrecognized attribute: " + name);
						return;
					}
					if (object[name] is Boolean) {
						if (dataNode.attributes[name] is Boolean) {
							object[name] = dataNode.attributes[name];
						}else {
							throw new Error("Invalid " + name + " type (Boolean expected): " + dataNode.attributes[name]);
						}
					}else if (object[name] is Number) {
						if (dataNode.attributes[name] is Number){
							object[name] = dataNode.attributes[name];
						}else {
							throw new Error("Invalid " + name + " type (Number expected): " + dataNode.attributes[name]);
						}
					}else if (object[name] is Function) { // assuming Function var has allways default value
						if (dataNode.attributes[name] is Function){
							object[name] = dataNode.attributes[name];
						}else {
							throw new Error("Invalid " + name + " type (Function expected): " + dataNode.attributes[name]);
						}
					}else if (object[name] == null || (object[name] is String)) { // String var may not be initialised
						if (dataNode.attributes[name] is String) {
							object[name] = dataNode.attributes[name];
						}else {
							throw new Error("Invalid " + name + " type (String expected): " + dataNode.attributes[name]);
						}
					}else if (!(dataNode.attributes[name] is Function) && getClass(dataNode.attributes[name]) === Object) {
						applySubAttributes(object[name], dataNode.attributes[name]);
					}else {
						throw new Error("Invalid " + name + " type (Object expected): " + dataNode.attributes[name]);
					}
				}
			}
			//read children
			if (dataNode.childNodes.length > 0){
				var structureParent:DataParent;
				var child:Object;
				var classVector:Vector.<Class>;
				if (object is DataParent) {
					structureParent = object as DataParent;
					for each(var cNode:DataNode in dataNode.childNodes) {
						classVector = structureParent.getChildrenTypes();
						for (var i:int = 0; i < classVector.length; i++) {
							if (cNode.name.toLowerCase() == getQualifiedClassName(structureParent.getChildrenTypes()[i]).match(/[^:]+$/)[0].toLowerCase()){
								child = new classVector[i]();
								dataNodeToObject(cNode, child);
								structureParent.getAllChildren().push(child);
								break;
							}
							if (i == classVector.length - 1) {
								throw new Error("Unrecognized child: " + cNode.name);
							}
						}
					}
				}else {
					throw new Error("Redundant children for: " + dataNode.name);
				}
			}
		}
		
		public function applySubAttributes(target:Object, source:Object):void {
			for (var name:String in source) {
				if (target.hasOwnProperty(name)) {
					if (target[name] is Boolean){
						if (source[name] is Boolean) {
							target[name] = source[name];
						}else {
							throw new Error("Invalid " + name + " type (Boolean expected): " + source[name]);
						}
					}else if(target[name] is Number) {
						if(source[name] is Number){
							target[name] = source[name];
						}else {
							throw new Error("Invalid " + name + " type (Number expected): " + source[name]);
						}
					}else if(target[name] is Function) { // assuming Function has allways default value
						if(source[name] is Function){
							target[name] = source[name];
						}else {
							throw new Error("Invalid " + name + " type (Function expected): " + source[name]);
						}
					}else if (target[name] == null || target[name] is String) { // String var may not be initialised
						if (source[name] is String) {
							target[name] = source[name]; 
						}else {
							throw new Error("Invalid " + name + " type (String expected): " + source[name]);
						}
					}
				}else {
					// check if creation of new atribute in object is possible
					try{
						target[name] = source[name];
					}catch (e:Error){
						throw new Error("Unrecognized subattribute name: " + name);
					}
				}
			}
		}
		
		protected function getClass(obj:Object):Class {
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
	}
}