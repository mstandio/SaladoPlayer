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
package com.panosalado.controller{
	
	import com.panosalado.controller.ICamera;
	import com.panosalado.events.CameraEvent;
	import com.panosalado.model.ArcBallCameraData;
	import com.panosalado.model.Characteristics;
	import com.panosalado.model.ViewData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ArcBallCamera extends Sprite implements ICamera {
		
		protected var _viewData:ViewData;
		protected var _mouseObject:Sprite;
		protected var _cameraData:ArcBallCameraData;
		
		private var __lastAngleX:Number;
		private var __lastAngleY:Number;
		private var __xh:Number;
		private var __xv:Number;
		
		private var mouseIsDown:Boolean;
		
		private var startPan:Number;
		private var startTilt:Number;
		
		private var frameTime:Number;
		
		public function ArcBallCamera(){
			__lastAngleX = 0;
			__lastAngleY = 0;
			__xh = 0;
			__xv = 0;
			
			mouseIsDown = false;
			
			startPan = 0;
			startTilt = 0;
			
			frameTime = 1000 / 30; // 30 fps
		}
		
		public function processDependency(reference:Object,characteristics:*):void {
			if (characteristics == Characteristics.VIEW_DATA) {
				viewData = reference as ViewData;
				if(_cameraData != null){
					mouseObject = reference as Sprite;
				}
			}else if (characteristics == Characteristics.ARC_BALL_CAMERA_DATA) {
				cameraData = reference as ArcBallCameraData;
			}
		}
		
		private function downHandler(event:MouseEvent):void{
			mouseIsDown = true;
			startPan = viewData._pan;
			startTilt = viewData._tilt;
			
			var vFov:Number;
			
			__xh = Math.tan(viewData.fieldOfView * 0.5 * __toRadians) / (viewData.boundsWidth * 0.5);
			
			vFov = __toDegrees * 2 * Math.atan((viewData.boundsHeight/viewData.boundsWidth) * Math.tan(__toRadians * 0.5 * viewData.fieldOfView));
			__xv = Math.tan(vFov * 0.5 * __toRadians) / (viewData.boundsHeight * 0.5);
			
			__lastAngleX = Math.atan(( _mouseObject.mouseX - viewData.boundsWidth * 0.5) * __xh);
			__lastAngleY = Math.atan(( _mouseObject.mouseY - viewData.boundsHeight * 0.5)* __xv);
			
			addEventListener( Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
			dispatchEvent( new CameraEvent(CameraEvent.ACTIVE));
		}
		
		private function upHandler(event:MouseEvent):void {
			mouseIsDown = false;
			// don't remove enterframe listener yet. remove when friction has slowed motion to under threshold
		}
		
		private var angleX:Number;
		private var angleY:Number;
		private var vFov:Number;
		private var deltaPan:Number;
		private var deltaTilt:Number;
		private function enterFrameHandler(event:Event):void {
			if (mouseIsDown){
				if ( viewData.invalid) {
					__xh = Math.tan(viewData.fieldOfView * 0.5 * __toRadians) / (viewData.boundsWidth * 0.5);
					vFov = __toDegrees * 2 * Math.atan((viewData.boundsHeight/viewData.boundsWidth) * Math.tan(__toRadians * 0.5 * viewData.fieldOfView));
					__xv = Math.tan(vFov * 0.5 * __toRadians) / (viewData.boundsHeight * 0.5);
				}
				angleX = Math.atan(( _mouseObject.mouseX - viewData.boundsWidth * 0.5) * __xh)
				angleY = Math.atan(( _mouseObject.mouseY - viewData.boundsHeight * 0.5 )* __xv);
				viewData.pan -= (angleX - __lastAngleX) * __toDegrees;
				viewData.tilt += (angleY - __lastAngleY) * __toDegrees;
				
				__lastAngleX = angleX;
				__lastAngleY = angleY;
				
				deltaPan = normalizePanDiff(startPan, viewData._pan) / (Math.pow(frameTime, 2) * _cameraData.sensitivity);
				deltaTilt = (startTilt - viewData._tilt) / (Math.pow(frameTime, 2) * _cameraData.sensitivity);
				
				startPan = viewData._pan;
				startTilt = viewData._tilt;
			}else{
			
				if((deltaPan * deltaPan + deltaTilt * deltaTilt ) > _cameraData.threshold) {
					var inverseFriction:Number = (1 - _cameraData.friction);
					deltaPan *= inverseFriction;
					deltaTilt *= inverseFriction;
					
					_viewData.pan -= deltaPan;
					_viewData.tilt -= deltaTilt;
					
					if (_viewData._tilt < -90 ) _viewData.tilt -= (_viewData._tilt + 90) * _cameraData.friction * 2;
					else if (_viewData._tilt > 90 ) _viewData.tilt -= (_viewData._tilt - 90) * _cameraData.friction * 2;
				
				}else { // motion is under threshold stop camera motion
					deltaPan = deltaTilt = 0;
					removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
					dispatchEvent(new CameraEvent(CameraEvent.INACTIVE));
				}
			}
		}
		
		protected function normalizePanDiff(pan1:Number, pan2:Number):Number {
			if (pan1 > 90 && pan2 < -90) {
				pan1 = 180 - pan1;
				pan2 = 180 + pan2;
			}else if (pan1 < -90 && pan2 > 90) {
				pan1 = 180 + pan1;
				pan2 = 180 - pan2;
			}
			return pan1 - pan2;
		}
		
		protected function enabledChangeHandler(e:Event):void {
			if (_mouseObject == null) return;
			if(_cameraData.enabled) {
				_mouseObject.addEventListener( MouseEvent.MOUSE_DOWN, downHandler, false, 0, true);
				_mouseObject.addEventListener( MouseEvent.MOUSE_UP, upHandler, false, 0, true);
				_mouseObject.addEventListener( MouseEvent.ROLL_OUT, upHandler, false, 0, true);
			}else{
				_mouseObject.removeEventListener( MouseEvent.MOUSE_DOWN, downHandler);
				_mouseObject.removeEventListener( MouseEvent.MOUSE_UP, upHandler);
				_mouseObject.removeEventListener( MouseEvent.ROLL_OUT, upHandler);
				_mouseObject.removeEventListener( Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		public function get cameraData():ArcBallCameraData { return _cameraData; }
		public function set cameraData(value:ArcBallCameraData):void{
			if (value === _cameraData) return;
			if (value != null) {
				value.addEventListener( CameraEvent.ENABLED_CHANGE, enabledChangeHandler, false, 0, true);
			} else if (value == null && _cameraData != null) {
				_cameraData.removeEventListener( CameraEvent.ENABLED_CHANGE, enabledChangeHandler);
			}
			_cameraData = value;
			mouseObject = viewData;
		}
		
		public function get mouseObject():Sprite { return _mouseObject; }
		public function set mouseObject(value:Sprite):void{
			if (_mouseObject === value) return;
			if (value != null && cameraData.enabled) {
				frameTime = 1000 / value.stage.frameRate;
				value.addEventListener( MouseEvent.MOUSE_DOWN, downHandler, false, 0, true);
				value.addEventListener( MouseEvent.MOUSE_UP, upHandler, false, 0, true);
				value.addEventListener( MouseEvent.ROLL_OUT, upHandler, false, 0, true);
			}else if(value == null && _mouseObject != null ){
				_mouseObject.removeEventListener( MouseEvent.MOUSE_DOWN, downHandler);
				_mouseObject.removeEventListener( MouseEvent.MOUSE_UP, upHandler);
				_mouseObject.removeEventListener( MouseEvent.ROLL_OUT, upHandler);
			}
			_mouseObject = value;
		}
		
		public function get viewData():ViewData { return _viewData; }
		public function set viewData(value:ViewData):void{
			_viewData = value;
		}
		
		private var __toDegrees:Number = 180 / Math.PI;
		private var __toRadians:Number = Math.PI / 180;
	}
}