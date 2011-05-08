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
	
	import com.panozona.modules.imagemap.model.EmbededGraphics;
	import com.panozona.modules.imagemap.model.ImageMapData;
	import com.panozona.modules.imagemap.model.WindowData;
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class WindowView extends Sprite{
		
		private var _imageMapData:ImageMapData;
		
		private var _contentViewerView:ContentViewerView;
		
		private var window:Sprite;
		private var windowCloseButton:SimpleButton;
		
		public function WindowView(imageMapData:ImageMapData) {
			
			_imageMapData = imageMapData;
			
			this.alpha = _imageMapData.windowData.window.alpha;
			
			// draw map window
			window = new Sprite();
			window.graphics.beginFill(0xFFFFFF,0);
			window.graphics.drawRect(0, 0, _imageMapData.windowData.window.size.width, _imageMapData.windowData.window.size.height);
			window.graphics.endFill();
			addChild(window);
			
			_contentViewerView = new ContentViewerView(_imageMapData);
			window.addChild(_contentViewerView);
			
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
			windowCloseButton.alpha = 1 / _imageMapData.windowData.window.alpha;
			window.addChild(windowCloseButton);
			
			visible = _imageMapData.windowData.open;
			
			windowCloseButton.addEventListener(MouseEvent.CLICK, closeWindow, false, 0, true);
		}
		
		public function get windowData():WindowData {
			return _imageMapData.windowData;
		}
		
		public function get contentViewerView():ContentViewerView {
			return _contentViewerView;
		}
		
		private function closeWindow(e:Event):void {
			_imageMapData.windowData.open = false;
		}
	}
}