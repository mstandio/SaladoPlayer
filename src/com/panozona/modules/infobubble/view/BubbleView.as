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
package com.panozona.modules.infobubble.view{
	
	import com.panozona.modules.infobubble.model.InfoBubbleData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class BubbleView extends Sprite{
		
		public const textSprite:Sprite = new Sprite();
		
		private var textField:TextField;
		
		private var _infoBubbleData:InfoBubbleData;
		
		public function BubbleView(infoBubbleData:InfoBubbleData){
			_infoBubbleData = infoBubbleData;
			mouseEnabled = false;
			mouseChildren = false;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = _infoBubbleData.settings.textStyle.fontFamily;
			textFormat.size = _infoBubbleData.settings.textStyle.fontSize;
			textFormat.color = _infoBubbleData.settings.textStyle.fontColor;
			textFormat.bold = _infoBubbleData.settings.textStyle.fontBold;
			
			textField = new TextField();
			textField.defaultTextFormat = textFormat;
			textField.multiline = true;
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.blendMode = BlendMode.LAYER;
			textField.background = false;
			textField.x = _infoBubbleData.settings.textStyle.bubblePadding;
			textField.y = _infoBubbleData.settings.textStyle.bubblePadding;
			
			textSprite.blendMode = BlendMode.LAYER;
			textSprite.addChild(textField);
		}
		
		public function get infoBubbleData():InfoBubbleData {
			return _infoBubbleData;
		}
		
		public function setText(text:String):void {
			textField.text = "";
			var array:Array = text.split("[n]");
			for (var i:int = 0; i < array.length; i++) {
				textField.appendText(array[i]);
				if (i < array.length - 1) {
					textField.appendText("\n");
				}
			}
			textSprite.graphics.clear();
			textSprite.graphics.lineStyle(_infoBubbleData.settings.textStyle.borderSize, _infoBubbleData.settings.textStyle.borderColor);
			textSprite.graphics.beginFill(_infoBubbleData.settings.textStyle.bubbleColor);
			textSprite.graphics.drawRoundRect(0, 0,
				textField.width + _infoBubbleData.settings.textStyle.bubblePadding * 2,
				textField.height + _infoBubbleData.settings.textStyle.bubblePadding * 2,
				_infoBubbleData.settings.textStyle.borderRadius);
			textSprite.graphics.endFill();
		}
	}
}