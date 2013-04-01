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
package com.panozona.modules.panolink.model{
	
	import com.panozona.modules.panolink.events.WindowEvent;
	import com.panozona.modules.panolink.model.structure.Window;
	import com.panozona.player.module.data.property.Move;
	import com.panozona.player.module.data.property.Size;
	import flash.events.EventDispatcher;
	
	public class WindowData extends EventDispatcher{
		
		public const window:Window = new Window();
		
		private var _open:Boolean;
		private var _currentSize:Size = new Size(1,1);
		private var _currentMove:Move = new Move(1,1);
		
		public function get open():Boolean {return _open;}
		public function set open(value:Boolean):void {
			if (value == _open) return;
			_open = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_OPEN));
		}
		
		public function get currentSize():Size { return _currentSize };
		public function set currentSize(value:Size):void {
			if (value == null 
				|| _currentSize.width == value.width 
				&& _currentSize.height == value.height) {
				return;
			}
			_currentSize = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_CURRENT_SIZE));
		}
		
		public function get currentMove():Move { return _currentMove };
		public function set currentMove(value:Move):void {
			if (value == null 
				|| _currentMove.horizontal == value.horizontal 
				&& _currentMove.vertical == value.vertical) {
				return;
			}
			_currentMove = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_CURRENT_MOVE));
		}
	}
}