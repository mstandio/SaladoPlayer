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
	
	import com.panozona.modules.imagemap.model.ViewerData;
	import com.panozona.modules.imagemap.model.ImageMapData;
	import com.panozona.modules.imagemap.model.MapData;
	import com.panozona.modules.imagemap.model.WaypointData;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class WaypointView extends Sprite{
		
		public const radar:Sprite = new Sprite();
		public const button:Sprite = new Sprite();
		
		private var _buttonImage:Bitmap;
		
		private var _imageMapData:ImageMapData;
		private var _waypointData:WaypointData;
		
		private var _radarTilt:Number;
		private var _radarScaleY:Number;
		
		public function WaypointView (imageMapData:ImageMapData, waypointData:WaypointData, mapView:MapView) {
			
			_imageMapData = imageMapData;
			_waypointData = waypointData;
			
			radar.mouseEnabled = false;
			
			radar.x = waypointData.waypoint.position.x;
			radar.y = waypointData.waypoint.position.y;
			mapView.radarContainer.addChild(radar);
			
			button.buttonMode = true;
			button.alpha = 1 / imageMapData.windowData.window.alpha;
			button.x = _waypointData.waypoint.position.x;
			button.y = _waypointData.waypoint.position.y;
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
		
		public function get waypointData():WaypointData {
			return _waypointData;
		}
		
		public function set radarTilt(value:Number):void {
			if (value < 0.15) {
				_radarTilt = 0.15;
			}else {
				_radarTilt = value;
			}
			radar.scaleY = _radarTilt * button.scaleX;
		}
		
		public function set radarScaleY(value:Number):void {
			_radarScaleY = value;
			radar.scaleY = _radarTilt * value;
		}
		
		public function set buttonBitmapData(bitmapData:BitmapData):void {
			_buttonImage.bitmapData = bitmapData;
			_buttonImage.x = - _buttonImage.width * 0.5;
			_buttonImage.y = - _buttonImage.height * 0.5;
			_buttonImage.x += _waypointData.move.horizontal;
			_buttonImage.y += _waypointData.move.vertical;
		}
		
		private function mouseOver(e:Event):void {
			waypointData.mouseOver = true; // button color change
			_imageMapData.viewerData.mouseOver = false; // removing hand bitmap
			
		}
		
		private function mouseOut(e:Event):void {
			waypointData.mouseOver = false; // button color change
			_imageMapData.viewerData.mouseOver = true; // adding hand bitmap
		}
	}
}