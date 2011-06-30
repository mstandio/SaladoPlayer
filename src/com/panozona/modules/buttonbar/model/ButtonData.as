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
package com.panozona.modules.buttonbar.model {
	
	import com.panozona.modules.buttonbar.events.ButtonEvent;
	import com.panozona.modules.buttonbar.model.structure.Button;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	
	public class ButtonData extends EventDispatcher {
		
		public static const STATE_PLAIN:String = "statePlain";
		public static const STATE_ACTIVE:String = "stateActive";
		
		public var name:String;
		public var onPress:Function;
		public var onRelease:Function;
		
		private var _state:String = ButtonData.STATE_PLAIN;
		private var _mousePress:Boolean;
		
		private var _bitmapPlain:BitmapData;
		private var _bitmapActive:BitmapData;
		
		private var _button:Button;
		
		public function ButtonData(button:Button):void {
			_button = button;
		}
		
		public function get button():Button {
			return _button;
		}
		
		public function get state():String { return _state}
		public function set state(value:String):void {
			if (value == _state) return;
			if (value == STATE_PLAIN || value == STATE_ACTIVE) {
				_state = value;
				dispatchEvent(new ButtonEvent(ButtonEvent.CHANGED_STATE));
			}
		}
		
		public function get mousePress():Boolean { return _mousePress}
		public function set mousePress(value:Boolean):void {
			if (value == mousePress) return;
			_mousePress = value;
			dispatchEvent(new ButtonEvent(ButtonEvent.CHANGED_MOUSE_PRESS));
		}
		
		public function get bitmapPlain():BitmapData { return _bitmapPlain }
		public function set bitmapPlain(value:BitmapData):void {
			if (value == _bitmapPlain) return;
			_bitmapPlain = value;
			dispatchEvent(new ButtonEvent(ButtonEvent.CHANGED_BITMAP_PLAIN));
		}
		
		public function get bitmapActive():BitmapData { return _bitmapActive }
		public function set bitmapActive(value:BitmapData):void {
			if (value  == _bitmapActive) return;
			_bitmapActive = value;
			dispatchEvent(new ButtonEvent(ButtonEvent.CHANGED_BITMAP_ACTIVE));
		}
	}
}