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

import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.FullScreenEvent;

import com.panosalado.controller.IResizer;
import com.panosalado.controller.ICamera;
import com.panosalado.events.CameraEvent;
import com.panosalado.model.ViewData;
import com.panosalado.model.Characteristics;

public class Resizer extends EventDispatcher implements IResizer, ICamera
{
	protected var _stage:Stage;
	protected var _viewData:ViewData;
	
	public function Resizer() {
		super();
	}
	
	public function processDependency(reference:Object,characteristics:*):void {
		if (characteristics == Characteristics.VIEW_DATA) viewData = (reference as ViewData);
	}
	
	protected function resizeHandler(e:Event=null):void { 
		if (_stage == null || _viewData == null) return;
		dispatchEvent( new CameraEvent(CameraEvent.ACTIVE) );
		_viewData.boundsWidth = _viewData.secondaryViewData.boundsWidth = _stage.stageWidth;
		_viewData.boundsHeight = _viewData.secondaryViewData.boundsHeight = _stage.stageHeight;
		dispatchEvent( new CameraEvent(CameraEvent.INACTIVE) );
	}
	
	public function get stageReference():Stage { return _stage; }
	public function set stageReference(value:Stage):void
	{
		if (_stage === value) return;
		if ( value != null ) 
		{
			value.align = StageAlign.TOP_LEFT;
			value.scaleMode = StageScaleMode.NO_SCALE;
			value.addEventListener(Event.RESIZE, resizeHandler, false, 0, true);
			value.addEventListener(FullScreenEvent.FULL_SCREEN, resizeHandler, false, 0, true);
		}
		else if (_stage != null) {
			_stage.removeEventListener(Event.RESIZE, resizeHandler);
			_stage.removeEventListener(FullScreenEvent.FULL_SCREEN, resizeHandler);
		}
		
		_stage = value;
		resizeHandler();
	}
	
	public function get viewData():ViewData { return _viewData; }
	public function set viewData(value:ViewData):void
	{
		_viewData = value;
	}
}

}