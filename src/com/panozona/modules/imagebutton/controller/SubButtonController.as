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
package com.panozona.modules.imagebutton.controller{
	
	import com.panozona.modules.imagebutton.events.SubButtonEvent;
	import com.panozona.modules.imagebutton.model.SubButtonData;
	import com.panozona.modules.imagebutton.view.SubButtonView;
	import com.panozona.player.module.Module;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	public class SubButtonController {
		
		private var _module:Module;
		private var _subButtonView:SubButtonView;
		
		public function SubButtonController(subButtonView:SubButtonView, module:Module){
			_subButtonView = subButtonView;
			_module = module;
			
			if (subButtonView.subButtonData.onPress != null) {
				_subButtonView.addEventListener(MouseEvent.MOUSE_DOWN, subButtonView.subButtonData.onPress, false, 0, true);
			}
			
			if (subButtonView.subButtonData.onRelease != null) {
				_subButtonView.addEventListener(MouseEvent.MOUSE_UP, subButtonView.subButtonData.onRelease, false, 0, true);
				_subButtonView.addEventListener(MouseEvent.ROLL_OUT, subButtonView.subButtonData.onRelease, false, 0, true);
			}
			_subButtonView.subButtonData.addEventListener(SubButtonEvent.CHANGED_MOUSE_PRESS, handleButtonMousePressChange, false, 0, true);
			_subButtonView.subButtonData.addEventListener(SubButtonEvent.CHANGED_IS_ACTIVE, handleButtonIsActiveChange, false, 0, true);
		}
		
		private function handleButtonMousePressChange(e:SubButtonEvent):void {
			if (_subButtonView.subButtonData.mousePress) {
				_subButtonView.setActive();
			}else if (!_subButtonView.subButtonData.isActive) {
				_subButtonView.setPlain();
			}
		}
		
		private function handleButtonIsActiveChange(e:SubButtonEvent):void {
			if (!_subButtonView.subButtonData.isActive) {
				_subButtonView.setPlain();
			}else {
				_subButtonView.setActive();
			}
		}
	}
}