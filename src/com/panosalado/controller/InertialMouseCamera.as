/*
Copyright 2010 Zephyr Renner.

This file is part of PanoSalado.

PanoSalado is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

PanoSalado is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with PanoSalado. If not, see <http://www.gnu.org/licenses/>.
*/
package com.panosalado.controller {
	
	import com.panosalado.controller.ICamera;
	import com.panosalado.events.CameraEvent;
	import com.panosalado.model.Characteristics;
	import com.panosalado.model.InertialMouseCameraData;
	import com.panosalado.model.ViewData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	public class InertialMouseCamera extends Sprite implements ICamera {
		
		protected var _mouseObject:Sprite;
		protected var _viewData:ViewData;
		
		protected var _cameraData:InertialMouseCameraData;
		private var __lastTimeStamp:Number;
		
		private var startPointX:Number;
		private var startPointY:Number;
		
		private var deltaPan:Number;
		private var deltaTilt:Number;
		private var deltaFieldOfView:Number;
		
		private var mouseIsDown:Boolean;
		
		public function InertialMouseCamera(){
			startPointX = 0;
			startPointY = 0;
			deltaPan = 0;
			deltaTilt = 0;
			mouseIsDown = false;
		}
		
		public function processDependency(reference:Object,characteristics:*):void {
			if (characteristics == Characteristics.VIEW_DATA) {
				viewData = reference as ViewData;
				if(cameraData != null){
					mouseObject = reference as Sprite;
				}
			}else if (characteristics == Characteristics.INERTIAL_MOUSE_CAMERA_DATA) cameraData = reference as InertialMouseCameraData;
		}
		
		private function downHandler(event:MouseEvent):void {
			mouseIsDown = true;
			startPointX = _mouseObject.mouseX;
			startPointY = _mouseObject.mouseY;
			__lastTimeStamp = getTimer();
			addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
			dispatchEvent(new CameraEvent(CameraEvent.ACTIVE));
		}
		
		private function upHandler(event:MouseEvent):void {
			mouseIsDown = false;
			// don't remove enterframe listener yet. remove when friction has slowed motion to under threshold
		}
		
		private var elapsedTime:Number;
		private var currentTimeStamp:Number;
		private var inverseFriction:Number;
		private function enterFrameHandler(event:Event):void {
			if (mouseIsDown) {
				// calculate new position changes
				currentTimeStamp = getTimer();
				elapsedTime = currentTimeStamp - __lastTimeStamp;
				deltaPan += (startPointX - _mouseObject.mouseX) / _viewData._boundsWidth * elapsedTime * _cameraData.sensitivity;
				deltaTilt -= (startPointY - _mouseObject.mouseY) / _viewData._boundsHeight * elapsedTime * _cameraData.sensitivity;
				__lastTimeStamp = currentTimeStamp;
			}
			
			// motion is still over the threshold, so apply friction
			if ((deltaPan * deltaPan + deltaTilt * deltaTilt ) > _cameraData.threshold) {
				// always apply friction so that motion slows AFTER mouse is up
				inverseFriction = (1 - _cameraData.friction);
				deltaPan *= inverseFriction;
				deltaTilt *= inverseFriction;
				
				_viewData.pan -= deltaPan * _viewData._fieldOfView / 90;
				_viewData.tilt -= deltaTilt * _viewData._fieldOfView / 90;
				
				if (_viewData._tilt < -90 ) _viewData.tilt -= (_viewData._tilt + 90) * _cameraData.friction * 2;
				else if (_viewData._tilt > 90 ) _viewData.tilt -= (_viewData._tilt - 90) * _cameraData.friction * 2;
				
			}else { // motion is under threshold stop camera motion
				if (!mouseIsDown) {
					deltaPan = deltaTilt = 0;
					removeEventListener(Event.ENTER_FRAME, enterFrameHandler, false);
					dispatchEvent(new CameraEvent(CameraEvent.INACTIVE));
				}
			}
		}
		
		protected function enabledChangeHandler(e:Event):void {
			if (_mouseObject == null) return;
			if (_cameraData.enabled) {
				_mouseObject.addEventListener(MouseEvent.MOUSE_DOWN, downHandler, false, 0, true);
				_mouseObject.addEventListener(MouseEvent.MOUSE_UP, upHandler, false, 0, true);
				_mouseObject.addEventListener(MouseEvent.ROLL_OUT, upHandler, false, 0, true);
			}else{
				_mouseObject.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
				_mouseObject.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
				_mouseObject.removeEventListener(MouseEvent.ROLL_OUT, upHandler);
				_mouseObject.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		public function get cameraData():InertialMouseCameraData { return _cameraData; }
		public function set cameraData(value:InertialMouseCameraData):void {
			if (value === _cameraData) return;
			if (value != null) {
				value.addEventListener(CameraEvent.ENABLED_CHANGE, enabledChangeHandler, false, 0, true);
			}
			else if (value == null && _cameraData != null) {
				_cameraData.removeEventListener(CameraEvent.ENABLED_CHANGE, enabledChangeHandler);
			}
			_cameraData = value;
			mouseObject = viewData;
		}
		
		public function get mouseObject():Sprite { return _mouseObject; }
		public function set mouseObject(value:Sprite):void {
			if (_mouseObject === value) return;
			if (value != null && cameraData.enabled) {
				value.addEventListener(MouseEvent.MOUSE_DOWN, downHandler, false, 0, true);
				value.addEventListener(MouseEvent.MOUSE_UP, upHandler, false, 0, true);
				value.addEventListener(MouseEvent.ROLL_OUT, upHandler, false, 0, true);
			}else if(value == null && _mouseObject != null) {
				_mouseObject.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
				_mouseObject.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
				_mouseObject.removeEventListener(MouseEvent.ROLL_OUT, upHandler);
			}
			_mouseObject = value;
		}
		
		public function get viewData():ViewData { return _viewData; }
		public function set viewData(value:ViewData):void {
			_viewData = value;
		}
	}
}