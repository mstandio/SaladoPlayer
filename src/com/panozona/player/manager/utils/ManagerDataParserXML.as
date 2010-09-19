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
package com.panozona.player.manager.utils {
	
	import com.panosalado.model.Params;
	
	import com.panozona.player.manager.data.*;
	import com.panozona.player.manager.utils.Trace;
	
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Translates XML to ManagerData
	 * @author mstandio
	 */
	public class ManagerDataParserXML {
		
		public function configureManagerData(managerData:ManagerData, settings:XML):void {
			for each(var mainNode:XML in settings.children()){
				switch(mainNode.localName().toString()) {
					case "global": 
						parseGlobal(managerData, mainNode);
					break;
					case "panoramas": 
						parsePanoramas(managerData, mainNode);
					break;
					case "actions": 
						parseActions(managerData, mainNode);
					break;
					case "modules": 
						parseModules(managerData, mainNode);
					break;
					default:
						Trace.instance.printWarning("Unrecognized node: "+mainNode.name());
				}
			}
			managerData.populateGlobalDataParams();
		}
		
		private function parseGlobal(managerData:ManagerData, globalNode:XML):void {
			for each(var globalAttribute:XML in globalNode.attributes()) {
				switch (globalAttribute.localName().toString()) {
					case "debug": 
						managerData.debugging = getAttributeValue(globalAttribute, Boolean);
					break;
					case "trace": 
						applySubAttributes(managerData.traceData, globalAttribute);
					break;
					case "showStatistics": 
						managerData.showStatistics = getAttributeValue(globalAttribute, Boolean);
					break;
					case "arcBall": 
						applySubAttributes(managerData.arcBallCameraData, globalAttribute);
					break;
					case "autorotation": 
						applySubAttributes(managerData.autorotationCameraData, globalAttribute);
					break;
					case "keyboard": 
						applySubAttributes(managerData.keyboardCameraData, globalAttribute);
					break;
					case "inertialMouse":
						applySubAttributes(managerData.inertialMouseCameraData, globalAttribute);
					break;
					case "simpleTransition":
						applySubAttributes(managerData.simpleTransitionData, globalAttribute);
					break;
					case "camera": 
						applySubAttributes(managerData.params, globalAttribute);
					break;
					case "firstPanorama": 
						managerData.firstPanorama = getAttributeValue(globalAttribute, String);
					break;
					default:
						Trace.instance.printWarning("Unrecognized attribute: "+globalAttribute.localName().toString());
				}
			}
		}
		
		private function parsePanoramas(managerData:ManagerData, panoramasNode:XML):void {
			var panoramaData:PanoramaData;
			for each(var panoramaNode:XML in panoramasNode.elements()) {
				panoramaData = new PanoramaData();
				for each(var panoramaAttribute:XML in panoramaNode.attributes()) {
					switch (panoramaAttribute.localName().toString()) {
						case "id":
							panoramaData.id = getAttributeValue(panoramaAttribute, String);
						break;
						case "label":
							panoramaData.label = getAttributeValue(panoramaAttribute, String);
						break;
						case "path":
							panoramaData.path = getAttributeValue(panoramaAttribute, String);
						break;
						case "camera":
							applySubAttributes(panoramaData.params, panoramaAttribute); // TODO: can collide  with path
						break;
						case "onEnter":
							panoramaData.onEnter = getAttributeValue(panoramaAttribute, String);
						break;
						case "onLeave":
							panoramaData.onLeave = getAttributeValue(panoramaAttribute, String);
							break;
						case "onTransitionEnd":
							panoramaData.onTransitionEnd = getAttributeValue(panoramaAttribute, String);
						break;
						case "onEnterSource":
							applySubAttributes(panoramaData.onEnterSource, panoramaAttribute);
							break;
						case "onLeaveTarget":
							applySubAttributes(panoramaData.onLeaveTarget, panoramaAttribute);
						break;
						case "onTransitionEndSource":
							applySubAttributes(panoramaData.onTransitionEndSource, panoramaAttribute);
						break;
						default:
							Trace.instance.printWarning("Unrecognized global attribute: "+panoramaAttribute.localName().toString());
					}
				}
				
				if (panoramaData.id != null) {
					if (panoramaData.path != null) {
						parseChildren(panoramaData, panoramaNode);
						managerData.panoramasData.push(panoramaData);
					}else {
						Trace.instance.printWarning("Missing panorama path for: "+panoramaData.id); 
					}
				}else {
					Trace.instance.printWarning("Missing panorama id.");
				}
			}
		}
		
		public function parseChildren(panoramaData:PanoramaData, panoramaNode:XML):void {
			var childData:ChildData;
			for (var i:int = 0; i < panoramaNode.elements().length(); i++) {
				childData = new ChildData();
				for each (var childAttribute:XML in panoramaNode.elements()[i].attributes()){
					switch(childAttribute.localName().toString()) {
						case "id":
							childData.id = getAttributeValue(childAttribute, String);
						break;
						case "path":
							childData.path = getAttributeValue(childAttribute, String);
						break;
						case "position":
							applySubAttributes(childData.childPosition, childAttribute);
						break;
						case "transformation":
							applySubAttributes(childData.childTransformation, childAttribute);
						break;
						case "mouse":
							applySubAttributes(childData.childMouse, childAttribute);
						break;
						case "arguments":
							applySubAttributes(childData.sfwArguments, childAttribute);
						break;
						default:
							Trace.instance.printWarning("Unrecognized child attribute: "+childAttribute.localName().toString());
					}
				}
				if (childData.id != null) {
					if (childData.path != null) {
						panoramaData.childrenData.push(childData);
					}else {
						Trace.instance.printWarning("Missing child path for: "+childData.id); // rozbic na parse children
					}
				}else {
					Trace.instance.printWarning("Missing child id.");
				}
			}
		}
		
		private function parseActions(managerData:ManagerData, actionsNode:XML):void {
			var actionData:ActionData;
			for each(var actionNode:XML in actionsNode.elements()) {
				actionData = new ActionData();
				for each(var actionAttribute:XML in actionNode.attributes()) {
					switch (actionAttribute.localName().toString()) {
						case "id":
							actionData.id = getAttributeValue(actionAttribute, String);
						break;
						case "content":
							parseActionContent(actionData, getAttributeValue(actionAttribute , String));
						break;
						default:
							Trace.instance.printWarning("Unrecognized action attribute: "+actionAttribute.localName().toString());
					}
				}
				if (actionData.id != null) {
					if (actionData.functions.length >0) {
						managerData.actionsData.push(actionData);
					}else {
						Trace.instance.printWarning("No functions in action: "+actionData.id);
					}
				}else {
					Trace.instance.printWarning("Missing action id.");
				}
			}
		}
		
		private function parseModules(managerData:ManagerData, modulesNode:XML):void {
			var abstractModuleData:AbstractModuleData;
			var abstractModuleNode:AbstractModuleNode;
			var modulePath:String;
			// for each module
			for (var j:int = 0; j < modulesNode.elements().length(); j++) {
				modulePath = (modulesNode.elements()[j] as XML).attribute("path").toString();
				if(modulePath != null &&  modulePath != ""){
					try {
						abstractModuleData = new AbstractModuleData(
							modulesNode.elements()[j].localName().toString(),
							modulePath,
							j);
						// for ech node inside module node
						for each(var node:XML in ((XML)(modulesNode.elements()[j])).elements()) {
							abstractModuleNode = new AbstractModuleNode(node.localName().toString());
							parseAbstractModuleNodeRecursive(abstractModuleNode, node);
							abstractModuleData.abstractModuleNodes.push(abstractModuleNode);
						}
						managerData.abstractModulesData.push(abstractModuleData);
					}catch (e:Error) {
						Trace.instance.printWarning(e.message);
					}
				}else {
					Trace.instance.printWarning("No path for module: "+modulesNode.elements()[j].localName().toString());
				}
			}
		}
		
		private function applySubAttributes(object:Object, subAttributes:String):void {
			var buffer:*;
			var allSubAttributes:Array = subAttributes.split(",");
			var singleSubAttrArray:Array;
			var recognizedValue:*;
			for each (var singleSubAttribute:String in allSubAttributes) {
				if (singleSubAttribute.length > 0) {
					if (!singleSubAttribute.match(/^[\w]+:[^:]+$/)){ 
						Trace.instance.printWarning("Invalid sub-attribute format: "+singleSubAttribute);
					}else{
						singleSubAttrArray = singleSubAttribute.match(/[^:]+/g);
						recognizedValue = recognizeContent(singleSubAttrArray[1]);
						if (recognizedValue != null){
							if (object.hasOwnProperty(singleSubAttrArray[0])) {
								if (object[singleSubAttrArray[0]] is Boolean) {
									if (recognizedValue is Boolean) {
										object[singleSubAttrArray[0]] = recognizedValue;
									}else {
											Trace.instance.printWarning("Invalid attribute value (Boolean expected): "+singleSubAttribute);
										}
								}else if (object[singleSubAttrArray[0]] is Number) {
									if(recognizedValue is Number){
										object[singleSubAttrArray[0]] = recognizedValue;
									}else {
											Trace.instance.printWarning("Invalid attribute value (Number expected): "+singleSubAttribute);
									}
								}else{
									try {
										object[singleSubAttrArray[0]] = recognizedValue; // this can only be String
									}catch(e:Error){
										Trace.instance.printWarning("Invalid attribute value (not recognized): " + singleSubAttribute);
									}
								}
							}else {
								// check if creation of new atribute in object is possible
								// used in onEnterSource, onLeaveTarget, ect.
								try{
									object[singleSubAttrArray[0]] = recognizedValue; // any recognized type
								}catch (e:Error){
									Trace.instance.printWarning("Invalid attribute name (cannot apply): " + singleSubAttrArray[0]);
								}
							}
						}
					}
				}
			}
		}
		
		private function parseActionContent(actionData:ActionData, content:String):void {
			if (content != null && content.length > 0){
				var singleFunctionArray:Array;
				var allArguments:Array;
				var functionData:FunctionData;				
				var allFunctions:Array = content.split(";");
				var recognizedValue:*;
				for each(var singleFunction:String in allFunctions) {
					if (singleFunction.length > 0) {
						//owner.function(arguments)
						//(^[\w]+)                owner
						//([\w]+(?=\())           function  
						//([^\(]+(?=\)))          arguments 
						singleFunctionArray = singleFunction.match(/(^[\w]+)|([\w]+(?=\())|([^\(]+(?=\)))/g);
						if (singleFunctionArray.length < 2 || singleFunctionArray.length > 3) {
							Trace.instance.printWarning("Wrong format of function: "+singleFunction);
						}else {
							functionData = new FunctionData(singleFunctionArray[0], singleFunctionArray[1]);
								// if function has parameters
							if (singleFunctionArray.length == 3) {
								allArguments = singleFunctionArray[2].split(",");
								for each(var singleArgument:String in allArguments) {
										recognizedValue = recognizeContent(singleArgument);
									if (recognizedValue == null) {
										Trace.instance.printWarning("Empty argument in: " + singleFunction);
									}else {
											functionData.args.push(recognizedValue);
									}
								}
							}
							actionData.functions.push(functionData);
						}
					}
				}
			}
		}
		
		private function recognizeContent(content:String):*{						
			if (content == "true" || content == "false") { 
				return ((content == "true")? true : false);
			}else if (content.match(/^(-)?[\d]+(.[\d]+)?$/)) {
				return (Number(content));
			}else if (content.match(/^#[0-9a-fA-F]{6}$/)) { // color
				content = content.substring(1,content.length);
				return (Number("0x"+content));
			}else if (content.match(/.+:.+/)) { // sub-attributes
				var object:Object = new Object();
				applySubAttributes(object, content);
				return object;
			}else  if (content.length > 0) {
				return content;
			}
			return null;
		}
		
		private function parseAbstractModuleNodeRecursive(abstractModuleNode:AbstractModuleNode, node:XML):void {
			var recognizedValue:*;
			for each(var attribute:XML in node.attributes()) {
				recognizedValue = recognizeContent(attribute.toString());
				if(recognizedValue != null){
					abstractModuleNode.attributes[attribute.name().toString()] = recognizedValue;
				}
			}
			var abstractModuleChildNode:AbstractModuleNode;
			for each(var childNode:XML in node.children()) {
				abstractModuleChildNode = new AbstractModuleNode(childNode.localName().toString());
				parseAbstractModuleNodeRecursive(abstractModuleChildNode, childNode);
				abstractModuleNode.abstractModuleNodes.push(abstractModuleChildNode);
			}
		}
		
		private function getAttributeValue(attribute:XML, ReturnClass:Class):*{
			var recognizedValue:* = recognizeContent(attribute.toString());
			if (recognizedValue is ReturnClass) {
				return recognizedValue;
			}else {
				Trace.instance.printWarning("Ivalid attribute value ("+ReturnClass+" expected): "+recognizedValue);
				return null;
			}
		}		
	}
}