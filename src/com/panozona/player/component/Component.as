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
along with SaladoPlayer.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.player.component{
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	public class Component extends Sprite {
		
		/**
		 * Short description displayed when module is opened as standalone *.swf file
		 */
		protected var aboutThisComponent:String; 
		
		private var _componentData:ComponentData;
		private var _componentDescription:ComponentDescription;
		private var _saladoPlayer:Object;
		
		
		public function Component(componentName:String, componentVersion:String, homeUrl:String){
			_componentDescription = new ComponentDescription(componentName, componentVersion, homeUrl);
			aboutThisComponent = "This is SaladoPlayer 1.x component."; // default information
			addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}
		
		private function stageReady(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			try {
				var SaladoPlayerClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.SaladoPlayer") as Class;
				_saladoPlayer = this.parent as SaladoPlayerClass;
				_moduleData = new ModuleData(saladoPlayer.managerData.getAbstractModuleDataByName(_moduleDescription.moduleName));
				try {
					moduleReady(_moduleData);
				}catch (error:Error) { // error in module ready function, possibly coused by configuration inconsistency
					while(numChildren) {removeChildAt(0);}
					printError(error.message);
					trace(error.getStackTrace());
				}
			}catch (error:Error) { // could not obtain SaladoPlayer reference
				while(numChildren){removeChildAt(0);}
				//addChild(new ModuleInfoPrinter(_moduleDescription));
				trace(error.getStackTrace());
			}
		}
		
		/**
		 * Entry point for component, at this point it is allready added to stage and it obtained reference to Saladoplayer.
		 * In this function raw configuration should be parsed and validated. Function is surrounded with try - catch block
		 * in case of any errors all children will be removed and error will be printed in [trace] window as well as in 
		 * standard trace.
		 * @param	moduleData Raw module configuration data.
		 */
		protected function componentReady(componentData:ComponentData):void {
			throw new Error("Function componentReady() must be overriden by this component.");
		}
		/**
		 * Ready to use SaladoPlayer reference.
		 */
		public final function get saladoPlayer():Object {
			return _saladoPlayer;
		}
		
		/**
		 * Alter module description by adding descriptions of exposed functions.
		 * Exposed function will be recognized by SaladoPlayer validator. 
		 * Module description can be modified only in constructor.
		 */
		public final function get componentDescription():ComponentDescription{
			return _componentDescription;
		}
		
		/**
		 * Determines if SaladoPlayer runs in debug mode. 
		 * This value is supposed to be used for skipping consistency checking and validation.
		 */
		public final function get debugMode():Boolean {
			return saladoPlayer.managerData.debugMode;
		}
		
		/**
		 * Width of panorama window. It should be used instead of stage.stageWidth - 
		 * in case when SaladoPlayer is emebeded into another *.swf file
		 */
		public final function get boundsWidth():Number {
			return saladoPlayer.manager.boundsWidth;
		}
		
		/**
		 * Height of panorama window. It should be used instead of stage.stageHeight -
		 * in case when SaladoPlayer is emebeded into another *.swf file
		 */
		public final function get boundsHeight():Number {
			return saladoPlayer.manager.boundsHeight;
		}
		
		/**
		 * Used by SaladoPlayer to execute functions on module. It can also be used by other modules.
		 * 
		 * @param	functionName name of module function
		 * @param	args Array of arguments applied to module function
		 * @return  any type returned by given function
		 */
		public final function execute(functionName:String, args:Array):*{ // tutaj trzeba bedzie podejsc inaczej ...
			if(_componentDescription.functionsDescription.hasOwnProperty(functionName)) {
				return (this[functionName] as Function).apply(this, args);
			}
		}
		
		/**
		 * Prints message in green text in trace window.
		 * Printing "info" does not trigger trace window open.
		 * @param	message
		 */
		public final function printInfo(message:String):void {
			_saladoPlayer.traceWindow.printInfo(_componentDescription.name + ": " + message);
		}
		
		/**
		 * Prints message in yellow text in trace window.
		 * Printing warning triggers trace window open.
		 * @param	message
		 */
		public final function printWarning(message:String):void {
			_saladoPlayer.traceWindow.printWarning(_componentDescription.name + ": " + message);
		}
		
		/**
		 * Prints message in red text in trace window.
		 * Printing error triggers trace window open.
		 * @param	message
		 */
		public final function printError(message:String):void {
			_saladoPlayer.traceWindow.printError(_componentDescription.name + ": " + message);
		}
	}
}