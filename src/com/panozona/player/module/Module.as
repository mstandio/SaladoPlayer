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
	 * Class implements all featuers nessesery for SaladoPlayer to recognize *.swf file as module. 
	 * It also provides SaladoPlayer reference and some other usefull functions. 
	 * In order to implement module, you need to extend this class, set module name and version and override moduleReady function. 
	 * @author mstandio
	 */
	public class Module extends Sprite {
		
		/**
		 * Ready to use SaladoPlayer reference.
		 */
		protected var saladoPlayer:Object;
		
		/**
		 * Short description displayed when module is opened as standalone *.swf file
		 */
		protected var aboutThisModule:String; 
		
		private var _moduleData:ModuleData;
		private var _moduleDescription:ModuleDescription;
		private var _tracer:Object; 
		
		/**
		 * Constructor. 
		 * Creates module description, ads module to stage, obtains reference to Saladoplayer and gets from it raw module configuration data.
		 * 
		 * @param	moduleName Name of module. It is nessesery for obtaining configuration data from Saladoplayer 
		 * @param	moduleVersion Version of module. It is nessesery for convinience reasons.
		 * @param	moduleAuthor Name of module author - optional
		 * @param	moduleAuthorContact email addredd of module author - optional
		 * @param	moduleHomeUrl url to site containing documentation for module - optional
		 */
		public final function Module(moduleName:String, moduleVersion:Number, moduleAuthor:String = null, moduleAuthorContact:String = null, moduleHomeUrl:String = null) {
			
			_moduleDescription = new ModuleDescription(moduleName, moduleVersion, moduleAuthor, moduleAuthorContact, moduleHomeUrl);
			
			aboutThisModule = "This is SaladoPlayer module."; // default information
			
			addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}
		
		private function stageReady(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			try {
				
				var SaladoPlayerClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.SaladoPlayer") as Class;
				saladoPlayer = this.parent as SaladoPlayerClass;				
				
				var TraceClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.utils.Trace") as Class;
				_tracer = saladoPlayer.tracer as TraceClass;
				
				_moduleData = new ModuleData(saladoPlayer.managerData.getAbstractModuleDataByName(_moduleDescription.moduleName));
				
				try {
					
					moduleReady(_moduleData);
					
				}catch (error:Error) { // error in module ready function, possibly coused by configuration inconsistency
					
					while(numChildren) {removeChildAt(0);}
					printError(error.message);
					trace(error.getStackTrace());
				}
			
			}catch (error:Error) { // could not obtain SaladoPlayer or trace window reference
				
				while(numChildren){removeChildAt(0);}
				addChild(new ModuleInfoPrinter(_moduleDescription, aboutThisModule)); 
				trace(error.getStackTrace());
			}
			
			_moduleDescription = null;
			_moduleData = null;
		}
		
		/**
		 * Entry point for module, at this point module is allready added to stage and it obtained reference to Saladoplayer.
		 * In this function raw configuration should be parsed and validated, in case of any problems errors should be mercylessly thrown.
		 * Function is surrounded with try - catch block, in case of any errors all children will be removed and error will be printed in trace window as well as in standard trace.				 
		 * @param	moduleData Raw module configuration data.
		 */
		protected function moduleReady(moduleData:ModuleData):void {
			throw new Error("Function moduleReady() must be overriden by this module.");
		}
		
		/**
		 * Alter module description by adding descriptions of exposed functions.
		 * Exposed function will be recognized by SaladoPlayer validator. 
		 * Module description can be modified only in constructor.
		 */
		public final function get moduleDescription():ModuleDescription {
			return _moduleDescription;
		}
		
		/**
		 * Used by SaladoPlayer to execute functions on module. It can also be used by other modules.
		 * 
		 * @param	functionName name of module function
		 * @param	args Array of arguments applied to module function
		 * @return  any type returned by given function
		 */
		public final function execute(functionName:String, args:Array):*{
			return (this[functionName] as Function).apply(this, args);
		}
		
		/**
		 * Determines if SaladoPlayer runs in debug mode. This value is supposed to use for skipping consistency checking and validation.
		 */
		public final function get debugMode():Boolean {
			return saladoPlayer.managerData.debugMode;
		}
		
		/**
		 * Width of panorama window. It should be used instead of stage.stageWidth in case when SaladoPlayer is emebeded into another *.swf file
		 */
		public final function get boundsWidth():Number {
			return saladoPlayer.manager.boundsWidth;
		}
		
		/**
		 * Height of panorama window. It should be used instead of stage.stageHeight in case when SaladoPlayer is emebeded into another *.swf file
		 */
		public final function get boundsHeight():Number {
			return saladoPlayer.manager.boundsHeight;
		}
		
		/**
		 * Prints message in green text in trace window, printing information does not trigger trace window open.
		 * @param	message
		 */
		public final function printInfo(message:String):void {
			if(_tracer != null){
				_tracer.printInfo(_moduleDescription.moduleName+": "+message);
			}
		}
		
		/**
		 * Prints message in yellow text in trace window, printing warning triggers trace window open.
		 * @param	message
		 */
		public final function printWarning(message:String):void {
			if(_tracer != null){
				_tracer.printWarning(_moduleDescription.moduleName+": "+message);
			}
		}
		
		/**
		*  Prints message in red text in trace window, printing error triggers trace window open.
		 * @param	message
		 */
		public final function printError(message:String):void {
			if(_tracer != null){
				_tracer.printError(_moduleDescription.moduleName+": "+message);
			}
		}
	}
}