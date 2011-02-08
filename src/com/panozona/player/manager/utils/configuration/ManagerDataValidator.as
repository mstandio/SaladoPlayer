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
package com.panozona.player.manager.utils.configuration{
	
	import com.panozona.player.component.*;
	import com.panozona.player.manager.data.*;
	import com.panozona.player.manager.data.actions.*;
	import com.panozona.player.manager.data.panoramas.*;
	import flash.events.*;
	import flash.utils.*;
	
	public class ManagerDataValidator extends EventDispatcher{
		
		public function validate(managerData:ManagerData):void {
			checkPanoramas(managerData.panoramasData, managerData.actionsData);
			checkComponents(managerData.modulesData);
			checkActions(managerData);
		}
		
		private function checkPanoramas(panoramasData:Vector.<PanoramaData>, actionsData:Vector.<ActionData>):void {
			if (panoramasData.length < 1) {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR, "No panoramas found."));
				return;
			}
			var panosId:Object = new Object();
			var hotspotsId:Object = new Object();
			for each(var panoramaData:PanoramaData in panoramasData) {
				if (panosId[panoramaData.id] != undefined) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, "Repeating panorama id: " + panoramaData.id));
				}else {
					if (panoramaData.id == null) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR, "Missig panorama id."));
						return;
					}
					if (panoramaData.params.path == null) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR, "Missig panorama path."));
						return;
					}
					panosId[panoramaData.id] = null; // not undefined
					actionExists(panoramaData.onEnter, actionsData);
					actionExists(panoramaData.onLeave, actionsData);
					actionExists(panoramaData.onTransitionEnd, actionsData);
					checkActionTrigger(panoramaData.onEnterFrom, panoramasData, actionsData);
					checkActionTrigger(panoramaData.onTransitionEndFrom, panoramasData, actionsData);
					checkActionTrigger(panoramaData.onLeaveTo, panoramasData, actionsData);
					checkActionTrigger(panoramaData.onLeaveToAttempt, panoramasData, actionsData);
					for each(var hotspotData:HotspotData in panoramaData.hotspotsData) {
						if (hotspotsId[hotspotData.id] != undefined) {
							dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, "Repeating hotspot id: " + hotspotData.id));
						}else {
							hotspotsId[hotspotData.id] = null; // not undefined
							checkHotspot(hotspotData, actionsData);
						}
					}
				}
			}
		}
		
		private function actionExists(actionId:String, actionsData:Vector.<ActionData>):Boolean{
			for each(var actionData:ActionData in actionsData) {
				if (actionData.id == actionId) {
					return true;
				}
			}
			dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, "Action not found: " + actionId));
			return false;
		}
		
		private function checkActionTrigger(actionTrigger:Object, panoramasData:Vector.<PanoramaData>, actionsData:Vector.<ActionData>):void {
			for (var panoramaId:String in actionTrigger) {
				panoramaExists(panoramaId, panoramasData);
				actionExists(actionTrigger[panoramaId], actionsData);
			}
		}
		
		private function panoramaExists(panoramaId:String, panoramasData:Vector.<PanoramaData>):Boolean {
			for each(var panoramaData:PanoramaData in panoramasData) {
				if (panoramaData.id == panoramaId) {
					return true;
				}
			}
			dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, "Panorama not found: " + panoramaId));
			return false;
		}
		
		private function checkHotspot(hotspotData:HotspotData, actionsData:Vector.<ActionData>):void {
			if (hotspotData.id == null) {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR, "Missig hotspot id."));
				return;
			}
			actionExists(hotspotData.mouse.onClick, actionsData);
			actionExists(hotspotData.mouse.onOut, actionsData);
			actionExists(hotspotData.mouse.onOver, actionsData);
			actionExists(hotspotData.mouse.onPress, actionsData);
			actionExists(hotspotData.mouse.onRelease, actionsData);
		}
		
		private function checkComponents(componentsData:Vector.<ComponentData>):void {
			var componentsName:Object = new Object();
			for each(var componentData:ComponentData in componentsData) {
				if (componentData.name == null) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR, "Missig component id."));
					return;
				}
				if (componentData.path == null) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR, "Missig path in: " + componentData.name));
					return;
				}
				if (componentsName[componentData.name] != undefined) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, "Repeating name: " + componentData.name));
				}else{
					componentsName[componentData.name] = null; // not undefined
				}
			}
		}
		
		private function checkActions(managerData:ManagerData):void {
			var acttionsId:Object = new Object();
			for each(var actionData:ActionData in managerData.actionsData) {
				if (actionData.id == null) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR, "Missig action id."));
					return;
				}
				if (actionData.functions.length == 0) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR, "Missing functions in: " + actionData.id));
					return;
				}
				if (acttionsId[actionData.id] != undefined) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, "Repeating action id: " + actionData.id));
				}else {
					acttionsId[actionData.id] = null; // not undefined
					for each(var functionData:FunctionData in actionData.functions) {
						checkFunction(functionData, managerData);
					}
				}
			}
		}
		
		private function checkFunction(functionData:FunctionData, managerData:ManagerData):void {
			if (managerData.getModuleDataByName(functionData.name) == null) {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, "Owner not found: " + functionData.owner + "." + functionData.name));
			}else {
				if (managerData.getModuleDataByName(functionData.name).descriptionReference != null) {
					verifyFunction(functionData, managerData.getModuleDataByName(functionData.name).descriptionReference);
				}
			}
		}
		
		private function verifyFunction(functionData:FunctionData, componentDescription:ComponentDescription):void {
			if (componentDescription.functionsDescription[functionData.name] == undefined) {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, "Function not found: " + functionData.owner + "." + functionData.name));
				return;
			}
			if (componentDescription.functionsDescription.length != functionData.args.length) {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, "Wrong number of arguments in: " +
					componentDescription.name + "." + functionData.name +
					" got: " + functionData.args.length +
					" expected: "+componentDescription.functionsDescription.length));
				return;
			}
			if(componentDescription.functionsDescription[functionData.name].args > 0){ // TODO: rzutowanie 
				for (var i:int = 0; i < functionData.args.length; i++) {
					if (!(functionData.args[i] is componentDescription.functionsDescription[i])) {
						if (!(componentDescription.functionsDescription[i] === Boolean && (functionData.args[i] == "true" || functionData.args[i] == "false"))) {
							dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, "Wrong argument type in: " +
								componentDescription.name + "." + functionData.name +
								" got: " + functionData.args[i] +
								" expected: " + getQualifiedClassName(componentDescription.functionsDescription[i]).match(/[^:]+$/)[0]));
							return;
						}
					}
				}
			}
		}
	}
}