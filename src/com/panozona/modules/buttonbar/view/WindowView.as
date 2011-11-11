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
package com.panozona.modules.buttonbar.view{
	
	import com.panozona.modules.buttonbar.model.ButtonBarData;
	import com.panozona.modules.buttonbar.model.WindowData;
	import flash.display.Sprite;
	
	public class WindowView extends Sprite{
		
		private var _barView:BarView;
		private var _buttonBarData:ButtonBarData;
		
		public function WindowView(buttonBarData:ButtonBarData) {
			
			_buttonBarData = buttonBarData;
			
			this.alpha = _buttonBarData.windowData.window.alpha;
			
			_barView = new BarView(_buttonBarData);
			addChild(_barView);
			
			visible = _buttonBarData.windowData.open;
		}
		
		public function get windowData():WindowData {
			return _buttonBarData.windowData;
		}
		
		public function get barView():BarView {
			return _barView;
		}
	}
}