/*
Copyright 2010 Zephyr Renner.

This file is part of PanoSalado.

PanoSalado is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

PanoSalado is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with PanoSalado.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.panosalado.events
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class ViewEvent extends Event
	{
		public static const RENDERED:String = "rendered";
		public static const PATH:String = "path";
		public static const NULL_PATH:String = "nullPath";
		public static const BOUNDS_CHANGED:String = "boundsChanged";
		
		public var canvas:Sprite;
		
		public function ViewEvent(type:String,canvas:Sprite=null,cancelable:Boolean=false)
		{
			this.canvas = canvas;
			super(type,false,cancelable);
		}
		
		override public function clone():Event
		{
			return new ViewEvent(type,canvas,cancelable);
		}
		
	}
}