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
package com.panozona.modules.infobox.view{
	
	import com.panozona.modules.infobox.model.InfoBoxData;
	import com.panozona.modules.infobox.model.WindowData;
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class WindowView extends Sprite{
		
		private var _closeView:CloseView;
		private var _viewerView:ViewerView;
		
		private var window:Sprite;
		private var windowCloseButton:SimpleButton;
		
		private var _infoBoxData:InfoBoxData;
		
		public function WindowView(infoBoxData:InfoBoxData) {
			
			_infoBoxData = infoBoxData;
			
			this.alpha = _infoBoxData.windowData.window.alpha;
			
			_viewerView = new ViewerView(_infoBoxData);
			window.addChild(_viewerView);
			
			_closeView = new CloseView(_infoBoxData);
			window.addChild(_closeView);
			
			visible = _infoBoxData.windowData.open;
		}
		
		public function get windowData():WindowData {
			return _infoBoxData.windowData;
		}
		
		public function get closeView():CloseView {
			return _closeView;
		}
		
		public function get viewerView():ViewerView {
			return _viewerView;
		}
	}
}