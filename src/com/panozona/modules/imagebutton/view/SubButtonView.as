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
package com.panozona.modules.imagebutton.view{
	
	import com.panozona.modules.imagebutton.model.SubButtonData;
	import com.panozona.modules.imagebutton.model.WindowData;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class SubButtonView extends Sprite{
		
		public const bitmap:Bitmap = new Bitmap();
		
		private var _subButtonData:SubButtonData;
		private var _windowData:WindowData;
		
		public function SubButtonView(subButtonData:SubButtonData, windowData:WindowData){
			_subButtonData = subButtonData;
			_windowData = windowData;
			
			bitmap.x = subButtonData.subButton.move.horizontal;
			bitmap.y = subButtonData.subButton.move.vertical;
			addChild(bitmap);
			
			if (subButtonData.subButton.action != null) {
				buttonMode = true;
			}
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMousePress, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, onMouseRelease, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, onMouseRelease, false, 0, true);
		}
		
		public function get subButtonData():SubButtonData {
			return _subButtonData;
		}
		
		public function get windowData():WindowData {
			return _windowData;
		}
		
		private function onMousePress(e:MouseEvent):void {
			_subButtonData.mousePress = true;
		}
		
		private function onMouseRelease(e:MouseEvent):void {
			_subButtonData.mousePress = false;
		}
	}
}