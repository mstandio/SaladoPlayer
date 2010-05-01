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
import com.panosalado.model.NonInertialKeyboardCameraData;
import com.panosalado.model.TilePyramid;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.utils.getTimer;

public class KeyboardCamera implements ICamera
{
	
	protected var _canvas:Sprite;
	protected var _stage:Stage;
	protected var _viewData:ViewData;
	
	public var cameraData:KeyboardCameraData;
	
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
	
	public function KeyboardCamera(cameraData:KeyboardCameraData)
	{
		this.cameraData = cameraData;
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
	
	protected function keyDownEvent( event:KeyboardEvent ):void
	{ 
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
		
		if ( addEnterFrameListener && (keyIsDown) ) _stage.addEventListener( Event.ENTER_FRAME, enterFrameHandler, false, 0, true );
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
		if ( !mouseIsDown && !go_up && !go_down && !go_left && !go_right && !go_in && !go_out )
		{
			keyIsDown = false;
			_stage.removeEventListener( Event.ENTER_FRAME, enterFrameHandler );
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
			deltaPan 	= deltaPan 	+ ((startPointX - _stage.mouseX) * delta);
			deltaTilt 	= deltaTilt - ((startPointY - _stage.mouseY) * delta);
			__lastTimeStamp = currentTimeStamp;
		}
		
		// motion is still over the threshold, so apply friction
		if ( ( (deltaPan * deltaPan) + (deltaTilt * deltaTilt) ) > cameraData.threshold ) 
		{
			// always apply friction so that motion slows AFTER mouse is up
			deltaPan = (deltaPan * (1 - cameraData.friction) );
			deltaTilt = (deltaTilt * (1 - cameraData.friction) );
			
			_viewData.pan += deltaPan;
			_viewData.tilt -= deltaTilt;
			// shortcut to avoid the overhead of calling the setter function.  MUST invalidate
// 			viewData._pan += deltaPan; viewData.invalidPan = invalidate = true; 
// 			viewData._tilt -= deltaTilt; viewData.invalidTilt = invalidate = true; 
			
			if ( _viewData._tilt < -90 ) _viewData.tilt -= (_viewData._tilt +90) * cameraData.friction * 2;
			else if ( _viewData._tilt > 90 ) _viewData.tilt -= (_viewData._tilt -90) * cameraData.friction * 2;
// 			if ( viewData._tilt < -90 ) {
// 				viewData._tilt -= (viewData._tilt +90) * friction * 2;
// 				viewData.invalidTilt = invalidate = true;
// 			}
// 			if ( viewData._tilt > 90 ) {
// 				viewData._tilt -= (viewData._tilt -90) * friction * 2;
// 				viewData.invalidTilt = invalidate = true;
// 			}
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
		//if ( invalidate ) _stage.invalidate();
	}
	
	public function get canvas():Sprite { return _canvas; }
	public function set canvas(value:Sprite):void
	{
		if ( _canvas === value ) return;
		if ( value != null){
			value.addEventListener( MouseEvent.MOUSE_DOWN, downHandler, false, 0, true );
			value.addEventListener( MouseEvent.MOUSE_UP, upHandler, false, 0, true );
			value.addEventListener( Event.ADDED_TO_STAGE, stagePresenceHandler, false, 0, true );
		}
		else{
			value.removeEventListener( MouseEvent.MOUSE_DOWN, downHandler );
			value.removeEventListener( MouseEvent.MOUSE_UP, upHandler );
			value.addEventListener( Event.REMOVED_FROM_STAGE, stagePresenceHandler, false, 0, true );
		}
		_canvas = value;
	}
	
	private function stagePresenceHandler(e:Event):void {
		stage = _canvas.stage;
	}
	
	public function get stage():Stage { return _stage; }
	public function set stage(value:Stage):void
	{
		if ( _stage === value ) return;
		_stage = value;
		if ( _stage != null){
			_stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownEvent, false, 0, true );
			_stage.addEventListener( KeyboardEvent.KEY_UP, keyUpEvent, false, 0, true);
		}
		else if(value == null && _canvas != null ){
			_stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownEvent );
			_stage.removeEventListener( KeyboardEvent.KEY_UP, keyUpEvent );
		}
	}
	
	public function get viewData():ViewData { return _viewData; }
	public function set viewData(value:ViewData):void
	{
		_viewData = value;
	}
	
	public function get tilePyramid():TilePyramid { return _tilePyramid; }
	public function set tilePyramid(value:TilePyramid):void
	{
		_tilePyramid = value;
	}
}
}