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
	import flash.display.Sprite;
	
	public class BarView extends Sprite{
		
		public const backgroundBar:Sprite = new Sprite();
		public const buttonsContainer:Sprite = new Sprite();
		
		private var _buttonBarData:ButtonBarData;
		
		public function BarView(buttonBarData:ButtonBarData):void {
			_buttonBarData = buttonBarData;
			
			if (buttonBarData.bar.visible) {
				mouseEnabled = false;
				backgroundBar.alpha = _buttonBarData.bar.alpha;
				backgroundBar.mouseEnabled = false;
				addChild(backgroundBar);
			}
			
			addChild(buttonsContainer);
		}
		
		public function get buttonBarData():ButtonBarData {
			return _buttonBarData;
		}
	}
}