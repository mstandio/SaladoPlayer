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
package com.panosalado.model
{

import flash.events.Event;
import flash.events.EventDispatcher;

import com.panosalado.events.CameraEvent;
import com.panosalado.events.AutorotationEvent;

public class AutorotationCameraData extends EventDispatcher
{	
	public static var SPEED:String = "speed";
	public static var FRAME_INCREMENT:String = "frameIncrement";
		
	public var delay:int;
	public var mode:String;
	public var speed:Number;  // in degrees / second
	public var frameIncrement:Number // in degress / frame	
	protected var _enabled:Boolean;		
	
	public function AutorotationCameraData()
	{
		delay			= 5000;
		mode			= "speed" // speed
		speed 			= 3;
		frameIncrement		= 0.0333;
		_enabled			= true; 		
	}
	
	public function toggleRotation():void {
		dispatchEvent(new AutorotationEvent(AutorotationEvent.AUTOROTATION_TOGGLE));
	}
	
	public function get enabled():Boolean {
		return _enabled;
	}
	public function set enabled(value:Boolean):void {
		if (value == _enabled) return;
		_enabled = value;
		dispatchEvent( new Event(CameraEvent.ENABLED_CHANGE) );
	}	
}
}