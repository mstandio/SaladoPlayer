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
package com.panozona.modules.dropdown.model {
	
	import com.panozona.modules.dropdown.events.ElementEvent;
	import com.panozona.modules.dropdown.model.structure.Element;
	import flash.events.EventDispatcher;
	
	public class ElementData extends EventDispatcher{
		
		public static const STATE_PLAIN:String = "statePlain";
		public static const STATE_HOVER:String = "stateHover";
		public static const STATE_ACTIVE:String = "stateActive";
		
		private var _element:Element;
		
		private var _state:String = ElementData.STATE_PLAIN;
		private var _mouseOver:Boolean;
		private var _width:Number;
		
		public function ElementData(element:Element) {
			_element = element;
		}
		
		public function get element():Element { return _element;}
		
		public function get state():String { return _state;}
		public function set state(value:String):void {
			if (value == _state) return;
			if (value == STATE_PLAIN || value == STATE_HOVER || value == STATE_ACTIVE) {
				_state = value;
				dispatchEvent(new ElementEvent(ElementEvent.CHANGED_STATE));
			}
		}
		
		public function get mouseOver():Boolean { return _mouseOver;}
		public function set mouseOver(value:Boolean):void {
			if (value == _mouseOver) return;
			_mouseOver = value;
			dispatchEvent(new ElementEvent(ElementEvent.CHANGED_MOUSE_OVER));
		}
		
		public function get width():Number { return _width;}
		public function set width(value:Number):void {
			if (value == _width) return;
			_width = value;
			dispatchEvent(new ElementEvent(ElementEvent.CHANGED_WIDTH));
		}
	}
}