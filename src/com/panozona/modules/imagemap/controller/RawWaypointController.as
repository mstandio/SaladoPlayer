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
package com.panozona.modules.imagemap.controller {
	
	import com.panozona.modules.imagemap.events.WaypointEvent;
	import com.panozona.modules.imagemap.view.RawWaypointView;
	import com.panozona.player.module.Module;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class RawWaypointController {
		
		protected var _rawWapointView:RawWaypointView;
		protected var _module:Module;
		
		public function RawWaypointController(rawWapointView:RawWaypointView, module:Module) {
			_rawWapointView = rawWapointView;
			_module = module;
			
			_rawWapointView.rawWaypointData.addEventListener(WaypointEvent.CHANGED_MOUSE_OVER, handleMouseOverChange, false, 0, true);
			_rawWapointView.rawWaypointData.addEventListener(WaypointEvent.CHANGED_IS_ACTIVE, handleIsActiveChange, false, 0, true);
			_rawWapointView.addEventListener(MouseEvent.CLICK, handleMouseClick, false, 0, true);
			
			drawButton();
		}
		
		protected function handleMouseOverChange(e:Event):void {
			drawButton();
		}
		
		protected function handleIsActiveChange(e:Event):void {
			drawButton();
		}
		
		protected function handleMouseClick(e:Event):void {
			// to be overriden
		}
		
		private function drawButton():void {
			if (_rawWapointView.rawWaypointData.isActive){
				_rawWapointView.buttonBitmapData = _rawWapointView.rawWaypointData.bitmapDataActive;
			}else if (_rawWapointView.rawWaypointData.mouseOver) {
				_rawWapointView.buttonBitmapData = _rawWapointView.rawWaypointData.bitmapDataHover;
			}else { // !mouseOver
				_rawWapointView.buttonBitmapData = _rawWapointView.rawWaypointData.bitmapDataPlain;
			}
		}
	}
}