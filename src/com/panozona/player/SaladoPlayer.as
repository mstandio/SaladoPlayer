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
package com.panozona.player {
	
	import com.panosalado.controller.ArcBallCamera;
	import com.panosalado.controller.AutorotationCamera;
	import com.panosalado.controller.ICamera;
	import com.panosalado.controller.InertialMouseCamera;
	import com.panosalado.controller.IResizer;
	import com.panosalado.controller.KeyboardCamera;
	import com.panosalado.controller.Nanny;
	import com.panosalado.controller.Resizer;
	import com.panosalado.controller.ScrollCamera;
	import com.panosalado.controller.SimpleTransition;
	import com.panosalado.controller.StageReference;
	import com.panosalado.model.DeepZoomTilePyramid;
	import com.panosalado.view.Panorama;
	import com.panozona.player.manager.data.ManagerData;
	import com.panozona.player.manager.events.ConfigurationEvent;
	import com.panozona.player.manager.events.LoadLoadableEvent;
	import com.panozona.player.manager.Manager;
	import com.panozona.player.manager.utils.Branding;
	import com.panozona.player.manager.utils.configuration.ManagerDataParserXML;
	import com.panozona.player.manager.utils.configuration.ManagerDataValidator;
	import com.panozona.player.manager.utils.loading.ILoadable;
	import com.panozona.player.manager.utils.loading.LoadablesLoader;
	import com.panozona.player.manager.utils.Stats;
	import com.panozona.player.manager.utils.Trace;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	import com.spikything.utils.MouseWheelTrap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	[SWF(width="500", height="375", frameRate="30")] // default size is MANDATORY
	
	public class SaladoPlayer extends Sprite {
		
		/**
		 * Instance of main class that extends PanoSalado.
		 */
		public var manager:Manager = new Manager();
		
		/**
		 * Instance of class that aggregates and stores configuration data.
		 */
		public var managerData:ManagerData = new ManagerData();
		
		/**
		 * Instance of Trace window. Trace can alsa be accessed as singleton.
		 */
		public var traceWindow:Trace = Trace.instance;
		
		/**
		 * Dictionary, where key is moduleData object
		 * and value is loaded module (swf file)
		 */
		public var modules:Dictionary = new Dictionary();
		
		protected var panorama:Panorama;
		protected var stageReference:StageReference;
		protected var resizer:IResizer;
		protected var inertialMouseCamera:ICamera;
		protected var arcBallCamera:ICamera;
		protected var scrollCamera:ICamera;
		protected var keyboardCamera:ICamera;
		protected var autorotationCamera:ICamera;
		protected var simpleTransition:SimpleTransition;
		protected var nanny:Nanny;
		
		public function SaladoPlayer() {
			
			panorama = new Panorama(); // Singleton
			resizer = new Resizer();
			inertialMouseCamera = new InertialMouseCamera();
			arcBallCamera = new ArcBallCamera();
			scrollCamera = new ScrollCamera();
			keyboardCamera = new KeyboardCamera();
			autorotationCamera = new AutorotationCamera();
			simpleTransition = new SimpleTransition();
			nanny = new Nanny();
			init();
		}
		
		protected function init():void {
			
			traceWindow.printLink(manager.description.homeUrl, manager.description.name+" "+manager.description.version);
			
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			try {
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, configurationLost);
				xmlLoader.addEventListener(Event.COMPLETE, configurationLoaded);
				xmlLoader.load(new URLRequest((loaderInfo.parameters.xml ?
					(loaderInfo.parameters.xml + (loaderInfo.parameters.xml.indexOf("?") > 0 ? "&" : "?")) :
					"settings.xml?") +
					"v=" + new Date().getTime()));
			}catch (error:Error) {
				addChild(traceWindow);
				traceWindow.printError("Could not access local files, error: " + error.message);
				traceWindow.printLink("http://www.macromedia.com/support/documentation/en/flashplayer/help/settings_manager04.html", "configure Global Security Settings");
			}
		}
		
		protected function configurationLost(event:IOErrorEvent):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, configurationLost);
			event.target.removeEventListener(Event.COMPLETE, configurationLoaded);
			addChild(traceWindow);
			traceWindow.printError("Could not load configuration file: " + event.text);
		}
		
		protected function configurationLoaded(event:Event):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, configurationLost);
			event.target.removeEventListener(Event.COMPLETE, configurationLoaded);
			var input:ByteArray = event.target.data;
			try {input.uncompress();} catch (error:Error) {}
			var settings:XML;
			try {
				settings = XML(input.toString().replace(/~/gm, loaderInfo.parameters.tilde ? loaderInfo.parameters.tilde : ""));
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
			modulesLoader.addEventListener(LoadLoadableEvent.LOST, moduleLost);
			modulesLoader.addEventListener(LoadLoadableEvent.LOADED, moduleLoaded);
			modulesLoader.addEventListener(LoadLoadableEvent.FINISHED, modulesFinished);
			modulesLoader.load(Vector.<ILoadable>(managerData.modulesData));
		}
		
		protected function moduleLost(event:LoadLoadableEvent):void {
			traceWindow.printError("Clould not load module: " + event.loadable.path);
		}
		
		protected function moduleLoaded(event:LoadLoadableEvent):void {
			modules[event.loadable] = event.content;
			if (event.content is Module){
				for each (var moduleData:ModuleData in managerData.modulesData) {
					if ((event.loadable as ModuleData) === moduleData) {
						moduleData.descriptionReference = (event.content as Module).moduleDescription;
						return;
					}
				}
			}
		}
		
		protected function modulesFinished(event:LoadLoadableEvent):void {
			event.target.removeEventListener(LoadLoadableEvent.LOST, moduleLost);
			event.target.removeEventListener(LoadLoadableEvent.LOADED, moduleLoaded);
			event.target.removeEventListener(LoadLoadableEvent.FINISHED, modulesFinished);
			for (var i:int = managerData.modulesData.length - 1; i >= 0; i--) {
				if (modules[managerData.modulesData[i]] != undefined){
					addChild(modules[managerData.modulesData[i]] as DisplayObject);
				}
			}
			finalOperations();
		}
		
		protected function printConfigurationMessage(event:ConfigurationEvent):void {
			if (event.type == ConfigurationEvent.INFO) {
				traceWindow.printInfo(event.message);
			}else if (event.type == ConfigurationEvent.WARNING) {
				traceWindow.printWarning(event.message);
			}else if (event.type == ConfigurationEvent.ERROR) {
				traceWindow.printError(event.message);
			}
		}
		
		protected function runValidator():void {
			var fakeModuleData:ModuleData = new ModuleData(manager.description.name, "fake path");
			fakeModuleData.descriptionReference = manager.description;
			managerData.modulesData.push(fakeModuleData);
			var managerDataValidator:ManagerDataValidator = new ManagerDataValidator();
			managerDataValidator.addEventListener(ConfigurationEvent.INFO, printConfigurationMessage, false, 0, true);
			managerDataValidator.addEventListener(ConfigurationEvent.WARNING, printConfigurationMessage, false, 0, true);
			managerDataValidator.addEventListener(ConfigurationEvent.ERROR, printConfigurationMessage, false, 0, true);
			managerDataValidator.validate(managerData);
			managerData.modulesData.pop();
		}
		
		protected function finalOperations():void {
			if (managerData.debugMode) {
				runValidator();
			}
			addChild(traceWindow); // to make it most on top
			addChild(new Branding());
			if (managerData.statsData.visible) {
				addChild(new Stats());
			}
			if (managerData.controlData.mouseWheelTrap) {
				MouseWheelTrap.setup(stage);
			}
			
			manager.initialize([
				panorama,
				DeepZoomTilePyramid,
				//ZoomifyTilePyramid,
				resizer,
				managerData.controlData.keyboardCameraData,
				keyboardCamera,
				managerData.controlData.inertialMouseCameraData,
				inertialMouseCamera,
				managerData.controlData.arcBallCameraData,
				arcBallCamera,
				managerData.controlData.scrollCameraData,
				scrollCamera,
				managerData.controlData.autorotationCameraData,
				autorotationCamera,
				managerData.controlData.simpleTransitionData,
				simpleTransition,
				nanny
			]);
			
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
			for each(var moduleData:ModuleData in managerData.modulesData) {
				if (moduleData.name == name) {
					return modules[moduleData];
				}
			}
			return null;
		}
	}
}
