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
package com.panozona.player.manager.data.actions{
	
	/**
	 * Stores function description: function owner, target, function name and function arguments.
	 * Same as in FunctionData but owner can be only a Factory and target referrs to factory product.
	 * For instance: owner[target].name(arguments)
	 * 
	 * @see FunctionData
	 */
	public class TargetFunctionData extends FunctionData{
		
		private var _target:String;
		
		public function TargetFunctionData(owner:String, target:String, name:String) {
			super (owner, name);
			_target = target;
		}
		
		public function get target():String {
			return _target;
		}
	}
}