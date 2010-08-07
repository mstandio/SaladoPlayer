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
package com.panozona.player{
	
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
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
	import com.panozona.player.manager.events.LoadModuleEvent;
	import com.panozona.player.manager.data.ManagerData;
	import com.panozona.player.manager.data.AbstractModuleData;
	import com.panozona.player.manager.data.AbstractModuleDescription;
	import com.panozona.player.manager.data.TraceData;
	
	import performance.Stats;
	
	[SWF(width = "500", height = "375", frameRate = "30", backgroundColor = "#FFFFFF")]
	
	public class SaladoPlayer extends Sprite {
		
		public var manager: Manager;
		public var managerData:ManagerData;
		public var tracer:Trace;
		
		private var panorama:Panorama;
		private var stageReference:StageReference;
		private var resizer:IResizer;
		private var inertialMouseCamera:ICamera;
		private var keyboardCamera:ICamera;
		private var autorotationCamera:ICamera;
		private var simpleTransition:SimpleTransition;
		private var nanny:Nanny;	
		
		
		private var modulesLoader:ModulesLoader;		
		private var moduleByDepth:Array;
		private var moduleByName:Array;		
		private var moduleClass:Class;
		private var abstractModuleDescriptions:Vector.<AbstractModuleDescription>;	
		
		public function SaladoPlayer() {
			
			managerData = new ManagerData();			
			manager = new Manager(managerData);			
			
			panorama = new Panorama(); // Singleton
			resizer	= new Resizer();
			inertialMouseCamera = new InertialMouseCamera();
			keyboardCamera = new KeyboardCamera();
			autorotationCamera = new AutorotationCamera();
			simpleTransition = new SimpleTransition();
			nanny = new Nanny();			
			
			manager.initialize([
				panorama,
				DeepZoomTilePyramid,
				resizer,
				managerData.inertialMouseCameraData,
				inertialMouseCamera,
				managerData.keyboardCameraData, 
				keyboardCamera,
				managerData.autorotationCameraData, 
				autorotationCamera,
				managerData.simpleTransitionData,
				simpleTransition,
				nanny
			]);			
			
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.dataFormat = URLLoaderDataFormat.BINARY;
    		xmlLoader.load( new URLRequest(loaderInfo.parameters.xml?loaderInfo.parameters.xml:"settings.xml"));
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, configurationNotLoaded, false, 0, true);
    		xmlLoader.addEventListener(Event.COMPLETE, configurationLoaded, false, 0, true);			
		}
		
		private function configurationNotLoaded(event:IOErrorEvent):void {
			Trace.instance.configure(new TraceData()); // to show trace window 
			addChild(Trace.instance);
			Trace.instance.printError("Could not load configuration file");
		}
		
		private function configurationLoaded(event:Event):void {			
			
			abstractModuleDescriptions = new Vector.<AbstractModuleDescription>()
			moduleByDepth = new Array();
			moduleByName = new Array();			
			
			var input:ByteArray = event.target.data;			
			try {
				input.uncompress()
			}catch (error:Error) {} // huh
			
			try {
				var managerDataParserXML:ManagerDataParserXML = new ManagerDataParserXML();
				managerDataParserXML.configureManagerData(managerData, XML(input));
				Trace.instance.printInfo("Configuration parsing done");
			}catch (error:Error) {
				Trace.instance.printError(error.message);
			}
			
			addChild(manager);
			
			Trace.instance.configure(managerData.traceData); 
			tracer = Trace.instance;
			addChild(tracer); 
			
			if (managerData.abstractModulesData.length == 0) {
				finalOperations();
			}else {
				modulesLoader = new ModulesLoader();
				modulesLoader.addEventListener(LoadModuleEvent.MODULE_LOADED, insertModule, false, 0, true);
				modulesLoader.addEventListener(LoadModuleEvent.ALL_MODULES_LOADED, modulesLoadingComplete, false, 0, true);
				modulesLoader.loadModules(managerData.abstractModulesData);
			}
		}
		
		
		private function insertModule(event:LoadModuleEvent):void {
			if(moduleClass == null){
				moduleClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.module.Module") as Class;
			}
			var name:String = event.moduleName;
			var module:Object = moduleClass(event.module);
			for each (var abstractModuleData:AbstractModuleData in managerData.abstractModulesData){
				if (abstractModuleData.moduleName == name && moduleByName[abstractModuleData.moduleName] == undefined){
					moduleByDepth[abstractModuleData.weight] = module;
					moduleByName[abstractModuleData.moduleName] = module;
					try {
						abstractModuleDescriptions.push(new AbstractModuleDescription(module.moduleDescription));
					}catch (error:Error) {
						Trace.instance.printError(error.message);
					}
					return;
				}
			}
		}
		
		private function modulesLoadingComplete(e:Event):void {
			for (var i:int = moduleByDepth.length - 1; i >= 0 ; i--) {
				var addedModule:DisplayObject = moduleByDepth[i];
				if (addedModule){
					addChild(addedModule);
				}
			}
			finalOperations();
		}
		

		private function finalOperations():void{
			if (managerData.traceData.debug) {
				abstractModuleDescriptions.push(new ManagerDescription().description);				
				try {
					var managerDataValidator:ManagerDataValidator = new ManagerDataValidator(managerData, abstractModuleDescriptions);
					managerDataValidator.validate();
					Trace.instance.printInfo("Configuration validation done");
				}catch (error:Error) {
					Trace.instance.printError(error.message);
					trace(error.getStackTrace()); // remove
				}				
			}
			
			addChild(Trace.instance); // to make it most on top
			
			if (managerData.showStatistics) {
				addChild(new Stats());
			}
			
			manager.loadFirstPanorama();
		}
		
		/**
		 * Returns reference to module (swf file) loaded as one of layers atop SaladoPlayer
		 * With that reference one gets access to public functions and variables of module
		 * 
		 * @param	moduleName String name of module
		 * @return  module Object, null if not found
		 */
		public function getModuleByName(moduleName:String):Object{
			if (moduleName != null && moduleByName[moduleName] != undefined) {
				return moduleByName[moduleName];
			}else {
				return null;
			}
		}
	}
}