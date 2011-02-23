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
along with SaladoPlayer. If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.player.module.utils{
	
	public class ModuleDescription {
		
		/**
		 * Object where keys are function names 
		 * values are Vectors of Classes 
		 * (Boolean, Number, String or Function),
		 * that describe functions parameters.
		 */
		public const functionsDescription:Object = new Object();
		
		private var _name:String;
		private var _version:String;
		private var _homeUrl:String;
		
		/**
		 * @param	name mandatory module name
		 * @param	version mandatory module version
		 * @param	homeUrl optional url address containing module description
		 */
		public function ModuleDescription(name:String, version:String, homeUrl:String = null) {
			_name = name;
			_version = version;
			_homeUrl = homeUrl;
		}
		
		public final function get name():String {
			return _name;
		}
		
		public final function get version():String{
			return _version;
		}
		
		public final function get homeUrl():String{
			return _homeUrl;
		}
		
		/**
		 * Used for adding descriptions of module functions that are recognized by SaladoPlayer.
		 * Usage of this function is supposed to be hard-coded into module constructor.
		 * For instance function foo(arg1:Boolean, arg2:Number, arg3:String, arg4:Function) 
		 * should be added as folows: addFunctionDescription("foo", Boolean, Number, String, Function);
		 * 
		 * @param	functionName name of added function
		 * @param	... args classes, only allowed classes are Boolean, Number, String and Function
		 */
		public function addFunctionDescription(functionName:String, ... args):void {
			
			functionsDescription[functionName] = new Vector.<Class>;
			
			for(var i:int = 0; i < args.length; i++){
				if (args[i] === Boolean ||  args[i] === Number || args[i] === String || args[i] === Function) {
					(functionsDescription[functionName])[i] = args[i];
				}else {
					throw new Error("Ivalid " + (i + 1) + ". argument in: " + functionName); 
				}
			}
		}
	}
}