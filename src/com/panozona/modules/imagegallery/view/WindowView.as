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
package com.panozona.modules.imagegallery.view {
	
	import com.panozona.modules.imagegallery.model.ImageGalleryData;
	import com.panozona.modules.imagegallery.model.WindowData;
	import flash.display.Sprite;
	
	public class WindowView extends Sprite{
		
		private var _closeView:CloseView;
		private var _viewerView:ViewerView;
		
		private var _imagegalleryData:ImageGalleryData;
		
		public function WindowView(imagegalleryData:ImageGalleryData) {
			_imagegalleryData = imagegalleryData;
			
			_viewerView = new ViewerView(_imagegalleryData);
			addChild(_viewerView);
			
			_closeView = new CloseView(_imagegalleryData);
			addChild(_closeView);
		}
		
		public function get windowData():WindowData {
			return _imagegalleryData.windowData;
		}
		
		public function get viewerView():ViewerView {
			return _viewerView;
		}
		
		public function get closeView():CloseView {
			return _closeView;
		}
	}
}