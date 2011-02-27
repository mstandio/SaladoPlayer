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
package com.panozona.modules.dropdown.events{
	
	import flash.events.Event;
	
	public class BoxEvent extends Event{
		
		public static const CHANGED_OPEN:String = "chngdOpen";
		public static const CHANGED_MOUSE_OVER:String = "chngdMouseOver";
		public static const CHANGED_CURRENT_PANORAMA_ID:String = "chngdCurrentPanoramaId";
		
		public function BoxEvent( type:String){
			super(type);
		}
	}
}