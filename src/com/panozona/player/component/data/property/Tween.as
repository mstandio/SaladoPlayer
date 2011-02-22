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
package com.panozona.player.component.data.property{
	
	public class Tween {
		
		private var _transition:Function;
		private var _time:Number;
		
		public function Tween(transition:Function, time:Number){
			_transition = transition;
			_time = time;
		}
		
		/**
		 * Null value is discarded.
		 */
		public final function get transition():Function {
			return _transition;
		}
		
		/**
		* @private
		*/
		public final function set transition(value:Function):void {
			if (value == null) return;
			_transition = value;
		}
		
		/**
		 * Value less than 0 is discarded.
		 */
		public final function get time():Number{
			return _time;
		}
		
		/**
		* @private
		*/
		public final function set time(value:Number):void {
			if (value < 0) return;
			_time = value;
		}
	}
}