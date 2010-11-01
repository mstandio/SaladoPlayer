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
package com.panozona.modules.imagemap.events {
	
	import flash.events.Event;
	
	/**
	 * @author mstandio
	 */
	public class ContentViewerEvent extends Event{
		
		public static const CHANGED_MOVE:String = "changedMove";
		public static const CHANGED_ZOOM:String = "changedZoom";
		
		public static const CHANGED_MOUSE_OVER:String = "changedmOver";
		public static const CHANGED_MOUSE_DRAG:String = "changedmDrag";
		
		public function ContentViewerEvent(type:String){
			super(type);
		}
	}
}