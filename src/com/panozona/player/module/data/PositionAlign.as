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
package com.panozona.player.module.data{
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class PositionAlign{
		
		public static const RIGHT:String = "right";
		public static const LEFT:String = "left";
		public static const CENTER:String = "center";
		
		public static const BOTTOM:String = "bottom";
		public static const TOP:String = "top";
		public static const MIDDLE:String = "middle";
		
		private var _horizontal:String;
		private var _vertical:String;
		
		public function PositionAlign(defaultHorizontal:String, defaultVertical:String) {
			_horizontal =  defaultHorizontal;
			_vertical = defaultVertical;
		}
		
		public function set horizontal(value:String):void{
			if (value == PositionAlign.RIGHT || value == PositionAlign.LEFT || value == PositionAlign.CENTER) {
				_horizontal = value;
			}else {
				throw new Error("Unknown horizontal align value: "+value);
			}
		}
		
		public function get horizontal():String {
			return _horizontal;
		}
		
		public function set vertical(value:String):void{
			if (value == PositionAlign.BOTTOM || value == PositionAlign.TOP || value == PositionAlign.MIDDLE){
				_vertical = value;
			}else {
				throw new Error("Unknown vertical align value: "+value);
			}
		}
		
		public function get vertical():String {
			return _vertical;
		}
	}
}