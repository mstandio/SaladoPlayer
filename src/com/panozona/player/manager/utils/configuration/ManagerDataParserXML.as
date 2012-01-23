/*
Copyright 2012 Marek Standio.

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
	
	import com.panozona.player.manager.data.actions.ActionData;
	import com.panozona.player.manager.data.actions.FunctionData;
	import com.panozona.player.manager.data.global.AllPanoramasData;
	import com.panozona.player.manager.data.global.BrandingData;
	import com.panozona.player.manager.data.global.ControlData;
	import com.panozona.player.manager.data.global.StatsData;
	import com.panozona.player.manager.data.global.TraceData;
	import com.panozona.player.manager.data.ManagerData;
	import com.panozona.player.manager.data.panoramas.HotspotData;
	import com.panozona.player.manager.data.panoramas.HotspotDataImage;
	import com.panozona.player.manager.data.panoramas.HotspotDataSwf;
	import com.panozona.player.manager.data.panoramas.PanoramaData;
	import com.panozona.player.manager.events.ConfigurationEvent;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.robertpenner.easing.Back;
	import com.robertpenner.easing.Bounce;
	import com.robertpenner.easing.Cubic;
	import com.robertpenner.easing.Elastic;
	import com.robertpenner.easing.Expo;
	import com.robertpenner.easing.Linear;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
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
					parseModules(managerData.modulesData, mainNode);
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
				}else if (globalPanoAttributeName == "firstOnEnter") {
					allPanoramasData.firstOnEnter = getAttributeValue(globalPanoAttribute, String);
				}else if (globalPanoAttributeName == "firstOnTransitionEnd") {
					allPanoramasData.firstOnTransitionEnd = getAttributeValue(globalPanoAttribute, String);
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
				if (controlAttributeName == "mouseWheelTrap") {
					controlData.mouseWheelTrap = getAttributeValue(controlAttribute, Boolean);
				}else if (controlAttributeName == "autorotation") {
					applySubAttributes(controlData.autorotationCameraData, controlAttribute);
				} else if (controlAttributeName == "transition") {
					applySubAttributes(controlData.simpleTransitionData, controlAttribute);
				} else if (controlAttributeName == "keyboard") {
					applySubAttributes(controlData.keyboardCameraData, controlAttribute);
				} else if (controlAttributeName == "mouseInertial") {
					applySubAttributes(controlData.inertialMouseCameraData, controlAttribute);
				} else if (controlAttributeName == "mouseDrag") {
					applySubAttributes(controlData.arcBallCameraData, controlAttribute);
				} else if (controlAttributeName == "mouseScroll") {
					applySubAttributes(controlData.scrollCameraData, controlAttribute);
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
					traceData.open = getAttributeValue(traceAttribute, Boolean);
				}else if (traceAttributeName == "size") {
					applySubAttributes(traceData.size, traceAttribute);
				}else if (traceAttributeName == "align"){
					try{
						applySubAttributes(traceData.align, traceAttribute);
					}catch (error:Error) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Invalid align value: " + error.message));
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
					brandingData.visible = getAttributeValue(brandingAttribute, Boolean);
				}else if (brandingAttributeName == "align") {
					try{
						applySubAttributes(brandingData.align, brandingAttribute);
					}catch (error:Error) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Invalid align value: " + error.message));
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
							"Invalid align value: " + error.message));
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
				panoramaId = getAttributeValue(panoramaNode.@id, String);
				panoramaData = new PanoramaData(panoramaId , panoramaNode.@path);
				panoramasData.push(panoramaData);
				for each(var panoramaAttribute:XML in panoramaNode.attributes()) {
					panoramaAttributeName = panoramaAttribute.localName();
					if (panoramaAttributeName == "camera") {
						applySubAttributes(panoramaData.params, panoramaAttribute);
					}else if (panoramaAttributeName == "direction") {
						panoramaData.direction = getAttributeValue(panoramaAttribute, Number);
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
				hotspotId = getAttributeValue(hotspotNode.@id, String);
				if (hotspotNode.localName() == "image" || hotspotNode.localName() == "swf") {
					if (hotspotNode.localName() == "image") {
						hotspotData = new HotspotDataImage(hotspotId, hotspotNode.@path);
						panoramaData.hotspotsData.push(hotspotData as HotspotDataImage);
					}else {
						hotspotData = new HotspotDataSwf(hotspotId, hotspotNode.@path);
						var dataNode:DataNode;
						for each(var hotspotChildNode:XML in hotspotNode.elements()) {
							dataNode = new DataNode(hotspotChildNode.localName());
							parseDataNodeRecursive(dataNode, hotspotChildNode);
							(hotspotData as HotspotDataSwf).nodes.push(dataNode);
						}
						panoramaData.hotspotsData.push(hotspotData as HotspotDataSwf);
					}
				}else {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Unrecognized hotspot: " + hotspotNode.localName()));
					continue;
				}
				for each (var hotspotAttribute:XML in hotspotNode.attributes()) {
					hotspotAttributeName = hotspotAttribute.localName();
					if (hotspotAttributeName == "location"){
						applySubAttributes(hotspotData.location, hotspotAttribute);
					}else if (hotspotAttributeName == "target"){
						hotspotData.target = getAttributeValue(hotspotAttribute, String);
					}else if (hotspotAttributeName == "mouse") {
						applySubAttributes(hotspotData.mouse, hotspotAttribute);
					}else if (hotspotAttributeName == "transform") {
						applySubAttributes(hotspotData.transform, hotspotAttribute);
					}else if (hotspotAttributeName == "handCursor") {
						hotspotData.handCursor = getAttributeValue(hotspotAttribute, Boolean);
					}else if (hotspotAttributeName != "id" && hotspotAttributeName != "path"){
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Unrecognized hotspot attribute: " + hotspotAttribute.localName()));
					}
				}
			}
		}
		
		protected function parseModules(modulesData:Vector.<ModuleData>, modulesNode:XML):void {
			var moduleData:ModuleData;
			var dataNode:DataNode;
			for each(var moduleNode:XML in modulesNode.elements()) {
				if(moduleNode.@path == undefined ) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
						"Missing path for: " + moduleNode.localName()));
					continue;
				}
				if (modulesNode.localName() == "modules") {
					moduleData = new ModuleData(moduleNode.localName(), moduleNode.@path);
					modulesData.push(moduleData);
				}else {
					continue;
				}
				for each(var moduleChildNode:XML in moduleNode.elements()) {
					dataNode = new DataNode(moduleChildNode.localName());
					parseDataNodeRecursive(dataNode, moduleChildNode);
					moduleData.nodes.push(dataNode);
				}
			}
		}
		
		protected function parseDataNodeRecursive(dataNode:DataNode, moduleNode:XML):void {
			var recognizedValue:*;
			for each(var attribute:XML in moduleNode.attributes()) {
				recognizedValue = recognizeContent(attribute);
				dataNode.attributes[attribute.name().toString()] = recognizedValue;
			}
			var childDataNode:DataNode;
			for each(var moduleChildNode:XML in moduleNode.children()){
				if (moduleChildNode.nodeKind() == "text"){
					if (dataNode.attributes["text"] == undefined) {
						dataNode.attributes["text"] = moduleChildNode.toString();
					}else {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Text value allready exists in: " + dataNode.name));
					}
				}else {
					childDataNode = new DataNode(moduleChildNode.localName());
					parseDataNodeRecursive(childDataNode, moduleChildNode);
					dataNode.childNodes.push(childDataNode);
				}
			}
		}
		
		protected function parseActions(actionsData:Vector.<ActionData>, actionsNode:XML):void {
			var actionData:ActionData;
			var actionId:*;
			for each(var actionNode:XML in actionsNode.elements()) {
				actionId = getAttributeValue(actionNode.@id, String);
				actionData = new ActionData(actionId);
				actionsData.push(actionData);
				if (actionId == null) continue; // otherwise will be constantly executed
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
				}else {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Wrong format of action content: " + singleFunction));
				}
			}
		}
		
		protected function getAttributeValue(attribute:String, ReturnClass:Class):*{
			var recognizedValue:* = recognizeContent(attribute);
			if (recognizedValue is ReturnClass) {
				return recognizedValue;
			}else if (recognizedValue != null){
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
					"Ivalid attribute type (" + getQualifiedClassName(ReturnClass) + " expected): " + attribute));
			}
			return null;
		}
		
		protected function applySubAttributes(object:Object, subAttributes:String):void {
			var allSubAttributes:Array = subAttributes.split(",");
			var singleSubAttrArray:Array;
			var recognizedValue:*;
			for each (var singleSubAttribute:String in allSubAttributes) {
				if (!singleSubAttribute.match(/^[\w]+:[^:]+$/)){
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Invalid subattribute format: " + singleSubAttribute));
					continue;
				}
				singleSubAttrArray = singleSubAttribute.match(/[^:]+/g);
				recognizedValue = recognizeContent(singleSubAttrArray[1]);
				
				if (!debugMode) {
					object[singleSubAttrArray[0]] = recognizedValue;
					continue;
				}
				
				if (object.hasOwnProperty(singleSubAttrArray[0])) {
					if (object[singleSubAttrArray[0]] is Boolean) {
						if (recognizedValue is Boolean) {
							object[singleSubAttrArray[0]] = recognizedValue;
						}else {
							dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
								"Invalid subattribute type (Boolean expected): " + singleSubAttribute));
						}
					}else if (object[singleSubAttrArray[0]] is Number) {
						if(recognizedValue is Number){
							object[singleSubAttrArray[0]] = recognizedValue;
						}else {
							dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
								"Invalid subattribute type (Number expected): " + singleSubAttribute));
						}
					}else if (object[singleSubAttrArray[0]] is Function) {
						if(recognizedValue is Function){
							object[singleSubAttrArray[0]] = recognizedValue;
						}else {
							dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
								"Invalid subattribute type (Function expected): " + singleSubAttribute));
						}
					}else if (object[singleSubAttrArray[0]] == null || object[singleSubAttrArray[0]] is String) {
						if(recognizedValue is String){
							object[singleSubAttrArray[0]] = recognizedValue; 
						}else {
							dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
								"Invalid subattribute type (String expected): " + singleSubAttribute));
						}
					}
				}else {
					// check if creation of new atribute in object is possible
					// used in onEnterSource, onLeaveTarget, ect.
					try{
						object[singleSubAttrArray[0]] = recognizedValue;
					}catch (e:Error) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Invalid attribute name (cannot apply): " + singleSubAttrArray[0]));
					}
				}
			}
		}
		
		Linear; Expo; Back; Bounce; Cubic; Elastic;
		protected function recognizeContent(content:String):*{
			if (content == null){
				return null;
			}else if (content.match(/^(\[.*\])$/)) { // [String]
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
			}else if (content.match(/^(?!http).+:.+$/)) { // Object
				var object:Object = new Object();
				applySubAttributes(object, content); 
				return object;
			}else if (content.match(/^(Linear|Expo|Back|Bounce|Cubic|Elastic)\.[a-zA-Z]+$/)) { // Function
				return (recognizeFunction(content) as Function);
			}else if (content.replace(/\s/g, "").length > 0) { // TODO: trim
				return content; // String
			}else {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, "Missing value."));
				return null;
			}
		}
		
		protected function recognizeFunction(content:String):Function {
			var result:Function;
			var functionElements:Array = content.split(".");
			var functionClass:Object = getDefinitionByName("com.robertpenner.easing." + functionElements[0]);
			result = functionClass[functionElements[1]] as Function
			if (result == null){
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
					"Invalid function name in: " + functionElements[0]+"."+functionElements[1]));
			}
			return result;
		}
		
		override public function dispatchEvent(event:Event):Boolean {
			if (debugMode) return super.dispatchEvent(event);
			return false;
		}
	}
}