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
package com.panozona.modules.imagemap.view {
	
	import flash.display.Sprite;
	import com.panozona.modules.imagemap.model.WaypointData;
	
	/**
	 * @author mstandio
	 */
	public class WaypointView extends Sprite{
		
		private var _waypointData:WaypointData;
		
		private var _radar:Sprite;
		private var _button:Sprite;
		
		public function WaypointView (waypointData:WaypointData) {
			
			_waypointData = waypointData;
			
			_radar = new Sprite();
			addChild(_radar);
			
			_button = new Sprite();
			_button.graphics.beginFill(0xffff00);            // temporary, needs more states
			_button.graphics.drawRect(0, 0, 20, 20);
			//_button.graphics.lineStyle(2*20, 0x000000);
			//_button.graphics.drawCircle(0, 0, 15*20);
			_button.graphics.endFill();
			_button.x = _waypointData.waypoint.position.x - (_button.width * 0.5);
			_button.y = _waypointData.waypoint.position.y - (_button.height * 0.5);
			addChild(_button);
		}
		
		public function get waypointData():WaypointData {
			return _waypointData;
		}
		
		public function get radar():Sprite {
			return _radar
		}
		
		public function get button():Sprite {
			return _button;
		}
	}
}