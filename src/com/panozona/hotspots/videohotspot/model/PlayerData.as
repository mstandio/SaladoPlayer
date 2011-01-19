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
	
	import com.panozona.hotspots.videohotspot.events.PlayerEvent;
	import flash.events.EventDispatcher;
	
	public class PlayerData extends EventDispatcher{
		
		public const barHeightHidden:Number = 5;
		public const barHeightExpanded:Number = 15;
		
		private var _navigationActive:Boolean;
		private var _progressPointerDragged:Boolean;
		private var _volumeBarOpen:Boolean;
		private var _volumePointerDragged:Boolean;
		private var _isMute:Boolean;
		
		public function get navigationActive():Boolean {
			return _navigationActive;
		}
		
		public function set navigationActive(value:Boolean):void{
			if (value == _navigationActive) return;
			_navigationActive = value;
			dispatchEvent(new PlayerEvent(PlayerEvent.CHANGED_NAVIGATION_ACTIVE));
		}
		
		public function get progressPointerDragged():Boolean {
			return _progressPointerDragged;
		}
		
		public function set progressPointerDragged(value:Boolean):void{
			if (value == _progressPointerDragged) return;
			_progressPointerDragged = value;
			dispatchEvent(new PlayerEvent(PlayerEvent.CHANGED_PROGRESS_POINTER_DRAGGED));
		}
		
		public function get volumeBarOpen():Boolean {
			return _volumeBarOpen;
		}
		
		public function set volumeBarOpen(value:Boolean):void{
			if (value == _volumeBarOpen) return;
			_volumeBarOpen = value;
			dispatchEvent(new PlayerEvent(PlayerEvent.CHANGED_VOLUME_BAR_OPEN));
		}
		
		public function get volumePointerDragged():Boolean {
			return _volumePointerDragged;
		}
		
		public function set volumePointerDragged(value:Boolean):void{
			if (value == _volumePointerDragged) return;
			_volumePointerDragged = value;
			dispatchEvent(new PlayerEvent(PlayerEvent.CHANGED_VOLUME_POINTER_DRAGGED));
		}
		
		public function get isMute():Boolean {
			return _isMute;
		}
		
		public function set isMute(value:Boolean):void{
			if (value == _isMute) return;
			_isMute = value;
			dispatchEvent(new PlayerEvent(PlayerEvent.CHANGED_IS_MUTE));
		}
	}
}