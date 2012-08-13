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
	
	import com.panozona.modules.imagegallery.events.WindowEvent;
	import com.panozona.modules.imagegallery.model.structure.Window;
	import com.panozona.player.module.data.property.Size;
	import flash.events.EventDispatcher;
	 
	public class WindowData extends EventDispatcher {
		
		public const window:Window = new Window();
		
		private var _open:Boolean;
		private var _finalSize:Size;
		
		public function get open():Boolean{return _open}
		public function set open(value:Boolean):void {
			if (value == _open) return;
			_open = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_OPEN));
		}
		
		public function get finalSize():Size{return _finalSize}
		public function set finalSize(value:Size):void {
			if (_finalSize != null) return;
			_finalSize = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_FINAL_SIZE));
		}
	}
}