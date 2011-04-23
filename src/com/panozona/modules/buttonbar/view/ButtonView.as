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
package com.panozona.modules.buttonbar.view{
	
	import com.panozona.modules.buttonbar.model.ButtonData;
	import com.panozona.modules.buttonbar.model.ButtonBarData;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class ButtonView extends Sprite{
		
		public var bitmap:Bitmap;
		
		private var _buttonData:ButtonData;
		private var _buttonBarData:ButtonBarData;
		
		
		public function ButtonView(buttonData:ButtonData, buttonBarData:ButtonBarData){
			_buttonData = buttonData;
			_buttonBarData = buttonBarData;
			
			buttonMode = true;
			
			bitmap = new Bitmap();
			addChild(bitmap);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMousePress, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, onMouseRelease, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, onMouseRelease, false, 0, true);
		}
		
		public function get buttonData():ButtonData {
			return _buttonData;
		}
		
		public function get buttonBarData():ButtonBarData {
			return _buttonBarData;
		}
		
		private function onMousePress(e:MouseEvent):void {
			_buttonData.mousePress = true;
		}
		
		private function onMouseRelease(e:MouseEvent):void {
			_buttonData.mousePress = false;
		}
	}
}