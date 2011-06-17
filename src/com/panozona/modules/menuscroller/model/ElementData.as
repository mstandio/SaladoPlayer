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
package com.panozona.modules.menuscroller.model {
	
	import com.panozona.modules.menuscroller.events.ElementEvent;
	import com.panozona.modules.menuscroller.model.structure.Element;
	import flash.events.EventDispatcher;
	
	public class ElementData extends EventDispatcher{
		
		public static const STATE_PLAIN:String = "statePlain";
		public static const STATE_HOVER:String = "stateHover";
		public static const STATE_ACTIVE:String = "stateActive";
		
		private var _state:String;
		
		private var _showing:Boolean;
		private var _loaded:Boolean;
		private var _mouseOver:Boolean;
		
		public function get showing():Boolean { return _showing; }
		public function set showing(value:Boolean):void {
			if (_showing == value) return;
			_showing = value;
			dispatchEvent(new ElementEvent(ElementEvent.CHANGED_STATE));
		}
		
		public function get loaded():Boolean { return _loaded; }
		public function set loaded(value:Boolean):void {
			if (value) _loaded = true;
		}
		
		public function get state():String { return _state; }
		public function set state(value:String):void {
			if (_state == value) return;
			if (value == STATE_PLAIN || value == STATE_HOVER || value == STATE_ACTIVE) {
				_state = value;
				dispatchEvent(new ElementEvent(ElementEvent.CHANGED_STATE));
			}
		}
		
		public function get mouseOver():Boolean { return _mouseOver; }
		public function set mouseOver(value:Boolean):void {
			if (_mouseOver == value) return;
			_mouseOver = value;
			dispatchEvent(new ElementEvent(ElementEvent.CHANGED_MOUSE_OVER));
		}
	}
}