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
package com.panozona.modules.imagebutton.model {
	
	import com.panozona.modules.imagebutton.events.SubButtonEvent;
	import com.panozona.modules.imagebutton.model.structure.SubButton;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	
	public class SubButtonData extends EventDispatcher{
		
		public var name:String;
		public var onPress:Function;
		public var onRelease:Function;
		
		private var _isActive:Boolean;
		private var _mousePress:Boolean;
		
		private var _subButton:SubButton;
		
		public function SubButtonData(subButton:SubButton):void {
			_subButton = subButton;
		}
		
		public function get subButton():SubButton {
			return _subButton;
		}
		
		public function get isActive():Boolean { return _isActive; }
		public function set isActive(value:Boolean):void {
			if (value == _isActive) return;
			_isActive= value;
			dispatchEvent(new SubButtonEvent(SubButtonEvent.CHANGED_IS_ACTIVE));
		}
		
		public function get mousePress():Boolean { return _mousePress}
		public function set mousePress(value:Boolean):void {
			if (value == mousePress) return;
			_mousePress = value;
			dispatchEvent(new SubButtonEvent(SubButtonEvent.CHANGED_MOUSE_PRESS));
		}
	}
}