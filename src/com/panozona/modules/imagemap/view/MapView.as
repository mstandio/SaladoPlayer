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
package com.panozona.modules.imagemap.view {
	
	import com.panozona.modules.imagemap.model.ImageMapData;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class MapView extends Sprite {
		
		public const waypointsContainer:Sprite = new Sprite();
		public const radarContainer:Sprite = new Sprite();
		
		private var _content:DisplayObject;
		private var _imageMapData:ImageMapData;
		
		public function MapView(imageMapData:ImageMapData) {
			_imageMapData = imageMapData;
			
			addChild(waypointsContainer);
		}
		
		public function get imageMapData():ImageMapData {
			return _imageMapData;
		}
		
		public function get content():DisplayObject {
			return _content;
		}
		
		public function set content(value:DisplayObject):void {
			if (value == null) return;
			while(numChildren) removeChildAt(0);
			_content = value;
			addChild(_content);
			addChild(waypointsContainer);
		}
	}
}