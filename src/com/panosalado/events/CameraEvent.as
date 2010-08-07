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
	import flash.events.Event;

	public class CameraEvent extends Event
	{
		public static const ENABLED_CHANGE:String = "enabledChange";
		
		/**
		* The CameraEvent.INACTIVE constant defines the value of the 
		* <code>type</code> property of the event object 
		* for an <code>inactive</code> event.
		*
		* @eventType inactive
		*/
		public static const INACTIVE:String = "inactive";
		
		/**
		* The CameraEvent.ACTIVE constant defines the value of the 
		* <code>type</code> property of the event object 
		* for an <code>active</code> event.
		*
		* @eventType active
		*/
		public static const ACTIVE:String = "active";
		
		public function CameraEvent(type:String)
		{
			super(type);
		}
		
		override public function clone():Event
		{
			return new CameraEvent(type);
		}		
	}
}