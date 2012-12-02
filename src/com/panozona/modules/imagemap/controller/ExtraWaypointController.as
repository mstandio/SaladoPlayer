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
	
	import com.panozona.modules.imagemap.events.MapEvent;
	import com.panozona.modules.imagemap.view.ExtraWaypointView;
	import com.panozona.player.module.Module;
	import flash.events.Event;
	
	public class ExtraWaypointController extends RawWaypointController{
		
		private var _extraWaypointView:ExtraWaypointView;
		
		public function ExtraWaypointController(extraWaypointView:ExtraWaypointView, module:Module) {
			super(extraWaypointView, module);
			_extraWaypointView = _rawWapointView as ExtraWaypointView;
			
			_extraWaypointView.mapData.addEventListener(MapEvent.CHANGED_CURRENT_EXTRAWAYPOINT_ID, onCurrentExtraWaypointIdChange, false, 0 , true);
			
			onCurrentExtraWaypointIdChange(null);
		}
		
		override protected function handleMouseClick(e:Event):void {
			_module.saladoPlayer.manager.runAction(_extraWaypointView.extraWaypointData.extraWaypoint.action);
		}
		
		private function onCurrentExtraWaypointIdChange(e:Event):void {
			if (_extraWaypointView.extraWaypointData.extraWaypoint.id == _extraWaypointView.mapData.currentExtraWaypointId) {
				_extraWaypointView.extraWaypointData.isActive = true;
			}else {
				_extraWaypointView.extraWaypointData.isActive = false;
			}
		}
	}
}