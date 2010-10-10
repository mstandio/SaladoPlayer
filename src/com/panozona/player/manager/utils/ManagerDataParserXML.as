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
	
	import flash.utils.getQualifiedClassName;
	
	import com.panosalado.model.Params;
	
	import com.panozona.player.manager.data.ManagerData;
	import com.panozona.player.manager.data.trace.TraceData;
	import com.panozona.player.manager.data.panorama.PanoramaData;
	import com.panozona.player.manager.data.hotspot.HotspotData;
	import com.panozona.player.manager.data.module.AbstractModuleData;
	import com.panozona.player.manager.data.module.AbstractModuleNode;
	import com.panozona.player.manager.data.action.ActionData;
	import com.panozona.player.manager.data.action.FunctionData;
	import com.panozona.player.manager.utils.Trace;
	
	import com.robertpenner.easing.Expo;
	import com.robertpenner.easing.Linear;
	
	/**
	 * Translates XML to ManagerData
	 * @author mstandio
	 */
	public class ManagerDataParserXML {
		
		private var _debugMode:Boolean = true;
		
		public function configureManagerData(managerData:ManagerData, settings:XML):void {
			
			_debugMode = managerData.debugMode;
			
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
			managerData.populateGlobalParams();
		}
		
		protected function parseGlobal(managerData:ManagerData, globalNode:XML):void {
			for each(var globalAttribute:XML in globalNode.attributes()) {
				switch (globalAttribute.localName().toString()) {
					case "debug":
						managerData.debugMode = getAttributeValue(globalAttribute, Boolean);
					break;
					case "firstPanorama":
						managerData.firstPanorama = getAttributeValue(globalAttribute, String);
					break;
					case "camera":
						applySubAttributes(managerData.params, globalAttribute);
					break;
					case "autorotation":
						applySubAttributes(managerData.autorotationCameraData, globalAttribute);
					break;
					case "transition":
						applySubAttributes(managerData.simpleTransitionData, globalAttribute);
					break;
					case "keyboard":
						applySubAttributes(managerData.keyboardCameraData, globalAttribute);
					break;
					case "mouseDrag":
						applySubAttributes(managerData.arcBallCameraData, globalAttribute);
					break;
					case "mouseInertial":
						applySubAttributes(managerData.inertialMouseCameraData, globalAttribute);
					break;
					case "stats":
						managerData.showStats = getAttributeValue(globalAttribute, Boolean);
					break;
					default:
						Trace.instance.printWarning("Unrecognized global attribute: "+globalAttribute.localName().toString());
				}
			}
			
			parseGlobalChildren(managerData, globalNode);
		}
		
		protected function parseGlobalChildren(managerData:ManagerData, globalNode:XML):void {
			for each(var globalChild:XML in globalNode.children()) {
				switch (globalChild.localName().toString()) {
					case "trace":
						if(_debugMode) parseTrace(managerData.traceData, globalChild);
					break;
					default:
						Trace.instance.printWarning("Unrecognized global child node: "+globalChild.localName().toString());
				}
			}
		}
		
		protected function parseTrace(traceData:TraceData, traceNode:XML):void {
			for each(var traceAttribute:XML in traceNode.attributes()) {
				switch (traceAttribute.localName().toString()) {
					case "open":
						traceData.open = getAttributeValue(traceAttribute, Boolean);
					break;
					case "size":
						applySubAttributes(traceData.size, traceAttribute);
					break;
					case "align":
						applySubAttributes(traceData.align, traceAttribute);
					break;
					default:
						Trace.instance.printWarning("Unrecognized trace attribute: " + traceAttribute.localName().toString());
				}
			}
		}
		
		protected function parsePanoramas(managerData:ManagerData, panoramasNode:XML):void {
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
							applySubAttributes(panoramaData.params, panoramaAttribute);
						break;
						case "onLeaveToAttempt":
							applySubAttributes(panoramaData.onLeaveToAttempt, panoramaAttribute);
						break;
						case "onEnter":
							panoramaData.onEnter = getAttributeValue(panoramaAttribute, String);
						break;
						case "onTransitionEnd":
							panoramaData.onTransitionEnd = getAttributeValue(panoramaAttribute, String);
						break;
						case "onLeave":
							panoramaData.onLeave = getAttributeValue(panoramaAttribute, String);
						break;
						case "onEnterFrom":
							applySubAttributes(panoramaData.onEnterFrom, panoramaAttribute);
							break;
						case "onTransitionEndFrom":
							applySubAttributes(panoramaData.onTransitionEndFrom, panoramaAttribute);
						break;
						case "onLeaveTo":
							applySubAttributes(panoramaData.onLeaveTo, panoramaAttribute);
						break;
						default:
							Trace.instance.printWarning("Unrecognized panorama attribute: "+panoramaAttribute.localName().toString());
					}
				}
				
				if (panoramaData.id != null) {
					if (panoramaData.path != null) {
						parseHotspots(panoramaData, panoramaNode);
						managerData.panoramasData.push(panoramaData);
					}else {
						Trace.instance.printWarning("Missing panorama path for: "+panoramaData.id); 
					}
				}else {
					Trace.instance.printWarning("Missing panorama id.");
				}
			}
		}
		
		protected function parseHotspots(panoramaData:PanoramaData, panoramaNode:XML):void {
			var hotspotData:HotspotData;
			for (var i:int = 0; i < panoramaNode.elements().length(); i++) {
				hotspotData = new HotspotData();
				for each (var hotspotAttribute:XML in panoramaNode.elements()[i].attributes()){
					switch(hotspotAttribute.localName().toString()) {
						case "id":
							hotspotData.id = getAttributeValue(hotspotAttribute, String);
						break;
						case "path":
							hotspotData.path = getAttributeValue(hotspotAttribute, String);
						break;
						case "position":
							applySubAttributes(hotspotData.position, hotspotAttribute);
						break;
						case "mouse":
							applySubAttributes(hotspotData.mouse, hotspotAttribute);
						break;
						case "transformation":
							applySubAttributes(hotspotData.transformation, hotspotAttribute);
						break;
						case "swfArguments":
							applySubAttributes(hotspotData.swfArguments, hotspotAttribute);
						break;
						default:
							Trace.instance.printWarning("Unrecognized hotspot attribute: "+hotspotAttribute.localName().toString());
					}
				}
				if (hotspotData.id != null) {
					if (hotspotData.path != null) {
						panoramaData.hotspotsData.push(hotspotData);
					}else {
						Trace.instance.printWarning("Missing hotspot path for: "+hotspotData.id); // rozbic na parse children
					}
				}else {
					Trace.instance.printWarning("Missing hotspot id.");
				}
			}
		}
		
		protected function parseActions(managerData:ManagerData, actionsNode:XML):void {
			var actionData:ActionData;
			for each(var actionNode:XML in actionsNode.elements()) {
				actionData = new ActionData();
				for each(var actionAttribute:XML in actionNode.attributes()) {
					switch (actionAttribute.localName().toString()) {
						case "id":
							actionData.id = getAttributeValue(actionAttribute, String);
						break;
						case "content":
							parseActionContent(actionData, getAttributeValue(actionAttribute, String));
						break;
						default:
							Trace.instance.printWarning("Unrecognized action attribute: "+actionAttribute.localName().toString());
					}
				}
				if (actionData.id != null) {
					if (actionData.functions.length > 0){
						managerData.actionsData.push(actionData);
					}else {
						Trace.instance.printWarning("No functions in action: "+actionData.id);
					}
				}else {
					Trace.instance.printWarning("Missing action id.");
				}
			}
		}
		
		protected function parseModules(managerData:ManagerData, modulesNode:XML):void {
			var abstractModuleData:AbstractModuleData;
			var abstractModuleNode:AbstractModuleNode;
			var modulePath:String;
			// for each module
			for (var j:int = 0; j < modulesNode.elements().length(); j++) {
				modulePath = (modulesNode.elements()[j] as XML).attribute("path").toString();
				if(modulePath != null){
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
					}catch (error:Error) {
						Trace.instance.printWarning("Could not read module data:" + error.message);
						trace(error.getStackTrace());
					}
				}else {
					Trace.instance.printWarning("No path for module: "+modulesNode.elements()[j].localName().toString());
				}
			}
		}
		
		protected function applySubAttributes(object:Object, subAttributes:String):void {
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
						if (!_debugMode) {
							if (recognizedValue != null) {
								object[singleSubAttrArray[0]] = recognizedValue;
							}
						}else {
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
									}else if (object[singleSubAttrArray[0]] is Function) {
										if(recognizedValue is Function){
											object[singleSubAttrArray[0]] = recognizedValue;
										}else {
											Trace.instance.printWarning("Invalid attribute value (Function expected): "+singleSubAttribute);
										}
									}else{ // this can only be String
										try {
											object[singleSubAttrArray[0]] = recognizedValue; 
										}catch(e:Error){
											Trace.instance.printWarning("Invalid attribute value (String expected): "+singleSubAttribute);
										}
									}
								}else {
									// check if creation of new atribute in object is possible
									// used in onEnterSource, onLeaveTarget, ect.
									try{
										object[singleSubAttrArray[0]] = recognizedValue; // any recognized type
									}catch (e:Error){
										Trace.instance.printWarning("Invalid attribute name (cannot apply): "+singleSubAttrArray[0]);
									}
								}
							}
						}
					}
				}
			}
		}
		
		protected function parseActionContent(actionData:ActionData, content:String):void {
			if (content != null && content.length > 0){
				var singleFunctionArray:Array;
				var allArguments:Array;
				var functionData:FunctionData;
				var allFunctions:Array = content.split(";");
				var recognizedValue:*;
				for each(var singleFunction:String in allFunctions) {
					if (singleFunction.length > 0 && singleFunction.match(/^[\w]+\.[\w]+\(.*\)$/)) {
						//owner.function(arguments)
						//(^[\w]+)                owner
						//([\w]+(?=\())           function  
						//((?<=\().+(?=\)))       arguments 
						singleFunctionArray = singleFunction.match(/(^[\w]+)|([\w]+(?=\())|((?<=\().+(?=\)))/g);
						if (singleFunctionArray.length < 2 || singleFunctionArray.length > 3) {
							Trace.instance.printWarning("Wrong format of function: "+singleFunction);
						}else {
							functionData = new FunctionData(singleFunctionArray[0], singleFunctionArray[1]);
							if (singleFunctionArray.length == 3) { // if function has parameters
								allArguments = singleFunctionArray[2].split(",");
								for each(var singleArgument:String in allArguments) {
										recognizedValue = recognizeContent(singleArgument);
									if (recognizedValue != null) {
										functionData.args.push(recognizedValue);
									}
								}
							}
							actionData.functions.push(functionData);
						}
					}else {
						Trace.instance.printWarning("Wrong format of function: "+singleFunction);
					}
				}
			}
		}
		
		protected function recognizeContent(content:String):*{
			if (content == "true" || content == "false") { // Boolean
				return ((content == "true")? true : false);
			}else if (content.match(/^(-)?[\d]+(.[\d]+)?$/)) { // Number
				return (Number(content));
			}else if (content.match(/^#[0-9a-fA-F]{6}$/)) { // Number - color
				content = content.substring(1,content.length);
				return (Number("0x" + content));
			}else  if (content == "NaN"){ // Number - NaN
				return NaN;
			}else if (content.match(/^.+:.+$/)) { // sub-attributes
				var object:Object = new Object();
				applySubAttributes(object, content);
				return object;
			}else  if (content.match(/^(Linear|Expo)\.[a-zA-Z]+$/)){ // Function
				return (recognizeFunction(content) as Function);
			}else if (content.match(/^\[.+\]$/)) {
				return content.substring(1, content.length - 1); // [String]
			}else {
				return content;	// String
			}
			Trace.instance.printWarning("Unrecognized content: "+content);
			return null;
		}
		
		protected function recognizeFunction(content:String):Function {
			var functionElements:Array = content.split(".");
			if (functionElements[0] == "Linear") {
				if (functionElements[1] == "easeNone") return Linear.easeNone;
				if (functionElements[1] == "easeIn") return Linear.easeIn;
				if (functionElements[1] == "easeOut") return Linear.easeInOut;
				if (functionElements[1] == "easeInOut") return Linear.easeInOut;
				Trace.instance.printWarning("Invalid function name: "+functionElements[1]);
				return null;
			} else if (functionElements[0] == "Expo") {
				if (functionElements[1] == "easeIn") return Expo.easeIn;
				if (functionElements[1] == "easeOut") return Expo.easeOut;
				if (functionElements[1] == "easeInOut") return Expo.easeInOut;
				Trace.instance.printWarning("Invalid function name: "+functionElements[1]);
				return null;
			}else {
				Trace.instance.printWarning("Invalid function owner: "+functionElements[0]);
				return null;
			}
		}
		
		protected function parseAbstractModuleNodeRecursive(abstractModuleNode:AbstractModuleNode, node:XML):void {
			var recognizedValue:*;
			for each(var attribute:XML in node.attributes()) {
				recognizedValue = recognizeContent(attribute.toString());
				if(recognizedValue != null){
					abstractModuleNode.attributes[attribute.name().toString()] = recognizedValue;
				}
			}
			var abstractModuleChildNode:AbstractModuleNode;
			for each(var childNode:XML in node.children()){
				if(childNode.nodeKind() != "text"){
					abstractModuleChildNode = new AbstractModuleNode(childNode.localName().toString());
					parseAbstractModuleNodeRecursive(abstractModuleChildNode, childNode);
					abstractModuleNode.abstractModuleNodes.push(abstractModuleChildNode);
				}else {
					if (abstractModuleNode.attributes["text"] == undefined) {
						abstractModuleNode.attributes["text"] = childNode.toString();
					}else {
						Trace.instance.printWarning("Text value allready exists in: "+abstractModuleNode.nodeName);
					}
				}
			}
		}
		
		protected function getAttributeValue(attribute:XML, ReturnClass:Class):*{
			var recognizedValue:* = recognizeContent(attribute.toString());
			if (recognizedValue is ReturnClass) {
				return recognizedValue;
			}else {
				Trace.instance.printWarning("Ivalid attribute value ("+getQualifiedClassName(ReturnClass)+" expected): "+recognizedValue);
				return null;
			}
		}
		
		protected function get debugMode():Boolean {
			return _debugMode;
		}
	}
}