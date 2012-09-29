/*
Copyright 2012 Marek Standio.

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
package com.panozona.modules.imagemap.view{
	
	import com.panozona.modules.imagemap.model.ImageMapData;
	import flash.display.Sprite;
	
	public class CloseView extends Sprite{
		
		private var _imageMapData:ImageMapData;
		
		public function CloseView(imageMapData:ImageMapData):void{
			_imageMapData = imageMapData;
			alpha = 1 / _imageMapData.windowData.window.alpha;
			buttonMode = true;
		}
		
		public function get imageMapData():ImageMapData {
			return _imageMapData;
		}
	}
}