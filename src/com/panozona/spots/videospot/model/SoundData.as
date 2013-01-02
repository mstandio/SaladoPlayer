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
	
	import com.panozona.spots.videospot.events.SoundEvent;
	import flash.events.EventDispatcher;
	
	public class SoundData extends EventDispatcher{
		
		private var _volumeBarOpen:Boolean;
		private var _volumePointerDragged:Boolean;
		private var _mute:Boolean;
		
		public function get volumeBarOpen():Boolean {
			return _volumeBarOpen;
		}
		
		public function set volumeBarOpen(value:Boolean):void{
			if (value == _volumeBarOpen) return;
			_volumeBarOpen = value;
			dispatchEvent(new SoundEvent(SoundEvent.CHANGED_VOLUME_BAR_OPEN));
		}
		
		public function get volumePointerDragged():Boolean {
			return _volumePointerDragged;
		}
		
		public function set volumePointerDragged(value:Boolean):void{
			if (value == _volumePointerDragged) return;
			_volumePointerDragged = value;
			dispatchEvent(new SoundEvent(SoundEvent.CHANGED_VOLUME_POINTER_DRAGGED));
		}
		
		public function get mute():Boolean {
			return _mute;
		}
		
		public function set mute(value:Boolean):void{
			if (value == _mute) return;
			_mute = value;
			dispatchEvent(new SoundEvent(SoundEvent.CHANGED_MUTE));
		}
	}
}