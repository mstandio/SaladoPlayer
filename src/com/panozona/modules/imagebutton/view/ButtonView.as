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
	
	import com.panozona.modules.imagebutton.model.ButtonData;
	import com.panozona.modules.imagebutton.model.ImageButtonData;
	import flash.display.Sprite;
	
	public class ButtonView extends Sprite{
		
		public var buttonData:ButtonData;
		public var imageButtonData:ImageButtonData;
		
		public function ButtonView(buttonData:ButtonData, imageButtonData:ImageButtonData) {
			this.buttonData = buttonData;
			this.imageButtonData = imageButtonData;
			visible = buttonData.button.open;
			
			if (buttonData.button.text || buttonData.button.mouse.onClick
						|| buttonData.button.mouse.onOut || buttonData.button.mouse.onOver
						|| buttonData.button.mouse.onPress || buttonData.button.mouse.onRelease){
				buttonMode = true;
			}else {
				mouseEnabled = false;
				mouseChildren = false;
			}
		}
	}
}