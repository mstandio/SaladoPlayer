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
package com.panozona.modules.menuscroller.view {
	
	import com.panozona.modules.menuscroller.model.ElementData;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class ElementView extends Sprite{
		
		public var _content:DisplayObject;
		private var _contentAnchor:Sprite;
		
		private var _elementData:ElementData;
		
		public function ElementView(elementData:ElementData) {
			_elementData = elementData;
			
			_contentAnchor = new Sprite();
			_contentAnchor.graphics.beginFill(0x000000, 0);
			_contentAnchor.graphics.drawRect(0, 0, _elementData.size.width * 0.5, _elementData.size.height * 0.5);
			_contentAnchor.graphics.endFill();
			addChild(_contentAnchor);
		}
		
		public function get elementData():ElementData {
			return _elementData;
		}
		
		public function set content(displayObject:DisplayObject):void {
			if (_content != null) return;
			_contentAnchor.graphics.clear();
			_contentAnchor.x = displayObject.width * 0.5;
			_contentAnchor.y = displayObject.height * 0.5;
			_content = displayObject;
			_content.x = -displayObject.width * 0.5;
			_content.y = -displayObject.height * 0.5;
			_contentAnchor.addChild(_content);
			
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
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