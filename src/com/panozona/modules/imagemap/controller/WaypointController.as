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
package com.panozona.modules.imagemap.controller {
	
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	import com.panozona.player.module.Module;
	
	import com.panozona.modules.imagemap.view.WaypointView;
	import com.panozona.modules.imagemap.events.WaypointEvent;
	
	/**
	 * @author mstandio
	 */
	public class WaypointController {
		
		private var _waypointView:WaypointView; 
		private var _module:Module;
		
		private var _pan:Number;
		private var _tilt:Number;
		private var _fov:Number;
		
		public function WaypointController(waypointView:WaypointView, module:Module) {
			_waypointView = waypointView;
			_module = module;
			
			var LoadPanoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.LoadPanoramaEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(LoadPanoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			
			_waypointView.addEventListener(WaypointEvent.CHANGED_SHOW_RADAR, handleShowRadarChange, false, 0, true);
		}
		
		private function onPanoramaLoaded(loadPanoramaEvent:Object):void {
			if (_waypointView.waypointData.waypoint.target != null) { // TODO: aand how about mouse events ??? it should also check onclick somehow. and parse action itself. omg
				if (loadPanoramaEvent.panoramaData.id == _waypointView.waypointData.waypoint.target) {
					_waypointView.waypointData.showRadar = true;
				}else {
					_waypointView.waypointData.showRadar = false;
					
					// perhaps some fade in fade out effects ??? 
				}
			}
		}
		
		private function handleShowRadarChange(e:Event):void {
			if (_waypointView.waypointData.showRadar) {
				_pan = _module.saladoPlayer.pan;
				_tilt = _module.saladoPlayer.tilt;
				_fov = _module.saladoPlayer.fieldOfView;
				_module.stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
			}else {
				_module.stage.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			}
		}
		
		private function handleEnterFrame(e:Event):void {
			
			// cos narysowac i to obracac jakos byle by dzialalo
			// obrocic go jakos trzeba by bylo 
			
			//if (_module.saladoPlayer.fieldOfView != _fov) {
				//drawRadar();
			//}
			
			//_pan = _module.saladoPlayer.pan;
			//_tilt = _module.saladoPlayer.tilt;
			//_fov = _module.saladoPlayer.fieldOfView;
		}
		
		private function drawRadar():void {
			/*
			_waypointView.radar.graphics.clear();
			this.cam.graphics.clear();
			var r:Number = 80 * this.camSize;
			var a:Number = zoom*0.051 +0.55; 
			var x:Number = (r * Math.sin(a));
			var y:Number = (Math.sqrt(r * r - x * x));
			_waypointView.radar.graphics.beginFill(Number(this._waypointView.waypointData.color),0.75);
			_waypointView.radar.graphics.lineStyle(2*this.camSize,0x000000,0.75);
			_waypointView.radar.graphics.moveTo(0, 0);
			_waypointView.radar.graphics.lineTo(x, y);
			_waypointView.radar.graphics.curveTo(2*r-x, 0, x, -y);
			_waypointView.radar.graphics.endFill();
			*/
		}
	}
}