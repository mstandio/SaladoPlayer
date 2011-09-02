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
	import com.panozona.modules.dropdown.model.structure.RawElement;
	import flash.events.EventDispatcher;
	
	public class ElementData extends EventDispatcher{
		
		private var _isActive:Boolean;
		private var _mouseOver:Boolean;
		
		private var _rawElement:RawElement;
		
		private var _width:Number;
		
		public function ElementData(rawElement:RawElement) {
			_rawElement = rawElement;
		}
		
		public function get rawElement():RawElement { return _rawElement;}
		
		public function get width():Number { return _width;}
		public function set width(value:Number):void {
			if (value == _width) return;
			_width = value;
			dispatchEvent(new ElementEvent(ElementEvent.CHANGED_WIDTH));
		}
		
		public function get isActive():Boolean { return _isActive;}
		public function set isActive(value:Boolean):void {
			if (value == _isActive) return;
			_isActive = value;
			dispatchEvent(new ElementEvent(ElementEvent.CHANGED_IS_ACTIVE));
		}
		
		public function get mouseOver():Boolean { return _mouseOver;}
		public function set mouseOver(value:Boolean):void {
			if (value == _mouseOver) return;
			_mouseOver = value;
			dispatchEvent(new ElementEvent(ElementEvent.CHANGED_MOUSE_OVER));
		}
	}
}