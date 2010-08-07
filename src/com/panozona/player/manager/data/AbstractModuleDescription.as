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
package com.panozona.player.manager.data{
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class AbstractModuleDescription {
		
		private var _moduleName:String;
		private var _moduleVersion:Number;
		private var _functionsDescription:Object;		
		
		public function AbstractModuleDescription(moduleDescription:Object) {			
			if (!moduleDescription.hasOwnProperty("moduleName")) {
				throw new Error("No module name in module description");				
			}else {
				_moduleName = moduleDescription["moduleName"];
			}
			
			if (!moduleDescription.hasOwnProperty("moduleVersion")) {
				throw new Error("No module version in module description");				
			}else {
				_moduleVersion = moduleDescription["moduleVersion"];
			}			
			
			if (!moduleDescription.hasOwnProperty("functionsDescription")) {
				throw new Error("No functions in module description");
			}else {
				_functionsDescription = moduleDescription["functionsDescription"];				
			}
		}
		
		public function get moduleName():String {
			return _moduleName;
		}
		
		public function get moduleVersion():Number {
			return _moduleVersion;
		}		
		
		public function get functionsDescription():Object{
			return _functionsDescription;
		}							
	}
}