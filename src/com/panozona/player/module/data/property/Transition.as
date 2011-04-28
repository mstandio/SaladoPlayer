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
package com.panozona.player.module.data.property{
	
	public class Transition{
		
		public static const FADE:String = "fade";
		public static const SLIDE_UP:String = "slideUp";
		public static const SLIDE_DOWN:String = "slideDown";
		public static const SLIDE_LEFT:String = "slideLeft";
		public static const SLIDE_RIGHT:String = "slideRight";
		
		private var _type:String;
		
		public function Transition(value:String){
			this.type = value;
		}
		
		public final function get type():String {
			return _type;
		}
		
		public final function set type(value:String):void{
			if (value == Transition.FADE || value == Transition.SLIDE_UP
				|| value == Transition.SLIDE_DOWN || value == Transition.SLIDE_LEFT
				|| value == Transition.SLIDE_RIGHT) {
				_type = value;
			}else {
				throw new Error("Unrecognized transition value: " + value);
			}
		}
	}
}