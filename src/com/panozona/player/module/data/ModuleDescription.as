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
	 * Description declared by module, contains name version and exposed functions. 
	 * It may also contain additional data like athor name, email address or url to site with documentation.
	 * Functions are described with object where key is name of function and value is array of classes 
	 * (Boolean, Number, String or Array of Strings), that describes arguments of function. 
	 * 
	 * @author mstandio
	 */
	public class ModuleDescription {
		
		private var _moduleName:String;
		private var _moduleVersion:Number;
		private var _moduleAuthor:String;
		private var _moduleAuthorContact:String;
		private var _moduleHomeUrl:String;
		
		private var _functionsDescription:Object;
		
		/**
		 * All values beside of function descriptions can be set only through constructor.
		 * 
		 * @param	moduleName mandatory name of module author
		 * @param	moduleVersion mandatory version of module
		 * @param	moduleAuthor optional name of author
		 * @param	moduleAuthorContact optional email address
		 * @param	moduleHomeUrl optional url address containing module description
		 */
		public function ModuleDescription(moduleName:String, moduleVersion:Number, moduleAuthor:String = null, moduleAuthorContact:String = null, moduleHomeUrl:String = null) {
			_moduleName = moduleName;
			_moduleVersion = moduleVersion;
			_moduleAuthor = moduleAuthor;
			_moduleAuthorContact = moduleAuthorContact;
			_moduleHomeUrl = moduleHomeUrl;
			_functionsDescription = new Object();
		}
		
		/**
		 * Module name, mandatory value
		 */
		public function get moduleName():String {
			return _moduleName;
		}
		
		/**
		 * Module version, mandatory value
		 */
		public function get moduleVersion():Number{
			return _moduleVersion;
		}
		
		/**
		 * Module author, default null
		 */
		public function get moduleAuthor():String{
			return _moduleAuthor;
		}
		
		/**
		 * Email address to module author, default null
		 */
		public function get moduleAuthorContact():String{
			return _moduleAuthorContact;
		}
		
		/**
		 *  Url to site containing module description, default null
		 */
		public function get moduleHomeUrl():String{
			return _moduleHomeUrl;
		}
		
		/**
		 *  Object with String keys for function names where values are Arrays of Classes (Boolean, Number, String or Function), that describe functions parameters.
		 */
		public function get functionsDescription():Object{
			return _functionsDescription;
		}
		
		/**
		 * Used for adding descriptions of module functions that are recognized by SaladoPlayer.
		 * Usage of this function is supposed to be hard-coded into module constructor.
		 * For instance foo(arg1:Boolean, arg2:Number, arg3:String, arg4:Function) should be added as folows:
		 * addFunctionDescription("foo", Boolean, Number, String, Function)
		 * 
		 * @param	functionName name of added function
		 * @param	... args classes, only allowed classes are Boolean, Number, String and Function
		 */
		public function addFunctionDescription(functionName:String, ... args):void {
	
			_functionsDescription[functionName] = new Array;
			
			for(var i:int = 0; i < args.length; i++){
				if (args[i] === Boolean ||  args[i] === Number || args[i] === String || args[i] === Function) {
					(_functionsDescription[functionName])[i] = args[i];
				}else {
					throw new Error("Ivalid "+(i+1)+". argument in: "+functionName); 
				}
			}
		}
	}
}