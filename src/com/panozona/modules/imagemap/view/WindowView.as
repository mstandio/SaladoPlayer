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
package com.panozona.modules.imagemap.view{
	
	import com.panozona.modules.imagemap.model.ImageMapData;
	import com.panozona.modules.imagemap.model.WindowData;
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class WindowView extends Sprite{
		
		private var _closeView:CloseView;
		private var _viewerView:ViewerView;
		
		private var window:Sprite;
		
		private var _imageMapData:ImageMapData;
		
		public function WindowView(imageMapData:ImageMapData) {
			
			_imageMapData = imageMapData;
			
			this.alpha = _imageMapData.windowData.window.alpha;
			
			// draw map window
			window = new Sprite();
			window.graphics.beginFill(0xFFFFFF,0);
			window.graphics.drawRect(0, 0, _imageMapData.windowData.window.size.width, _imageMapData.windowData.window.size.height);
			window.graphics.endFill();
			addChild(window);
			
			_viewerView = new ViewerView(_imageMapData);
			window.addChild(_viewerView);
			
			_closeView = new CloseView(_imageMapData);
			window.addChild(_closeView);
			
			visible = _imageMapData.windowData.open;
		}
		
		public function get windowData():WindowData {
			return _imageMapData.windowData;
		}
		
		public function get closeView():CloseView {
			return _closeView;
		}
		
		public function get viewerView():ViewerView {
			return _viewerView;
		}
	}
}