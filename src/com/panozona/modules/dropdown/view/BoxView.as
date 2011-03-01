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
		
		private var _elementsContainer:Sprite;
		private var _textField:TextField;
		private var textFormat:TextFormat;
		private var _button:Sprite;
		
		private var _dropDownData:DropDownData;
		
		public function BoxView(dropDownData:DropDownData){
			
			_dropDownData = dropDownData;
			
			textFormat = new TextFormat();
			textFormat.blockIndent = 0;
			textFormat.font = dropDownData.settings.style.fontFamily;
			textFormat.size = dropDownData.settings.style.fontSize;
			textFormat.color = dropDownData.settings.style.fontColor;
			textFormat.leftMargin = dropDownData.settings.style.fontSize * 0.3;
			textFormat.rightMargin = dropDownData.settings.style.fontSize * 0.5;
			
			_textField = new TextField();
			_textField.defaultTextFormat = textFormat;
			_textField.selectable = false;
			_textField.blendMode = BlendMode.LAYER;
			_textField.background = true;
			_textField.backgroundColor = dropDownData.settings.style.plainColor;
			_textField.border = true;
			_textField.borderColor = dropDownData.settings.style.borderColor;
			_textField.height = dropDownData.settings.style.fontSize * 1.4;
			_textField.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
			addChild(_textField);
			
			_button = new Sprite();
			_button.graphics.beginFill(_dropDownData.settings.style.plainColor);
			_button.graphics.drawRect(0, 0, _textField.height, _textField.height - 1 ) // inside border 
			_button.graphics.endFill();
			_button.graphics.moveTo(0, 0);
			_button.graphics.lineStyle(1, _dropDownData.settings.style.borderColor);
			_button.graphics.lineTo(0, _textField.height);
			_button.graphics.beginFill(_dropDownData.settings.style.borderColor);
			if (dropDownData.settings.style.opensUp) {
				_button.graphics.moveTo(_textField.height / 2, _textField.height / 3);
				_button.graphics.lineTo(_textField.height / 3 * 2, _textField.height / 3 * 2);
				_button.graphics.lineTo(_textField.height / 3, _textField.height / 3 * 2);
			} else {
				_button.graphics.moveTo(_textField.height / 3, _textField.height / 3);
				_button.graphics.lineTo(_textField.height / 3 * 2, _textField.height / 3);
				_button.graphics.lineTo(_textField.height / 2, _textField.height / 3 * 2);
			}
			_button.graphics.endFill();
			_button.buttonMode = true;
			_button.useHandCursor = true;
			_button.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
			addChild(_button);
			
			_elementsContainer = new Sprite();
			_elementsContainer.visible = false;
			addChild(_elementsContainer);
			
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
		}
		
		public function get dropDownData():DropDownData {
			return _dropDownData;
		}
		
		public function get elementsContainer():Sprite {
			return _elementsContainer;
		}
		
		public function get textField():TextField {
			return _textField;
		}
		
		public function get button():Sprite {
			return _button;
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