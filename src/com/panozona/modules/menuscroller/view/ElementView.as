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
	import flash.display.MovieClip;
	
	public class ElementView extends Sprite{
		
		public var _content:DisplayObject;
		private var _elementData:ElementData;
		private var _contentAnchor:MovieClip;
		
		public function ElementView(elementData:ElementData) {
			_elementData = elementData;
			
			_contentAnchor = new MovieClip();
			_contentAnchor.graphics.beginFill(0xFF0000, 1);
			_contentAnchor.graphics.drawRect(0, 0, _elementData.size.width, _elementData.size.height);
			_contentAnchor.graphics.endFill();
			addChild(_contentAnchor);
		}
		
		public function get elementData():ElementData {
			return _elementData;
		}
		
		public function set content(displayObject:DisplayObject):void {
			if (_content != null) return;
			
			_content = displayObject;
			_contentAnchor.graphics.clear();
			_contentAnchor.addChild(_content);
			_content.x = _content.width * 0.5;
			_content.y = _content.height * 0.5;
			
			_content.addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
			_content.addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
		}
		
		private function onMouseOver(e:Event):void {
			_elementData.state = ElementData.STATE_HOVER;
		}
		
		private function onMouseOut(e:Event):void {
			_elementData.state = ElementData.STATE_PLAIN;
		}
	}
}