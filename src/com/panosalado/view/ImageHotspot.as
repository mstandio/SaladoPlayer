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
package com.panosalado.view {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	public class ImageHotspot extends ManagedChild{
		
		protected var _bitmap:Bitmap;
		protected var invalidGraphicsData:Boolean;
		
		public function ImageHotspot(bitmap:Bitmap) {
			//this.bitmap = bitmap;
			addChild(bitmap);
		}
		/*
		public function get bitmap():Bitmap { return _bitmap;}
		public function set bitmap(value:Bitmap):void {
			if (value != null) {
				_bitmap = value;
				invalidGraphicsData = true;
				addEventListener(Event.RENDER, draw, false, 0, true);
				return;
			}
			removeEventListener(Event.RENDER, draw);
		}
		
		protected function draw(e:Event):void {
			if (!invalidGraphicsData) return;
			var matrix:Matrix = new Matrix();
			matrix.tx = - _bitmap.width * 0.5;
			matrix.ty = - _bitmap.height * 0.5;
			graphics.beginBitmapFill(_bitmap.bitmapData, matrix, false, false);
			graphics.drawRect(- _bitmap.width * 0.5, - _bitmap.height * 0.5, _bitmap.width, _bitmap.height);
			graphics.endFill();
			invalidGraphicsData = false;
		}
		*/
	}
}