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
	
	import caurina.transitions.Tweener;
	import com.panozona.modules.imagemap.events.WaypointEvent;
	import com.panozona.modules.imagemap.events.ViewerEvent;
	import com.panozona.modules.imagemap.view.WaypointView;
	import com.panozona.player.module.Module;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	
	public class WaypointController extends RawWaypointController{
		
		private var _pan:Number;
		private var _tilt:Number;
		private var _fov:Number;
		
		private var pan1:Number;
		private var pan2:Number;
		private var pan3:Number;
		
		private var currentDirection:Number;
		private var _waypointView:WaypointView;
		
		public function WaypointController(waypointView:WaypointView, module:Module) {
			super(waypointView, module);
			_waypointView = _rawWapointView as WaypointView;
			
			var autorotationEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.AutorotationEvent") as Class;
			_module.saladoPlayer.managerData.controlData.autorotationCameraData.addEventListener(autorotationEventClass.AUTOROTATION_CHANGE, onIsAutorotatingChange, false, 0, true);
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			
			if(_module.saladoPlayer.manager.currentPanoramaData != null){
				onPanoramaLoaded(); // in case when map just got changed
			}
		}
		
		override protected function handleMouseClick(e:Event):void {
			if (_module.saladoPlayer.manager.currentPanoramaData.id != _waypointView.waypointData.waypoint.target){
				_module.saladoPlayer.manager.loadPano(_waypointView.waypointData.waypoint.target);
			}else {
				_waypointView.waypointData.hasFocus = true;
			}
		}
		
		private function onPanoramaLoaded(panoramaEvent:Object = null):void {
			if (_module.saladoPlayer.manager.currentPanoramaData.id == _waypointView.waypointData.waypoint.target) {
				currentDirection = _module.saladoPlayer.managerData.getPanoramaDataById(_waypointView.waypointData.waypoint.target).direction;
				_waypointView.waypointData.hasFocus = true;
				_waypointView.waypointData.isActive = true;
				if (!_waypointView.waypointData.radar.showTilt) {
					_waypointView.imageMapData.mapData.radarFirst = false;
				}
			}else {
				_waypointView.waypointData.isActive = false;
			}
		}
		
		private function onIsAutorotatingChange(autorotationEvent:Object):void {
			if (_waypointView.waypointData.isActive && !_waypointView.waypointData.hasFocus) {
				_waypointView.waypointData.hasFocus = true;
			}
		}
		
		override protected function handleIsActiveChange(e:Event):void {
			super.handleIsActiveChange(e);
			if (_waypointView.waypointData.isActive){
				_pan = NaN;
				_tilt = NaN;
				_fov = NaN;
				_module.stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
				handleEnterFrame();
				_waypointView.radar.alpha = 0;
				Tweener.addTween(_waypointView.radar, {
					alpha:((1 / _waypointView.imageMapData.windowData.window.alpha) * _waypointView.waypointData.radar.alpha), 
					time:0.5,
					transition:"easeInExpo"
				});
			}else {
				_waypointView.radar.graphics.clear();
				_module.stage.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			}
		}
		
		private function handleEnterFrame(e:Event = null):void {
			if (_fov != _module.saladoPlayer.manager._fieldOfView) {
				drawRadar();
				_fov = _module.saladoPlayer.manager._fieldOfView;
			}
			if(_waypointView.waypointData.radar.showTilt && _tilt != _module.saladoPlayer.manager._tilt){
				_waypointView.radarTilt = (1 - Math.abs(_module.saladoPlayer.manager._tilt) / 100);
				if (_module.saladoPlayer.manager._tilt > 0) {
					_waypointView.imageMapData.mapData.radarFirst = true;
				}else {
					_waypointView.imageMapData.mapData.radarFirst = false;
				}
				_tilt = _module.saladoPlayer.manager._tilt;
			}
			if (_pan != _module.saladoPlayer.manager._pan) {
				_waypointView.radar.rotationZ = _module.saladoPlayer.manager._pan + currentDirection + _waypointView.waypointData.panShift;
				_pan = _module.saladoPlayer.manager._pan;
				pan3 = pan2;
				pan2 = pan1;
				pan1 = _module.saladoPlayer.manager._pan;
				if (_waypointView.waypointData.isActive && !_waypointView.waypointData.hasFocus) {
					if(Math.floor(Math.abs(pan1 - pan2)) > Math.floor(Math.abs(pan2 - pan3))){ // detect acceleration 
						_waypointView.waypointData.hasFocus = true;
					}
				}
			}
		}
		
		private function drawRadar():void {
			_waypointView.radar.graphics.clear();
			var startAngle:Number = (-_module.saladoPlayer.manager._fieldOfView - 180) * Math.PI / 180 * 0.5;
			var endAngle:Number = (_module.saladoPlayer.manager._fieldOfView - 180) * Math.PI / 180 * 0.5;
			var divisions:Number = Math.floor(Math.abs(endAngle - startAngle) / (Math.PI / 4)) + 1;
			var span:Number = Math.abs(endAngle - startAngle) / (2 * divisions);
			var controlRadius:Number = _waypointView.waypointData.radar.radius / Math.cos(span);
			_waypointView.radar.graphics.beginFill(_waypointView.waypointData.radar.color);
			_waypointView.radar.graphics.lineStyle(_waypointView.waypointData.radar.borderSize, _waypointView.waypointData.radar.borderColor);
			_waypointView.radar.graphics.moveTo(0, 0);
			_waypointView.radar.graphics.lineTo((Math.cos(startAngle) * _waypointView.waypointData.radar.radius), Math.sin(startAngle) * _waypointView.waypointData.radar.radius);
			var controlPoint:Point;
			var anchorPoint:Point;
			for(var i:Number=0; i < divisions; ++i){
				endAngle = startAngle + span;
				startAngle = endAngle + span;
				controlPoint = new Point(Math.cos(endAngle) * controlRadius, Math.sin(endAngle) * controlRadius);
				anchorPoint = new Point(Math.cos(startAngle) * _waypointView.waypointData.radar.radius, Math.sin(startAngle) * _waypointView.waypointData.radar.radius);
				_waypointView.radar.graphics.curveTo(controlPoint.x, controlPoint.y, anchorPoint.x, anchorPoint.y);
			}
			_waypointView.radar.graphics.endFill();
		}
	}
}