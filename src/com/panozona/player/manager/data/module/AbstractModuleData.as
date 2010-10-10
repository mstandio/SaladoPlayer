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
package com.panozona.player.manager.data.module {
	
	/**
	 * Stores data obtained from i.e. *.xml configuration.
	 * Data is used to load, arrange, and configure modules.
	 * 
	 * @author mstandio
	 */
	public class AbstractModuleData {
		
		private var _moduleName:String;
		private var _path:String;
		private var _weight:int;
		private var _abstractModuleNodes:Array;
		
		/**
		 * Constructor
		 * 
		 * @param moduleName Name of module
		 * @param path Path to module .*swf file
		 * @param weight Determines sequence of modules
		 */	
		public function AbstractModuleData(moduleName:String, path:String, weight:int) {
			_moduleName = moduleName;
			_path = path;
			_weight = weight;
			_abstractModuleNodes =  new Array();
		}
		
		/**
		 * Name of module. Module stores its name as seperate var, it is not identical to DisplayObject name or *.swf file name
		 */
		public function get moduleName():String {
			return _moduleName;
		}
		
		/**
		 * Points to module *.swf file.
		 */
		public function get path():String {
			return _path;
		}
		
		/**
		 * Determines sequence of modules. For instance module with weight 0 will be positioned most ontop.
		 */
		public function get weight():int {
			return _weight;
		}
		
		/**
		 * Stores tree structure of module configuration.
		 */
		public function get abstractModuleNodes():Array {
			return _abstractModuleNodes;
		}
	}
}