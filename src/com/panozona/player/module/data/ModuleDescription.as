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
		private var _version:Number;
		private var _functionsDescription:Object;
		
		/**
		 * Name and version are supposed to be hard-coded into module
		 * 
		 * @param	name 
		 * @param	version 
		 */
		public function ModuleDescription(moduleName:String, version:Number) {
			_moduleName = moduleName;
			_version = version;
			_functionsDescription = new Object();
		}		
		
		public function get moduleName():String {
			return _moduleName;
		}
		
		public function get version():Number{
			return _version;
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
			
			_functionsDescription[functionName] = new Vector.<Class>();
			
			for(var i:int=0; i<args.length;i++){
				if (args[i] === String ||  args[i] === Number || args[i] === Boolean || args[i] === Array) {
					Vector.<Class>(_functionsDescription[functionName])[i] = args[i];					
				}else {
					throw new Error("Ivalid " + (i + 1) + ". argument in " + functionName); 
				}
			}
		}
		
		
		/**
		 * Returns readable module description that is displayed when module
		 * is launched as separate file or when it is not loaded properly. 
		 * 
		 * @return String
		 */
		public function printDescription():String{
			var result:String ="";
			result += _moduleName;
			result += " v" + (( Number(_version.toFixed(1)) == _version)?_version.toFixed(1):_version.toFixed(2));
			if(this.getFunctionsNames().length > 0){
				result += "\n\nexposed functions: ";
				for (var functionName:String in _functionsDescription) {
					result += "\n  "+functionName + "(";
					for each(var _class:Class in Vector.<Class>(_functionsDescription[functionName])) {
						result += (_class===Boolean?"Boolean":(_class===Number?"Number":(_class===String?"String":(_class===Array?"Array":"Error!"))))+ ",";
					}
					if (result.lastIndexOf(",") == result.length-1) {
						result = result.substring(0, result.length - 1);						
					}			
					result += ")";
				}			
				
			}else {
				result += "\nno exposed functions";
			}
			return result;
		}
		
		private function getFunctionsNames():Array{
			var result:Array = new Array();
			for each(var functionName:String in _functionsDescription) {
				result.push(functionName);
			}
			return result;
		}
	}
}