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
package com.panozona.modules.imagemap.model.structure {
	
	import com.panozona.player.module.data.property.Position;
	
	/**
	 * @author mstandio
	 */
	public class Waypoint {
		
		public static var GRADIENT:String = "gradient";
		public static var GRADIENT_SHORT:String = "gradientShort";
		public static var SOLID:String = "solid";
		public static var SOLID_SHORT:String = "solidShort";
		
		public var position:Position = new Position(0,0);		
		public var target:String; // intentionally not initialized
		public var panShift:Number = 0;
		
		public var color:Number = 0x00FF00; // green
		
		public var maxPointSize:Number = 20;
		public var minPointSize:Number = 200;
		
		public var _camType:String = Waypoint.SOLID;
		
		public function get camType():String {
			return _camType;
		}
		
		public function set camType(value:String):void {
			if (value == Waypoint.SOLID ||
				value == Waypoint.GRADIENT_SHORT ||
				value == Waypoint.GRADIENT ||
				value == Waypoint.GRADIENT_SHORT) {
				_camType = value;
			}else {
				throw new Error("Invalid camera type value: "+value);
			}
		}
	}
}