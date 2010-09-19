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
package com.panozona.player.manager.data {
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class AbstractModuleData {
		
		private var _moduleName:String;
		private var _path:String;
		private var _weight:int;
		private var _abstractModuleNodes:Array;
		
		public function AbstractModuleData(moduleName:String, path:String, weight:int) {
			
			if ( path==null || path=="") {
				throw new Error("No path specified for module: "+moduleName);
			}
			
			_moduleName = moduleName;
			_path = path;
			_weight = weight;
			_abstractModuleNodes =  new Array();
		}
		
		public function get moduleName():String {
			return _moduleName;
		}
		
		public function get path():String {
			return _path;
		}
		
		public function get weight():int {
			return _weight;
		}
		
		public function get abstractModuleNodes():Array {
			return _abstractModuleNodes;
		}
	}
}