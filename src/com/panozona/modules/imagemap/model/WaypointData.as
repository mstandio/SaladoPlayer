/*
Copyright 2011 Marek Standio.

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
along with SaladoPlayer. If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.modules.imagemap.model{
	
	import com.panozona.modules.imagemap.events.WaypointEvent;
	import com.panozona.modules.imagemap.model.structure.Button;
	import com.panozona.modules.imagemap.model.structure.Radar;
	import com.panozona.modules.imagemap.model.structure.Waypoint;
	import flash.events.EventDispatcher;
	
	public class WaypointData extends EventDispatcher{
		
		public var waypoint:Waypoint;
		public var button:Button;
		public var radar:Radar;
		
		private var _showRadar:Boolean;
		private var _mouseOver:Boolean;
		
		public function WaypointData(waypoint:Waypoint, button:Button, radar:Radar){
			this.waypoint = waypoint;
			this.button = button;
			this.radar = radar;
		}
		
		public function get showRadar():Boolean {return _showRadar;}
		public function set showRadar(value:Boolean):void {
			if (value == _showRadar) return;
			_showRadar = value;
			dispatchEvent(new WaypointEvent(WaypointEvent.CHANGED_SHOW_RADAR));
		}
		
		public function get mouseOver():Boolean {return _mouseOver;}
		public function set mouseOver(value:Boolean):void {
			if (value == _mouseOver) return;
			_mouseOver = value;
			dispatchEvent(new WaypointEvent(WaypointEvent.CHANGED_MOUSE_OVER));
		}
	}
}