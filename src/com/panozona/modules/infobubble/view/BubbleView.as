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
	import com.panozona.modules.infobubble.model.structure.StyleContent;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	
	public class BubbleView extends Sprite{
		
		public const textSprite:Sprite = new Sprite();
		
		private var textField:TextField = new TextField();
		private var textFormat:TextFormat = new TextFormat();
		
		private var _infoBubbleData:InfoBubbleData;
		
		public function BubbleView(infoBubbleData:InfoBubbleData){
			_infoBubbleData = infoBubbleData;
			
			mouseEnabled = false;
			mouseChildren = false;
			
			alpha = _infoBubbleData.settings.alpha;
			
			textField.defaultTextFormat = textFormat;
			textField.multiline = true;
			textField.selectable = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.blendMode = BlendMode.LAYER;
			textField.background = false;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			
			textSprite.blendMode = BlendMode.LAYER;
			textSprite.addChild(textField);
		}
		
		public function get infoBubbleData():InfoBubbleData {
			return _infoBubbleData;
		}
		
		public function setText(text:String, styleContent:StyleContent = null):void {
			if (styleContent == null) styleContent = new StyleContent();
			
			textFormat.font = styleContent.fontFamily;
			textFormat.size = styleContent.fontSize;
			textFormat.color = styleContent.fontColor;
			textFormat.bold = styleContent.fontBold;
			textField.defaultTextFormat = textFormat;
			textField.x = styleContent.bubblePadding;
			textField.y = styleContent.bubblePadding;
			textField.text = "";
			
			var array:Array = text.split("[n]");
			for (var i:int = 0; i < array.length; i++) {
				textField.appendText(array[i]);
				if (i < array.length - 1) {
					textField.appendText("\n");
				}
			}
			textSprite.graphics.clear();
			textSprite.graphics.lineStyle(styleContent.borderSize, styleContent.borderColor);
			textSprite.graphics.beginFill(styleContent.bubbleColor);
			textSprite.graphics.drawRoundRect(0, 0,
				textField.width + styleContent.bubblePadding * 2,
				textField.height + styleContent.bubblePadding * 2,
				styleContent.borderRadius);
			textSprite.graphics.endFill();
		}
	}
}