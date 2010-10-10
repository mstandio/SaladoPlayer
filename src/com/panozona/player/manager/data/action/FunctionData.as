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
package com.panozona.player.manager.data.action {
	
	/**	 
	 *  Stores data about functions to be executed on given events.
	 *  Owner of the function can be either SaladoPlayer, or some module.
	 *  FunctionData is stored by ActionData.
	 * 
	 * @author mstandio
	 */
	public class FunctionData {
		
		private var _owner:String;
		private var _name:String;
		private var _args:Array;
		
		/**
		 * Constructor. 
		 * 
		 * @param	owner function description 
		 * @param	name function description 
		 */
		public function FunctionData(owner:String, name:String){
			_owner = owner;
			_name = name;
			_args = new Array();
		}	
		
		/**
		 * Determines what object is called to execute function.
		 */
		public function get owner():String {
			return _owner;
		}
		
		/**
		 * Determines what is name of executed function.
		 */
		public function get name():String {
			return _name;
		}
		
		/**
		 * Array of arguments that can be taken by function.
		 */
		public function get args():Array {
			return _args;
		}
	}
}