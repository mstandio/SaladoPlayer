/*
Copyright 2010 Marek Standio.

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
along with SaladoPlayer.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.modules.navigationbar.combobox{
	
	import flash.display.Sprite;
	import flash.display.BlendMode;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ComboboxElement extends Sprite {
		
		private var _object:Object; // content
		private var style:ComboboxStyle;
		
		private var textField:TextField;
		private var textFormat:TextFormat;
		
		private var _isActive:Boolean;   // if its label is currently in main element
		private var _isEnabled:Boolean;  // if it is interactive
		private var _isMainElement:Boolean;  
		
		public function ComboboxElement(object:Object, style:ComboboxStyle, isMainElement:Boolean = false) {
			_object = object;
			this.style = style;
			_isMainElement = isMainElement;
			
			textFormat = new TextFormat();
			textFormat.blockIndent = 0;
			textFormat.font = style.fontFamily;
			textFormat.size = style.fontSize;
			textFormat.color = style.fontColor;
			textFormat.leftMargin = style.fontSize * 0.3;
			textFormat.rightMargin = style.fontSize * 0.5;
			
			textField = new TextField();
			textField.defaultTextFormat = textFormat;
			if (_isMainElement) {
				textField.text = "";
			}else {
				textField.text = (_object.label != null) ? _object.label : "no label";
			}
			
			textField.selectable = false;
			textField.blendMode = BlendMode.LAYER;
			textField.background = true;
			textField.backgroundColor = style.backgroundColor;
			textField.border = true;
			textField.borderColor = style.borderColor;
			textField.height = style.fontSize * 1.4;
			
			addChild(textField);
			
			buttonMode = true;
			useHandCursor = true;
			mouseChildren = false;
			
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver, false, 0 , true);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut, false, 0 , true);
			addEventListener(MouseEvent.CLICK, mouseClick, false, 0 , true);
		}
		
		private function mouseOver(e:Event):void {
			if (!_isMainElement && isEnabled) {
				textField.backgroundColor = style.selectedColor;
			}
		}
		
		private function mouseOut(e:Event):void {
			if (!_isMainElement && !_isActive && isEnabled) {
				textField.backgroundColor = style.backgroundColor;
			}
		}
		
		private function mouseClick(e:Event):void {
			if(!_isMainElement && isEnabled){
				dispatchEvent(new ComboboxEvent(ComboboxEvent.LABEL_CHANGED, object)); 
			}
		}
		
		public function setWidth(elementWidth:Number):void {
			textField.width = elementWidth;
		}
		
		public function getTextWidth():Number {
			return textField.textWidth + textFormat.leftMargin + textFormat.rightMargin;
		}
		
		public function setLabel(object:Object):void {
			textField.text = String(object.label);
			textField.setTextFormat(textFormat);
		}
		
		public function get object():Object {
			return _object;
		}
		
		public function set isActive(value:Boolean):void {
			if (value != _isActive) {
				_isActive = value;
				if(_isActive){
					textField.backgroundColor = style.selectedColor;
				}else {
					textField.backgroundColor = style.backgroundColor;
				}
			}
		}
		
		public function get isActive():Boolean {
			return _isActive;
		}
		
		public function set isEnabled(value:Boolean):void {
			if (value != _isEnabled) {
				_isEnabled= value;
				if (_isEnabled) {
					textFormat.color = style.fontColor;
					this.buttonMode = true;
					this.useHandCursor = true;
				}else {
					textFormat.color = 0xdddddd;
					this.buttonMode = false;
					this.useHandCursor = false;
				}
			}
		}
		
		public function get isEnabled():Boolean {
			return _isEnabled;
		}
	}
}