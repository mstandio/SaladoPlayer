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
package com.panozona.modules.imagemap.view {
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.panozona.modules.imagemap.model.ImageMapData;
	import com.panozona.modules.imagemap.model.ContentViewerData;
	import com.panozona.modules.imagemap.model.WaypointData;
	
	/**
	 * @author mstandio
	 */
	public class WaypointView extends Sprite{
		
		private var _imageMapData:ImageMapData;
		private var _waypointData:WaypointData;
		
		private var _radar:Sprite;
		
		private var _button:Sprite;
		
		public function WaypointView (imageMapData:ImageMapData, waypointData:WaypointData) {
			
			_imageMapData = imageMapData;
			_waypointData = waypointData;
			
			_radar = new Sprite();
			_radar.mouseEnabled = false;
			_radar.x = waypointData.waypoint.position.x;
			_radar.y = waypointData.waypoint.position.y;
			addChild(_radar);
			
			_button = new Sprite();
			_button .buttonMode = true;
			_button.graphics.beginFill(0xffff00);            // temporary, needs more states
			_button.graphics.drawRect(0, 0, 20, 20);
			//_button.graphics.lineStyle(2*20, 0x000000);
			//_button.graphics.drawCircle(0, 0, 15*20);
			_button.graphics.endFill();
			
			_button.alpha = 1 / imageMapData.windowData.alpha;
			
			_button.x = _waypointData.waypoint.position.x - (_button.width * 0.5);
			_button.y = _waypointData.waypoint.position.y - (_button.height * 0.5);
			addChild(_button);
			
			_button.addEventListener(MouseEvent.ROLL_OVER, mouseOver);
			_button.addEventListener(MouseEvent.ROLL_OUT, mouseOut);
		}	
		
		public function get contentViewerData():ContentViewerData {
			return _imageMapData.contentViewerData;
		}
		
		public function get waypointData():WaypointData {
			return _waypointData;
		}
		
		public function get radar():Sprite {
			return _radar;
		}
		
		public function get button():Sprite {
			return _button;
		}
		
		private function mouseOver(e:Event):void {
			_imageMapData.contentViewerData.mouseOver = false;
		}
		
		private function mouseOut(e:Event):void {
			_imageMapData.contentViewerData.mouseOver = true;
		}
	}
}