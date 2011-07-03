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
	import com.panozona.modules.panolink.model.EmbededGraphics;
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class WindowView extends Sprite{
		
		public const window:Sprite = new Sprite;
		private var windowCloseButton:SimpleButton;
		
		private var _panoLinkData:PanoLinkData;
		
		private var _linkView:LinkView;
		
		public function WindowView(panoLinkData:PanoLinkData){
			
			_panoLinkData = panoLinkData;
			
			visible = _panoLinkData.windowData.open;
			
			window.graphics.beginFill(0xFFFFFF);
			window.graphics.drawRect(0, 0, panoLinkData.windowData.window.size.width, panoLinkData.windowData.window.size.height);
			window.graphics.endFill();
			addChild(window);
			
			// draw close button
			windowCloseButton = new SimpleButton();
			var closePlainIcon:Sprite = new Sprite();
			closePlainIcon.addChild(new Bitmap(new EmbededGraphics.BitmapClosePlain().bitmapData));
			var closePressIcon:Sprite = new Sprite();
			closePressIcon.addChild(new Bitmap(new EmbededGraphics.BitmapClosePress().bitmapData));
			windowCloseButton.upState = closePlainIcon;
			windowCloseButton.overState = closePlainIcon;
			windowCloseButton.downState = closePressIcon;
			windowCloseButton.hitTestState = closePressIcon;
			windowCloseButton.x = window.width - windowCloseButton.width - 3;
			windowCloseButton.y = 3;
			window.addChild(windowCloseButton);
			
			windowCloseButton.addEventListener(MouseEvent.CLICK, closeWindow, false, 0, true);
			
			_linkView = new LinkView(panoLinkData);
			window.addChild(_linkView);
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
		
		private function closeWindow(e:Event):void {
			panoLinkData.windowData.open = false;
		}
	}
}