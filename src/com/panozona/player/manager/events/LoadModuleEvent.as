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
package com.panozona.player.manager.events {
	
	import flash.events.Event;
	import flash.display.DisplayObject;
	
	/**
	 * 
	 * 
	 * @author mstandio
	 */
	public class LoadModuleEvent extends Event {
		
		public static const MODULE_LOADED:String = "moduleLoaded";
		public static const ALL_MODULES_LOADED:String = "allModulesLoaded";
		
		/**
		 * 
		 */
		public var moduleName:String;
		
		/**
		 * 
		 */
		public var weight:int;
		
		/**
		 * 
		 */
		public var module:DisplayObject;
		
		/**
		 * 
		 * @param	type
		 * @param	moduleName
		 * @param	weight
		 * @param	module
		 */
		public function LoadModuleEvent(type:String, moduleName:String, weight:int, module:DisplayObject) {
			super(type);
			this.moduleName = moduleName;
			this.weight = weight;
			this.module = module;
		}
	}
}