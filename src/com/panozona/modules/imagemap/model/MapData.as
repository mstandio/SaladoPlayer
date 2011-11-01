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
	
	import com.panozona.modules.imagemap.events.MapEvent;
	import com.panozona.modules.imagemap.model.structure.Map;
	import com.panozona.modules.imagemap.model.structure.Maps;
	import flash.events.EventDispatcher;
	
	public class MapData extends EventDispatcher{
		
		public const maps:Maps = new Maps();
		private var _currentMapId:String = null;
		private var _radarFirst:Boolean = false;
		
		public function getMapById(mapId:String):Map {
			for each(var map:Map in maps.getChildrenOfGivenClass(Map)) {
				if (map.id == mapId) return map;
			}
			return null;
		}
		
		public function get currentMapId():String {return _currentMapId;}
		public function set currentMapId(value:String):void {
			if (value == null || value == _currentMapId) return;
			_currentMapId = value;
			dispatchEvent(new MapEvent(MapEvent.CHANGED_CURRENT_MAP_ID));
		}
		
		public function get radarFirst():Boolean {return _radarFirst;}
		public function set radarFirst(value:Boolean):void {
			_radarFirst = value;
			dispatchEvent(new MapEvent(MapEvent.CHANGED_RADAR_FIRST));
		}
	}
}