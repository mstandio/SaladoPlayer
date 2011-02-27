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
package com.panozona.modules.dropdown.model{
	
	import com.panozona.modules.dropdown.events.BoxEvent;
	import com.panozona.modules.dropdown.model.structure.Elements;
	import flash.events.EventDispatcher;
	
	public class BoxData extends EventDispatcher{
		
		public var elements:Elements = new Elements();
		
		private var _open:Boolean;
		private var _mouseOver:Boolean;
		private var _currentPanoramaId:String;
		
		public function get open():Boolean { return _open;}
		public function set open(value:Boolean):void {
			if (_open == value) return;
			_open = value;
			dispatchEvent(new BoxEvent(BoxEvent.CHANGED_OPEN));
		}
		
		public function get mouseOver():Boolean { return _mouseOver;}
		public function set mouseOver(value:Boolean):void {
			if (_mouseOver == value) return;
			_mouseOver = value;
			dispatchEvent(new BoxEvent(BoxEvent.CHANGED_MOUSE_OVER));
		}
		
		public function get currentPanoramaId():String { return _currentPanoramaId;}
		public function set currentPanoramaId(value:String):void {
			if (_currentPanoramaId == value) return;
			_currentPanoramaId = value;
			dispatchEvent(new BoxEvent(BoxEvent.CHANGED_CURRENT_PANORAMA_ID));
		}
	}
}