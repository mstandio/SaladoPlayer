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
package com.panozona.modules.compass.view {
	
	import com.panozona.modules.compass.model.CompassData;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	
	
	public class CompassView extends Sprite{
		
		public const base:Sprite = new Sprite();
		public const axis:Sprite = new Sprite();
		
		private var _dial:Bitmap;
		private var _needle:Bitmap;
		
		private var _compassData:CompassData;
		
		public function CompassView(compassData:CompassData):void {
			
			_compassData = compassData;
			
			addChild(base);
		}
		
		public function setBitmapsData(dialBitmapData:BitmapData, needleBitmapData:BitmapData):void {
			_dial = new Bitmap(dialBitmapData, PixelSnapping.NEVER, true);
			_needle = new Bitmap(needleBitmapData, PixelSnapping.NEVER, true);
			
			if (_compassData.settings.rotateNeedle) {
				_needle.x = -_needle.width * 0.5;
				_needle.y = -_needle.height * 0.5;
				base.addChild(_dial);
				axis.x = _dial.x + _dial.width * 0.5;
				axis.y = _dial.y + _dial.height * 0.5;
				axis.addChild(_needle);
				base.addChild(axis);
			}else {
				axis.x = _dial.width * 0.5;
				axis.y = _dial.height * 0.5;
				_dial.x = -_dial.width * 0.5;
				_dial.y = -_dial.height * 0.5;
				_needle.x = (_dial.width - _needle.width) * 0.5;
				axis.addChild(_dial);
				base.addChild(axis);
				base.addChild(_needle);
			}
		}
		
		public function get compassData():CompassData {
			return _compassData;
		}
	}
}