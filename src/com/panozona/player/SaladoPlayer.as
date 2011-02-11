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
package com.panozona.player {
	
	import com.panosalado.controller.*;
	import com.panosalado.core.*;
	import com.panosalado.model.*;
	import com.panosalado.view.*;
	import com.panozona.player.component.*;
	import com.panozona.player.manager.*;
	import com.panozona.player.manager.data.*;
	import com.panozona.player.manager.utils.configuration.*;
	import com.panozona.player.manager.events.*;
	import com.panozona.player.manager.utils.loading.*;
	import com.panozona.player.manager.utils.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	[SWF(width="500", height="375", frameRate="60", backgroundColor="#FFFFFF")] // default size is MANDATORY
	
	public class SaladoPlayer extends Sprite {
		
		/**
		 * Instance of main class that extends PanoSalado
		 */
		public const manager:Manager = new Manager();
		
		/**
		 * Instance of class that aggregates and stores configuration data
		 */
		private const managerData:ManagerData = new ManagerData();
		
		private var loadedModules:Dictionary;
		private var traceWindow:Trace;
		
		private var panorama:Panorama;
		private var stageReference:StageReference;
		private var resizer:IResizer;
		private var inertialMouseCamera:ICamera;
		private var arcBallCamera:ICamera;
		private var keyboardCamera:ICamera;
		private var autorotationCamera:ICamera;
		private var simpleTransition:SimpleTransition;
		private var nanny:Nanny;
		
		public function SaladoPlayer() {
			
			loadedModules = new Dictionary();
			traceWindow = Trace.instance;
			
			panorama = new Panorama(); // Singleton
			resizer = new Resizer();
			inertialMouseCamera = new InertialMouseCamera();
			arcBallCamera = new ArcBallCamera();
			keyboardCamera = new KeyboardCamera();
			autorotationCamera = new AutorotationCamera();
			simpleTransition = new SimpleTransition();
			nanny = new Nanny();
			
			Trace.instance.printInfo(manager.description.name +" v"+manager.description.version);
			
			manager.initialize([
				panorama,
				DeepZoomTilePyramid,
				resizer,
				managerData.controlData.keyboardCameraData,
				keyboardCamera,
				managerData.controlData.inertialMouseCameraData,
				inertialMouseCamera,
				managerData.controlData.arcBallCameraData,
				arcBallCamera,
				managerData.controlData.autorotationCameraData,
				autorotationCamera,
				managerData.controlData.simpleTransitionData,
				simpleTransition,
				nanny
			]);
			
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			try{
				xmlLoader.load(new URLRequest(loaderInfo.parameters.xml ? loaderInfo.parameters.xml : "settings.xml"));
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, configurationLost);
				xmlLoader.addEventListener(Event.COMPLETE, configurationLoaded);
			}catch (error:Error) {
				addChild(traceWindow);
				Trace.instance.printError("Could not load configuration, security error: " + error.message);
			}
		}
		
		private function configurationLost(event:IOErrorEvent):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, configurationLost);
			event.target.removeEventListener(Event.COMPLETE, configurationLoaded);
			addChild(traceWindow);
			Trace.instance.printError("Could not load configuration file: " + event.text);
		}
		
		private function configurationLoaded(event:Event):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, configurationLost);
			event.target.removeEventListener(Event.COMPLETE, configurationLoaded);
			var input:ByteArray = event.target.data;
			try {input.uncompress();} catch (error:Error) {}
			var settings:XML;
			try {
				settings = XML(input);
			}catch (error:Error) {
				addChild(traceWindow);
				Trace.instance.printError("Error in configuration file structure: " + error.message);
				return;
			}
			
			//var managerDataParserXML:ManagerDataParserXML = new ManagerDataParserXML(settings);
			//managerDataParserXML.addEventListener(ConfigurationEvent.INFO, printConfigurationMessage, false, 0, true);
			//managerDataParserXML.addEventListener(ConfigurationEvent.WARNING, printConfigurationMessage, false, 0, true);
			//managerDataParserXML.addEventListener(ConfigurationEvent.ERROR, printConfigurationMessage, false, 0, true);
			//managerDataParserXML.configureManagerData(managerData);
			
			addChild(manager);
			
			if (managerData.modulesData.length == 0){
				finalOperations();
			}else {
				var modulesLoader:LoadablesLoader = new LoadablesLoader();
				modulesLoader.addEventListener(LoadLoadableEvent.LOST, moduleLost);
				modulesLoader.addEventListener(LoadLoadableEvent.LOADED, moduleLoaded);
				modulesLoader.addEventListener(LoadLoadableEvent.FINISHED, modulesFinished);
				modulesLoader.load(managerData.modulesData as Vector.<ILoadable>);
			}
		}
		
		private function moduleLost(event:LoadLoadableEvent):void {
			Trace.instance.printError("Clould not load module: " + event.path);
		}
		
		private function moduleLoaded(event:LoadLoadableEvent):void {
			for each (var componentData:ComponentData in managerData.modulesData){
				if (componentData.path == event.path) {
					loadedModules[componentData] = event.content;
					// TODO: jezeli jest modulem to dodaj tutaj referencje ..
					loadedModules.push(event.content); 
					return;
				}
			}
		}
		
		private function modulesFinished(event:LoadLoadableEvent):void {
			event.target.removeEventListener(LoadLoadableEvent.LOST, moduleLost);
			event.target.removeEventListener(LoadLoadableEvent.LOADED, moduleLoaded);
			event.target.removeEventListener(LoadLoadableEvent.FINISHED, modulesFinished);
			var displayObject:DisplayObject;
			for (var i:int = managerData.modulesData.length - 1; i >= 0 ; i--) {
				displayObject = loadedModules[managerData.modulesData[i]];
				// pass configuration to module 
				addChild(displayObject);
			}
			if (managerData.debugMode) {
				var managerDataValidator:ManagerDataValidator = new ManagerDataValidator();
				managerDataValidator.addEventListener(ConfigurationEvent.INFO, printConfigurationMessage, false, 0, true);
				managerDataValidator.addEventListener(ConfigurationEvent.WARNING, printConfigurationMessage, false, 0, true);
				managerDataValidator.addEventListener(ConfigurationEvent.ERROR, printConfigurationMessage, false, 0, true);
				managerDataValidator.validate(managerData);
			}
			finalOperations();
		}
		
		private function printConfigurationMessage(event:ConfigurationEvent):void {
			if (event.type == ConfigurationEvent.INFO) {
				Trace.instance.printInfo(event.message);
			}else if (event.type == ConfigurationEvent.WARNING) {
				Trace.instance.printWarning(event.message);
			}else if (event.type == ConfigurationEvent.ERROR) {
				Trace.instance.printError(event.message);
				// TODO indicate crash!
			}
		}
		
		private function finalOperations():void {
			addChild(traceWindow); // to make it most on top
			manager.loadFirstPanorama();
		}
		
		/**
		 * Returns reference to module (swf file)
		 * by its name declared in configuration
		 * 
		 * @param name of module
		 * @return module as DisplayObject, null if not found
		 */
		public function getModuleByName(name:String):DisplayObject {
			for each(var moduleData:ComponentData in managerData.modulesData) {
				if (moduleData.name == name) {
					return loadedModules[moduleData];
				}
			}
			return null;
		}
	}
}
