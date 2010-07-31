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
	 * Action has its unique amogng other actions id
	 * It also contains array of functions executed sequentally
	 * 
	 * @author mstandio
	 */
	public class ActionData{
		
		private var _id:String;
		private var _functions:Vector.<FunctionData>;
		
		public function ActionData(id:String) {
			if (id == null || id == "") {
				throw new Error("No id for action");
			}					
			_id = id;
			_functions = new Vector.<FunctionData>();
		}
		
		public function get id():String{
			return _id;
		}
		
		public function get functions():Vector.<FunctionData> {
			return _functions;
		}
	}
}