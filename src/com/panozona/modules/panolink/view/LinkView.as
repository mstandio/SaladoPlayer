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
	
	import com.panozona.modules.panolink.model.EmbededGraphics;
	import com.panozona.modules.panolink.model.PanoLinkData;
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class LinkView extends Sprite{
		
		private var textField:TextField;
		private var textFormat:TextFormat;
		
		private var textCopyButton:SimpleButton;
		
		private var _panoLinkData:PanoLinkData;
		
		public function LinkView(panoLinkData:PanoLinkData) {
			
			_panoLinkData = panoLinkData;
			
			// draw copy button
			textCopyButton = new SimpleButton(); // todo: do not use simplebutton!
			var copyPlainIcon:Sprite = new Sprite();
			copyPlainIcon.addChild(new Bitmap(new EmbededGraphics.BitmapCopyPlain().bitmapData));
			var copyPressIcon:Sprite = new Sprite();
			copyPressIcon.addChild(new Bitmap(new EmbededGraphics.BitmapCopyPress().bitmapData));
			textCopyButton.upState = copyPlainIcon;
			textCopyButton.overState = copyPlainIcon;
			textCopyButton.downState = copyPressIcon;
			textCopyButton.hitTestState = copyPressIcon;
			textCopyButton.x = _panoLinkData.windowData.window.size.width - textCopyButton.width - 30;
			textCopyButton.y = 3;
			
			addChild(textCopyButton);
			
			// draw textfield
			textFormat = new TextFormat();
			textFormat.size = 20;
			textFormat.font = "Verdana";
			textField = new TextField();
			textField.defaultTextFormat = textFormat;
			textField.width = _panoLinkData.windowData.window.size.width - 82;
			textField.height = _panoLinkData.windowData.window.size.height;
			textField.alwaysShowSelection = true;
			addChild(textField);
			
			textCopyButton.addEventListener(MouseEvent.CLICK, copyText, false, 0 , true);
		}
		
		private function copyText(e:Event):void {
			textField.setSelection(0, textField.text.length);
			System.setClipboard(textField.text);
		}
		
		public function get panoLinkData():PanoLinkData {
			return _panoLinkData;
		}
		
		public function setText(value:String):void {
			textField.text = value;
			textField.setSelection(0, 0);
		}
	}
}