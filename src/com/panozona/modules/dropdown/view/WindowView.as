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
package com.panozona.modules.dropdown.view{
	
	import com.panozona.modules.dropdown.model.DropDownData;
	import com.panozona.modules.dropdown.model.WindowData;
	import flash.display.Sprite;
	
	public class WindowView extends Sprite{
		
		private var _boxView:BoxView;
		private var _dropDownData:DropDownData;
		
		public function WindowView(dropDownData:DropDownData) {
			_dropDownData = dropDownData;
			
			this.alpha = _dropDownData.windowData.window.alpha;
			
			_boxView = new BoxView(_dropDownData);
			addChild(_boxView);
			
			visible = _dropDownData.windowData.open;
		}
		
		public function get dropDownData():DropDownData {
			return _dropDownData;
		}
		
		public function get windowData():WindowData {
			return _dropDownData.windowData;
		}
		
		public function get boxView():BoxView {
			return _boxView;
		}
	}
}