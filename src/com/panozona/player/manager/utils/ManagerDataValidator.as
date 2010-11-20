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

	import com.panozona.player.manager.data.ManagerData;
	import com.panozona.player.manager.utils.ManagerDescription;
	import com.panozona.player.manager.data.panorama.PanoramaData;
	import com.panozona.player.manager.data.action.*;
	import com.panozona.player.manager.data.module.*;
	import com.panozona.player.manager.data.hotspot.HotspotData;
	
	/**
	 * This class aggregates functions that validate ManagerData content
	 * against naming integrity and called functions arguments
	 * 
	 * @author mstandio
	 */
	public class ManagerDataValidator {
		
		private var managerData:ManagerData;
		private var abstractModuleDescriptions:Vector.<AbstractModuleDescription>;
		
		public function validate(managerData:ManagerData, abstractModuleDescriptions:Vector.<AbstractModuleDescription>):void {
			
			this.managerData = managerData;
			this.abstractModuleDescriptions = abstractModuleDescriptions;
			
			checkPanoramas();
			checkModules();
			checkActions();
		}
		
		private function checkPanoramas():void {
			if (managerData.panoramasData.length  < 1) {
				throw new Error("No panoramas found.");
			}
			
			var panosIds:Object = new Object();
			var hotspotsIds:Object;
			for each(var panoramaData:PanoramaData in managerData.panoramasData) {
				if (panosIds[panoramaData.id] != undefined) {
					Trace.instance.printWarning("Repeating panorama id: "+panoramaData.id);
				}else {
					panosIds[panoramaData.id] = "";// something
					
					actionExists(panoramaData.onEnter);
					actionExists(panoramaData.onLeave);
					actionExists(panoramaData.onTransitionEnd);
					
					checkActionTrigger(panoramaData.onEnterFrom);
					checkActionTrigger(panoramaData.onTransitionEndFrom);
					checkActionTrigger(panoramaData.onLeaveTo);
					checkActionTrigger(panoramaData.onLeaveToAttempt);
					
					hotspotsIds = new Object();
					for each(var hotspotData:HotspotData in panoramaData.hotspotsData) {
						if (hotspotsIds[hotspotData.id] != undefined) {
							Trace.instance.printWarning("Repeating child id: "+hotspotData.id+" in "+panoramaData.id);
						}else {
							hotspotsIds[hotspotData.id] = ""; //something
							checkHotspot(hotspotData);
						}
					}
				}
			}
		}
		
		private function checkActionTrigger(actionTrigger:Object):void {
			for (var panoramaId:String in actionTrigger) {
				panoramaExists(panoramaId);
				actionExists(actionTrigger[panoramaId]);
			}
		}
		
		private function checkHotspot(hotspotData:HotspotData):void {
			if (hotspotData.mouse.onClick != null) {
				if (!actionExists(hotspotData.mouse.onClick)) {
					Trace.instance.printWarning("Invalid action id: "+hotspotData.mouse.onClick+" in hotspot: " +hotspotData.id);
				}
			}
			if (hotspotData.mouse.onOut != null) {
				if (!actionExists(hotspotData.mouse.onOut)) {
					Trace.instance.printWarning("Invalid action id: "+hotspotData.mouse.onOut+" in hotspot: " +hotspotData.id);
				}
			}
			if (hotspotData.mouse.onOver != null) {
				if (!actionExists(hotspotData.mouse.onOver)) {
					Trace.instance.printWarning("Invalid action id: "+hotspotData.mouse.onOver+" in hotspot: " +hotspotData.id);
				}
			}
			if (hotspotData.mouse.onPress != null) {
				if (!actionExists(hotspotData.mouse.onPress)) {
					Trace.instance.printWarning("Invalid action id: "+hotspotData.mouse.onPress+" in hotspot: " +hotspotData.id);
				}
			}
			if (hotspotData.mouse.onRelease != null) {
				if (!actionExists(hotspotData.mouse.onRelease)) {
					Trace.instance.printWarning("Invalid action id: "+hotspotData.mouse.onRelease+" in hotspot: " +hotspotData.id);
				}
			}
		}
		
		private function checkModules():void {
			var moduleNames:Object = new Object();
			for each(var abstractModuleData:AbstractModuleData in managerData.abstractModulesData) {
				if (moduleNames[abstractModuleData.moduleName] != undefined) {
					Trace.instance.printWarning("Repeating module name: "+abstractModuleData.moduleName);
				}else{
					moduleNames[abstractModuleData.moduleName] = ""; // something
				}
			}
			for each(var abstractModuleDescription:AbstractModuleDescription in abstractModuleDescriptions) {
				if (managerData.getAbstractModuleDataByName(abstractModuleDescription.moduleName) == null) {
					if(abstractModuleDescription.moduleName != ManagerDescription.name){
						Trace.instance.printWarning("Module naming mismatch for: " + abstractModuleDescription.moduleName);
					}
				}
			}
		}
		
		private function checkActions():void {
			var actIds:Object = new Object();
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
			for each(var abstractModuleDescription:AbstractModuleDescription in abstractModuleDescriptions) {
				if (functionData.owner == abstractModuleDescription.moduleName){
					verifyFunction(abstractModuleDescription, functionData.name, functionData.args);
					return;
				}
			}
			Trace.instance.printWarning("No function owner for: "+functionData.owner+"."+functionData.name);
		}
		
		public function verifyFunction(abstractModuleDescription:AbstractModuleDescription, functionName:String, args:Array):void {
			if (functionName == null ){
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
									(describedArgs[i] === Boolean?"Boolean":(describedArgs[i] === Number?"Number":(describedArgs[i] === String?"String":(describedArgs[i] === Function?"Function":"Error!")))));
								}
							}
						}
					}
				}
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