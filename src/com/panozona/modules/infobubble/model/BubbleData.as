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
		
		private var _currentBubbleId:String;
		private var _isShowingBubble:Boolean;
		private var _enabled:Boolean;
		
		public function get currentBubbleId():String {
			return _currentBubbleId;
		}
		
		public function set currentBubbleId(value:String):void {
			if (value == null || _currentBubbleId == value) return;
			_currentBubbleId = value;
			dispatchEvent(new BubbleEvent(BubbleEvent.CHANGED_CURRENT_BUBBLE_ID));
		}
		
		public function get isShowingBubble():Boolean {
			return _isShowingBubble;
		}
		
		public function set isShowingBubble(value:Boolean):void {
			if ( _isShowingBubble == value) return;
			_isShowingBubble = value;
			dispatchEvent(new BubbleEvent(BubbleEvent.CHANGED_IS_SHOWING_BUBBLE));
		}
		
		public function get enabled():Boolean {
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void {
			if ( _enabled == value) return;
			_enabled = value;
			dispatchEvent(new BubbleEvent(BubbleEvent.CHANGED_ENABLED));
		}
	}
}