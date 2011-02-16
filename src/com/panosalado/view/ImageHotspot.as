/*
Copyright 2010 Marek Standio.

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
along with SaladoPlayer.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.panosalado.view {

	import flash.display.Sprite
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	
	public class ImageHotspot extends ManagedChild{
		
		public var _bitmapData:BitmapData;
		public var invalidGraphicsData:Boolean;
		
		public function ImageHotspot(bitmapData:BitmapData) {
			this.bitmapData = bitmapData;
		}
		
		public function get bitmapData():BitmapData { return _bitmapData;}
		public function set bitmapData(value:BitmapData):void {
			if (value != null) {
				_bitmapData = value;
				invalidGraphicsData = true;
				addEventListener(Event.RENDER, draw, false, 0, true);
				return;
			}
			removeEventListener(Event.RENDER, draw);
		}
		
		protected function draw(e:Event):void {
			if (!invalidGraphicsData) return;
			var matrix:Matrix = new Matrix();
			matrix.tx = - bitmapData.width * 0.5;
			matrix.ty = - bitmapData.height * 0.5;
			graphics.beginBitmapFill(bitmapData,matrix,false,false);
			graphics.drawRect(- bitmapData.width * 0.5, - bitmapData.height * 0.5, bitmapData.width, bitmapData.height);
			graphics.endFill();
			invalidGraphicsData = false;
		}
	}
}