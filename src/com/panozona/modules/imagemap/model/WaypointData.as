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
package com.panozona.modules.imagemap.model{
	
	import flash.events.EventDispatcher;
	
	import com.panozona.modules.imagemap.model.structure.Waypoint;
	import com.panozona.modules.imagemap.events.WaypointEvent;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class WaypointData extends EventDispatcher{
		
		private var _waypoint:Waypoint;
		
		private var _showRadar:Boolean;		
		
		public function WaypointData(waypoint:Waypoint){
			_waypoint = waypoint;
		}
		
		public function get waypoint():Waypoint {
			return _waypoint;
		}
		
		public function get showRadar():Boolean {
			return _showRadar;
		}
		
		public function set showRadar(value:Boolean):void {			
			if (value == _showRadar) return;
			_showRadar = value;
			dispatchEvent(new WaypointEvent(WaypointEvent.CHANGED_SHOW_RADAR));
		}
	}
}