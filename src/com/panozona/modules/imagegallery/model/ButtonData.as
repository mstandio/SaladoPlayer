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
	
	import com.panozona.modules.imagegallery.events.ButtonEvent;
	import flash.events.EventDispatcher;
	
	public class ButtonData extends EventDispatcher {
		
		public var onPress:Function;
		public var onRelease:Function;
		
		private var _imageIndex:Number;
		private var _isActive:Boolean;
		private var _mousePress:Boolean;
		
		public function ButtonData(imageIndex:Number):void {
			_imageIndex = imageIndex;
		}
		
		public function get imageIndex():Number { return _imageIndex; }
		
		public function get isActive():Boolean { return _isActive; }
		public function set isActive(value:Boolean):void {
			if (value == _isActive) return;
			_isActive= value;
			dispatchEvent(new ButtonEvent(ButtonEvent.CHANGED_IS_ACTIVE));
		}
		
		public function get mousePress():Boolean { return _mousePress}
		public function set mousePress(value:Boolean):void {
			if (value == mousePress) return;
			_mousePress = value;
			dispatchEvent(new ButtonEvent(ButtonEvent.CHANGED_MOUSE_PRESS));
		}
	}
}