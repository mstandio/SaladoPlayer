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
package com.panozona.modules.compass.model {
	
	import com.panozona.modules.compass.events.WindowEvent;
	import com.panozona.modules.compass.model.structure.Window;
	import com.panozona.player.module.data.property.Size;
	import flash.events.EventDispatcher;
	
	public class WindowData extends EventDispatcher{
		
		private var _open:Boolean;
		private var _size:Size;
		
		public const window:Window = new Window();
		
		public function WindowData ():void {
			_size = new Size(1, 1);
		}
		
		public function get open():Boolean{return _open}
		public function set open(value:Boolean):void {
			if (value == _open) return;
			_open = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_OPEN));
		}
		
		public function get size():Size { return _size;}
		public function set size(value:Size):void {
			if (value.width > _size.width) {
				_size.width = value.width;
			}
			if (value.height > _size.height) {
				_size.height = value.height;
			}
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_SIZE));
		}
	}
}