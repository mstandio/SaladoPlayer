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
package com.panozona.player {
	
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.utils.ByteArray;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.events.ContextMenuEvent;
	import flash.system.ApplicationDomain;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.external.ExternalInterface;
	
	import com.panosalado.model.*;
	import com.panosalado.view.*;
	import com.panosalado.controller.*;
	import com.panosalado.core.*;
	
	import com.panozona.player.manager.Manager;
	import com.panozona.player.manager.utils.ManagerDataParserXML;
	import com.panozona.player.manager.utils.ManagerDataValidator;
	import com.panozona.player.manager.utils.ModulesLoader;
	import com.panozona.player.manager.utils.ManagerDescription;
	import com.panozona.player.manager.utils.Trace;
	import com.panozona.player.manager.utils.Branding;
	import com.panozona.player.manager.data.ManagerData;
	import com.panozona.player.manager.data.module.AbstractModuleData;
	import com.panozona.player.manager.data.module.AbstractModuleDescription;
	import com.panozona.player.manager.data.global.TraceData;
	import com.panozona.player.manager.events.LoadModuleEvent;
	
	import performance.Stats;
	
	import com.spikything.utils.MouseWheelTrap;	
	
	[SWF(width="500", height="375", frameRate="60", backgroundColor="#FFFFFF")] // default size is mandatory
	
	/**
	 * @author mstandio
	 */
	public class SaladoPlayer extends Sprite {
		
		/**
		 * Instance of main class that extends PanoSalado
		 */
		public var manager: Manager;
		
		/**
		 * Instance of class that aggregates and stores configuration data
		 */
		public var managerData:ManagerData;
		
		/**
		 * Instance of singleton trace window that is added to stage.
		 */
		public var tracer:Trace;
		
		private var panorama:Panorama;
		private var stageReference:StageReference;
		private var resizer:IResizer;
		private var inertialMouseCamera:ICamera;
		private var arcBallCamera:ICamera;
		private var keyboardCamera:ICamera;
		private var autorotationCamera:ICamera;
		private var simpleTransition:SimpleTransition;
		private var nanny:Nanny;
		
		private var modulesLoader:ModulesLoader;
		private var moduleByDepth:Array;
		private var moduleByName:Array;
		private var moduleClass:Class;
		private var abstractModuleDescriptions:Vector.<AbstractModuleDescription>;
		
		/**
		 * Constructor
		 */
		public function SaladoPlayer() {
			
			managerData = new ManagerData();
			manager = new Manager();
			
			initialize();
		}
		
		/**
		 * 
		 */
		protected function initialize():void {
			
			panorama = new Panorama(); // Singleton
			resizer = new Resizer();
			inertialMouseCamera = new InertialMouseCamera();
			arcBallCamera = new ArcBallCamera();
			keyboardCamera = new KeyboardCamera();
			autorotationCamera = new AutorotationCamera();
			simpleTransition = new SimpleTransition();
			nanny = new Nanny();
			
			manager.initialize([
				panorama,
				DeepZoomTilePyramid,
				resizer,
				managerData.keyboardCameraData,
				keyboardCamera,
				managerData.inertialMouseCameraData,
				inertialMouseCamera,
				managerData.arcBallCameraData,
				arcBallCamera,
				managerData.autorotationCameraData,
				autorotationCamera,
				managerData.simpleTransitionData,
				simpleTransition,
				nanny
			]);
			
			tracer = Trace.instance;
			
			abstractModuleDescriptions = new Vector.<AbstractModuleDescription>();
			moduleByDepth = new Array();
			moduleByName = new Array();
			
			tracer.printInfo(ManagerDescription.name +" v"+ManagerDescription.version);
			
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			try{
				xmlLoader.load(new URLRequest(loaderInfo.parameters.xml?loaderInfo.parameters.xml:"settings.xml"));
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, configurationNotLoaded, false, 0, true);
				xmlLoader.addEventListener(Event.COMPLETE, configurationLoaded, false, 0, true);
			}catch (error:Error) {
				addChild(tracer);
				tracer.printError("Security error: "+error.message);
			}
		}
		
		private function configurationNotLoaded(event:IOErrorEvent):void {
			addChild(tracer);
			tracer.printError("Could not load configuration file: "+event.text);
		}
		
		private function configurationLoaded(event:Event):void {
			
			var input:ByteArray = event.target.data;
			try {input.uncompress()}catch (error:Error) {}
			
			try {
				var managerDataParserXML:ManagerDataParserXML = new ManagerDataParserXML();
				var settings:XML = XML(input);
				managerDataParserXML.configureManagerData(managerData, settings);
				addChild(manager);
				tracer.printInfo("Configuration parsing done.");
				
			}catch (error:Error) {
				addChild(tracer);
				Trace.instance.printError("Error in configuration file structure: " + error.message);
				return;
			}
			
			if (managerData.abstractModulesData.length == 0) {
				finalOperations();
			}else {
				var modulesLoader:ModulesLoader = new ModulesLoader();
				modulesLoader.addEventListener(LoadModuleEvent.MODULE_LOADED, insertModule);
				modulesLoader.addEventListener(LoadModuleEvent.ALL_MODULES_LOADED, modulesLoadingComplete);
				modulesLoader.load(managerData.abstractModulesData);
			}
		}
		
		private function insertModule(event:LoadModuleEvent):void {
			if(moduleClass == null){
				moduleClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.module.Module") as Class;
			}
			var name:String = event.moduleName;
			try{
				var module:Object = moduleClass(event.module);
				for each (var abstractModuleData:AbstractModuleData in managerData.abstractModulesData){
					if (abstractModuleData.moduleName == name && moduleByName[abstractModuleData.moduleName] == undefined){
						moduleByDepth[abstractModuleData.weight] = module;
						moduleByName[abstractModuleData.moduleName] = module;
						abstractModuleDescriptions.push(new AbstractModuleDescription(module.moduleDescription));
						return;
					}
				}
			}catch (error:Error) {
				Trace.instance.printError("Could not load module "+name+": "+error.message);
			}
		}
		
		protected function modulesLoadingComplete(e:LoadModuleEvent):void {
			e.target.removeEventListener(LoadModuleEvent.MODULE_LOADED, insertModule);
			e.target.removeEventListener(LoadModuleEvent.ALL_MODULES_LOADED, modulesLoadingComplete);
			for (var i:int = moduleByDepth.length - 1; i >= 0 ; i--) {
				var addedModule:DisplayObject = moduleByDepth[i];
				if (addedModule != null){
					addChild(addedModule);
				}
			}
			finalOperations();
		}
		
		protected function finalOperations():void {
			
			MouseWheelTrap.setup(stage);
			
			ExternalInterface.call("s = function(){document.getElementById('EyesisPlayer').focus(); }");
			
			if (managerData.debugMode) {
			abstractModuleDescriptions.push(new ManagerDescription().description);
				try {
					var managerDataValidator:ManagerDataValidator = new ManagerDataValidator();
					managerDataValidator.validate(managerData, abstractModuleDescriptions);
					Trace.instance.printInfo("Configuration validation done.");
				}catch (error:Error) {
					tracer.printError(error.message);
				}
			}
			
			if (managerData.brandingData.visible) {
				addChild(new Branding());
			}
			
			if (managerData.brandingData.contextMenu) {
				var menu:ContextMenu = new ContextMenu();
				var item:ContextMenuItem = new ContextMenuItem("Powered by SaladoPlayer");
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e:Event):void{ navigateToURL(new URLRequest("http://www.panozona.com"))});
				menu.customItems.push(item);
				contextMenu = menu;
			}
			
			if (managerData.showStats) {
				addChild(new Stats());
			}
			
			ExternalInterface.addCallback("runAction", manager.runAction);
			
			addChild(tracer); // to make it most on top
			manager.loadFirstPanorama();
		}
		
		/**
		 * Returns reference to module (swf file) loaded as one of layers atop SaladoPlayer
		 * With that reference one gets access to public functions and variables of module
		 * 
		 * @param	name of module
		 * @return  module as DisplayObject, null if not found
		 */
		public function getModuleByName(moduleName:String):DisplayObject{
			if (moduleName != null && moduleByName[moduleName] != undefined) {
				return moduleByName[moduleName];
			}else {
				return null;
			}
		}
	}
}
