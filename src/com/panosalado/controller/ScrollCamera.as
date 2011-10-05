/*
Copyright 2011 Marek Standio.

This file is part of PanoSalado.

PanoSalado is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

PanoSalado is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with PanoSalado. If not, see <http://www.gnu.org/licenses/>.
*/
package com.panosalado.controller {
	
	import com.panosalado.controller.ICamera;
	import com.panosalado.events.CameraEvent;
	import com.panosalado.model.Characteristics;
	import com.panosalado.model.ScrollCameraData;
	import com.panosalado.model.ViewData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	public class ScrollCamera extends Sprite implements ICamera {
		
		protected var _viewData:ViewData;
		protected var _mouseObject:Sprite;
		
		protected var _cameraData:ScrollCameraData;
		
		public function processDependency(reference:Object, characteristics:*):void {
			if (characteristics == Characteristics.VIEW_DATA) {
				viewData = reference as ViewData;
				if(_cameraData != null){
					mouseObject = reference as Sprite;
				}
			}else if (characteristics == Characteristics.SCROLL_CAMERA_DATA) cameraData = reference as ScrollCameraData;
		}
		
		private var scrollDelta:Number;
		private function inoutHandler(event:MouseEvent):void {
			if (isNaN(scrollDelta) || scrollDelta == 0){
				addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
				dispatchEvent(new CameraEvent(CameraEvent.ACTIVE));
			}
			scrollDelta = event.delta;
		}
		
		private var deltaFov:Number;
		private function enterFrameHandler(event:Event):void {
			deltaFov += scrollDelta * cameraData.sensitivity;
			scrollDelta = 0;
			if (deltaFov * deltaFov > cameraData.threshold) {
				deltaFov *= (1 - cameraData.friction);
				changeFov(deltaFov);
			}else {
				deltaFov = 0;
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler, false);
				dispatchEvent(new CameraEvent(CameraEvent.INACTIVE));
			}
		}
		
		private var tmpPan:Number;
		private var tmpTilt:Number;
		private function changeFov(value:Number):void {
			if(cameraData.zoomAtCursor) {
				tmpPan = getCursorPan();
				tmpTilt = getCursorTilt();
				_viewData.fieldOfView -= value;
				_viewData.pan += tmpPan - getCursorPan();
				_viewData.tilt += tmpTilt - getCursorTilt();
			}else {
				_viewData.fieldOfView -= value;
			}
		}
		
		private function getCursorPan():Number {
			return validatePanTilt( _viewData._pan +
				Math.atan((_viewData.mouseX - _viewData._boundsWidth * 0.5)
				* Math.tan(_viewData._fieldOfView * 0.5 * __toRadians) / (_viewData._boundsWidth * 0.5)) * __toDegrees);
		}
		
		private var verticalFieldOfView:Number
		private function getCursorTilt():Number {
			verticalFieldOfView = __toDegrees * 2 * Math.atan((_viewData._boundsHeight / _viewData._boundsWidth)
				* Math.tan(__toRadians * 0.5 * _viewData._fieldOfView));
			return validatePanTilt( _viewData._tilt -
				Math.atan(( _viewData.mouseY - _viewData._boundsHeight * 0.5)
				* Math.tan(verticalFieldOfView * 0.5 * __toRadians) / (_viewData._boundsHeight * 0.5)) * __toDegrees);
		}
		
		private function validatePanTilt(value:Number):Number {
			if (value <= -180) value = (((value + 180) % 360) + 180);
			if (value > 180) value = (((value + 180) % 360) - 180);
			return value;
		}
		
		protected function enabledChangeHandler(e:Event):void {
			if (_mouseObject == null) return;
			if (_cameraData.enabled) {
				_mouseObject.addEventListener(MouseEvent.MOUSE_WHEEL, inoutHandler, false, 0, true);
			}else{
				_mouseObject.removeEventListener(MouseEvent.MOUSE_WHEEL, inoutHandler);
			}
		}
		
		public function get cameraData():ScrollCameraData{ return _cameraData;}
		public function set cameraData(value:ScrollCameraData):void{
			if (value === _cameraData) return;
			if (value != null) {
				value.addEventListener(CameraEvent.ENABLED_CHANGE, enabledChangeHandler, false, 0, true);
			}else if (value == null && _cameraData != null) {
				_cameraData.removeEventListener(CameraEvent.ENABLED_CHANGE, enabledChangeHandler);
			}
			_cameraData = value;
			mouseObject = viewData;
		}
		
		public function get mouseObject():Sprite { return _mouseObject; }
		public function set mouseObject(value:Sprite):void {
			if ( _mouseObject === value ) return;
			if ( value != null && cameraData.enabled){
				value.addEventListener(MouseEvent.MOUSE_WHEEL, inoutHandler, false, 0, true);
			}else if(value == null && _mouseObject != null ){
				_mouseObject.removeEventListener(MouseEvent.MOUSE_WHEEL, inoutHandler);
			}
			_mouseObject = value;
		}
		
		public function get viewData():ViewData { return _viewData; }
		public function set viewData(value:ViewData):void {
			_viewData = value;
		}
		
		private var __toDegrees:Number = 180 / Math.PI;
		private var __toRadians:Number = Math.PI / 180;
	}
}