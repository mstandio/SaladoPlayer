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
package com.panozona.modules.imagemap.controller {
	
	import com.panozona.modules.imagemap.events.WaypointEvent;
	import com.panozona.modules.imagemap.events.MapEvent;
	import com.panozona.modules.imagemap.view.WaypointView;
	import com.panozona.player.module.Module;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	
	public class WaypointController {
		
		private var _waypointView:WaypointView;
		private var _module:Module;
		
		private var _pan:Number;
		private var _fov:Number;
		
		private var _isFocused:Boolean;
		
		private var pan1:Number;
		private var pan2:Number;
		private var pan3:Number;
		
		private var currentDirection:Number;
		
		public function WaypointController(waypointView:WaypointView, module:Module) {
			_waypointView = waypointView;
			_module = module;
			
			var autorotationEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.AutorotationEvent") as Class;
			_module.saladoPlayer.managerData.controlData.autorotationCameraData.addEventListener(autorotationEventClass.AUTOROTATION_CHANGE, onIsAutorotatingChange, false, 0, true);
			
			_waypointView.waypointData.addEventListener(WaypointEvent.CHANGED_SHOW_RADAR, handleShowRadarChange, false, 0, true);
			_waypointView.waypointData.addEventListener(WaypointEvent.CHANGED_MOUSE_OVER, handleMouseOverChange, false, 0, true);
			
			_waypointView.addEventListener(MouseEvent.CLICK, handleMouseClick, false, 0, true);
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			onPanoramaLoaded(); // in case when map just got changed
			
			drawButton();
		}
		
		public function lostFocus():void {
			_isFocused = false;
		}
		
		private function handleMouseClick(e:Event):void {
			if (_module.saladoPlayer.manager.currentPanoramaData.id != _waypointView.waypointData.waypoint.target){
				_module.saladoPlayer.manager.loadPano(_waypointView.waypointData.waypoint.target);
			}else {
				_waypointView.viewerData.focusPoint = new Point(_waypointView.waypointData.waypoint.position.x, _waypointView.waypointData.waypoint.position.y);
			}
		}
		
		private function onPanoramaLoaded(panoramaEvent:Object = null):void {
			if (_module.saladoPlayer.manager.currentPanoramaData.id == _waypointView.waypointData.waypoint.target) {
				currentDirection = _module.saladoPlayer.managerData.getPanoramaDataById(_waypointView.waypointData.waypoint.target).direction;
				_waypointView.viewerData.focusPoint = new Point(_waypointView.waypointData.waypoint.position.x, _waypointView.waypointData.waypoint.position.y);
				_waypointView.waypointData.showRadar = true;
			}else {
				_waypointView.waypointData.showRadar = false;
			}
		}
		
		private function onIsAutorotatingChange(autorotationEvent:Object):void {
			if (_waypointView.waypointData.showRadar && !_isFocused) {
				_waypointView.viewerData.focusPoint = new Point(_waypointView.waypointData.waypoint.position.x, _waypointView.waypointData.waypoint.position.y);
				_isFocused = true;
			}
		}
		
		private function handleShowRadarChange(e:Event):void {
			drawButton();
			if (_waypointView.waypointData.showRadar){
				_pan = NaN;
				_fov = NaN;
				_module.stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
				handleEnterFrame();
			}else {
				_waypointView.radar.graphics.clear();
				_module.stage.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			}
		}
		
		public function handleMouseOverChange(e:Event):void {
			drawButton();
		}
		
		private function handleEnterFrame(e:Event = null):void {
			if (_fov != _module.saladoPlayer.manager._fieldOfView) {
				drawRadar();
				_fov = _module.saladoPlayer.manager._fieldOfView;
			}
			if(_waypointView.waypointData.radar.displayTilt){
				_waypointView.radar.scaleY = _waypointView.button.scaleY * (1 - Math.abs(_module.saladoPlayer.manager._tilt) / 100);
				if (_waypointView.radar.scaleY < 0.15) _waypointView.radar.scaleY = 0.15;
				if (_module.saladoPlayer.manager._tilt > 0) {
					_waypointView.radarFirst();
				}else {
					_waypointView.buttonFirst();
				}
			}
			if (_pan != _module.saladoPlayer.manager._pan) {
				_waypointView.radar.rotationZ = _module.saladoPlayer.manager._pan + currentDirection + _waypointView.waypointData.panShift;
				_pan = _module.saladoPlayer.manager._pan;
				pan3 = pan2;
				pan2 = pan1;
				pan1 = _module.saladoPlayer.manager._pan;
				if (_waypointView.waypointData.showRadar && !_isFocused) {
					if(Math.floor(Math.abs(pan1 - pan2)) > Math.floor(Math.abs(pan2 - pan3))){ // detect acceleration 
						_waypointView.viewerData.focusPoint = new Point(_waypointView.waypointData.waypoint.position.x, _waypointView.waypointData.waypoint.position.y);
						_isFocused = true;
					}
				}
			}
		}
		
		private function drawRadar():void {
			_waypointView.radar.graphics.clear();
			var startAngle:Number = (-_module.saladoPlayer.manager.fieldOfView - 180) * Math.PI / 180 * 0.5;
			var endAngle:Number = (_module.saladoPlayer.manager.fieldOfView - 180) * Math.PI / 180 * 0.5;
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
		
		private function drawButton():void {
			if (_waypointView.waypointData.showRadar){
				_waypointView.buttonBitmapData = _waypointView.waypointData.bitmapDataActive;
			}else if (_waypointView.waypointData.mouseOver) {
				_waypointView.buttonBitmapData = _waypointView.waypointData.bitmapDataHover;
			}else { // !mouseOver
				_waypointView.buttonBitmapData = _waypointView.waypointData.bitmapDataPlain;
			}
		}
	}
}