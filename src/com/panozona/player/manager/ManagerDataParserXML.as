package com.panozona.player.manager {
	
	import com.panosalado.model.Params;
	import com.panozona.player.manager.data.*;
	
	import com.panozona.player.utils.Trace;
	
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Translates XML to ManagerData
	 * @author mstandio
	 */
	public class ManagerDataParserXML {
		
		public var messages:Array;
		
		public function ManagerDataParserXML() {
			messages = new Array();
		}				
				
		public function configureManagerData(settings:XML, managerData:ManagerData):void {			
								
			var global:XML    = getChildNodeByName(settings, "global");
			var panoramas:XML = getChildNodeByName(settings, "panoramas");
			var actions:XML   = getChildNodeByName(settings, "actions");			
			
			if (actions != null){
				var actionData:ActionData;			
				for each(var action:XML in actions.elements()) {
					actionData =  new ActionData();
					actionData.id = getAttributeValue(action, "id", String, null)
					parseActionContent(actionData, getAttributeValue(action, "content", String, null));
					managerData.actions.push(actionData);
				}			
			}
			
			if(panoramas != null){
				var panoramaData:PanoramaData;
				var childData:ChildData;
								
				for each(var panorama:XML in panoramas.elements()){
					panoramaData       = new PanoramaData(getAttributeValue(panorama, "path", String, null));
					panoramaData.id    = getAttributeValue(panorama, "id", String, null);
					panoramaData.label = getAttributeValue(panorama, "label", String, "label_" + panoramaData.id);													
					
					applySubAttributes(panorama.attribute("camera"), panoramaData.params);
				
					panoramaData.onEnter = getAttributeValue(panorama, "onEnter", String, null);
					panoramaData.onLeave = getAttributeValue(panorama, "onLeave", String, null); 					
					applySubAttributes(panorama.attribute("onLeaveTarget"), panoramaData.onLeaveTarget);				 								
										
					for each(var child:XML in panorama.elements()) {											
						childData    = new ChildData();
						childData.id = getAttributeValue(child, "id", String, null);
						applySubAttributes(child.attribute("position"), childData.positionData);
						panoramaData.children.push(childData);																		
					}										
					managerData.panoramas.push(panoramaData);
				}			
			}
			
			if (global != null) {		
				
				applySubAttributes(global.attribute("arcBallCamera"),       managerData.arcBallCameraData);
				applySubAttributes(global.attribute("autorotationCamera"),  managerData.autorotationCameraData);
				applySubAttributes(global.attribute("keyboardCamera"),      managerData.keyboardCameraData);
				applySubAttributes(global.attribute("inertialMouseCamera"), managerData.inertialMouseCameraData);
				applySubAttributes(global.attribute("simpleTransition"),    managerData.simpleTransitionData);
				applySubAttributes(global.attribute("camera"),              managerData.params);
				
				managerData.firstPanorama = getAttributeValue(global, "firstPanorama", String, null);				
				managerData.useTrace = getAttributeValue(global, "useTrace", Boolean, false); 									
				managerData.populateGlobalDataParams();
			}				
		}		
		
		
		private function applySubAttributes(subAttributes:String, object:Object):void {
			if (object != null && subAttributes != null && subAttributes.length > 0) {
				var subAttributesArray:Array = subAttributes.match(/([^,|\s]+):([^,|\s]+)/g); 
				var subAttrArray:Array;
				var buffer:*;
				for (var i:Number=0; i < subAttributesArray.length ; i++ ){
					subAttrArray = subAttributesArray[i].match(/((\w)*[^:])/g);										
					if (subAttrArray != null && subAttrArray.length == 2 ) {
						if (object.hasOwnProperty(subAttrArray[0])){
							buffer = object[subAttrArray[0]];							
							object[subAttrArray[0]] = subAttrArray[1];
							if (subAttrArray[1] == "true" || subAttrArray[1] == "false") {
								object[subAttrArray[0]] = subAttrArray[1] == "true" ? true : false;
							}							
							if (isNaN(object[subAttrArray[0]] as Number)) {
								messages.push("invalid subAttribute value: " + subAttrArray[1]);
								object[subAttrArray[0]] = buffer;
							}							
							if (object[subAttrArray[0]] == null) {
								object[subAttrArray[0]] = buffer;
							}
						}else{
							try{
								object[subAttrArray[0]] = subAttrArray[1];								
							}catch (errObject:Error) {
								messages.push("invalid subAttribute name: " + subAttrArray[0]);
							}							
						}						
					}
				}				
			}
		}							
		
		private function getAttributeValue(node:XML, name:String, ReturnClass:Class, defaultValue:*):*{						
			if (node != null && name != null ){
				if ( node.attribute(name).toString().length > 0){ 
					if ( ReturnClass != Boolean ){ 
						return ReturnClass(node.attribute(name));
					}else{ 
						return ReturnClass(node.attribute(name) == "true" ? true : false );
					}
				}
			} 			
			return ReturnClass(defaultValue);			
		}		
		
		private function getChildNodeByName(parent:XML, name:String):XML {						
			for each (var child:XML in parent.children()){
				if (child.name() == name){
					return child;
				}
			}
			return null;			
		}
		
		private function getClass(obj:Object):Class {
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}		
		
		private function parseActionContent(actionData:ActionData, content:String):void {
			if (actionData != null && content != null && content.length > 0){
				var functionData:FunctionData;	
				// function
				// ([^;|\s]+     does not contain ";" nor space
				// \([\w\s,]*\)  ends with "(.*)"
				var functionsArray:Array = content.match(/([^;|\s]+\([\w\s,]*\))/g);  
				var funArray:Array;
				var funParams:Array;
				for (var i:Number = 0; i < functionsArray.length ; i++) {
					//target.function(attributes)
					//(^[^\.|^\s]+)          target
					//[^\.]+(?=(\([\w|\)]))  function
					//[^\(]+(?=(\)$))        attributes
					funArray = functionsArray[i].match(/(^[^\.]+)|[^\.]+(?=(\(\w))|[^\(]+(?=(\)$))/g);				
					if (funArray.length >= 2) {
						functionData = new FunctionData(funArray[0],funArray[1]);						
						if (funArray.length == 3) {
							funParams = funArray[2].toString().match(/[^,\s]+/g);	
							for (var j:Number = 0; j < funParams.length; j++) {
								functionData.params.push(funParams[j]);
							}							
						}						
						actionData.functions.push(functionData);
					}					
				}									
			}			
		}		
	}
}