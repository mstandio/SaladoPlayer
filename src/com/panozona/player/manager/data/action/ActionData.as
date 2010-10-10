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
	 * It is identified by id unique among other actions.  
	 * Stores array of functions descriptions obtained from i.e. *.xml configuration.
	 * Execution of action couses execution of all described functions, one afer another.
	 * 
	 * @author mstandio
	 */
	public class ActionData{
		
		/**
		 * Action identyfier, unique among other actions.
		 */
		public var id:String;
		
		private var _functions:Vector.<FunctionData>;
		
		/**
		 * Constructor
		 */
		public function ActionData() {
			_functions = new Vector.<FunctionData>();
		}
		
		/**
		 * Vector of FunctionData objects.
		 */
		public function get functions():Vector.<FunctionData> {
			return _functions;
		}
	}
}