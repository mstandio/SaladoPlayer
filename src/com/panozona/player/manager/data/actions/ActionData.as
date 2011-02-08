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
package com.panozona.player.manager.data.actions {
	
	/**
	 * It is identified by id unique among other actions.
	 * Stores vector of function descriptions.
	 */
	public class ActionData{
		
		public const functions:Vector.<FunctionData> = new Vector.<FunctionData>();
		private var _id:String;
		
		public function ActionData(id:String) {
			_id = id;
		}
		
		public function get id():String {
			return _id;
		}
	}
}