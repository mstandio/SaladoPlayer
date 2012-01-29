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
package com.panozona.modules.panolink.view{
	
	import com.panozona.modules.panolink.model.PanoLinkData;
	import com.panozona.modules.panolink.model.WindowData;
	import com.panozona.modules.panolink.view.CloseView;
	import flash.display.Sprite;
	
	public class WindowView extends Sprite{
		
		private var _linkView:LinkView;
		private var _closeView:CloseView;
		
		private var _panoLinkData:PanoLinkData;
		
		public function WindowView(panoLinkData:PanoLinkData){
			
			_panoLinkData = panoLinkData;
			
			this.alpha = _panoLinkData.windowData.window.alpha;
			
			_linkView = new LinkView(_panoLinkData);
			addChild(_linkView);
			
			_closeView = new CloseView(_panoLinkData);
			addChild(_closeView);
			
			visible = _panoLinkData.windowData.open;
		}
		
		public function get panoLinkData():PanoLinkData {
			return _panoLinkData;
		}
		
		public function get windowData():WindowData {
			return _panoLinkData.windowData;
		}
		
		public function get linkView():LinkView {
			return _linkView;
		}
		
		public function get closeView():CloseView {
			return _closeView;
		}
	}
}