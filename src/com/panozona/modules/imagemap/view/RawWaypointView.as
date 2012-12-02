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
package com.panozona.modules.imagemap.view {
	
	import com.panozona.modules.imagemap.model.RawWaypointData;
	import com.panozona.modules.imagemap.model.ViewerData;
	import com.panozona.modules.imagemap.model.ImageMapData;
	import com.panozona.modules.imagemap.model.MapData;
	import com.panozona.modules.imagemap.model.WaypointData;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class RawWaypointView extends Sprite {
		
		public const button:Sprite = new Sprite();
		
		private var _buttonImage:Bitmap;
		
		protected var _imageMapData:ImageMapData;
		protected var _rawWaypointData:RawWaypointData;
		
		public function RawWaypointView (imageMapData:ImageMapData, rawWaypointData:RawWaypointData) {
			
			_imageMapData = imageMapData;
			_rawWaypointData = rawWaypointData;
			
			button.buttonMode = true;
			button.alpha = 1 / imageMapData.windowData.window.alpha;
			addChild(button);
			
			_buttonImage = new Bitmap();
			button.addChild(_buttonImage);
			
			button.addEventListener(MouseEvent.ROLL_OVER, mouseOver, false, 0, true);
			button.addEventListener(MouseEvent.ROLL_OUT, mouseOut, false, 0, true);
		}
		
		public function get imageMapData():ImageMapData {
			return _imageMapData;
		}
		
		public function get viewerData():ViewerData {
			return _imageMapData.viewerData;
		}
		
		public function get rawWaypointData():RawWaypointData {
			return _rawWaypointData;
		}
		
		public function set buttonBitmapData(bitmapData:BitmapData):void {
			_buttonImage.bitmapData = bitmapData;
			placeWaypoint();
		}
		
		public function placeWaypoint():void {
			x = _rawWaypointData.rawWaypoint.position.x * _imageMapData.viewerData.scale - _buttonImage.width * 0.5 + _rawWaypointData.move.horizontal;
			y = _rawWaypointData.rawWaypoint.position.y * _imageMapData.viewerData.scale - _buttonImage.height * 0.5 + _rawWaypointData.move.vertical;
		}
		
		private function mouseOver(e:Event):void {
			_rawWaypointData.mouseOver = true;
			_imageMapData.viewerData.mouseOver = false;
		}
		
		private function mouseOut(e:Event):void {
			_rawWaypointData.mouseOver = false;
			_imageMapData.viewerData.mouseOver = true;
		}
	}
}