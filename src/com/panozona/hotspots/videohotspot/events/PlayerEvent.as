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
package com.panozona.hotspots.videohotspot.events {
	
	import flash.events.Event;
	
	public class PlayerEvent extends Event{
		
		public static const CHANGED_NAVIGATION_ACTIVE:String = "chngdNaviActive";
		public static const CHANGED_PROGRESS_POINTER_DRAGGED:String = "chngdPrPoiDragged";
		public static const CHANGED_VOLUME_BAR_OPEN:String = "chngdVoBarOpen";
		public static const CHANGED_VOLUME_POINTER_DRAGGED:String = "chngdVoPoiDragged";
		public static const CHANGED_IS_MUTE:String = "chngdIsMute";
		
		public function PlayerEvent(type:String) {
			super(type);
		}
	}
}