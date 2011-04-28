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
package com.panozona.modules.imagebutton.model{
	
	import com.panozona.modules.imagebutton.events.ButtonEvent;
	import com.panozona.modules.imagebutton.model.structure.Button;
	import flash.events.EventDispatcher;
	
	public class ButtonData extends EventDispatcher{
		
		private var _button:Button;
		private var _open:Boolean;
		
		public function ButtonData(button:Button){
			_button = button;
			_open = _button.open;
		}
		
		public function get button():Button{
			return _button;
		}
		
		public function get open():Boolean{return _open;}
		public function set open(value:Boolean):void{
			if (value == _open) return;
			_open = value;
			dispatchEvent(new ButtonEvent(ButtonEvent.CHANGED_OPEN));
		}
	}
}