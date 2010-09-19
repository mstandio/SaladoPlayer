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

You should have received a copy of the GNU General Public Licensep
along with SaladoPlayer.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.player.module{
		
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;	
	
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.ModuleNode;
	import com.panozona.player.module.data.ModuleDescription;		
	import com.panozona.player.module.utils.ModuleInfoPrinter;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class Module extends Sprite  {
					
		protected var aboutThisModule:String; 
		
		protected var _moduleData:ModuleData;
		protected var _moduleDescription:ModuleDescription;		
		
		protected var SaladoPlayerClass:Class;
		protected var saladoPlayer:Object;		
				
		private var TraceClass:Class;
		private var tracer:Object;
						
		public final function Module(moduleName:String, moduleVersion:Number, moduleAuthor:String = null, moduleHomeUrl:String = null) {			
			_moduleDescription = new ModuleDescription(moduleName, moduleVersion, moduleAuthor, moduleHomeUrl);
			
			// default information
			aboutThisModule = "This is SaladoPlayer module.";
			
			addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}		
		
		private final function stageReady(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			try {
				
				SaladoPlayerClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.SaladoPlayer") as Class;
				saladoPlayer = this.parent as SaladoPlayerClass;
				
				_moduleData = new ModuleData(saladoPlayer.managerData.getAbstractModuleDataByName(_moduleDescription.moduleName));
				
				TraceClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.utils.Trace") as Class;
				tracer = saladoPlayer.tracer as TraceClass;
				
				try {
					moduleReady();
				}catch (error:Error) {
					while(numChildren) {
						removeChildAt(0);
					}
					printError(error.message);
					trace(error.getStackTrace());					
				}				
				
			}catch (error:Error) {				
				while(numChildren) {
					removeChildAt(0);
				}				
				addChild(new ModuleInfoPrinter(_moduleDescription, aboutThisModule));
				trace(error.getStackTrace());
			}
		}	
		
		protected function moduleReady():void {			
			throw new Error("Function moduleReady() must be overrided by this module");
		}						
		
		// used by module
		protected final function get moduleData():ModuleData {			
			return _moduleData;
		}
		
		// used by Manager
		public final function get moduleDescription():ModuleDescription {
			return _moduleDescription;
		}
		
		// used by other modules  
		public final function execute(functionName:String, args:Array):*{			
			return (this[functionName] as Function).apply(this, args);
		}							
		
		///////////////////////////////////////////////////////////////////////////////////////////////////
		// Following Functions are avaible for module
		// also module can access any public functions and variables of SaladoPlayer
		// including manager that extends PanoSalado e.g. panoSalado.manager.swingToChild(...)
		// or managerData e.g. panoSalado.managerData.getActionDataById("someid")
		// module should not import any classes from com.panozona.player.manager or from com.panosalado
		// (those classes will change in time and module may loose compatibility)
		// instead, module should get variables as Objects and catch potential errors
		///////////////////////////////////////////////////////////////////////////////////////////////////
		
		public final function moduleExists(moduleName:String):Boolean{
			return (saladoPlayer.getModuleByName(moduleName) != null);
		} 
		
		public final function executeModule(moduleName:String, functionName:String, args:Array):*{
			return saladoPlayer.getModuleByName(moduleName).execute(functionName, args);
		} 		
		
		public final function get debugging():Boolean {
			return saladoPlayer.managerData.debugging;
		}
		
		public final function printError(msg:String):void {
			if(tracer != null){
				tracer.printError(_moduleDescription.moduleName+": "+msg);
			}
		}
		
		public final function printWarning(msg:String):void {
			if(tracer != null){
				tracer.printWarning(_moduleDescription.moduleName+": "+msg);
			}
		}
		
		public final function printInfo(msg:String):void {
			if(tracer != null){
				tracer.printInfo(_moduleDescription.moduleName+": "+msg);
			}
		}
	}
}