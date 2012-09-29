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
package com.panozona.modules.imagemap.model{
	
	import com.panozona.modules.imagemap.events.WaypointEvent;
	import com.panozona.modules.imagemap.model.structure.Radar;
	import com.panozona.modules.imagemap.model.structure.Waypoint;
	import com.panozona.player.module.data.property.Move;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	
	public class WaypointData extends EventDispatcher{
		
		public var waypoint:Waypoint;
		public var radar:Radar;
		public var panShift:Number;
		
		public var move:Move;
		
		public var bitmapDataPlain:BitmapData;
		public var bitmapDataHover:BitmapData;
		public var bitmapDataActive:BitmapData;
		
		private var _showRadar:Boolean;
		private var _mouseOver:Boolean;
		private var _hasFocus:Boolean;
		
		public function WaypointData(waypoint:Waypoint, radar:Radar, panShift:Number, move:Move,
			bitmapDataPlain:BitmapData, bitmapDataHover:BitmapData, bitmapDataActive:BitmapData ){
			this.waypoint = waypoint;
			this.radar = radar;
			this.panShift = panShift;
			this.move = move;
			this.bitmapDataPlain = bitmapDataPlain;
			this.bitmapDataHover = bitmapDataHover;
			this.bitmapDataActive = bitmapDataActive;
		}
		
		public function get showRadar():Boolean {return _showRadar;}
		public function set showRadar(value:Boolean):void {
			if (value == _showRadar) return;
			_showRadar = value;
			dispatchEvent(new WaypointEvent(WaypointEvent.CHANGED_SHOW_RADAR));
		}
		
		public function get mouseOver():Boolean {return _mouseOver;}
		public function set mouseOver(value:Boolean):void {
			if (value == _mouseOver) return;
			_mouseOver = value;
			dispatchEvent(new WaypointEvent(WaypointEvent.CHANGED_MOUSE_OVER));
		}
		
		public function get hasFocus():Boolean {return _hasFocus;}
		public function set hasFocus(value:Boolean):void {
			if (value == _hasFocus) return;
			_hasFocus = value;
			if (_hasFocus) {
				dispatchEvent(new WaypointEvent(WaypointEvent.FOCUS_GAINED));
			}
		}
	}
}