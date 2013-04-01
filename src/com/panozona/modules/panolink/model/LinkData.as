/*
Copyright 2013 Marek Standio.

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
package com.panozona.modules.panolink.model {
	
	import com.panozona.modules.panolink.events.LinkEvent;
	import com.panozona.player.module.data.property.Size;
	import flash.events.EventDispatcher;
	
	public class LinkData extends EventDispatcher {
		
		private var _minSize:Size = new Size(1, 1);
		private var _maxSize:Size = new Size(1, 1);
		
		public function get minSize():Size {return _minSize};
		public function get maxSize():Size {return _maxSize};
		public function setMinMaxSize(minSize:Size, maxSize:Size):void {
			_minSize = minSize;
			_maxSize = maxSize;
			dispatchEvent(new LinkEvent(LinkEvent.CHANGED_SIZE_LIMIT));
		}
	}
}