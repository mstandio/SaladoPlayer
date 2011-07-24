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
along with PanoSalado.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.panosalado.controller{
	
	import com.panosalado.controller.ICamera;
	import com.panosalado.events.CameraEvent;
	import com.panosalado.model.Characteristics;
	import com.panosalado.model.ScrollCameraData;
	import com.panosalado.model.ViewData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
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
		
		private function inoutHandler(event:MouseEvent):void {
			dispatchEvent(new CameraEvent(CameraEvent.ACTIVE));
			_viewData.fieldOfView -= cameraData.zoomIncrement * event.delta;
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
		public function set mouseObject(value:Sprite):void{
			if ( _mouseObject === value ) return;
			if ( value != null && cameraData.enabled){
				value.addEventListener(MouseEvent.MOUSE_WHEEL, inoutHandler, false, 0, true);
			}else if(value == null && _mouseObject != null ){
				_mouseObject.removeEventListener(MouseEvent.MOUSE_WHEEL, inoutHandler);
			}
			_mouseObject = value;
		}
		
		public function get viewData():ViewData { return _viewData; }
		public function set viewData(value:ViewData):void{
			_viewData = value;
		}
	}
}