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
	
	import com.panozona.modules.imagemap.model.ContentViewerData;
	import com.panozona.modules.imagemap.model.ImageMapData;
	import com.panozona.modules.imagemap.model.WaypointData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class WaypointView extends Sprite{
		
		public const radar:Sprite = new Sprite();
		public const button:Sprite = new Sprite();
		
		private var _imageMapData:ImageMapData;
		private var _waypointData:WaypointData;
		
		public function WaypointView (imageMapData:ImageMapData, waypointData:WaypointData) {
			
			_imageMapData = imageMapData;
			_waypointData = waypointData;
			
			radar.mouseEnabled = false;
			radar.alpha = (1 / imageMapData.windowData.window.alpha) * _waypointData.radar.alpha;
			radar.x = waypointData.waypoint.position.x;
			radar.y = waypointData.waypoint.position.y;
			addChild(radar);
			
			button.buttonMode = true;
			button.alpha = 1 / imageMapData.windowData.window.alpha;
			button.x = _waypointData.waypoint.position.x;
			button.y = _waypointData.waypoint.position.y;
			addChild(button);
			
			button.addEventListener(MouseEvent.ROLL_OVER, mouseOver, false, 0, true);
			button.addEventListener(MouseEvent.ROLL_OUT, mouseOut, false, 0, true);
		}
		
		public function get contentViewerData():ContentViewerData {
			return _imageMapData.contentViewerData;
		}
		
		public function get waypointData():WaypointData {
			return _waypointData;
		}
		
		public function radarFirst():void {
			addChild(button);
			addChild(radar);
		}
		
		public function buttonFirst():void {
			addChild(radar);
			addChild(button);
		}
		
		private function mouseOver(e:Event):void {
			waypointData.mouseOver = true; // button color change
			_imageMapData.contentViewerData.mouseOver = false; // removing hand bitmap
			
		}
		
		private function mouseOut(e:Event):void {
			waypointData.mouseOver = false; // button color change
			_imageMapData.contentViewerData.mouseOver = true; // adding hand bitmap
		}
	}
}