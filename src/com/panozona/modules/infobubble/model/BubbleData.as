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
package com.panozona.modules.infobubble.model{
	
	import com.panozona.modules.infobubble.events.BubbleEvent;
	import flash.events.EventDispatcher;
	
	public class BubbleData extends EventDispatcher {
		
		private var _currentId:String;
		private var _isShowing:Boolean;
		private var _enabled:Boolean;
		
		public function get currentId():String {return _currentId;}
		public function set currentId(value:String):void {
			if (value == null || value == _currentId) return;
			_currentId = value;
			dispatchEvent(new BubbleEvent(BubbleEvent.CHANGED_CURRENT_ID));
		}
		
		public function get isShowing():Boolean {return _isShowing;}
		public function set isShowing(value:Boolean):void {
			if (value == _isShowing) return;
			_isShowing = value;
			dispatchEvent(new BubbleEvent(BubbleEvent.CHANGED_IS_SHOWING));
		}
		
		public function get enabled():Boolean {return _enabled;}
		public function set enabled(value:Boolean):void {
			if (value == _enabled) return;
			_enabled = value;
			dispatchEvent(new BubbleEvent(BubbleEvent.CHANGED_ENABLED));
		}
	}
}