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
	
	import com.panozona.player.component.data.*;
	import com.panozona.player.component.utils.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	public class Component extends Sprite {
		
		private var _componentData:ComponentData;
		private var _componentDescription:ComponentDescription;
		private var _saladoPlayer:Object;
		
		/**
		 * Reference set by SaladoPlayer when component is accepted.
		 * Calls componentReady overriden by descendant. 
		 * function componentReady is surrounded with try/catch
		 */
		public function Component(componentName:String, componentVersion:String){
			_componentDescription = new ComponentDescription(componentName, componentVersion);
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}
		
		private function stageReady(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			try{
				var SaladoPlayerClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.SaladoPlayer") as Class;
				_saladoPlayer = this.parent as SaladoPlayerClass;
				_componentData = _saladoPlayer.managerData.getComponentDataByName(_componentDescription.name) as ComponentData;
			}catch (error:Error) {
				trace("Try: " + _componentDescription.homeUrl);
				trace(error.getStackTrace());
				trace(error.getStackTrace());
			}
			try {
				componentReady(_componentData);
			}catch (error:Error) {
				while (numChildren) {removeChildAt(0);}
				_saladoPlayer.traceWindow.printError(error.message);
				trace(error.getStackTrace());
			}
		}
		
		protected function componentReady(componentData:ComponentData):void {
			throw new Error("Function componentReady() must be overriden.");
		}
		
		public function execute(functionData:Object):void {
			throw new Error("Function extecute() must be overriden.");
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
		 * Prints message in green text in trace window.
		 * Printing "info" does not trigger trace window open.
		 * @param message
		 */
		public final function printInfo(message:String):void {
			_saladoPlayer.traceWindow.printInfo(_componentDescription.name + ": " + message);
		}
		
		/**
		 * Prints message in yellow text in trace window.
		 * Printing warning triggers trace window open.
		 * @param message
		 */
		public final function printWarning(message:String):void {
			_saladoPlayer.traceWindow.printWarning(_componentDescription.name + ": " + message);
		}
		
		 /**
		 * Prints message in red text in trace window.
		 * Printing error triggers trace window open.
		 * @param message
		 */
		public final function printError(message:String):void {
			_saladoPlayer.traceWindow.printError(_componentDescription.name + ": " + message);
		}
	}
}