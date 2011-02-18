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
	import com.panozona.player.manager.data.panoramas.*;
	import com.panozona.player.manager.events.*;
	import com.panozona.player.manager.utils.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flash.utils.*;
	
	public class ManagerDataParserXML extends EventDispatcher{
		
		protected var debugMode:Boolean = true;
		
		public function configureManagerData(managerData:ManagerData, settings:XML):void {
			if (settings.global != undefined) {
				if (settings.global.@debug != undefined) {
					var debugValue:*;
					debugValue = recognizeContent(settings.global.@debug);
					if (!(debugValue is Boolean)) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Unrecognized main node: " + mainNodeName));
					}else {
						managerData.debugMode = debugValue;
						debugMode = managerData.debugMode;
					}
				}
			}
			var mainNodeName:String;
			for each(var mainNode:XML in settings.children()) {
				mainNodeName = mainNode.localName().toString();
				if (mainNode.localName().toString() == "global") {
					parseGlobal(managerData, mainNode);
				}else if (mainNode.localName().toString() == "panoramas") {
					parsePanoramas(managerData.panoramasData, mainNode);
				}else if (mainNode.localName().toString() == "modules") {
					parseComponents(managerData.modulesData, mainNode);
				}else if (mainNode.localName().toString() == "factories") {
					parseComponents(managerData.factoriesData, mainNode);
				}else if (mainNode.localName().toString() == "actions") {
					parseActions(managerData.actionsData, mainNode);
				}else {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Unrecognized main node: " + mainNodeName));
				}
			}
		}
		
		protected function parseGlobal(managerData:ManagerData, globalNode:XML):void {
			var globalChildNodeName:String;
			for each(var globalChildNode:XML in globalNode.children()) {
				globalChildNodeName = globalChildNode.localName();
				if (globalChildNodeName == "trace") {
					parseTrace(managerData.traceData, globalChildNode);
				}else if (globalChildNodeName == "stats") {
					parseStats(managerData.statsData, globalChildNode);
				}else if (globalChildNodeName == "branding") {
					parseBranding(managerData.brandingData, globalChildNode);
				}else if (globalChildNodeName == "control") {
					parseControl(managerData.controlData, globalChildNode);
				}else if (globalChildNodeName == "panoramas") {
					parseGlobalPanoramas(managerData.allPanoramasData, globalChildNode);
				}else {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Unrecognized global node: " + globalChildNodeName));
				}
			}
		}
		
		protected function parseGlobalPanoramas(allPanoramasData:AllPanoramasData, globalPanoramasNode:XML):void {
			var globalPanoAttributeName:String;
			for each(var globalPanoAttribute:XML in globalPanoramasNode.attributes()) {
				globalPanoAttributeName = globalPanoAttribute.localName();
				if (globalPanoAttributeName == "firstPanorama") {
					allPanoramasData.firstPanorama = getAttributeValue(globalPanoAttribute, String);
				} else if (globalPanoAttributeName == "camera") {
					applySubAttributes(allPanoramasData.params, globalPanoAttribute);
				} else {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Unrecognized global panoramas attribute: " + globalPanoAttributeName));
				}
			}
		}
		
		protected function parseControl(controlData:ControlData, controlNode:XML):void {
			var controlAttributeName:String;
			for each(var controlAttribute:XML in controlNode.attributes()) {
				controlAttributeName = controlAttribute.localName();
				if (controlAttributeName == "autorotation") {
					applySubAttributes(controlData.autorotationCameraData, controlAttribute);
				} else if (controlAttributeName == "transition") {
					applySubAttributes(controlData.simpleTransitionData, controlAttribute);
				} else if (controlAttributeName == "keyboard") {
					applySubAttributes(controlData.keyboardCameraData, controlAttribute);
				} else if (controlAttributeName == "mouseInertial") {
					applySubAttributes(controlData.inertialMouseCameraData, controlAttribute);
				} else if (controlAttributeName == "mouseDrag") {
					applySubAttributes(controlData.arcBallCameraData, controlAttribute);
				} else {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Unrecognized control attribute: " + controlAttributeName));
				}
			}
		}
		
		protected function parseTrace(traceData:TraceData, traceNode:XML):void {
			var traceAttributeName:String;
			for each(var traceAttribute:XML in traceNode.attributes()) {
				traceAttributeName = traceAttribute.localName();
				if (traceAttributeName == "open") {
					traceData.open = getAttributeValue(traceAttribute, String);
				}else if (traceAttributeName == "size") {
					applySubAttributes(traceData.size, traceAttribute);
				}else if (traceAttributeName == "align"){
					try{
						applySubAttributes(traceData.align, traceAttribute);
					}catch (error:Error) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							error.message));
					}
				}else if (traceAttributeName == "move") {
					applySubAttributes(traceData.move, traceAttribute);
				}else {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Unrecognized trace attribute: " + traceAttributeName));
				}
			}
		}
		
		protected function parseBranding(brandingData:BrandingData, brandingNode:XML):void {
			var brandingAttributeName:String;
			for each(var brandingAttribute:XML in brandingNode.attributes()) {
				brandingAttributeName = brandingAttribute.localName();
				if (brandingAttributeName == "visible") {
					brandingData.visible = getAttributeValue(brandingAttribute, String);
				}else if (brandingAttributeName == "align") {
					try{
						applySubAttributes(brandingData.align, brandingAttribute);
					}catch (error:Error) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							error.message));
					}
				}else if (brandingAttributeName == "move") {
					applySubAttributes(brandingData.move, brandingAttribute);
				}else {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Unrecognized branding attribute: " + brandingAttributeName));
				}
			}
		}
		
		protected function parseStats(statsData:StatsData, statsNode:XML):void {
			var statsAttributeName:String;
			for each(var statsAttribute:XML in statsNode.attributes()) {
				statsAttributeName = statsAttribute.localName();
				if (statsAttributeName == "visible") {
					statsData.visible = getAttributeValue(statsAttribute, Boolean); // TODO: can be risky...
				}else if (statsAttributeName == "align") {
					try{
						applySubAttributes(statsData.align, statsAttribute);
					}catch (error:Error) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							error.message));
					}
				}else if (statsAttributeName == "move") {
					applySubAttributes(statsData.move, statsAttribute);
				}else {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Unrecognized stats attribute: " + statsAttributeName));
				}
			}
		}
		
		protected function parsePanoramas(panoramasData:Vector.<PanoramaData>, panoramasNode:XML):void {
			var panoramaId:*;
			var panoramaData:PanoramaData;
			var panoramaAttributeName:String;
			for each(var panoramaNode:XML in panoramasNode.elements()) {
				if (panoramaNode.@id == undefined) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
						"Missing panorama id."));
					continue;
				}
				if (panoramaNode.@path == undefined) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
						"Missing panorama path."));
					continue;
				}
				panoramaId = recognizeContent(panoramaNode.@id);
				if (!(panoramaId is String)) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
						"Invalid panorama id format."));
					continue;
				}
				panoramaData = new PanoramaData(panoramaId, panoramaNode.@path);
				panoramasData.push(panoramaData);
				for each(var panoramaAttribute:XML in panoramaNode.attributes()) {
					panoramaAttributeName = panoramaAttribute.localName();
					if (panoramaAttributeName == "camera") {
						applySubAttributes(panoramaData.params, panoramaAttribute);
					}else if (panoramaAttributeName == "onEnter") {
						panoramaData.onEnter = getAttributeValue(panoramaAttribute, String);
					}else if (panoramaAttributeName == "onTransitionEnd") {
						panoramaData.onTransitionEnd = getAttributeValue(panoramaAttribute, String);
					}else if (panoramaAttributeName == "onLeave") {
						panoramaData.onLeave = getAttributeValue(panoramaAttribute, String);
					}else if (panoramaAttributeName == "onEnterFrom") {
						applySubAttributes(panoramaData.onEnterFrom, panoramaAttribute);
					}else if (panoramaAttributeName == "onTransitionEndFrom") {
						applySubAttributes(panoramaData.onTransitionEndFrom, panoramaAttribute);
					}else if (panoramaAttributeName == "onLeaveTo") {
						applySubAttributes(panoramaData.onLeaveTo, panoramaAttribute);
					}else if (panoramaAttributeName == "onLeaveToAttempt") {
						applySubAttributes(panoramaData.onLeaveToAttempt, panoramaAttribute);
					}else if (panoramaAttributeName != "id" && panoramaAttributeName != "path") {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Unrecognized panorama attribute: " + panoramaAttribute.localName()));
					}
				}
				parseHotspots(panoramaData, panoramaNode);
			}
		}
		
		protected function parseHotspots(panoramaData:PanoramaData, panoramaNode:XML):void {
			var hotspotId:*;
			var hotspotData:HotspotData;
			var hotspotAttributeName:String;
			for each(var hotspotNode:XML in panoramaNode.elements()) {
				if(hotspotNode.@id == undefined) {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
					"Missing hotspot id."));
					continue;
				}
				hotspotId = recognizeContent(hotspotNode.@id);
				if (!(hotspotId is String)) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
						"Invalid hotspot id format: " + hotspotId));
					continue;
				}
				if (hotspotNode.localName() == "image" || hotspotNode.localName() == "swf") {
					if (hotspotNode.@path == undefined) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
							"Missing hotspot path: " + hotspotId));
						continue;
					}
					if (hotspotNode.localName() == "image") {
						 hotspotData = new HotspotDataImage(hotspotId, hotspotNode.@path);
						 panoramaData.hotspotsDataImage.push(hotspotData as HotspotDataImage);
					}else {
						 hotspotData = new HotspotDataSwf(hotspotId, hotspotNode.@path, hotspotNode);
						 panoramaData.hotspotsDataSwf.push(hotspotData as HotspotDataSwf);
					}
				}else if (hotspotNode.localName() == "product") {
					if (hotspotNode.@factory == undefined) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
							"Missing hotspot factory: " + hotspotId));
						continue;
					}
					hotspotData = new HotspotDataProduct(hotspotId, hotspotNode.@factory);
					panoramaData.hotspotsDataProduct.push(hotspotData as HotspotDataProduct);
				}else {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Unrecognized hotspot type: " + hotspotNode.localName()));
					continue;
				}
				for each (var hotspotAttribute:XML in hotspotNode.attributes()) {
					hotspotAttributeName = hotspotAttribute.localName();
					if (hotspotAttributeName == "location"){
						applySubAttributes(hotspotData.location, hotspotAttribute);
					}else if (hotspotAttributeName == "mouse") {
						applySubAttributes(hotspotData.mouse, hotspotAttribute);
					}else if (hotspotAttributeName == "transform") {
						applySubAttributes(hotspotData.transform, hotspotAttribute);
					}else if (hotspotAttributeName != "id" && hotspotAttributeName != "path" && hotspotAttributeName != "factory"){
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Unrecognized hotspot attribute: " + hotspotAttribute.localName()));
					}
				}
			}
		}
		
		protected function parseComponents(componentsData:Vector.<ComponentData>, componentsDataNode:XML):void {
			var componentData:ComponentData;
			var componentNode:ComponentNode;
			for each(var componentDataNode:XML in componentsDataNode.elements()) {
				if(componentDataNode.@path == undefined ) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Missing path for: " + componentDataNode.localName()));
					continue;
				}
				componentData = new ComponentData(componentDataNode.localName(), componentDataNode.@path);
				componentsData.push(componentData);
				for each(var componentChildNode:XML in componentDataNode.elements()) {
					componentNode = new ComponentNode(componentChildNode.localName());
					parseComponentNodeRecursive(componentNode, componentChildNode);
					componentData.nodes.push(componentNode);
				}
			}
		}
		
		protected function parseComponentNodeRecursive(componentNode:ComponentNode, xmlNode:XML):void {
			var recognizedValue:*;
			for each(var attribute:XML in xmlNode.attributes()) {
				recognizedValue = recognizeContent(attribute);
				componentNode.attributes[attribute.name().toString()] = recognizedValue;
			}
			var componentChildNode:ComponentNode;
			for each(var childNode:XML in xmlNode.children()){
				if (childNode.nodeKind() == "text"){
					if (componentNode.attributes["text"] == undefined) {
						componentNode.attributes["text"] = childNode;
					}else {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Text value allready exists in: " + componentNode.name));
					}
				}else {
					componentChildNode = new ComponentNode(childNode.localName());
					componentNode.childNodes.push(componentChildNode);
					parseComponentNodeRecursive(componentChildNode, childNode);
				}
			}
		}
		
		protected function parseActions(actionsData:Vector.<ActionData>, actionsNode:XML):void {
			var actionData:ActionData;
			var actionId:*;
			for each(var actionNode:XML in actionsNode.elements()) {
				if (actionNode.@id == undefined) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
						"Missing action id."));
					continue;
				}
				actionId = recognizeContent(actionNode.@id);
				if (!(actionId is String)) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
						"Invalid action id format" + actionId));
					continue;
				}
				
				if (actionNode.@content == undefined) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
						"Missing action content."));
					continue;
				}
				actionData = new ActionData(actionId);
				actionsData.push(actionData);
				for each(var actionAttribute:XML in actionNode.attributes()) {
					if (actionAttribute.localName() == "content") {
						parseActionContent(actionData, actionAttribute);
					}else if (actionAttribute.localName() != "id") {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Unrecognized action attribute: " + actionAttribute.localName()));
					}
				}
			}
		}
		
		protected function parseActionContent(actionData:ActionData, content:String):void {
			var allFunctions:Array = content.split(";");
			var singleFunctionArray:Array;
			var allArguments:Array;
			var singleArgument:String;
			var functionData:FunctionData;
			var recognizedValue:*;
			for each(var singleFunction:String in allFunctions) {
				if (singleFunction.match(/^[\w]+\.[\w]+\(.*\)$/)) {
					//owner.function(arguments)
					//(^[\w]+)          owner
					//([\w]+(?=\())     function
					//((?<=\().+(?=\))) arguments
					singleFunctionArray = singleFunction.match(/(^[\w]+)|([\w]+(?=\())|((?<=\().+(?=\)))/g);
					if (singleFunctionArray.length < 2 || singleFunctionArray.length > 3) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Wrong format of function: " + singleFunction));
						continue;
					}
					functionData = new FunctionData(singleFunctionArray[0], singleFunctionArray[1]);
					actionData.functions.push(functionData);
					if (singleFunctionArray.length == 3) {
						allArguments = singleFunctionArray[2].split(",");
						for each(singleArgument in allArguments) {
							recognizedValue = recognizeContent(singleArgument);
							functionData.args.push(recognizedValue);
						}
					}
				}else if (singleFunction.match(/^[\w]+\[[^\[\]]+\]\.[\w]+\(.*\)$/)) {
					singleFunctionArray = singleFunction.match(/(^[\w]+)|(?<=(\w\[)).+(?=\]\.)|([\w]+(?=\())|((?<=\().+(?=\)))/g);
					//owner.function(arguments)
					//(^[\w]+)              owner
					//(?<=(\w\[)).+(?=\]\.) target
					//([\w]+(?=\())         function
					//((?<=\().+(?=\)))     arguments
					if (singleFunctionArray.length < 3 || singleFunctionArray.length > 4) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Wrong format of function: " + singleFunction));
						continue;
					}
					functionData = new FunctionDataTarget(singleFunctionArray[0], singleFunctionArray[1].split(","), singleFunctionArray[2]);
					actionData.functions.push(functionData);
					if (singleFunctionArray.length == 4) {
						allArguments = singleFunctionArray[3].split(",");
						for each(singleArgument in allArguments) {
							recognizedValue = recognizeContent(singleArgument);
							functionData.args.push(recognizedValue);
						}
					}
				}else {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Wrong format of action content: " + singleFunction));
				}
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
		
		protected function applySubAttributes(object:Object, subAttributes:String):void {
			var allSubAttributes:Array = subAttributes.split(",");
			var singleSubAttrArray:Array;
			var recognizedValue:*;
			for each (var singleSubAttribute:String in allSubAttributes) {
				if (!singleSubAttribute.match(/^[\w]+:[^:]+$/)){
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Invalid sub-attribute format: " + singleSubAttribute));
					continue;
				}
				singleSubAttrArray = singleSubAttribute.match(/[^:]+/g);
				recognizedValue = recognizeContent(singleSubAttrArray[1]);
				if (!debugMode) {
					object[singleSubAttrArray[0]] = recognizedValue;
				}else {
					if (object.hasOwnProperty(singleSubAttrArray[0])) {
						if (object[singleSubAttrArray[0]] is Boolean) {
							if (recognizedValue is Boolean) {
								object[singleSubAttrArray[0]] = recognizedValue;
							}else {
								dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
									"Invalid attribute value (Boolean expected): " + singleSubAttribute));
							}
						}else if (object[singleSubAttrArray[0]] is Number) {
							if(recognizedValue is Number){
								object[singleSubAttrArray[0]] = recognizedValue;
							}else {
								dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
									"Invalid attribute value (Number expected): " + singleSubAttribute));
							}
						}else if (object[singleSubAttrArray[0]] is Function) {
							if(recognizedValue is Function){
								object[singleSubAttrArray[0]] = recognizedValue;
							}else {
								dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
									"Invalid attribute value (Function expected): " + singleSubAttribute));
							}
						}else if (object[singleSubAttrArray[0]] == null || object[singleSubAttrArray[0]] is String) {
							if(recognizedValue is String){
								object[singleSubAttrArray[0]] = recognizedValue; 
							}else {
								dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
									"Invalid attribute value (String expected): " + singleSubAttribute));
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
		
		protected function recognizeContent(content:String):*{
			if (content == null){ // TODO: this brings chaos
				return null;
			}else if (content.match(/^\[.*\]$/)) { // [String]
				return content.substring(1, content.length - 1); 
			}else if (content == "true" || content == "false") { // Boolean
				return ((content == "true")? true : false);
			}else if (content.match(/^(-)?[\d]+(.[\d]+)?$/)) { // Number
				return (Number(content));
			}else if (content.match(/^#[0-9a-f]{6}$/i)) { // Number - color
				content = content.substring(1, content.length);
				return (Number("0x" + content));
			}else if (content == "NaN"){ // Number - NaN
				return NaN;
			}else if (content.match(/^.+:.+$/)) { // Object // TODO: support for string:[con,tent]
				var object:Object = new Object();
				applySubAttributes(object, content); 
				return object;
			}else if (content.match(/^(Linear|Expo|Back|Bounce|Cubic|Elastic)\.[a-zA-Z]+$/)) { // Function
				return (recognizeFunction(content) as Function);
			}else if (content.replace(/\s/g, "").length > 0) { // TODO: trim
				return content; // String
			}else {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, "Empty content."));
				return null;
			}
		}
		
		protected function recognizeFunction(content:String):Function {
			var functionElements:Array = content.split(".");
			if (functionElements.length != 2) {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
					"Invalid function format: " + content));
				return null;
			}
			var functionClass:Object;
			try{
				functionClass = getDefinitionByName("com.robertpenner.easing." + functionElements[0]);
				try {
					return functionClass[functionElements[1]] as Function;
				}catch (nameError:Error) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Invalid function name: " + functionElements[1]));
				return null;
				}
			}catch (ownerError:Error) {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
					"Invalid function owner: " + functionElements[0]));
				return null;
			}
			dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
				"Unknown function parsing error: " + content));
			return null;
		}
		
		override public function dispatchEvent(event:Event):Boolean {
			if (debugMode) return super.dispatchEvent(event);
			return false;
		}
	}
}