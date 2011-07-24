/*
Copyright 2010 Zephyr Renner.

This file is part of PanoSalado.

PanoSalado is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

PanoSalado is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with PanoSalado. If not, see <http://www.gnu.org/licenses/>.
*/
package com.panosalado.model{
	
	import com.panosalado.events.CameraEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	final public class KeyboardCameraData extends EventDispatcher {
		
		/**
		* sensitivity of keyboard
		*/
		public var sensitivity:Number;
		
		/**
		* friction of camera after mouse is up
		*/
		public var friction:Number;
		
		/**
		* delta pan and tilt value that will be used for key movement
		*/
		public var directionSpeed:Number;
		
		/**
		* delta zoom value that will be used for key zooming
		*/
		public var zoomSpeed:Number;
		
		public var _enabled:Boolean;
		
		public function KeyboardCameraData() {
			friction = 0.25;
			sensitivity = 0.5;
			
			directionSpeed = 2;
			zoomSpeed = 1;
			
			enabled = true;
		}
		
		public function get enabled():Boolean { return _enabled;}
		public function set enabled(value:Boolean):void {
			if (value == _enabled) return;
			_enabled = value;
			dispatchEvent(new Event(CameraEvent.ENABLED_CHANGE));
		}
	}
}