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
import com.panosalado.model.KeyboardCameraData;
import com.panosalado.events.CameraEvent;
import com.panosalado.model.Characteristics;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.utils.getTimer;

public class KeyboardCamera extends EventDispatcher implements ICamera
{
	
	protected var _canvas:Sprite;
	protected var _stage:Stage;
	protected var _viewData:ViewData;
	protected var _cameraData:KeyboardCameraData;
	
	private var __lastTimeStamp:Number;
	
	private var startPointX:Number;
	private var startPointY:Number;
	
	private var deltaPan:Number;
	private var deltaTilt:Number;
	private var keyIsDown:Boolean;
	private var go_up:Boolean;
	private var go_down:Boolean;
	private var go_left:Boolean;
	private var go_right:Boolean;
	private var go_in:Boolean;
	private var go_out:Boolean;
	
	public function KeyboardCamera()
	{
		startPointX = 0;
		startPointY = 0;
		deltaPan	= 0;
		deltaTilt	= 0;
		keyIsDown	= false;
		go_up		= false;
		go_down		= false;
		go_left		= false;
		go_right	= false;
		go_in		= false;
		go_out		= false;
	}
	
	public function processDependency(reference:Object,characteristics:*):void {
		if 		(characteristics == Characteristics.VIEW_DATA) viewData = reference as ViewData;
		else if (characteristics == Characteristics.KEYBOARD_CAMERA_DATA) cameraData = reference as KeyboardCameraData;
	}
	
	protected function keyDownEvent( event:KeyboardEvent ):void
	{ 
		__lastTimeStamp = getTimer();
		
		var addEnterFrameListener:Boolean = !keyIsDown;
		switch( event.keyCode )
		{
		case CameraKeyBindings.UP:
			go_up = true; 
			keyIsDown = true;
		break;

		case CameraKeyBindings.DOWN:
			go_down = true;
			keyIsDown = true;
		break;

		case CameraKeyBindings.LEFT:
			go_left = true;
			keyIsDown = true;
		break;

		case CameraKeyBindings.RIGHT:
			go_right = true;
			keyIsDown = true;
		break;
		case CameraKeyBindings.IN:
			go_in = true;
			keyIsDown = true;
		break;
		case CameraKeyBindings.OUT:
			go_out = true;
			keyIsDown = true;
		break;
		default: 
			break;
		}
		
		if ( addEnterFrameListener && (keyIsDown) ) {
			dispatchEvent( new CameraEvent(CameraEvent.ACTIVE) );
			_stage.addEventListener( Event.ENTER_FRAME, enterFrameHandler, false, 0, true );
		}
	}
	
	protected function keyUpEvent(event:KeyboardEvent):void
	{ 
		switch( event.keyCode )
			{
			case CameraKeyBindings.UP:
				go_up = false;
			break;

			case CameraKeyBindings.DOWN:
				go_down = false;
			break;

			case CameraKeyBindings.LEFT:
				go_left = false;
			break;

			case CameraKeyBindings.RIGHT:
				go_right = false;
			break;
			case CameraKeyBindings.IN:
				go_in = false;
			break;
			case CameraKeyBindings.OUT:
				go_out = false;
			break;
			}
		if ( !go_up && !go_down && !go_left && !go_right && !go_in && !go_out ) {
			keyIsDown = false;
			_stage.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
			dispatchEvent( new CameraEvent(CameraEvent.INACTIVE) );
		}
	}
	
	private function enterFrameHandler(event:Event):void 
	{ 
		if (keyIsDown)
		{
			if 		( go_up ) 	{ startPointX = _stage.mouseX; 							startPointY = _stage.mouseY + cameraData.keyIncrement ; }
			else if ( go_down ) { startPointX = _stage.mouseX; 							startPointY = _stage.mouseY - cameraData.keyIncrement ; }
			if 		( go_left) 	{ startPointX = _stage.mouseX + cameraData.keyIncrement; 	startPointY = _stage.mouseY ; }
			else if ( go_right ){ startPointX = _stage.mouseX - cameraData.keyIncrement; 	startPointY = _stage.mouseY ; }
			if ( go_in ) { 
				viewData.fieldOfView -= cameraData.zoomIncrement;
			}
			else if ( go_out ) { 
				viewData.fieldOfView += cameraData.zoomIncrement;
			}
		}
		if (go_up || go_down || go_left || go_right)
		{
			// calculate new position changes
			var currentTimeStamp:Number = getTimer();
			var elapsedTime:Number = currentTimeStamp - __lastTimeStamp;
			var delta:Number = elapsedTime * cameraData.speed;
			deltaPan 	+= (startPointX - _stage.mouseX) * delta;
			deltaTilt 	-= (startPointY - _stage.mouseY) * delta;
			__lastTimeStamp = currentTimeStamp;
		}
		
		// motion is still over the threshold, so apply friction
		if ( ( (deltaPan * deltaPan) + (deltaTilt * deltaTilt) ) > cameraData.threshold ) 
		{
			// always apply friction so that motion slows AFTER mouse is up
			var inverseFriction:Number = 1 - _cameraData.friction;
			deltaPan  *= inverseFriction;
			deltaTilt *= inverseFriction;
			
			_viewData.pan += deltaPan;
			_viewData.tilt -= deltaTilt; 
			
			if ( _viewData._tilt < -90 ) _viewData.tilt -= (_viewData._tilt +90) * _cameraData.friction * 2;
			else if ( _viewData._tilt > 90 ) _viewData.tilt -= (_viewData._tilt -90) * _cameraData.friction * 2;
		} 
		else 
		{ // motion is under threshold stop camera motion
			if ( !keyIsDown )
			{	
				// motion is under threshold, stop and remove enter frame listener
				deltaPan = 0;
				deltaTilt = 0;
				
				if (_stage) _stage.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
			}
		}
	}
	
	protected function enabledChangeHandler(e:Event):void {
		
		if (_viewData != null) {
			_viewData.dispatchEvent(new CameraEvent(CameraEvent.ENABLED_CHANGE))
		}
		
		switch(_cameraData.enabled) {
			case true: 
			if (_stage) {
				_stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownEvent, false, 0, true );
				_stage.addEventListener( KeyboardEvent.KEY_UP, keyUpEvent, false, 0, true);
			}
			break;
			case false: 
			if (_stage) {
				_stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownEvent );
				_stage.removeEventListener( KeyboardEvent.KEY_UP, keyUpEvent );
				_stage.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
			}
			break;
		}
	}
	
	public function get cameraData():KeyboardCameraData { return _cameraData; }
	public function set cameraData(value:KeyboardCameraData):void
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
	
	public function get stageReference():Stage { return _stage; }
	public function set stageReference(value:Stage):void
	{
		if ( _stage === value ) return;
		if ( value != null){
			value.addEventListener( KeyboardEvent.KEY_DOWN, keyDownEvent, false, 0, true );
			value.addEventListener( KeyboardEvent.KEY_UP, keyUpEvent, false, 0, true);
		}
		else if(value == null && _stage != null ){
			_stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownEvent );
			_stage.removeEventListener( KeyboardEvent.KEY_UP, keyUpEvent );
			_stage.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
		}
		_stage = value;
	}
	
	public function get viewData():ViewData { return _viewData; }
	public function set viewData(value:ViewData):void
	{
		_viewData = value;
	}
}
}