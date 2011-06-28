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
	
	import com.panozona.modules.menuscroller.events.WindowEvent;
	import com.panozona.modules.menuscroller.model.structure.Window;
	import flash.events.EventDispatcher;
	
	public class WindowData extends EventDispatcher{
		
		private var _open:Boolean;
		
		private var _elasticWidth:Number;
		private var _elasticHeight:Number;
		
		public const window:Window = new Window();
		
		public function get open():Boolean { return _open;}
		public function set open(value:Boolean):void {
			if (value == _open) return;
			_open = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_OPEN));
		}
		
		public function get elasticWidth():Number { return _elasticWidth;}
		public function set elasticWidth(value:Number):void {
			if (value == _elasticWidth) return;
			_elasticWidth = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_ELASTIC_WIDTH));
		}
		
		public function get elasticHeight():Number { return _elasticHeight;}
		public function set elasticHeight(value:Number):void {
			if (value == _elasticHeight) return;
			_elasticHeight = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_ELASTIC_HEIGHT));
		}
	}
}