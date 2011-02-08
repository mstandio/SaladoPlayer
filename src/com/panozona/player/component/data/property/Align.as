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
package com.panozona.player.component.data.property{
	
	public class Align{
		
		public static const RIGHT:String = "right";
		public static const LEFT:String = "left";
		public static const CENTER:String = "center";
		
		public static const BOTTOM:String = "bottom";
		public static const TOP:String = "top";
		public static const MIDDLE:String = "middle";
		
		private var _horizontal:String;
		private var _vertical:String;
		
		public function Align(defaultHorizontal:String, defaultVertical:String) {
			horizontal = defaultHorizontal;
			vertical = defaultVertical;
		}
		
		public function set horizontal(value:String):void {
			if (value == Align.RIGHT || value == Align.LEFT || value == Align.CENTER) {
				_horizontal = value;
			}
		}
		
		public function get horizontal():String {
			return _horizontal;
		}
		
		public final function set vertical(value:String):void {
			if (value == Align.BOTTOM || value == Align.TOP || value == Align.MIDDLE) {
				_vertical = value;
			}
		}
		
		public function get vertical():String {
			return _vertical;
		}
	}
}