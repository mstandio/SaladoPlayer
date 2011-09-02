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
package com.panozona.modules.dropdown.view {
	
	import com.panozona.modules.dropdown.model.DropDownData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class BoxView extends Sprite{
		
		public const elementsContainer:Sprite = new Sprite();
		public const elementsContainerMask:Sprite = new Sprite();
		public const textField:TextField = new TextField();
		public const button:Sprite = new Sprite();
		
		private var _dropDownData:DropDownData;
		
		public function BoxView(dropDownData:DropDownData){
			_dropDownData = dropDownData;
			
			elementsContainer.mask = elementsContainerMask;
			addChild(elementsContainer);
			addChild(elementsContainerMask);
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.blockIndent = 0;
			textFormat.font = dropDownData.boxData.box.style.fontFamily;
			textFormat.bold = dropDownData.boxData.box.style.fontBold;
			textFormat.size = dropDownData.boxData.box.style.fontSize;
			textFormat.color = dropDownData.boxData.box.style.fontColor;
			textFormat.leftMargin = dropDownData.boxData.box.style.fontSize * 0.3;
			textFormat.rightMargin = dropDownData.boxData.box.style.fontSize * 0.7;
			
			textField.defaultTextFormat = textFormat;
			textField.selectable = false;
			textField.blendMode = BlendMode.LAYER;
			textField.background = true;
			textField.backgroundColor = dropDownData.boxData.box.style.plainColor;
			textField.border = true;
			textField.borderColor = dropDownData.boxData.box.style.borderColor;
			textField.height = dropDownData.boxData.box.style.fontSize * 1.4;
			textField.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
			addChild(textField);
			
			button.graphics.beginFill(_dropDownData.boxData.box.style.plainColor, 0);
			button.graphics.drawRect(0, 0, textField.height, textField.height - 1) // inside border 
			button.graphics.endFill();
			button.graphics.moveTo(0, 0);
			button.graphics.lineStyle(1, _dropDownData.boxData.box.style.borderColor);
			button.graphics.lineTo(0, textField.height);
			button.graphics.beginFill(_dropDownData.boxData.box.style.borderColor);
			if (dropDownData.boxData.box.opensUp) {
				button.graphics.moveTo(textField.height / 2, textField.height / 3);
				button.graphics.lineTo(textField.height / 3 * 2, textField.height / 3 * 2);
				button.graphics.lineTo(textField.height / 3, textField.height / 3 * 2);
			} else {
				button.graphics.moveTo(textField.height / 3, textField.height / 3);
				button.graphics.lineTo(textField.height / 3 * 2, textField.height / 3);
				button.graphics.lineTo(textField.height / 2, textField.height / 3 * 2);
			}
			button.graphics.endFill();
			button.buttonMode = true;
			button.useHandCursor = true;
			button.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
			addChild(button);
			
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
		}
		
		public function get dropDownData():DropDownData {
			return _dropDownData;
		}
		
		private function onMouseClick(e:MouseEvent):void {
			_dropDownData.boxData.open = !_dropDownData.boxData.open;
		}
		
		private function onMouseOver(e:MouseEvent):void {
			_dropDownData.boxData.mouseOver = true;
		}
		
		private function onMouseOut(e:MouseEvent):void {
			_dropDownData.boxData.mouseOver = false;
		}
	}
}