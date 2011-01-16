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
package com.panozona.hotspots.videohotspot.model {
	
	import com.panozona.hotspots.videohotspot.events.WindowEvent;
	import flash.events.EventDispatcher;
	
	public class WindowData extends EventDispatcher{
		
		public const barHeightHidden:Number = 5;
		public const barHeightExpanded:Number = 15;
		
		private var _mouseIsOver:Boolean;
		private var _pointerDragged:Boolean;
		
		public function get mouseIsOver():Boolean {
			return _mouseIsOver;
		}
		
		public function set mouseIsOver(value:Boolean):void{
			if (value == _mouseIsOver) return;
			_mouseIsOver = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_MOUSE_IS_OVER));
		}
		
		public function get pointerDragged():Boolean {
			return _pointerDragged;
		}
		
		public function set pointerDragged(value:Boolean):void{
			if (value == _pointerDragged) return;
			_pointerDragged = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_POINTER_DRAGGED));
		}
	}
}