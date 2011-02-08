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
package com.panozona.player.manager.utils.configuration {
	
	import com.panozona.player.component.*;
	import com.panozona.player.manager.data.*;
	import com.panozona.player.manager.data.actions.*;
	import com.panozona.player.manager.data.global.*;
	import com.panozona.player.manager.data.panoramas.*
	import com.panozona.player.manager.utils.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flash.utils.*;
	
	public class OldManagerDataParserXML extends EventDispatcher{
		
		private var debugMode;
		
		public function OldManagerDataParserXML(settings:XML):void {
			// dive for debug mode first could have some use for digging for ids
			debugMode = true;
		}
		
		/*
		public function configureManagerData(managerData:ManagerData):void {
			
			for each(var mainNode:XML in settings.children()){
				switch(mainNode.localName().toString()){
					case "global":
						parseGlobal(mainNode, managerData);
					break;
					case "panoramas":
						parsePanoramas(mainNode, managerData.panoramasData);
					break;
					case "actions":
						parseActions(mainNode, managerData.actionsData);
					break;
					case "modules":
						parseComponets(mainNode, managerData.modulesData);
					break;
					case "factories":
						parseComponets(mainNode, managerData.factoriesData);
					break;
					default:
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Unrecognized node: " + mainNode.name()));
				}
			}
			managerData.populateGlobalParams();
		}
		
		protected function pickAttribute(name:String, type:Class, node:XML):* {
			for each(var attribute:XML in node.attributes()) {
				if (attribute.localName().toString() == name) {
					var result:* = recognizeContent(attribute);
					if (result is type) return result;
				}
			}
			return null;
		}
		
		// TODO: this needs to be done right 
		protected function translateXMLtoObjet(node:XML, object:Object){
			for each(var attribute:XML in node.attributes()){
				//attribute
			}
		}
		
		//no i teraz  warto sie zastanowic czy nie da sie tego skrocic 
		// potrzebna funkcja tlumaczaca pojedynczy node xml na zawartosc obiektu ... 
		// juz to wlasciwie mam zrobione 
		
		private function parseGlobal(managerData:ManagerData, globalNode:XML):void {
			for each(var globalAttribute:XML in globalNode.attributes()) {
				switch (globalAttribute.localName().toString()) {
					case "debug":
						// nothing, debug was alleady found.
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
					//case "stats": TODO: place stats elswhere
					//managerData.showStats = getAttributeValue(globalAttribute, Boolean);
					//break;
					default:
						Trace.instance.printWarning("Unrecognized global attribute: "+globalAttribute.localName().toString());
				}
			}
			
			// tutaj powinno to gowno byc z ta populacja dzieci 
			
			parseGlobalChildren(managerData, globalNode);
		}
		
		private function parseGlobalChildren(managerData:ManagerData, globalNode:XML):void {
			for each(var globalChild:XML in globalNode.children()) {
				switch (globalChild.localName().toString()) {
					case "trace":
						if(debugMode) parseTrace(managerData.traceData, globalChild);
					break;
					case "branding":
						parseBranding(managerData.brandingData, globalChild);
					break;
					default:
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, "Unrecognized global child node: "+globalChild.localName().toString()));
				}
			}
		}
		
		private function parseTrace(traceData:TraceData, traceNode:XML):void {
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
		
		private function parseBranding(brandingData:BrandingData, brandingNode:XML):void {
			for each(var brandingAttribute:XML in brandingNode.attributes()) {
				switch (brandingAttribute.localName().toString()) {
					case "visible":
						brandingData.visible = getAttributeValue(brandingAttribute, Boolean);
					break;
					case "align":
						applySubAttributes(brandingData.align, brandingAttribute);
					break;
					case "move":
						applySubAttributes(brandingData.move, brandingAttribute);
					break;
					default:
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, "Unrecognized branding attribute: " + brandingAttribute.localName().toString()));
				}
			}
		}
		
		private function parsePanoramas(panoramasData:Vector.<PanoramaData>, panoramasNode:XML):void {
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
						case "thumbnail":
							panoramaData.thumbnail = getAttributeValue(panoramaAttribute, String);
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
							dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, "Unrecognized panorama attribute: " +
								panoramaAttribute.localName().toString()));
					}
				}
			}
			parseHotspots(panoramaData.hotspotsData, panoramaNode);
			panoramasData.push(panoramaData);
		}
		
		private function parseHotspots(hotspotsData:Vector.<HotspotData>, panoramaNode:XML):void {
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
							dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, "Unrecognized panorama attribute: " +
								"Unrecognized hotspot attribute: "+hotspotAttribute.localName().toString()));
					}
				}
				hotspotsData.push(hotspotData);
			}
		}
		
		private function parseActions(actionsData:Vector.<ActionData>, actionsNode:XML):void {
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
							dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, "Unrecognized panorama attribute: " +
								"Unrecognized action attribute: "+actionAttribute.localName().toString()));
					}
				}
				actionsData.push(actionData);
			}
		}
		
		private function parseModules(modulesData:Vector.<ComponentData>, modulesNode:XML):void {
			var componentData:ComponentData;
			var componentNode:ComponentNode;
			var modulePath:String;
			// for each module
			for (var j:int = 0; j < modulesNode.elements().length(); j++) {
				modulePath = (modulesNode.elements()[j] as XML).attribute("path").toString();// TODO: huhhh
				if(modulePath != null){
					try {
						componentData = new ComponentData(modulesNode.elements()[j].localName().toString(), modulePath); // TODO: wtf was I thinking
						// for ech node inside module node
						for each(var node:XML in ((XML)(modulesNode.elements()[j])).elements()) {
							componentNode = new ComponentNode(node.localName().toString());
							parseComponentNodeRecursive(componentNode, node);
							componentData.nodes.push(componentNode);
						}
						modulesData.push(componentData);
					}catch (error:Error) {
						Trace.instance.printWarning("Could not read module data:" + error.message); 
						trace(error.getStackTrace());
					}
				}else {
					Trace.instance.printWarning("No path for module: " + modulesNode.elements()[j].localName().toString());
				}
			}
		}
		
		private function parseComponentNodeRecursive(componentNode:ComponentNode, node:XML):void {
			var recognizedValue:*;
			for each(var attribute:XML in node.attributes()) {
				recognizedValue = recognizeContent(attribute.toString());
				if(recognizedValue != null){
					componentNode.attributes[attribute.name().toString()] = recognizedValue;
				}
			}
			var componentChildNode:ComponentNode;
			for each(var childNode:XML in node.children()){
				if(childNode.nodeKind() != "text"){
					componentChildNode = new ComponentNode(childNode.localName().toString());
					parseComponentNodeRecursive(componentChildNode, childNode);
					componentNode.childNodes.push(componentChildNode);
				}else {
					if (componentNode.attributes["text"] == undefined) {
						componentNode.attributes["text"] = childNode.toString();
					}else {
						Trace.instance.printWarning("Text value allready exists in: " + componentNode.name);
					}
				}
			}
		}
		
		private function applySubAttributes(subAttributes:String, object:Object):void {
			var allSubAttributes:Array = subAttributes.split(","); // TODO: hmmm nie powinno to tak wygladac blechtrudno 
			var singleSubAttrArray:Array;
			var recognizedValue:*;
			for each (var singleSubAttribute:String in allSubAttributes) {
				if (singleSubAttribute.length > 0) {
					if (!singleSubAttribute.match(/^[\w]+:[^:]+$/)){
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Invalid sub-attribute format: " + singleSubAttribute));
					}else{
						singleSubAttrArray = singleSubAttribute.match(/[^:]+/g);
						recognizedValue = recognizeContent(singleSubAttrArray[1]);
						if (recognizedValue != null) {
							continue;
						}
						if (!_debugMode) {
							object[singleSubAttrArray[0]] = recognizedValue;
						}else {
							if (object.hasOwnProperty(singleSubAttrArray[0])) {
								if (object[singleSubAttrArray[0]] is Boolean) {
									if (recognizedValue is Boolean) {
										object[singleSubAttrArray[0]] = recognizedValue;
									}else {
										dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
											("Invalid attribute value (Boolean expected): " + singleSubAttribute)));
									}
								}else if (object[singleSubAttrArray[0]] is Number) {
									if(recognizedValue is Number){
									object[singleSubAttrArray[0]] = recognizedValue;
									}else {
										dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
											("Invalid attribute value (Number expected): " + singleSubAttribute)));
									}
								}else if (object[singleSubAttrArray[0]] is Function) {
									if(recognizedValue is Function){
										object[singleSubAttrArray[0]] = recognizedValue;
									}else {
										dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
											("Invalid attribute value (Function expected): " + singleSubAttribute)));
									}
								}else if (object[singleSubAttrArray[0]] == null || object[singleSubAttrArray[0]] is String) {
									if(recognizedValue is String){
										object[singleSubAttrArray[0]] = recognizedValue; 
									}else {
										dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
											("Invalid attribute value (String expected): " + singleSubAttribute)));
									}
								}
							}else {
								// check if creation of new atribute in object is possible
								// used in onEnterSource, onLeaveTarget, ect.
								try{
									object[singleSubAttrArray[0]] = recognizedValue;
								}catch (e:Error) {
									dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
										"Invalid attribute name (cannot apply): "+singleSubAttrArray[0]));
								}
							}
						}
					}
				}
			}
		}
		
		// [a-zA-Z]+\.[a-zA-Z]+\([\[\]\{\}a-zA-Z0-9\.\s,:;]*\)(?=[;]) TODO: verify 
		
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
							dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, "Wrong format of function: " + singleFunction));
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
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, "Wrong format of function: " + singleFunction));
					}
				}
			}
		}
		
		private function recognizeContent(content:String):*{
			if (content.match(/^\[.*\]$/)) { // [String]
				return content.substring(1, content.length - 1); 
			} else if (content == "true" || content == "false") { // Boolean
				return ((content == "true")? true : false);
			}else if (content.match(/^(-)?[\d]+(.[\d]+)?$/)) { // Number
				return (Number(content));
			}else if (content.match(/^#[0-9a-f]{6}$/i)) { // Number - color
				content = content.substring(1,content.length);
				return (Number("0x" + content));
			}else if (content == "NaN"){ // Number - NaN
				return NaN;
			}else if (content.match(/^.+:.+$/)) { // Object
				var object:Object = new Object();
				applySubAttributes(object, content);
				return object;
			}else  if (content.match(/^(Linear|Expo|Back|Bounce|Cubic)\.[a-zA-Z]+$/)){ // Function
				return (recognizeFunction(content) as Function);
			}else if (content.replace(/\s/g, "").length > 0) { // TODO: trim String
				return content; // String
			}else {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, "Empty content."));
				return null;
			}
		}
		
		// TODO: should not return null 
		protected function recognizeFunction(content:String):Function {
			var functionElements:Array = content.split(".");
			if (functionElements[0] == "Linear") {
				if (functionElements[1] == "easeNone") return Linear.easeNone;
				if (functionElements[1] == "easeIn") return Linear.easeIn;
				if (functionElements[1] == "easeOut") return Linear.easeInOut;
				if (functionElements[1] == "easeInOut") return Linear.easeInOut;
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, 
					"Invalid function owner: " + functionElements[0]));
				return null;
			} else if (functionElements[0] == "Expo") {
				if (functionElements[1] == "easeIn") return Expo.easeIn;
				if (functionElements[1] == "easeOut") return Expo.easeOut;
				if (functionElements[1] == "easeInOut") return Expo.easeInOut;
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, 
					"Invalid function owner: " + functionElements[0]));
				return null;
			/*} else if (functionElements[0] == "Elastic") { // TODO: too many arguments 
				if (functionElements[1] == "easeIn") return Elastic.easeIn;
				if (functionElements[1] == "easeOut") return Elastic.easeOut;
				if (functionElements[1] == "easeInOut") return Elastic.easeInOut;
				Trace.instance.printWarning("Invalid function name: " + functionElements[1]);
				return null;
			
			} else if (functionElements[0] == "Cubic") { // TODO: too many arguments 
				if (functionElements[1] == "easeIn") return Cubic.easeIn;
				if (functionElements[1] == "easeOut") return Cubic.easeOut;
				if (functionElements[1] == "easeInOut") return Cubic.easeInOut;
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, 
					"Invalid function owner: " + functionElements[0]));
				return null;
			} else if (functionElements[0] == "Bounce") { // TODO: too many arguments 
				if (functionElements[1] == "easeIn") return Bounce.easeIn;
				if (functionElements[1] == "easeOut") return Bounce.easeOut;
				if (functionElements[1] == "easeInOut") return Bounce.easeInOut;
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, 
					"Invalid function owner: " + functionElements[0]));
				return null;
			} else if (functionElements[0] == "Back") {
				if (functionElements[1] == "easeIn") return Back.easeIn;
				if (functionElements[1] == "easeOut") return Back.easeOut;
				if (functionElements[1] == "easeInOut") return Back.easeInOut;
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
					"Invalid function name: " + functionElements[1]));
				return null;
			}else {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, 
					"Invalid function owner: " + functionElements[0]));
				return null;
			}
		}
		
		protected function getAttributeValue(attribute:XML, ReturnClass:Class):*{
			var recognizedValue:* = recognizeContent(attribute.toString());
			if (recognizedValue is ReturnClass) {
				return recognizedValue;
			}else {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
					"Ivalid attribute value (" + getQualifiedClassName(ReturnClass) + " expected): " + recognizedValue)); // TODO: should get proper class name
				return null;
			}
		}
		*/
	}
}