/*
Copyright 2010 Zephyr Renner.

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
package com.panosalado.controller
{

import com.panosalado.controller.ICamera;
import com.panosalado.model.Characteristics;
import com.panosalado.model.CameraKeyBindings;
import com.panosalado.model.ViewData;
import com.panosalado.model.ArcBallCameraData;
import com.panosalado.events.CameraEvent;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.getTimer;

public class ArcBallCamera extends Sprite implements ICamera
{
	protected var _viewData:ViewData;
	protected var _mouseObject:Sprite;
	
	protected var _cameraData:ArcBallCameraData;
	
	private var __lastAngleX:Number;
	private var __lastAngleY:Number;
	private var __xh:Number;
	private var __xv:Number;
	
	private var mouseIsDown:Boolean;
	
	private var wheelDelta:Number;
	private var mouseWheeled:Boolean;
	
	public function ArcBallCamera()
	{
		__lastAngleX = 0;
		__lastAngleY = 0;
		__xh = 0;
		__xv = 0;
		
		mouseIsDown = false;
		
		wheelDelta  = 0;
		mouseWheeled = false;
	}
	
	public function processDependency(reference:Object,characteristics:*):void {
		if (characteristics == Characteristics.VIEW_DATA) { 
			viewData = reference as ViewData;
			if(_cameraData != null){
				mouseObject = reference as Sprite;
			}
		}
		else if (characteristics == Characteristics.ARC_BALL_CAMERA_DATA) cameraData = reference as ArcBallCameraData;
	}
	
	private function downHandler(event:MouseEvent):void
	{
		mouseIsDown = true;
		
		var vFov:Number;
		
		__xh = Math.tan(viewData.fieldOfView * 0.5 * __toRadians) / (viewData.boundsWidth * 0.5);
		
		vFov = viewData.boundsHeight / viewData.boundsWidth * viewData.fieldOfView;
		__xv = Math.tan(vFov * 0.5 * __toRadians) / (viewData.boundsHeight * 0.5);
		
		__lastAngleX = Math.atan(( _mouseObject.mouseX - viewData.boundsWidth * 0.5) * __xh);    // HARDCORE
		__lastAngleY = Math.atan(( _mouseObject.mouseY - viewData.boundsHeight * 0.5 )* __xv);  // TRIGONOMETRY :F
		
		
		addEventListener( Event.ENTER_FRAME, enterFrameHandler, false, 0, true );
		dispatchEvent( new CameraEvent(CameraEvent.ACTIVE) );
	}
	private function upHandler(event:MouseEvent):void
	{
		mouseIsDown = false;
		
		removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
		dispatchEvent( new CameraEvent(CameraEvent.INACTIVE) );
	}
	
	private function inoutHandler(event:MouseEvent):void {
		
		wheelDelta = event.delta;
		
		mouseWheeled = true;
		
		dispatchEvent( new CameraEvent(CameraEvent.ACTIVE) );
		addEventListener( Event.ENTER_FRAME, enterFrameHandler, false, 0, true );
	}
	
	private function enterFrameHandler(event:Event):void 
	{ 
		if (mouseWheeled) 
		{
			_viewData.fieldOfView -= cameraData.zoomIncrement * wheelDelta;
			mouseWheeled = false;
			if (!mouseIsDown) {
				removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
			}
		}
		
		if (mouseIsDown)
		{
			var angleX:Number;
			var angleY:Number;
			var vFov:Number;
			if ( viewData.invalid) {
				__xh = Math.tan(viewData.fieldOfView * 0.5 * __toRadians) / (viewData.boundsWidth * 0.5);
			}
			if ( viewData.invalid ) {
				vFov = viewData.boundsHeight / viewData.boundsWidth * viewData.fieldOfView;
				__xv = Math.tan(vFov * 0.5 * __toRadians) / (viewData.boundsHeight * 0.5);
			}
			
			angleX = Math.atan(( _mouseObject.mouseX - viewData.boundsWidth * 0.5) * __xh)
			angleY = Math.atan(( _mouseObject.mouseY - viewData.boundsHeight * 0.5 )* __xv);
			viewData.pan -= (angleX - __lastAngleX) * __toDegrees;
			viewData.tilt += (angleY - __lastAngleY) * __toDegrees;
			
			if (viewData._tilt > 90) {
				viewData.tilt = 90;
			}
			if (viewData._tilt < -90) {
				viewData.tilt = -90;
			}
			
			__lastAngleX = angleX;
			__lastAngleY = angleY;
		}
	}
	
	protected function enabledChangeHandler(e:Event):void {
		
		switch(_cameraData.enabled) {
			case true: 
			if (_mouseObject) {
				_mouseObject.addEventListener( MouseEvent.MOUSE_DOWN, downHandler, false, 0, true );
				_mouseObject.addEventListener( MouseEvent.MOUSE_UP, upHandler, false, 0, true );
				_mouseObject.addEventListener( MouseEvent.ROLL_OUT, upHandler, false, 0, true );
				_mouseObject.addEventListener( MouseEvent.MOUSE_WHEEL, inoutHandler, false, 0, true );
			}
			break;
			case false: 
			if (_mouseObject) {
				_mouseObject.removeEventListener( MouseEvent.MOUSE_DOWN, downHandler );
				_mouseObject.removeEventListener( MouseEvent.MOUSE_UP, upHandler );
				_mouseObject.removeEventListener( MouseEvent.ROLL_OUT, upHandler );
				_mouseObject.removeEventListener( MouseEvent.MOUSE_WHEEL, inoutHandler );
				_mouseObject.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
			}
			break;
		}
	}
	
	public function get cameraData():ArcBallCameraData { return _cameraData; }
	public function set cameraData(value:ArcBallCameraData):void
	{
		if (value === _cameraData) return;
		if (value != null) {
			value.addEventListener( CameraEvent.ENABLED_CHANGE, enabledChangeHandler, false, 0, true );
		}
		else if (value == null && _cameraData != null) {
			_cameraData.removeEventListener( CameraEvent.ENABLED_CHANGE, enabledChangeHandler );
		}
		_cameraData = value;
		mouseObject = viewData;
	}
	
	public function get mouseObject():Sprite { return _mouseObject; }
	public function set mouseObject(value:Sprite):void
	{
		if ( _mouseObject === value ) return;
		
		if ( value != null && cameraData.enabled){
			value.addEventListener( MouseEvent.MOUSE_DOWN, downHandler, false, 0, true );
			value.addEventListener( MouseEvent.MOUSE_UP, upHandler, false, 0, true );
			value.addEventListener( MouseEvent.ROLL_OUT, upHandler, false, 0, true );
			value.addEventListener( MouseEvent.MOUSE_WHEEL, inoutHandler, false, 0, true );
		}
		else if(value == null && _mouseObject != null ){
			_mouseObject.removeEventListener( MouseEvent.MOUSE_DOWN, downHandler );
			_mouseObject.removeEventListener( MouseEvent.MOUSE_UP, upHandler );
			_mouseObject.removeEventListener( MouseEvent.ROLL_OUT, upHandler );
			_mouseObject.removeEventListener( MouseEvent.MOUSE_WHEEL, inoutHandler );
		}
		_mouseObject = value;
	}
	
	public function get viewData():ViewData { return _viewData; }
	public function set viewData(value:ViewData):void
	{
		_viewData = value;
	}
	
	private var __toDegrees:Number = 180 / Math.PI;
	private var __toRadians:Number = Math.PI / 180;
}
}