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
		
		private var _thumbLength:Number;
		
		public function get thumbLength():Number { return _thumbLength };
		public function set thumbLength(value:Number):void {
			if (value == _thumbLength) return;
			_thumbLength = value;
			dispatchEvent(new ScrollBarEvent(ScrollBarEvent.CHANGED_THUMB_LENGTH));
		}
	}
}