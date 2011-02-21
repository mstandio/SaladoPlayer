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
		 * Instance of main class that extends PanoSalado.
		 */
		public const manager:Manager = new Manager();
		
		/**
		 * Instance of class that aggregates and stores configuration data.
		 */
		public const managerData:ManagerData = new ManagerData();
		
		/**
		 * Instance of Trace window. Trace can alsa be accessed as singleton.
		 */
		public const traceWindow:Trace = Trace.instance;
		
		protected var loadedModules:Dictionary;
		protected var loadedFactories:Dictionary;
		
		protected var panorama:Panorama;
		protected var stageReference:StageReference;
		protected var resizer:IResizer;
		protected var inertialMouseCamera:ICamera;
		protected var arcBallCamera:ICamera;
		protected var keyboardCamera:ICamera;
		protected var autorotationCamera:ICamera;
		protected var simpleTransition:SimpleTransition;
		protected var nanny:Nanny;
		
		public function SaladoPlayer() {
			
			loadedModules = new Dictionary();
			loadedFactories = new Dictionary();
			
			panorama = new Panorama(); // Singleton
			resizer = new Resizer();
			inertialMouseCamera = new InertialMouseCamera();
			arcBallCamera = new ArcBallCamera();
			keyboardCamera = new KeyboardCamera();
			autorotationCamera = new AutorotationCamera();
			simpleTransition = new SimpleTransition();
			nanny = new Nanny();
			
			traceWindow.printInfo(manager.description.name +" v"+manager.description.version);
			
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
				traceWindow.printError("Could not load configuration, security error: " + error.message);
			}
		}
		
		private function configurationLost(event:IOErrorEvent):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, configurationLost);
			event.target.removeEventListener(Event.COMPLETE, configurationLoaded);
			addChild(traceWindow);
			traceWindow.printError("Could not load configuration file: " + event.text);
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
				traceWindow.printError("Error in configuration file structure: " + error.message);
				return;
			}
			
			var managerDataParserXML:ManagerDataParserXML = new ManagerDataParserXML();
			managerDataParserXML.addEventListener(ConfigurationEvent.INFO, printConfigurationMessage, false, 0, true);
			managerDataParserXML.addEventListener(ConfigurationEvent.WARNING, printConfigurationMessage, false, 0, true);
			managerDataParserXML.addEventListener(ConfigurationEvent.ERROR, printConfigurationMessage, false, 0, true);
			managerDataParserXML.configureManagerData(managerData, settings);
			
			addChild(manager);
			
			var modulesLoader:LoadablesLoader = new LoadablesLoader();
			modulesLoader.addEventListener(LoadLoadableEvent.LOST, componentLost);
			modulesLoader.addEventListener(LoadLoadableEvent.LOADED, componentLoaded);
			modulesLoader.addEventListener(LoadLoadableEvent.FINISHED, componentsFinished);
			modulesLoader.load(Vector.<ILoadable>(managerData.getComponentsData()));
		}
		
		private function componentLost(event:LoadLoadableEvent):void {
			traceWindow.printError("Clould not load module: " + event.loadable.path);
		}
		
		private function componentLoaded(event:LoadLoadableEvent):void {
			if (event.content is Factory) {
				loadedFactories[event.loadable as ComponentData] = event.content;
			}else {
				loadedModules[event.loadable as ComponentData] = event.content;
			}
			if (event.content is Component){
				for each (var componentData:ComponentData in managerData.modulesData) {
					if ((event.loadable as ComponentData) === componentData) {
						componentData.descriptionReference = (event.content as Component).componentDescription;
						return;
					}
				}
			}
		}
		
		protected function componentsFinished(event:LoadLoadableEvent):void {
			event.target.removeEventListener(LoadLoadableEvent.LOST, componentLost);
			event.target.removeEventListener(LoadLoadableEvent.LOADED, componentLoaded);
			event.target.removeEventListener(LoadLoadableEvent.FINISHED, componentsFinished);
			for (var j:int = managerData.factoriesData.length - 1; j >= 0; j--) {
				if (loadedFactories[managerData.factoriesData[j]] != undefined){
					addChild(loadedFactories[managerData.factoriesData[j]] as DisplayObject);
				}
			}
			for (var i:int = managerData.modulesData.length - 1; i >= 0; i--) {
				if (loadedModules[managerData.modulesData[i]] != undefined){
					addChild(loadedModules[managerData.modulesData[i]] as DisplayObject);
				}
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
		
		protected function runValidator():void {
			var fakeComponentData:ComponentData = new ComponentData(manager.description.name, "fake path");
			fakeComponentData.descriptionReference = manager.description;
			managerData.modulesData.push(fakeComponentData);
			var managerDataValidator:ManagerDataValidator = new ManagerDataValidator();
			managerDataValidator.addEventListener(ConfigurationEvent.INFO, printConfigurationMessage, false, 0, true);
			managerDataValidator.addEventListener(ConfigurationEvent.WARNING, printConfigurationMessage, false, 0, true);
			managerDataValidator.addEventListener(ConfigurationEvent.ERROR, printConfigurationMessage, false, 0, true);
			managerDataValidator.validate(managerData);
			managerData.modulesData.pop();
		}
		
		private function finalOperations():void {
			if (managerData.debugMode) {
				runValidator();
			}
			
			addChild(traceWindow); // to make it most on top
			manager.loadFirstPanorama();
		}
		
		/**
		 * Dictionary, where key is componentData object
		 * and value is loaded module (swf file)
		 * 
		 * @return componentData to DisplayObject
		 */
		public function getModules(): Dictionary {
			return loadedModules;
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
		
		/**
		 * Dictionary, where key is componentData object
		 * and value is loaded factory (swf file)
		 * 
		 * @return componentData to DisplayObject
		 */
		public function getFactories():Dictionary {
			return loadedFactories;
		}
		
		/**
		 * Returns reference to factory (swf file)
		 * by its name declared in configuration
		 * 
		 * @param name of factory
		 * @return module as DisplayObject, null if not found
		 */
		public function getFactoryByName(name:String):DisplayObject {
			for each(var factoryData:ComponentData in managerData.factoriesData) {
				if (factoryData.name == name) {
					return loadedFactories[factoryData];
				}
			}
			return null;
		}
	}
}
