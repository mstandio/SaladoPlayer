/*
Copyright 2012 Marek Standio.

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
package com.panozona.modules.infobox.model {
	
	import com.panozona.modules.infobox.events.ScrollBarEvent;
	import flash.events.EventDispatcher;
	
	public class ScrollBarData extends EventDispatcher{
		
		public var minThumbHeight:Number;
		
		private var _thumbLength:Number;
		private var _isShowing:Boolean;
		private var _scrollBarWidth:Number;
		private var _mouseDrag:Boolean;
		private var _scrollValue:Number;
		
		public function ScrollBarData() {
			minThumbHeight = 0;
			_thumbLength = 0;
			_scrollBarWidth = 0;
			_scrollValue = 0;
		}
		
		public function get thumbLength():Number { return _thumbLength };
		public function set thumbLength(value:Number):void {
			if (value == _thumbLength) return;
			_thumbLength = value;
			dispatchEvent(new ScrollBarEvent(ScrollBarEvent.CHANGED_THUMB_LENGTH));
		}
		
		public function get isShowing():Boolean { return _isShowing };
		public function set isShowing(value:Boolean):void {
			if (value == _isShowing) return;
			_isShowing = value;
			dispatchEvent(new ScrollBarEvent(ScrollBarEvent.CHANGED_IS_SHOWING));
		}
		
		public function get scrollBarWidth():Number { return _scrollBarWidth };
		public function set scrollBarWidth(value:Number):void {
			if (value == _scrollBarWidth) return;
			_scrollBarWidth = value;
			dispatchEvent(new ScrollBarEvent(ScrollBarEvent.CHANGED_SCROLL_BAR_WIDTH));
		}
		
		public function get mouseDrag():Boolean {return _mouseDrag;}
		public function set mouseDrag(value:Boolean):void {
			if (value == _mouseDrag) return;
			_mouseDrag = value;
			dispatchEvent(new ScrollBarEvent(ScrollBarEvent.CHANGED_MOUSE_DRAG));
		}
		
		public function get scrollValue():Number { return _scrollValue };
		public function set scrollValue(value:Number):void {
			if (value == _scrollValue) return;
			_scrollValue = value;
			dispatchEvent(new ScrollBarEvent(ScrollBarEvent.CHANGED_SCROLL_VALUE));
		}
	}
}