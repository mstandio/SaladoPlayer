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
package com.panozona.modules.imagegallery.model {
	
	import flash.events.EventDispatcher;
	import com.panozona.modules.imagegallery.events.ImageEvent;
	import com.panozona.player.module.data.property.Size;
	
	public class ImageData extends EventDispatcher {
		
		private var _isShowingThrobber:Boolean;
		private var _maxScale:Number;
		
		public var isOpened:Boolean;
		public var isOpening:Boolean;
		public var isClosing:Boolean;
		
		public function get isShowingThrobber():Boolean { return _isShowingThrobber; }
		public function set isShowingThrobber(value:Boolean):void {
			if (value == _isShowingThrobber) return;
			_isShowingThrobber = value;
			dispatchEvent(new ImageEvent(ImageEvent.CHANGED_IS_THROBBER_SHOWING));
		}
		
		public function get maxScale():Number { return _maxScale };
		public function set maxScale(value:Number):void {
			if (isNaN(value) || value == _maxScale) return;
			_maxScale = value;
			dispatchEvent(new ImageEvent(ImageEvent.CHANGED_MAX_SCALE));
		}
	}
}