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
package com.panozona.modules.panolink.view{
	
	import com.panozona.modules.panolink.model.PanoLinkData;
	import com.panozona.modules.panolink.model.WindowData;
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class WindowView extends Sprite{
		
		private var window:Sprite;
		private var windowCloseButton:Sprite;
		
		private var _panoLinkData:PanoLinkData;
		private var _textBoxView:TextBoxView;
		
		public function WindowView(panoLinkData:PanoLinkData) {
			
			_panoLinkData = panoLinkData;
			
			visible = _panoLinkData.windowData.open;
			
			// draw map window
			window = new Sprite();
			window.graphics.beginFill(0xFFFFFF);
			window.graphics.drawRect(0, 0, windowData.size.width, windowData.size.height);
			window.graphics.endFill();
			window.alpha = windowData.alpha;
			addChild(window);
			
			// draw close button
			windowCloseButton = new SimpleButton();
			var closePlainIcon:Sprite = new Sprite();
			closePlainIcon.addChild(new Bitmap(new EmbededGraphics.BitmapIconClosePlain().bitmapData));
			var closePressIcon:Sprite = new Sprite();
			closePressIcon.addChild(new Bitmap(new EmbededGraphics.BitmapIconClosePress().bitmapData));
			windowCloseButton.upState = closePlainIcon;
			windowCloseButton.overState = closePlainIcon;
			windowCloseButton.downState = closePressIcon;
			windowCloseButton.hitTestState = closePressIcon;
			windowCloseButton.x = window.width - windowCloseButton.width - 3;
			windowCloseButton.y = 3;
			windowCloseButton.alpha = 1 / _permalinkData.windowData.alpha;
			window.addChild(windowCloseButton);
			
			windowCloseButton.addEventListener(MouseEvent.CLICK, closeWindow, false, 0, true);
			
			_textBoxView = new TextBoxView(_permalinkData);
			window.addChild(_textBoxView);
		}
		
		private function closeWindow(e:Event):void {
			_permalinkData.windowData.open = false;
		}
		
		public function get panoLinkData():PanoLinkData {
			return _panoLinkData;
		}
		
		public function get windowData():WindowData {
			return _panoLinkData.windowData;
		}
		
		public function get textBoxView():TextBoxView {
			return _textBoxView;
		}
	}
}