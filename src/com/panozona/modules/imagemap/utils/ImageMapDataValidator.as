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
package com.panozona.modules.imagemap.utils{
	
	import com.panozona.modules.imagemap.model.*;
	import com.panozona.modules.imagemap.model.structure.*;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class ImageMapDataValidator{
		
		public function validate(imageMapData:ImageMapData):void{
			checkMaps(imageMapData.mapData.maps);
		}
		
		private function checkSettings():void {
			// TODO: might be something here 
		}
		
		private function checkMaps(maps:Maps):void {
			var mapIds:Object = new Object();
			for each(var map:Map in maps.getChildrenOfGivenClass(Map)) {
				if (map.id == null) throw new Error("Map id not specified.");
				if (mapIds[map.id] != undefined) {
					throw new Error("Repeating map id: "+map.id);
				}else {
					mapIds[map.id] = ""; // something
				}
				checkMap(map);
			}
			for (var key:String in mapIds) {
				return;
			}
			throw new Error("No maps found");
		}
		
		private function checkMap(map:Map):void {
			var waypointTargets:Object = new Object();
			for each(var waypoint:Waypoint in map.getChildrenOfGivenClass(Waypoint)) {
				if (waypoint.target == null) throw new Error("Waypoint target not specified.");
				if (waypointTargets[waypoint.target] != undefined) {
					throw new Error("Repeating waypoint target: "+waypoint.target);
				}else {
					waypointTargets[waypoint.target] = ""; // something
				}
			}
			for (var key:String in waypointTargets) {
				return;
			}
			throw new Error("No waypoints found in map: "+map.id);
		}
	}
}