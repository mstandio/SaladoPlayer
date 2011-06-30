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
package com.panozona.modules.buttonbar.controller{
	
	import com.panozona.modules.buttonbar.events.ButtonEvent;
	import com.panozona.modules.buttonbar.model.ButtonData;
	import com.panozona.modules.buttonbar.view.ButtonView;
	import com.panozona.player.module.Module;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	public class ButtonController {
		
		private var _module:Module;
		private var _buttonView:ButtonView;
		
		public function ButtonController(buttonView:ButtonView, module:Module){
			_buttonView = buttonView;
			_module = module;
			
			if (buttonView.buttonData.onPress != null) {
				_buttonView.addEventListener(MouseEvent.MOUSE_DOWN, buttonView.buttonData.onPress, false, 0, true);
			}
			
			if (buttonView.buttonData.onRelease != null) {
				_buttonView.addEventListener(MouseEvent.MOUSE_UP, buttonView.buttonData.onRelease, false, 0, true);
				if(buttonView.buttonData.button.name != "fullscreen"){ // bug when switching to fullscreen
					_buttonView.addEventListener(MouseEvent.ROLL_OUT, buttonView.buttonData.onRelease, false, 0, true);
				}
			}
			
			_buttonView.buttonData.addEventListener(ButtonEvent.CHANGED_BITMAP_PLAIN, handleButtonBitmapPlainChange, false, 0, true);
			_buttonView.buttonData.addEventListener(ButtonEvent.CHANGED_BITMAP_ACTIVE, handleButtonBitmapActiveChange, false, 0, true);
			
			_buttonView.buttonData.addEventListener(ButtonEvent.CHANGED_MOUSE_PRESS, handleButtonMousePressChange, false, 0, true);
			_buttonView.buttonData.addEventListener(ButtonEvent.CHANGED_STATE, handleButtonStateChange, false, 0, true);
		}
		
		private function handleButtonBitmapPlainChange(e:ButtonEvent):void {
			if (_buttonView.buttonData.state == ButtonData.STATE_PLAIN) {
				drawPlain();
			}
		}
		
		private function handleButtonBitmapActiveChange(e:ButtonEvent):void {
			if (_buttonView.buttonData.state == ButtonData.STATE_ACTIVE) {
				drawActive();
			}
		}
		
		private function handleButtonMousePressChange(e:ButtonEvent):void {
			if (_buttonView.buttonData.mousePress) {
				drawActive();
			}else if (_buttonView.buttonData.state != ButtonData.STATE_ACTIVE){
				drawPlain();
			}
		}
		
		private function handleButtonStateChange(e:ButtonEvent):void {
			if (_buttonView.buttonData.state == ButtonData.STATE_PLAIN) {
				drawPlain();
			}else {
				drawActive();
			}
		}
		
		private function drawPlain():void {
			if (_buttonView.buttonData.bitmapPlain != null) {
				_buttonView.bitmap.bitmapData = _buttonView.buttonData.bitmapPlain;
			}
		}
		
		private function drawActive():void{
			if (_buttonView.buttonData.bitmapActive != null) {
				_buttonView.bitmap.bitmapData = _buttonView.buttonData.bitmapActive;
			}
		}
	}
}