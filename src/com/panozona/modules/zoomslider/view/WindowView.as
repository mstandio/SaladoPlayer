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
package com.panozona.modules.zoomslider.view {
	
	import com.panozona.modules.zoomslider.model.ZoomSliderData;
	import com.panozona.modules.zoomslider.model.WindowData;
	import flash.display.Sprite;
	
	public class WindowView extends Sprite {
		
		private var _sliderView:SliderView;
		private var _zoomSliderData:ZoomSliderData;
		
		public function WindowView(zoomSliderData:ZoomSliderData) {
			_zoomSliderData = zoomSliderData;
			
			_sliderView = new SliderView(zoomSliderData);
			addChild(sliderView);
		}
		
		public function get sliderView():SliderView {
			return _sliderView;
		}
		
		public function get zoomSliderData():ZoomSliderData {
			return _zoomSliderData;
		}
		
		public function get windowData():WindowData {
			return _zoomSliderData.windowData;
		}
	}
}