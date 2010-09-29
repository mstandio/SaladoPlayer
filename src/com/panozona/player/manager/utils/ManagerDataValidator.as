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
package com.panozona.player.manager.utils{

	import com.panozona.player.manager.data.*;
	
	/**
	 * This class aggregates functions that validate ManagerData content
	 * against naming integrity and called functions arguments
	 * 
	 * @author mstandio
	 */
	public class ManagerDataValidator {
		
		private var managerData:ManagerData;
		private var abstractModuleDescriptions:Vector.<AbstractModuleDescription>;
		
		public function ManagerDataValidator(managerData:ManagerData, abstractModuleDescriptions:Vector.<AbstractModuleDescription>):void {
			this.managerData = managerData;			
			this.abstractModuleDescriptions = abstractModuleDescriptions;
		}		
		
		public function validate():void{
			checkPanoramas();			
			checkModules();
			checkActions();
		}		
		
		private function checkPanoramas():void {
			if (managerData.panoramasData.length  < 1) {
				throw new Error("No panoramas found");
			}
			
			var panoIds:Array = new Array();
			var childIds:Array;			
			for each(var panoramaData:PanoramaData in managerData.panoramasData) {
				if (panoIds[panoramaData.id] != undefined) {
					Trace.instance.printWarning("Repeating panorama id: "+panoramaData.id);
				}else {					
					panoIds[panoramaData.id] = "";// something
																	
					actionExists(panoramaData.onEnter);
					actionExists(panoramaData.onLeave);
					actionExists(panoramaData.onTransitionEnd);
										
					checkActionTrigger(panoramaData.onEnterFrom);
					checkActionTrigger(panoramaData.onLeaveTo);
					checkActionTrigger(panoramaData.onLeaveToAttempt);
					checkActionTrigger(panoramaData.onTransitionEndFrom);
					
					childIds = new Array();
					for each(var childData:ChildData in panoramaData.childrenData) {
						if (childIds[childData.id] != undefined) {
							Trace.instance.printWarning("Repeating child id: "+childData.id+" in "+panoramaData.id);
						}else {	
							childIds[childData.id] = "";
							checkChild(childData);
						}						
					}						
				}							
			}			
		}		
		
		private function checkActionTrigger(actionTrigger:Object):void {
			for (var panoramaId:String in actionTrigger) {
				panoramaExists(panoramaId);
				actionExists2(actionTrigger[panoramaId]);
			}			
		}		
		
		private function checkChild(childData:ChildData):void {
			if (childData.childMouse.onClick != null) {
				if (!actionExists(childData.childMouse.onClick)) {
					Trace.instance.printWarning("Invalid action id: "+childData.childMouse.onClick+" in child: " +childData.id);
				}
			}		
			
			if (childData.childMouse.onMove != null) {
				if (!actionExists(childData.childMouse.onMove)) {
					Trace.instance.printWarning("Invalid action id: "+childData.childMouse.onClick+" in child: " +childData.id);
				}
			}		
			
			if (childData.childMouse.onOut != null) {
				if (!actionExists(childData.childMouse.onOut)) {
					Trace.instance.printWarning("Invalid action id: "+childData.childMouse.onClick+" in child: " +childData.id);
				}
			}		
			
			if (childData.childMouse.onOver != null) {
				if (!actionExists(childData.childMouse.onOver)) {
					Trace.instance.printWarning("Invalid action id: "+childData.childMouse.onClick+" in child: " +childData.id);
				}
			}		
			
			if (childData.childMouse.onPress != null) {
				if (!actionExists(childData.childMouse.onPress)) {
					Trace.instance.printWarning("Invalid action id: "+childData.childMouse.onClick+" in child: " +childData.id);
				}
			}		
			
			if (childData.childMouse.onRelease != null) {
				if (!actionExists(childData.childMouse.onRelease)) {
					Trace.instance.printWarning("Invalid action id: "+childData.childMouse.onClick+" in child: " +childData.id);
				}
			}	
		}
		
		private function checkModules():void {
			var moduleNames:Array = new Array();
			for each(var abstractModuleData:AbstractModuleData in managerData.abstractModulesData) {
				if (moduleNames[abstractModuleData.moduleName] != undefined) {
					Trace.instance.printWarning("Repeating module name: "+abstractModuleData.moduleName);
				}else{
					moduleNames[abstractModuleData.moduleName] = ""; // something					
				}
			}			
			for each(var abstractModuleDescription:AbstractModuleDescription in abstractModuleDescriptions) {
				if (managerData.getAbstractModuleDataByName(abstractModuleDescription.moduleName) == null) {
					if(abstractModuleDescription.moduleName != "SaladoPlayer"){
						Trace.instance.printWarning("Module naming mismatch for: " + abstractModuleDescription.moduleName);
					}
				}
			}		
		}
		
		private function checkActions():void {
			var actIds:Array = new Array();
			for each(var actionData:ActionData in managerData.actionsData) {
				if (actIds[actionData.id] != undefined) {
					Trace.instance.printWarning("Repeating action id: "+actionData.id);
				}else {
					actIds[actionData.id] = "";
					for each(var functionData:FunctionData in actionData.functions) {
						checkFunction(functionData);
					}
				}
			}
		}
		
		private function actionExists(id:String):Boolean{
			for each(var actionData:ActionData in managerData.actionsData) {
				if (actionData.id == id) {
					return true;
				}
			}
			return false;
		}
		
		private function checkFunction(functionData:FunctionData):void {
			var newArgs:Array;
			for each(var abstractModuleDescription:AbstractModuleDescription in abstractModuleDescriptions) {
				if (functionData.owner == abstractModuleDescription.moduleName){										
					verifyFunction(abstractModuleDescription, functionData.name, functionData.args);
					return;
				}
			}			
			Trace.instance.printWarning("No function owner for: "+functionData.owner+"."+functionData.name);
		}
		
		public function verifyFunction(abstractModuleDescription:AbstractModuleDescription, functionName:String, args:Array):void {
			if (functionName == null || functionName==""){
				Trace.instance.printError("Empty function name in: "+abstractModuleDescription.moduleName);
			}else {								
				if (abstractModuleDescription.functionsDescription[functionName] == undefined) {
					Trace.instance.printError("Calling nonexistant function: "+abstractModuleDescription.moduleName+"."+functionName);
				}else {
					var describedArgs:Array = abstractModuleDescription.functionsDescription[functionName];
					if (describedArgs.length != args.length) {
						Trace.instance.printError("Not matching number of arguments for: "+abstractModuleDescription.moduleName+"."+functionName+" got: "+args.length+ " expected: "+describedArgs.length);
					}					
					if(describedArgs.length > 0){					
						for (var i:int = 0; i < args.length; i++) {							
							if (!(args[i] is describedArgs[i])) {
								if(!(describedArgs[i] === Boolean && (args[i]=="true" || args[i]=="false"))){
									Trace.instance.printError("Not matching argument type in: " + abstractModuleDescription.moduleName + "." + functionName +" got: " + args[i] +" expected: " +
									(describedArgs[i] === Boolean?"Boolean":(describedArgs[i] === Number?"Number":(describedArgs[i] === String?"String":(describedArgs[i] === Array?"Array":"Error!")))));
								}
							}
						}
					}
				}
			}
		}
		
		private function actionExists2(actionId:String):void{
			if (actionId != null) {
				for each(var actionData:ActionData in managerData.actionsData) {
					if (actionData.id == actionId) {
						return;
					}
				}			
				Trace.instance.printWarning("Action id does not exist: " + actionId);				
			}			
		}
		
		private function panoramaExists(panoramaId:String):void {
			if (panoramaId != null) {
				for each(var panoramaData:PanoramaData in managerData.panoramasData) {
					if (panoramaData.id == panoramaId) {
						return;					
					}
				}			
				Trace.instance.printWarning("Panorama id does not exist: "+panoramaId);
			}			
		}
		
	}
}