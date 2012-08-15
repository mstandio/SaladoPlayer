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
package com.panozona.modules.imagegallery.view {
	
	import com.panozona.modules.imagegallery.model.ImageGalleryData;
	import com.panozona.modules.imagegallery.model.ButtonData;
	import com.panozona.modules.imagegallery.view.ButtonView;
	import flash.display.Sprite;
	
	public class ViewerView extends Sprite {
		
		private var _imagegalleryData:ImageGalleryData;
		
		private var _buttonBar:Sprite;
		private var _buttonPrev:ButtonView;
		private var _buttonNext:ButtonView;
		
		public function ViewerView(imagegalleryData:ImageGalleryData) {
			_imagegalleryData = imagegalleryData;
			_buttonBar = new Sprite();
			addChild(_buttonBar);
			_buttonPrev = new ButtonView(new ButtonData(NaN), _imagegalleryData)
			addChild(_buttonPrev);
			_buttonNext = new ButtonView(new ButtonData(NaN), _imagegalleryData);
			addChild(_buttonNext);
		}
		
		public function get imagegalleryData():ImageGalleryData  {
			return _imagegalleryData;
		}
		
		public function get buttonBar():Sprite {
			return _buttonBar
		}
		
		public function get buttonPrev():ButtonView {
			return _buttonPrev;
		}
		
		public function get buttonNext():ButtonView {
			return _buttonNext;
		}
	}
}