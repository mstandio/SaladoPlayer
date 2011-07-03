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
package com.panozona.modules.menuscroller.view{
	
	import com.panozona.modules.menuscroller.model.MenuScrollerData;
	import com.panozona.modules.menuscroller.model.WindowData;
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class WindowView extends Sprite{
		
		private var _scrollerView:ScrollerView;
		
		private var window:Sprite;
		private var windowCloseButton:SimpleButton;
		
		private var _menuScrollerData:MenuScrollerData;
		
		public function WindowView(menuScrollerData:MenuScrollerData) {
			
			_menuScrollerData = menuScrollerData;
			
			this.alpha = _menuScrollerData.windowData.window.alpha;
			
			// draw map window
			window = new Sprite();
			addChild(window);
			visible = _menuScrollerData.windowData.open;
			
			_scrollerView = new ScrollerView(_menuScrollerData);
			window.addChild(_scrollerView);
		}
		
		public function get windowData():WindowData {
			return _menuScrollerData.windowData;
		}
		
		public function get scrollerView():ScrollerView {
			return _scrollerView;
		}
		
		public function drawBackground():void {
			window.graphics.clear()
			window.graphics.beginFill(0x000000, 0.5);
			window.graphics.drawRect(0, 0, _menuScrollerData.windowData.elasticWidth, _menuScrollerData.windowData.elasticHeight);
			window.graphics.endFill();
		}
	}
}