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

public class ArcBallCameraData extends EventDispatcher
{	
	
	protected var _enabled:Boolean;
	
	/**
	* delta zoom value that will be used for scroll zooming
	*/
	public var zoomIncrement:Number;
	
	public function ArcBallCameraData()
	{		
		_enabled = false;
		zoomIncrement = 3;
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