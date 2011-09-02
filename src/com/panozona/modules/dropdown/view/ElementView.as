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
package com.panozona.modules.dropdown.view{
	
	import com.panozona.modules.dropdown.model.DropDownData;
	import com.panozona.modules.dropdown.model.ElementData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ElementView extends Sprite{
		
		public const textField:TextField = new TextField();
		
		private var _elementData:ElementData;
		private var _dropDownData:DropDownData;
		
		public function ElementView(elementData:ElementData, dropDownData:DropDownData) {
			_elementData = elementData;
			_dropDownData = dropDownData;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.blockIndent = 0;
			textFormat.font = dropDownData.boxData.box.style.fontFamily;
			textFormat.bold = dropDownData.boxData.box.style.fontBold;
			textFormat.size = dropDownData.boxData.box.style.fontSize;
			textFormat.color = dropDownData.boxData.box.style.fontColor;
			textFormat.leftMargin = dropDownData.boxData.box.style.fontSize * 0.3;
			textFormat.rightMargin = dropDownData.boxData.box.style.fontSize * 0.7;
			
			textField.defaultTextFormat = textFormat;
			textField.text = elementData.rawElement.label;
			textField.width = textField.textWidth + textFormat.leftMargin + textFormat.rightMargin;
			textField.selectable = false;
			textField.blendMode = BlendMode.LAYER;
			textField.background = true;
			textField.backgroundColor = dropDownData.boxData.box.style.plainColor;
			textField.border = true;
			textField.borderColor = dropDownData.boxData.box.style.borderColor;
			textField.height = dropDownData.boxData.box.style.fontSize * 1.4;
			addChild(textField);
			
			elementData.width = textField.width;
			buttonMode = true;
			
			addEventListener(MouseEvent.ROLL_OVER, mouseOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, mouseOut, false, 0, true)
		}
		
		public function get elementData():ElementData {
			return _elementData;
		}
		
		public function get dropDownData():DropDownData {
			return _dropDownData;
		}
		
		private function mouseOver(e:Event):void {
			_elementData.mouseOver = true;
		}
		
		private function mouseOut(e:Event):void {
			_elementData.mouseOver = false;
		}
	}
}