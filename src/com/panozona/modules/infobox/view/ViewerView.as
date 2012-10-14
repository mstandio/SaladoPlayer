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
package com.panozona.modules.infobox.view {
	
	import com.panozona.modules.infobox.model.InfoBoxData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class ViewerView extends Sprite {
		
		public const textField:TextField = new TextField();
		public const textFieldMask:Sprite = new Sprite();
		
		private var _scrollBarView:ScrollBarView;
		
		private var _infoBoxData:InfoBoxData;
		
		public function ViewerView(infoBoxData:InfoBoxData) {
			_infoBoxData = infoBoxData;
			
			_scrollBarView = new ScrollBarView(infoBoxData);
			addChild(_scrollBarView);
			
			addChild(textField);
			textField.alwaysShowSelection = true;
			textField.autoSize = TextFieldAutoSize.LEFT; 
			textField.wordWrap = true;
			textField.multiline = true;
			textField.textColor = 0x00ff00;
			
			addChild(textFieldMask);
			textField.mask = textFieldMask;
		}
		
		public function get infoBoxData():InfoBoxData {
			return _infoBoxData;
		}
		
		public function get scrollBarView():ScrollBarView {
			return _scrollBarView;
		}
	}
}