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
package com.panozona.modules.menuscroller.model{
	
	import com.panozona.modules.menuscroller.events.ScrollerEvent;
	import com.panozona.modules.menuscroller.model.structure.Scroller;
	import flash.events.EventDispatcher;
	
	public class ScrollerData extends EventDispatcher{
		
		public const scroller:Scroller = new Scroller();
		
		private var _scrollValue:Number = 0;
		private var _totalSize:Number = 0;
		private var _mouseOver:Boolean;
		
		public function get scrollValue():Number { return _scrollValue; }
		public function set scrollValue(value:Number):void {
			if (value == _scrollValue) return;
			_scrollValue = value;
			dispatchEvent(new ScrollerEvent(ScrollerEvent.CHANGED_SCROLL));
		}
		
		public function get totalSize():Number { return _totalSize; }
		public function set totalSize(value:Number):void {
			if (value == _totalSize) return;
			_totalSize = value;
			dispatchEvent(new ScrollerEvent(ScrollerEvent.CHANGED_TOTAL_SIZE));
		}
		
		public function get mouseOver():Boolean { return _mouseOver; }
		public function set mouseOver(value:Boolean):void {
			if (value == _mouseOver) return;
			_mouseOver = value;
			dispatchEvent(new ScrollerEvent(ScrollerEvent.CHANGED_MOUSE_OVER));
		}
	}
}