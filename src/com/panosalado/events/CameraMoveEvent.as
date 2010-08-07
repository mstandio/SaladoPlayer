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
package com.panosalado.events {
	
	import flash.events.Event;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class CameraMoveEvent extends Event {
		
		public var pan:Number;
		public var tilt:Number;
		public var fieldOfView:Number;
		
		public static const CAMERA_MOVE:String = "CameraMoveEvent";
		
		public function CameraMoveEvent(pan:Number, tilt:Number, fieldOfView:Number) {
			super(CameraMoveEvent.CAMERA_MOVE);			
			this.pan = pan;
			this.tilt = tilt;
			this.fieldOfView = fieldOfView;			
		}		
	}
}