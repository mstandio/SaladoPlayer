/*
Copyright 2011 Marek Standio.

This file is part of DIY streetview player.

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
package org.diystreetview.player{
	
	import com.panozona.player.manager.events.ConfigurationEvent;
	import com.panozona.player.manager.events.LoadLoadableEvent;
	import com.panozona.player.manager.utils.loading.ILoadable;
	import com.panozona.player.manager.utils.loading.LoadablesLoader;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.SaladoPlayer;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;
	import org.diystreetview.controller.DsvKeyboardCamera;
	import org.diystreetview.player.manager.data.DsvManagerData;
	import org.diystreetview.player.manager.DsvManager;
	import org.diystreetview.player.manager.utils.configuration.DsvManagerDataParserXML;
	import org.diystreetview.player.manager.utils.configuration.DsvManagerDataValidator;
	
	[SWF(width="500", height="375", frameRate="30", backgroundColor="#FFFFFF")] // default size is mandatory
	
	public class DiyStreetviewPlayer extends SaladoPlayer{
		
		public function DiyStreetviewPlayer() {
			keyboardCamera = new DsvKeyboardCamera();
			managerData = new DsvManagerData();
			manager = new DsvManager();
			init();
		}
		
		override protected function configurationLoaded(event:Event):void {
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
			
			var managerDataParserXML:DsvManagerDataParserXML = new DsvManagerDataParserXML(); // use custom parser
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
		
		override protected function runValidator():void {
			var fakeModuleData:ModuleData = new ModuleData(manager.description.name, "fake path");
			fakeModuleData.descriptionReference = manager.description;
			managerData.modulesData.push(fakeModuleData);
			var managerDataValidator:DsvManagerDataValidator = new DsvManagerDataValidator();
			managerDataValidator.addEventListener(ConfigurationEvent.INFO, printConfigurationMessage, false, 0, true);
			managerDataValidator.addEventListener(ConfigurationEvent.WARNING, printConfigurationMessage, false, 0, true);
			managerDataValidator.addEventListener(ConfigurationEvent.ERROR, printConfigurationMessage, false, 0, true);
			managerDataValidator.validate(managerData);
			managerData.modulesData.pop();
		}
	}
}