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
	
	/**
	 * delay in miliseconds before autorotation starts
	 */
	public var delay:int;
	
	/**
	 * takes "speed" or "frameIncrement"
	 */
	public var mode:String;
	
	/**
	 * in degrees per second
	 */
	public var speed:Number;
	
	/**
	 * in degress per frame
	 */
	public var frameIncrement:Number 
	
	protected var _isAutorotating:Boolean;
	
	protected var _enabled:Boolean;
	
	public function AutorotationCameraData()
	{
		delay = 5;
		mode = "speed" // speed
		speed = 5;
		frameIncrement = 0.0333;
		_enabled = true; 
		_isAutorotating = false;
	}
	
	public function get isAutorotating():Boolean {
		return _isAutorotating;
	}
	public function set isAutorotating(value:Boolean):void {
		if (value == _isAutorotating) return;
		_isAutorotating = value;
		dispatchEvent( new Event(AutorotationEvent.AUTOROTATION_CHANGE));
	}
	
	/**
	 * Changing this value dispatches CameraEvent.ENABLED_CHANGE
	 * Setting it to false disables autorotation completely.
	 */
	public function get enabled():Boolean {
		return _enabled;
	}
	/**
	 * @private
	 */
	public function set enabled(value:Boolean):void {
		if (value == _enabled) return;
		_enabled = value;
		dispatchEvent( new Event(CameraEvent.ENABLED_CHANGE));
	}
}
}