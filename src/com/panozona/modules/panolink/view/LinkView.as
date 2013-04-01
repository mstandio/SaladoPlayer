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
package com.panozona.modules.panolink.view {
	
	import com.panozona.modules.panolink.model.PanoLinkData;
	import com.panozona.player.module.data.property.Size;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class LinkView extends Sprite {
		
		private var textField:TextField;
		private var textFormat:TextFormat;
		
		public const copyButton:SimpleButton = new SimpleButton();
		
		private var _panoLinkData:PanoLinkData;
		
		public function LinkView(panoLinkData:PanoLinkData) {
			
			_panoLinkData = panoLinkData;
			
			textFormat = new TextFormat();
			textFormat.size = _panoLinkData.settings.style.fontSize;
			textFormat.font = _panoLinkData.settings.style.fontFamily;
			textFormat.bold = _panoLinkData.settings.style.fontBold;
			textFormat.color = _panoLinkData.settings.style.fontColor;
			
			textField = new TextField();
			textField.background = true;
			textField.backgroundColor = _panoLinkData.settings.style.backgroundColor;
			textField.alwaysShowSelection = true;
			textField.defaultTextFormat = textFormat;
			textField.selectable = false;
			addChild(textField);
			
			draw();
		}
		
		public function setBitmapsData(plainBitmapData:BitmapData, activeBitmapData:BitmapData):void {
			var copyPlainIcon:Sprite = new Sprite();
			copyPlainIcon.addChild(new Bitmap(plainBitmapData));
			var copyPressIcon:Sprite = new Sprite();
			copyPressIcon.addChild(new Bitmap(activeBitmapData));
			copyButton.upState = copyPlainIcon;
			copyButton.overState = copyPlainIcon;
			copyButton.downState = copyPressIcon;
			copyButton.hitTestState = copyPressIcon;
			copyButton.mouseEnabled = true;
			addChild(copyButton);
			copyButton.addEventListener(MouseEvent.CLICK, copyText, false, 0, true);
			
			draw();
		}
		
		public function draw():void {
			textField.width = _panoLinkData.windowData.currentSize.width - copyButton.width;
			textField.height = _panoLinkData.settings.style.fontSize * 1.4;
			textField.scrollH = textField.maxScrollH;
			
			copyButton.x = textField.width + 3;
			copyButton.y = (_panoLinkData.settings.style.fontSize * 1.4 - copyButton.height) * 0.5;
		}
		
		public function get panoLinkData():PanoLinkData {
			return _panoLinkData;
		}
		
		public function setText(value:String):void {
			textField.setSelection(0, 0);
			textField.text = value;
			textField.scrollH = textField.maxScrollH;
		}
		
		private function copyText(e:Event):void {
			textField.setSelection(0, textField.text.length);
			System.setClipboard(textField.text);
		}
	}
}