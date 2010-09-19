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
package com.panozona.player.module.data{
	
	/**
	 * Description declared by module, contains name version and exposed functions 	 
	 * Functions are described in object where key is name of function and value is vector of classes
	 * (Boolean, Number, String or Array of Strings), that describes arguments of function. 
	 * 
	 * @author mstandio
	 */
	public class ModuleDescription {
		
		private var _moduleName:String;
		private var _moduleVersion:Number;
		private var _moduleAuthor:String;
		private var _moduleHomeUrl:String;
		
		private var _functionsDescription:Object;
		
		/**
		 * Name and version are supposed to be hard-coded into module
		 * 
		 * @param	name 
		 * @param	version 
		 * @param	moduleHomeUrl 
		 */
		public function ModuleDescription(moduleName:String, moduleVersion:Number, moduleAuthor:String, moduleHomeUrl:String) {
			_moduleName = moduleName;
			_moduleVersion = moduleVersion;
			_moduleAuthor = moduleAuthor;
			_moduleHomeUrl = moduleHomeUrl;
			_functionsDescription = new Object();
		}		
		
		public function get moduleName():String {
			return _moduleName;
		}
		
		public function get moduleVersion():Number{
			return _moduleVersion;
		}
		
		public function get moduleAuthor():String{
			return _moduleAuthor;
		}
		
		public function get moduleHomeUrl():String{
			return _moduleHomeUrl;
		}		
		
		public function get functionsDescription():Object{
			return _functionsDescription;
		}		
		
		/**
		 * Allows adding exposed function description. 		 
		 * Usage of this function is supposed to be hard-coded into module, it throws errors that are not supposed to be cought.
		 * For instance foo(arg1:Boolean, arg2:Number, arg3:String, arg4:Array) should be added as folows:
		 * addFunctionDescription("foo", Boolean, Number, String, Array)		 
		 * 
		 * @param	functionName
		 * @param	... args
		 */
		public function addFunctionDescription(functionName:String, ... args):void {
			if (functionName == null || functionName == "" || !functionName.match(/[\w]+/)) {
				throw new Error("Invalid function name: "+functionName);
			}
			if (functionsDescription.hasOwnProperty(functionName)) {
				throw new Error("Function allready described: "+functionName);
			}		
			
			_functionsDescription[functionName] = new Array;
			
			for(var i:int=0; i<args.length;i++){
				if (args[i] === Boolean ||  args[i] === Number || args[i] === String ) {
					(_functionsDescription[functionName])[i] = args[i];					
				}else {
					throw new Error("Ivalid " + (i + 1) + ". argument in " + functionName); 
				}
			}
		}		
		
		public function getFunctionsNames():Array{
			var result:Array = new Array();
			for each(var functionName:String in _functionsDescription) {
				result.push(functionName);
			}
			return result;
		}
	}
}