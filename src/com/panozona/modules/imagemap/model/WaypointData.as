/*
Copyright 2012 Marek Standio.

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
	import com.panozona.modules.imagemap.model.structure.Radar;
	import com.panozona.modules.imagemap.model.structure.Waypoint;
	import com.panozona.player.module.data.property.Move;
	import flash.display.BitmapData;
	
	public class WaypointData extends RawWaypointData{
		
		public var radar:Radar;
		public var panShift:Number;
		
		public function WaypointData(waypoint:Waypoint, move:Move,
			bitmapDataPlain:BitmapData, bitmapDataHover:BitmapData, bitmapDataActive:BitmapData,
			radar:Radar, panShift:Number) {
			super(waypoint, move, bitmapDataPlain, bitmapDataHover, bitmapDataActive);
			
			this.radar = radar;
			this.panShift = panShift;
		}
		
		public function get waypoint():Waypoint {
			return rawWaypoint as Waypoint
		}
	}
}