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
package com.panozona.modules.menuscroller.view{
	
	import com.panozona.modules.menuscroller.model.MenuScrollerData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ScrollerView extends Sprite {
		
		public const elementsContainer:Sprite = new Sprite();
		public const elementsContainerMask:Sprite = new Sprite();
		
		private var _menuScrollerData:MenuScrollerData;
		
		public function ScrollerView(menuScrollerData:MenuScrollerData, window:Sprite) {
			_menuScrollerData = menuScrollerData;
			
			alpha = 1 / _menuScrollerData.windowData.window.alpha;
			
			addChild(elementsContainer);
			addChild(elementsContainerMask);
			elementsContainer.mask = elementsContainerMask;
			
			window.addEventListener(MouseEvent.ROLL_OVER, onOver, false, 0, true);
			window.addEventListener(MouseEvent.ROLL_OUT, onOut, false, 0, true);
		}
		
		public function get menuScrollerData():MenuScrollerData {
			return _menuScrollerData;
		}
		
		private function onOver(e:Event):void {
			_menuScrollerData.scrollerData.mouseOver = true;
		}
		private function onOut(e:Event):void {
			_menuScrollerData.scrollerData.mouseOver = false;
		}
	}
}