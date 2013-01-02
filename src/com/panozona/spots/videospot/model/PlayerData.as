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
package com.panozona.spots.videospot.model {
	
	import com.panozona.spots.videospot.events.PlayerEvent;
	import flash.events.EventDispatcher;
	
	public class PlayerData extends EventDispatcher{
		
		public const barHeightHidden:Number = 5;
		public const barHeightExpanded:Number = 15;
		
		private var _navigationActive:Boolean;
		
		public function get navigationActive():Boolean {
			return _navigationActive;
		}
		
		public function set navigationActive(value:Boolean):void{
			if (value == _navigationActive) return;
			_navigationActive = value;
			dispatchEvent(new PlayerEvent(PlayerEvent.CHANGED_NAVIGATION_ACTIVE));
		}
	}
}