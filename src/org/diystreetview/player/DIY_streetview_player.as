/*
Copyright 2010 Marek Standio.

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
along with SaladoPlayer.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.diystreetview.player{
	
	import flash.utils.ByteArray;
	import flash.events.Event;
	
	import com.panozona.player.SaladoPlayer;
	import com.panozona.player.manager.utils.Trace;
	import com.panozona.player.manager.events.LoadModuleEvent;
	
	import com.diystreetview.player.manager.Manager;
	import com.diystreetview.player.manager.data.ManagerData;
	import com.diystreetview.player.manager.utils.ManagerDataParserXML;
	import com.panozona.player.manager.utils.ModulesLoader;
	
	[SWF(width="500", height="375", frameRate="30", backgroundColor="#FFFFFF")] // default size is mandatory
	
	public class DIY_streetview_player extends SaladoPlayer{
		
		public function DIY_streetview_player() {
			
			managerData = new com.diystreetview.player.manager.data.ManagerData();
			manager = new com.diystreetview.player.manager.Manager();
			initialize();
		}
		
		override protected function configurationLoaded(event:Event):void {
			
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
				modulesLoader.addEventListener(LoadModuleEvent.MODULE_LOADED, insertModule, false, 0, true);
				modulesLoader.addEventListener(LoadModuleEvent.ALL_MODULES_LOADED, modulesLoadingComplete, false, 0, true);
				modulesLoader.load(managerData.abstractModulesData);
			}
		}
	}
}