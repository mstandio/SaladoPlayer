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
	import com.panozona.player.manager.events.*;
	import com.panozona.player.manager.data.*;
	import com.panozona.player.manager.data.actions.*;
	import com.panozona.player.manager.data.panoramas.*;
	import flash.events.*;
	import flash.utils.*;
	
	public class ManagerDataValidator extends EventDispatcher{
		
		public function validate(managerData:ManagerData):void {
			checkPanoramas(managerData.panoramasData, managerData.actionsData);
			checkComponents(managerData.modulesData, managerData.factoriesData);
			checkActions(managerData);
		}
		
		private function checkPanoramas(panoramasData:Vector.<PanoramaData>, actionsData:Vector.<ActionData>):void {
			if (panoramasData.length < 1) {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
					"No panoramas found."));
				return;
			}
			var panosId:Object = new Object();
			for each(var panoramaData:PanoramaData in panoramasData) {
				if (panoramaData.id == null) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
						"Missig panorama id."));
					continue;
				}
				if (panoramaData.params.path == null) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
						"Missig panorama path."));
					continue;
				}
				if (panosId[panoramaData.id] != undefined) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Repeating panorama id: " + panoramaData.id));
					continue;
				}
				panosId[panoramaData.id] = ""; // not undefined
				
				actionExists(panoramaData.onEnter, actionsData);
				actionExists(panoramaData.onLeave, actionsData);
				actionExists(panoramaData.onTransitionEnd, actionsData);
				checkActionTrigger(panoramaData.id, panoramaData.onEnterFrom, panoramasData, actionsData);
				checkActionTrigger(panoramaData.id, panoramaData.onTransitionEndFrom, panoramasData, actionsData);
				checkActionTrigger(panoramaData.id, panoramaData.onLeaveTo, panoramasData, actionsData);
				checkActionTrigger(panoramaData.id, panoramaData.onLeaveToAttempt, panoramasData, actionsData);
				
				var hotspotsId:Object = new Object();
				for each(var hotspotData:HotspotData in panoramaData.hotspotsData){
					if (hotspotData.id == null) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
							"Missig hotspot id."));
						continue;
					}
					if (hotspotsId[hotspotData.id] != undefined) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING, 
							"Repeating hotspot id: " + hotspotData.id));
						continue;
					}
					hotspotsId[hotspotData.id] = ""; // not undefined
					
					actionExists(hotspotData.mouse.onClick, actionsData);
					actionExists(hotspotData.mouse.onOut, actionsData);
					actionExists(hotspotData.mouse.onOver, actionsData);
					actionExists(hotspotData.mouse.onPress, actionsData);
					actionExists(hotspotData.mouse.onRelease, actionsData);
				}
			}
		}
		
		private function actionExists(actionId:String, actionsData:Vector.<ActionData>):void {
			if (actionId == null) return;
			for each(var actionData:ActionData in actionsData) {
				if (actionData.id == actionId) return;
			}
			dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
				"Action not found: " + actionId));
		}
		
		private function checkActionTrigger(panoramaId:String, actionTrigger:Object, panoramasData:Vector.<PanoramaData>, actionsData:Vector.<ActionData>):void {
			for (var checkedPanoramaId:String in actionTrigger) {
				panoramaExists(checkedPanoramaId, panoramasData);
				actionExists(actionTrigger[checkedPanoramaId], actionsData);
				if (panoramaId == checkedPanoramaId) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Same panorama id not allowed: " + panoramaId));
				}
			}
		}
		
		private function panoramaExists(panoramaId:String, panoramasData:Vector.<PanoramaData>):void{
			for each(var panoramaData:PanoramaData in panoramasData) {
				if (panoramaData.id == panoramaId) return;
			}
			dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
				"Panorama not found: " + panoramaId));
		}
		
		private function checkComponents(...componentDataVectors):void {
			var componentsData:Vector.<ComponentData>;
			var componentsName:Object = new Object();
			for (var i:uint = 0; i < componentDataVectors.length; i++) {
				componentsData = componentDataVectors [i] as Vector.<ComponentData>;
				for each(var componentData:ComponentData in componentsData) {
					if (componentData.name == null) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
							"Missig component id."));
						continue;
					}
					if (componentData.path == null) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
							"Missig path in: " + componentData.name));
						continue;
					}
					if (componentData.descriptionReference == null) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Missig description for: " + componentData.name));
						// proceed anyway
					}
					if (componentsName[componentData.name] != undefined) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Repeating name: " + componentData.name));
					}else{
						componentsName[componentData.name] = ""; // not undefined
					}
				}
			}
		}
		
		private function checkActions(managerData:ManagerData):void {
			var actionsId:Object = new Object();
			for each(var actionData:ActionData in managerData.actionsData) {
				if (actionData.id == null) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
						"Missig action id."));
					continue;
				}
				if (actionsId[actionData.id] != undefined) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Repeating action id: " + actionData.id));
					continue;
				}
				actionsId[actionData.id] = ""; // not undefined
				for each(var functionData:FunctionData in actionData.functions) {
					checkFunction(functionData, managerData);
				}
			}
		}
		
		private function checkFunction(functionData:FunctionData, managerData:ManagerData):void {
			if (managerData.getComponentDataByName(functionData.owner) == null) {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
					"Owner not found: " + functionData.owner + "." + functionData.name));
				return;
			}
			if (managerData.getComponentDataByName(functionData.owner).descriptionReference != null) {
				verifyFunction(functionData, managerData);
			}
		}
		
		private function verifyFunction(functionData:FunctionData, managerData:ManagerData):void {
			var componentDescription:ComponentDescription = managerData.getComponentDataByName(functionData.owner).descriptionReference;
			if (componentDescription.functionsDescription[functionData.name] == undefined) {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
					"Function not found: " + functionData.owner + "." + functionData.name));
				return;
			}
			if ((componentDescription.functionsDescription[functionData.name] as Vector.<Class>).length != functionData.args.length) {
				dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
					"Wrong number of arguments in: " +
					functionData.owner + "." + functionData.name +
					" got: " + functionData.args.length +
					" expected: " + (componentDescription.functionsDescription[functionData.name] as Vector.<Class>).length));
				return;
			}
			if (functionData is FunctionDataTarget ) {
				for each(var target:String in (functionData as FunctionDataTarget).targets){
					var found:Boolean;
					for each (var panoramaData:PanoramaData in managerData.panoramasData) {
						for each (var hotspotData:HotspotData in panoramaData.hotspotsData) {
							if (hotspotData.id == target) {
								found = true;
								break;
							}
						}
						if (found) break;
					}
					if (!found) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Target not found: " + functionData.owner + "[" + target + "]." + functionData.name));
						return;
					}
					found = false;
					for each (var componentData:ComponentData in managerData.factoriesData) {
						if (componentData.name == functionData.owner) {
							found = true;
							break;
						}
					}
				}
				if (!found) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Target must be assigned to factory: " + functionData.owner + "[" + target + "]." + functionData.name));
					return;
				}
			}
			if ((componentDescription.functionsDescription[functionData.name] as Vector.<Class>).length > 0){
				for (var i:uint = 0; i < functionData.args.length; i++) {
					if (!(functionData.args[i] is (componentDescription.functionsDescription[functionData.name] as Vector.<Class>)[i])) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Wrong argument type in: " +
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