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
	import flash.display.*;
	import flash.events.*;
	import flash.system.*;
	
	public class Module extends Sprite {
		
		protected var functionDataClass:Class;
		
		private var _saladoPlayer:Object;
		private var _moduleDescription:ModuleDescription;
		
		/**
		 * Constructor creates moduleDescription instance and performs, and performs stage ready check.
		 * Once Module is added to stage it sets reference to SaladoPlayer and calls moduleReady function 
		 * with argument of ModuleData object containing configuration data.
		 * @param	moduleName
		 * @param	moduleVersion
		 * @param	homeUrl
		 */
		public function Module(moduleName:String, moduleVersion:String, homeUrl:String) {
			_moduleDescription = new ModuleDescription(moduleName, moduleVersion, homeUrl);
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}
		
		private function stageReady(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			var _moduleData:ModuleData;
			try {
				functionDataClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.data.actions.FunctionData") as Class;
				var SaladoPlayerClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.SaladoPlayer") as Class;
				_saladoPlayer = this.parent as SaladoPlayerClass;
				_moduleData = _saladoPlayer.managerData.getModuleDataByName(_moduleDescription.name) as ModuleData;
			}catch (error:Error) {
				trace(error.message);
				trace(error.getStackTrace());
			}
			try {
				_saladoPlayer.traceWindow.printLink(_moduleDescription.homeUrl, _moduleDescription.name + " " + _moduleDescription.version);
				moduleReady(_moduleData);
			}catch (error:Error) {
				while (numChildren) {removeChildAt(0);}
				printError(error.message);
				trace(error.message);
				trace(error.getStackTrace());
			}
		}
		
		/**
		 * This function has to be overriden by Module descendant. 
		 * At the point when this function is called, module is allready constructed
		 * added to stage and SaladoPlayer reference is ready to be used.
		 * @param	moduleData
		 */
		protected function moduleReady(moduleData:ModuleData):void {
			throw new Error("Function moduleReady() must be overriden.");
		}
		
		public function execute(functionData:Object):void {
			if(functionData is functionDataClass && _moduleDescription.functionsDescription.hasOwnProperty(functionData.name)) {
				(this[functionData.name] as Function).apply(this, functionData.args);
			}
		}
		
		/**
		 * SaladoPlayer reference avaible since moduleReady is called.
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