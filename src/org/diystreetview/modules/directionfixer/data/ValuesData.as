/*
Copyright 2011 Marek Standio.

This file is part of DIY streetview player.

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
package org.diystreetview.modules.directionfixer.data {
	
	import flash.events.EventDispatcher;
	import org.diystreetview.modules.directionfixer.events.ValuesDataEvent;
	
	public class ValuesData extends EventDispatcher{
		
		public static const STATE_INCREMENTING:String = "stateIncrementing";
		public static const STATE_DECREMENTING:String = "stateDecrementing";
		public static const STATE_IDLE:String = "stateIdle";
		
		private var _state:String = ValuesData.STATE_IDLE;
		
		private var _hotspotsLoaded:Boolean;
		
		public function get state():String {
			return _state;
		}
		
		public function set state(value:String):void {
			if (value != ValuesData.STATE_IDLE && 
				value != ValuesData.STATE_INCREMENTING && 
				value != ValuesData.STATE_DECREMENTING ) return;
			if (value == _state) return;
			_state = value;
			//dispatchEvent(new ValuesDataEvent(ValuesDataEvent.STATE_CHANGED));
		}
		
		public function get hotspotsLoaded():Boolean {
			return _hotspotsLoaded;
		}
		
		public function set hotspotsLoaded(value:Boolean):void {
			if (value == _hotspotsLoaded) return;
			_hotspotsLoaded = value;
			dispatchEvent(new ValuesDataEvent(ValuesDataEvent.HOTSPOTS_LOADED_CHANGED));
		}
	}
}