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
	import com.panozona.modules.menuscroller.model.structure.RawElement;
	import com.panozona.modules.menuscroller.model.structure.Scroller;
	import com.panozona.player.module.data.property.Size;
	import flash.events.EventDispatcher;
	
	public class ElementData extends EventDispatcher{
		
		private var _isShowing:Boolean;
		private var _loaded:Boolean;
		private var _size:Size;
		
		private var _isActive:Boolean;
		private var _mouseOver:Boolean;
		
		private var _rawElement:RawElement;
		private var _scroller:Scroller;
		
		public function ElementData(rawElement:RawElement, scroller:Scroller):void {
			_rawElement = rawElement;
			_scroller = scroller;
			_size = new Size(scroller.sizeLimit, scroller.sizeLimit);
		}
		
		public function get rawElement():RawElement {
			return _rawElement;
		}
		
		public function get scroller():Scroller {
			return _scroller;
		}
		
		public function get isShowing():Boolean { return _isShowing;}
		public function set isShowing(value:Boolean):void {
			if (value == _isShowing) return;
			_isShowing = value;
			dispatchEvent(new ElementEvent(ElementEvent.CHANGED_IS_SHOWING));
		}
		
		public function get loaded():Boolean { return _loaded; }
		public function set loaded(value:Boolean):void {
			if (value) _loaded = true;
		}
		
		public function get size():Size { return _size;}
		public function set size(value:Size):void {
			_size = value;
			dispatchEvent(new ElementEvent(ElementEvent.CHANGED_SIZE));
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