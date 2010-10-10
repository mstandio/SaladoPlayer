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
package com.panozona.player.manager.data.module{
	
	/**
	 * This class is used to copy module description data from loaded module,
	 * so that it can be used by validator.
	 * 
	 * @author mstandio
	 */
	public class AbstractModuleDescription {
		
		private var _moduleName:String;
		private var _functionsDescription:Object;
		
		/**
		 * Constructor.
		 * 
		 * @param	moduleDescription Object copied from loaded module.
		 */
		public function AbstractModuleDescription(moduleDescription:Object) {
			if (moduleDescription.hasOwnProperty("moduleName")) {
				_moduleName = moduleDescription["moduleName"];
			}else {
				throw new Error("No module name in module description.");
			}
			if (moduleDescription.hasOwnProperty("functionsDescription")) {
				_functionsDescription = moduleDescription["functionsDescription"];
			}else {
				throw new Error("No functions in module description.");
			}
		}
		
		/**
		 * Name decalred by module.
		 */
		public function get moduleName():String {
			return _moduleName;
		}
		
		/**
		 * Object where keys are functions names and values are arrays of classes: Boolean, Number, String, Object or Function.
		 */
		public function get functionsDescription():Object{
			return _functionsDescription;
		}
	}
}