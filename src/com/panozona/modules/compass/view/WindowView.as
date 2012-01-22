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
package com.panozona.modules.compass.view {
	
	import com.panozona.modules.compass.model.CompassData;
	import com.panozona.modules.compass.model.WindowData;
	import flash.display.Sprite;
	
	public class WindowView extends Sprite{
		
		private var _closeView:CloseView;
		private var _compassView:CompassView;
		
		private var _compassData:CompassData;
		
		public function WindowView(compassData:CompassData):void {
			
			_compassData = compassData;
			
			this.alpha = _compassData.windowData.window.alpha;
			
			_compassView = new CompassView(_compassData);
			addChild(_compassView);
			
			_closeView = new CloseView(_compassData);
			addChild(_closeView);
			
			visible = _compassData.windowData.open;
		}
		
		public function get compassData():CompassData {
			return _compassData;
		}
		
		public function get windowData():WindowData {
			return _compassData.windowData;
		}
		
		public function get compassView():CompassView {
			return _compassView;
		}
		
		public function get closeView():CloseView {
			return _closeView;
		}
	}
}