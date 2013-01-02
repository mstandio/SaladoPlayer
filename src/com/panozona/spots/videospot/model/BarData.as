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
package com.panozona.spots.videospot.model{
	
	import com.panozona.spots.videospot.events.BarEvent;
	import flash.events.EventDispatcher;
	
	public class BarData extends EventDispatcher{
		
		private var _progressPointerDragged:Boolean;
		
		public function get progressPointerDragged():Boolean {
			return _progressPointerDragged;
		}
		
		public function set progressPointerDragged(value:Boolean):void{
			if (value == _progressPointerDragged) return;
			_progressPointerDragged = value;
			dispatchEvent(new BarEvent(BarEvent.CHANGED_PROGRESS_POINTER_DRAGGED));
		}
	}
}