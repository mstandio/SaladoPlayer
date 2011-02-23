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
package com.panozona.player.module{
	
	import com.panozona.player.module.data.*;
	import com.panozona.player.module.utils.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	public class Module extends Sprite {
		
		private var _moduleData:ModuleData;
		private var _moduleDescription:ModuleDescription;
		private var _saladoPlayer:Object;
		
		protected var functionDataClass:Class;
		
		/**
		 * Reference set by SaladoPlayer when module is accepted.
		 * Calls moduleReady overriden by descendant. 
		 * function moduleReady is surrounded with try/catch
		 */
		public function Module(moduleName:String, moduleVersion:String){
			_moduleDescription = new ModuleDescription(moduleName, moduleVersion);
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}
		
		private function stageReady(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			try {
				functionDataClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.data.actions.FunctionData") as Class;
				var SaladoPlayerClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.SaladoPlayer") as Class;
				_saladoPlayer = this.parent as SaladoPlayerClass;
				_moduleData = _saladoPlayer.managerData.getModuleDataByName(_moduleDescription.name) as ModuleData;
			}catch (error:Error) {
				trace("Try: " + _moduleDescription.homeUrl);
				trace(error.getStackTrace());
				trace(error.getStackTrace());
			}
			try {
				moduleReady(_moduleData);
			}catch (error:Error) {
				while (numChildren) {removeChildAt(0);}
				_saladoPlayer.traceWindow.printError(error.message);
				trace(error.getStackTrace());
			}
		}
		
		protected function moduleReady(moduleData:ModuleData):void {
			throw new Error("Function moduleReady() must be overriden.");
		}
		
		public function execute(functionData:Object):void {
			if(functionData is functionDataClass && moduleDescription.functionsDescription.hasOwnProperty(functionData.name)) {
				(this[functionData.name] as Function).apply(this, functionData.args);
			}
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
		public final function get moduleDescription():ModuleDescription{
			return _moduleDescription;
		}
		
		/**
		 * Prints message in green text in trace window.
		 * Printing "info" does not trigger trace window open.
		 * @param message
		 */
		public final function printInfo(message:String):void {
			_saladoPlayer.traceWindow.printInfo(_moduleDescription.name + ": " + message);
		}
		
		/**
		 * Prints message in yellow text in trace window.
		 * Printing warning triggers trace window open.
		 * @param message
		 */
		public final function printWarning(message:String):void {
			_saladoPlayer.traceWindow.printWarning(_moduleDescription.name + ": " + message);
		}
		
		 /**
		 * Prints message in red text in trace window.
		 * Printing error triggers trace window open.
		 * @param message
		 */
		public final function printError(message:String):void {
			_saladoPlayer.traceWindow.printError(_moduleDescription.name + ": " + message);
		}
	}
}