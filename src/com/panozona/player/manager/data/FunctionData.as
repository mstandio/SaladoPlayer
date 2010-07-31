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
	 *  
	 * 
	 * @author mstandio
	 */
	public class FunctionData {
		
		private var _owner:String;  // what will be called to execute function
		private var _name:String;   // name of executed function
		private var _args:Array;  // arguments of function
		
		public function FunctionData(owner:String, name:String){			
			
			if (owner == null || owner == "" ) {
				throw new Error("Function has no owner");
			}			
			
			if (name == null || name == "") {
				throw new Error("Function has no name");
			}			
			
			_owner = owner;
			_name = name;			
			_args = new Array();
		}	
	    		
		public function get owner():String {
			return _owner;
		}		
		
		
		public function get name():String {
			return _name;
		}
		
		public function get args():Array {
			return _args;
		}
	}
}