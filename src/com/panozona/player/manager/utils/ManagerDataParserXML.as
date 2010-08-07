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
		
		/**
		 * 
		 * @param	managerData
		 * @param	settings
		 * @return  Vector.<String> 
		 */
		public function configureManagerData(managerData:ManagerData, settings:XML):void{								
			
			if(managerData.traceData.debug){
				checkNodeNamesAgainst(settings.children(),
				"global",
				"panoramas",
				"actions",
				"modules");			
			}
			
			var global:XML    = getChildNodeByName(settings, "global");
			var panoramas:XML = getChildNodeByName(settings, "panoramas");
			var actions:XML   = getChildNodeByName(settings, "actions");
			var modules:XML   = getChildNodeByName(settings, "modules");						
			
			if (global != null) {				
				
				if(managerData.traceData.debug){
					checkAttributesAgainst(global.attributes(),
					"trace",
					"showStatistics",
					"arcBallCamera", 				
					"autorotationCamera",
					"keyboardCamera",
					"inertialMouseCamera",
					"simpleTransition",
					"camera",				
					"firstPanorama");
				}
				
				applySubAttributes(managerData.traceData, global.attribute("trace"));
				applySubAttributes(managerData.arcBallCameraData, global.attribute("arcBallCamera"));
				applySubAttributes(managerData.autorotationCameraData, global.attribute("autorotationCamera"));
				applySubAttributes(managerData.keyboardCameraData, global.attribute("keyboardCamera"));
				applySubAttributes(managerData.inertialMouseCameraData, global.attribute("inertialMouseCamera"));
				applySubAttributes(managerData.simpleTransitionData, global.attribute("simpleTransition"));
				applySubAttributes(managerData.params, global.attribute("camera"));
				managerData.firstPanorama = getAttributeValue(global, "firstPanorama", String, null);
				managerData.showStatistics = getAttributeValue(global, "showStatistics", Boolean, false);
			}						
			
			if(panoramas != null){
				var panoramaData:PanoramaData;
				var childData:ChildData;
				for each(var panorama:XML in panoramas.elements()) {
					
					if(managerData.traceData.debug){
						checkAttributesAgainst(panorama.attributes(), 
						"id", 
						"label",
						"path", 
						"camera",
						"onEnter",
						"onLeave",
						"onTransitionEnd",
						"onEnterSource",
						"onLeaveTarget",						
						"onTransitionEndSource"); 
					}
					
					try {												
						panoramaData = new PanoramaData(
							getAttributeValue(panorama, "id", String, null),
							getAttributeValue(panorama, "label", String, null),
							getAttributeValue(panorama, "path", String, null),
							getAttributeValue(panorama, "onEnter", String, null),
							getAttributeValue(panorama, "onLeave", String, null),
							getAttributeValue(panorama, "onTransitionEnd", String, null));
						applySubAttributes(panoramaData.params, panorama.attribute("camera"));
						applySubAttributes(panoramaData.onEnterSource, panorama.attribute("onEnterSource"));
						applySubAttributes(panoramaData.onLeaveTarget, panorama.attribute("onLeaveTarget"));
						applySubAttributes(panoramaData.onTransitionEndSource, panorama.attribute("onTransitionEndSource"));						
					
						
						for (var i:int = 0; i < panorama.elements().length(); i++) {	
							
							if(managerData.traceData.debug){							
								checkAttributesAgainst(panorama.elements()[i].attributes(), 
								"id", 
								"path",							
								"position", 
								"transformation", 
								"mouse");
							}
							
							try {								
								childData = new ChildData(
									getAttributeValue(panorama.elements()[i], "id", String, null),
									getAttributeValue(panorama.elements()[i], "path", String, null),
									i);									
								applySubAttributes(childData.childPosition, panorama.elements()[i].attribute("position") );
								applySubAttributes(childData.childMouse, panorama.elements()[i].attribute("mouse"));
								panoramaData.childrenData.push(childData);
							}catch(e:Error) {
								Trace.instance.printError(e.message);
							}							
						}					
						managerData.panoramasData.push(panoramaData);
					}catch(e:Error) {
						Trace.instance.printError(e.message);
					}
				}
			}
			
			if (actions != null){
				var actionData:ActionData;
				for each(var action:XML in actions.elements()) {
					
					if(managerData.traceData.debug){
						checkAttributesAgainst(action.attributes(), 
						"id", 
						"content");
					}
															
					try {						
						actionData = new ActionData(getAttributeValue(action, "id", String, null));
						parseActionContent(actionData, getAttributeValue(action, "content", String, null));
						managerData.actionsData.push(actionData);
					}catch(e:Error) {
						Trace.instance.printError(e.message);
					}					
				}
			}			
			
			if (modules != null) {
				var abstractModuleData:AbstractModuleData;
				var abstractModuleNode:AbstractModuleNode;
				// for each module
				for (var j:int = 0; j < modules.elements().length(); j++) {
					checkAttributesAgainst(((XML)(modules.elements()[j])).attributes(), "path");
					try{
						abstractModuleData = new AbstractModuleData(modules.elements()[j].localName().toString(),
							getAttributeValue(modules.elements()[j], "path", String, null),
							j);
						// for ech node inside module node
						for each(var node:XML in ((XML)(modules.elements()[j])).elements()) {
							abstractModuleNode = new AbstractModuleNode(node.localName().toString());
							parseAbstractModuleNodeRecursive(abstractModuleNode, node);
							abstractModuleData.abstractModuleNodes.push(abstractModuleNode);
						}
						managerData.abstractModulesData.push(abstractModuleData);
					}catch (e:Error) {
						Trace.instance.printError(e.message);
					}
				}
			}			
			
			managerData.populateGlobalDataParams();
		}
		
		/**
		 * It is not intended to throw errors 
		 * 
		 * @param	object
		 * @param	subAttributes
		 */
		private function applySubAttributes(object:Object, subAttributes:String):void {
			if (subAttributes == null && subAttributes.length == 0) {
				Trace.instance.printWarning("Empty subAttribute");
			}else{				
				subAttributes.replace(/\s/, ""); // remove all white spaces
				var buffer:*;
				var allSubAttributes:Array = subAttributes.split(",");
				var singleSubAttrArray:Array;
				var recognizedValue:*;
				for each (var singleSubAttribute:String in allSubAttributes) {
					if (singleSubAttribute.length > 0) {
						if (!singleSubAttribute.match(/^[\w]+:[^:]+$/m)){ 
							Trace.instance.printWarning("Invalid attribute format (forbidden chars): "+singleSubAttribute);
						}else{
							singleSubAttrArray = singleSubAttribute.match(/[^:]+/g);
							if ( singleSubAttrArray.length != 2 ) { 
								Trace.instance.printWarning("Invalid attribute format (wrong number of segments): "+singleSubAttribute);
							} else {
								if (object.hasOwnProperty(singleSubAttrArray[0])) {
									recognizedValue = recognizeContent(singleSubAttrArray[1]);
									if (object[singleSubAttrArray[0]] is Number) {
										if(recognizedValue is Number){
											object[singleSubAttrArray[0]] = recognizedValue;
										}else {
											Trace.instance.printWarning("Invalid attribute value (Number expected): "+singleSubAttribute);
										}
									}else if (object[singleSubAttrArray[0]] is Boolean) {
										if (recognizedValue is Boolean) {
											object[singleSubAttrArray[0]] = recognizedValue;
										}else {
											Trace.instance.printWarning("Invalid attribute value (Boolean expected): "+singleSubAttribute);
										}
									}else if (object[singleSubAttrArray[0]] is Array) {
										if (recognizedValue is Array) {
											object[singleSubAttrArray[0]] = recognizedValue;
										}else {
											Trace.instance.printWarning("Invalid attribute value (Array expected): "+singleSubAttribute);
										}											
									}else { 
										try {
											object[singleSubAttrArray[0]] = recognizedValue;
										}catch(e:Error){
											Trace.instance.printWarning("Invalid attribute value (not recognized): " + singleSubAttribute);
										}
									}
								}else {
									// check if creation of new atribute in object is possible
									try{
										object[singleSubAttrArray[0]] = singleSubAttrArray[1];
									}catch (e:Error){
										Trace.instance.printWarning("Invalid attribute name (cannot apply): " + singleSubAttribute);
									}
								}
							}
						}
					}
				}
			}
		}
		
		private function parseActionContent(actionData:ActionData, content:String):void {
			if (actionData == null ) {
				Trace.instance.printWarning("No action data");
			}else if (content == null || content.length == 0) {
				Trace.instance.printWarning("No content for action: "+ actionData.id);
			} else {
				content = content.replace(/\s/, ""); // remove all white spaces
				var singleFunctionArray:Array;
				var allArguments:Array;
				var functionData:FunctionData;
				var allFunctions:Array = content.split(";");
				var recognizedValue:*;
				for each(var singleFunction:String in allFunctions) {
					if (singleFunction.length > 0) {
						if (!(singleFunction).match(/^[\w]+\.[\w]+(\([^\(\)]*\))?$/m)) {  
							Trace.instance.printWarning("Wrong format of function: "+singleFunction);	
						}else{
							//owner.function(arguments)
							//(^[\w]+)                owner
							//([\w]+(?=\()|[\w]+$)    function  
							//([^\(]+(?=\)))          arguments 
							singleFunctionArray = singleFunction.match(/(^[\w]+)|([\w]+(?=\()|[\w]+$)|([^\(]+(?=\)))/g);
							if (singleFunctionArray.length < 2 || singleFunctionArray.length > 3) {
								Trace.instance.printWarning("Wrong format of function: "+singleFunction);
							}else {
								functionData = new FunctionData(singleFunctionArray[0], singleFunctionArray[1]);
								// if function has parameters
								if (singleFunctionArray.length == 3) {
									allArguments = singleFunctionArray[2].match(/\[.*\]|[^,]+/g);
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
		}
		
		private function recognizeContent(content:String):*{
			if (content.match(/^(-)?[\d]+(.[\d]+)?$/m)) { // content is Number 
				return (Number(content));
			}else if (content == "true" || content == "false") { // content is Boolean
				return ((content == "true")? true : false);
			}else if (content.match(/^\[.*\]$/m)) { // content is an Array of Strings
				return content.match(/[^\[\],]+/g);
			}else if(content.length > 0){ // content is String
				return content;
			}else { 
				return null;
			}
		}
		
		private function parseAbstractModuleNodeRecursive(abstractModuleNode:AbstractModuleNode, node:XML):void{
			if (abstractModuleNode == null || node== null) {
				Trace.instance.printWarning("No module node");
			}else {
				for each(var attribute:XML in node.attributes()) {
					abstractModuleNode.attributes[attribute.name().toString()] = recognizeContent(attribute.toString());
				}
				var abstractModuleChildNode:AbstractModuleNode;
				for each(var childNode:XML in node.children()) {
					abstractModuleChildNode = new AbstractModuleNode(childNode.localName().toString());
					parseAbstractModuleNodeRecursive(abstractModuleChildNode, childNode);
					abstractModuleNode.abstractModuleNodes.push(abstractModuleChildNode);
				}
			}
		}
		
		private function getAttributeValue(node:XML, name:String, ReturnClass:Class, defaultValue:*):*{
			if (node != null && name != null && (("@"+name) in node)) {
				if ( ReturnClass === Array) { 
					return String(node.attribute(name)).match(/[^\[\],]+/g);
				}				
				if ( ReturnClass === Boolean ){ 
					return ReturnClass(node.attribute(name) == "true" ? true : false);
				}else{
					return ReturnClass(node.attribute(name));
				}
			} 			
			return defaultValue;
		}
		
		private function getChildNodeByName(parent:XML, name:String):XML {
			for each (var child:XML in parent.children()){
				if (child.name() == name){
					return child;
				}
			}
			return null;
		}	
		
		private function checkAttributesAgainst(attrinbutes:XMLList, ... args):void {
			var isFound:Boolean;
			for each(var attribute:XML in attrinbutes){
				isFound = false;
				for each(var arg:* in  args) {
					if (String(arg) == attribute.localName().toString()) {						
						isFound = true;
						break;
					}
				}
				if (!isFound) {
					Trace.instance.printWarning("Unrecognized attribute: "+attribute.localName().toString());
				}
			}
		}
		
		private function checkNodeNamesAgainst(children:XMLList, ... args):void {			
			var isFound:Boolean;
			for each(var child:XML in children) {
				isFound = false;
				for each(var arg:* in  args) {
					if (String(arg) == child.name()) {						
						isFound = true;
						break;
					}
				}
				if (!isFound) {
					Trace.instance.printWarning("Unrecognized node: "+child.name());
				}
			}			
		}
	}
}