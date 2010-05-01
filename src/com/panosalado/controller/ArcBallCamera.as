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
import com.panosalado.model.CameraKeyBindings;
import com.panosalado.model.ViewData;
import com.panosalado.model.ArcBallCameraData;
import com.panosalado.events.CameraEvent;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.utils.getTimer;

public class ArcBallCamera implements ICamera
{
	
	protected var _hitArea:EventDispatcher;
	protected var _stage:Stage;
	protected var _viewData:ViewData;
	
	private var __lastAngleX:Number;
	private var __lastAngleY:Number;
	private var __xh:Number;
	private var __xv:Number;
	
	protected var _cameraData:ArcBallCameraData;
	
	public function ArcBallCamera(cameraData:ArcBallCameraData)
	{
		this.cameraData = cameraData;
	}
	
	private function downHandler(event:MouseEvent):void
	{		
		var vFov:Number;
		if ( viewData.invalidBoundsWidth || viewData.invalidFieldOfView ) {
			__xh = Math.cos(viewData.fieldOfView * 0.5 * __toRadians) * (viewData.boundsWidth * 0.5);
		}
		if ( viewData.invalidBoundsHeight || viewData.invalidFieldOfView ) {
			vFov = viewData.boundsHeight / viewData.boundsWidth * viewData.fieldOfView;
			__xv = Math.cos(vFov * 0.5 * __toRadians) * (viewData.boundsHeight * 0.5);
		}
		__lastAngleX = Math.atan2( ((_stage.mouseX - viewData.boundsX) - viewData.boundsWidth), __xh );
		__lastAngleY = Math.atan2( ((_stage.mouseY - viewData.boundsY) - viewData.boundsHeight * 0.5), __xv );
		
		_stage.addEventListener( Event.ENTER_FRAME, enterFrameHandler, false, 0, true );
		_hitArea.addEventListener( MouseEvent.MOUSE_OUT, upHandler, false, 0, true );
	}
	private function upHandler(event:MouseEvent):void
	{
		_stage.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
	}
	
	private function enterFrameHandler(event:Event):void 
	{ 
		var angleX:Number;
		var angleY:Number;
		var vFov:Number;
		if ( viewData.invalidBoundsWidth || viewData.invalidFieldOfView ) {
			__xh = Math.cos(viewData.fieldOfView * 0.5 * __toRadians) * (viewData.boundsWidth * 0.5);
		}
		if ( viewData.invalidBoundsHeight || viewData.invalidFieldOfView ) {
			vFov = viewData.boundsHeight / viewData.boundsWidth * viewData.fieldOfView;
			__xv = Math.cos(vFov * 0.5 * __toRadians) * (viewData.boundsHeight * 0.5);
		}
		angleX = Math.atan2( ((_stage.mouseX - viewData.boundsX) - viewData.boundsWidth), __xh );
		angleY = Math.atan2( ((_stage.mouseY - viewData.boundsY) - viewData.boundsHeight * 0.5), __xv );
		viewData.pan += (angleX - __lastAngleX) * __toDegrees;
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
	
	protected function enabledChangeHandler(e:Event):void {
		switch(_cameraData.enabled) {
			case true: 
			if (_hitArea) {
				_hitArea.addEventListener( MouseEvent.MOUSE_DOWN, downHandler, false, 0, true );
				_hitArea.addEventListener( MouseEvent.MOUSE_UP, upHandler, false, 0, true );
			}
			break;
			case false: 
			if (_hitArea) {
				_hitArea.removeEventListener( MouseEvent.MOUSE_DOWN, downHandler );
				_hitArea.removeEventListener( MouseEvent.MOUSE_UP, upHandler );
			}
			if (_stage) {
				_stage.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
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
	}
	
	public function get hitArea():EventDispatcher { return _hitArea; }
	public function set hitArea(value:EventDispatcher):void
	{
		if ( _hitArea === value ) return;
		if ( value != null){
			value.addEventListener( MouseEvent.MOUSE_DOWN, downHandler, false, 0, true );
			value.addEventListener( MouseEvent.MOUSE_UP, upHandler, false, 0, true );
		}
		else if(value == null && _hitArea != null ){
			_hitArea.removeEventListener( MouseEvent.MOUSE_DOWN, downHandler );
			_hitArea.removeEventListener( MouseEvent.MOUSE_UP, upHandler );
		}
		_hitArea = value;
	}
	
	private function stagePresenceHandler(e:Event):void {
		stage = _hitArea.stage;
	}
	
	public function get stageReference():Stage { return _stage; }
	public function set stageReference(value:Stage):void
	{
		if ( _stage === value ) return;
		if ( value == null) {
			_stage.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
		}
		_stage = value;
	}
	
	public function get viewData():ViewData { return _viewData; }
	public function set viewData(value:ViewData):void
	{
		_viewData = value;
		__xh = Math.cos(viewData.fieldOfView * 0.5 * __toRadians) * (viewData.boundsWidth * 0.5);
		var vFov:Number = viewData.boundsHeight / viewData.boundsWidth * viewData.fieldOfView;
		__xv = Math.cos(vFov * 0.5 * __toRadians) * (viewData.boundsHeight * 0.5);
	}
	
	private var __toDegrees:Number = 180 / Math.PI;
	private var __toRadians:Number = Math.PI / 180;
}
}