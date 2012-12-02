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
package com.panozona.modules.imagemap.view {
	
	import com.panozona.modules.imagemap.model.ExtraWaypointData;
	import com.panozona.modules.imagemap.model.ImageMapData;
	import com.panozona.modules.imagemap.model.MapData;
	
	public class ExtraWaypointView extends RawWaypointView{
		
		public var mapData:MapData;
		
		public function ExtraWaypointView(imageMapData:ImageMapData, extraWaypointData:ExtraWaypointData, mapData:MapData) {
			super(imageMapData, extraWaypointData);
			this.mapData = mapData;
		}
		
		public function get extraWaypointData():ExtraWaypointData {
			return _rawWaypointData as ExtraWaypointData;
		}
	}
}