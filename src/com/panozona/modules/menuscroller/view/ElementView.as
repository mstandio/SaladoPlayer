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
package com.panozona.modules.menuscroller.view {
	
	import com.panozona.modules.menuscroller.model.MenuScrollerData;
	import com.panozona.modules.menuscroller.model.ElementData;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ElementView extends Sprite{
		
		private var _content:DisplayObject;
		private var _contentAnchor:Sprite;
		
		private var _elementData:ElementData;
		
		private var _menuScrollerData:MenuScrollerData;
		
		public function ElementView(menuScrollerData:MenuScrollerData, elementData:ElementData) {
			_elementData = elementData;
			_menuScrollerData = menuScrollerData;
			
			buttonMode = true;
			
			_contentAnchor = new Sprite();
			_contentAnchor.graphics.beginFill(0x000000, 0);
			_contentAnchor.graphics.drawRect(0, 0, _elementData.plainSize.width * 0.5, _elementData.plainSize.height * 0.5);
			_contentAnchor.graphics.endFill();
			addChild(_contentAnchor);
		}
		
		public function get menuScrollerData():MenuScrollerData {
			return _menuScrollerData;
		}
		
		public function get elementData():ElementData {
			return _elementData;
		}
		
		public function set content(displayObject:DisplayObject):void {
			_contentAnchor.graphics.clear();
			_content = displayObject;
			
			placeContent();
			
			if (_content is Bitmap) {
				(_content as Bitmap).smoothing = true;
			}
			_contentAnchor.addChild(_content);
			
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
		}
		
		public function applyScale(scale:Number):void {
			_content.scaleX = _content.scaleY = scale;
			placeContent();
		}
		
		public function get content():DisplayObject {
			return _content;
		}
		
		private function placeContent():void {
			_content.x = -_content.width * 0.5;
			_content.y = -_content.height * 0.5;
			_contentAnchor.x = _content.width * 0.5;
			_contentAnchor.y = _content.height * 0.5;
		}
		
		private function onMouseOver(e:Event):void {
			parent.setChildIndex(this, parent.numChildren - 1);
			_elementData.mouseOver = true;
		}
		
		private function onMouseOut(e:Event):void {
			_elementData.mouseOver = false;
		}
	}
}