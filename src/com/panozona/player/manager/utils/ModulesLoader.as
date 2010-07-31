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

	import flash.display.Loader;		
	import flash.system.LoaderContext;	
	import flash.system.ApplicationDomain;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import com.panozona.player.manager.events.LoadModuleEvent;
	import com.panozona.player.manager.data.AbstractModuleData;	
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class ModulesLoader extends EventDispatcher{
		
		private var loaders:Vector.<Loader>;
		private var abstractModulesData:Vector.<AbstractModuleData>
		
		public function loadModules(abstractModulesData:Vector.<AbstractModuleData>):void {				
			this.abstractModulesData = abstractModulesData;			
			loaders = new Vector.<Loader>();			
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);			
			for(var i:int=0; i<abstractModulesData.length; i++){
				loaders[i] = new Loader(); 			  				
				loaders[i].contentLoaderInfo.addEventListener(Event.COMPLETE, moduleLoaded, false, 0 , true);
				loaders[i].contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, moduleLost);
				loaders[i].load(new URLRequest(abstractModulesData[i].path),context);
			}		   			
		}	
		
		private function moduleLoaded(e:Event):void {
			
			for(var i:int=0;i<loaders.length;i++){
				if (loaders[i].contentLoaderInfo === e.target) {					
					dispatchEvent(new LoadModuleEvent(LoadModuleEvent.MODULE_LOADED,abstractModulesData[i].moduleName, abstractModulesData[i].weight, loaders[i].content));
					loaders[i].contentLoaderInfo.removeEventListener(Event.COMPLETE, moduleLoaded);						
					loaders[i] = null;
				}
			}
			
			checkLoadingState();
		}
			
		private function moduleLost(e:IOErrorEvent):void {					
			Trace.instance.printError("Could not load module: " + e.toString());
		}								
		
		private function checkLoadingState():void {
			for (var i:int = 0; i < loaders.length; i++) {
				if (loaders[i] != null) {
					break;
				}
			}			
			dispatchEvent(new LoadModuleEvent(LoadModuleEvent.ALL_MODULES_LOADED,"",0,null));
		}		
	}
}