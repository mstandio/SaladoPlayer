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
	
	import com.panozona.modules.imagemap.model.ImageMapData;
	import com.panozona.modules.imagemap.model.WaypointData;
	import flash.display.Sprite;
	
	public class WaypointView extends RawWaypointView{
		
		public const radar:Sprite = new Sprite();
		
		private var _radarTilt:Number;
		private var _radarScaleY:Number;
		
		public function WaypointView (imageMapData:ImageMapData, waypointData:WaypointData, mapView:MapView) {
			super(imageMapData, waypointData);
			
			radar.mouseEnabled = false;
			mapView.radarContainer.addChild(radar);
			
			_radarTilt = 1;
			_radarScaleY = 1;
		}
		
		public function get waypointData():WaypointData {
			return _rawWaypointData as WaypointData;
		}
		
		override public function placeWaypoint():void {
			super.placeWaypoint();
			radar.x = _rawWaypointData.rawWaypoint.position.x * _imageMapData.viewerData.scale;
			radar.y = _rawWaypointData.rawWaypoint.position.y * _imageMapData.viewerData.scale;
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
	}
}