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

import com.panosalado.model.ViewData;
import com.panosalado.view.Panorama;
import com.panosalado.events.ViewEvent;
import com.panosalado.model.Characteristics;
import com.panosalado.core.PanoSalado;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;

public class Nanny
{
	protected var _panorama					:Panorama
	protected var _viewData					:ViewData
	protected var _managedChildren			:Sprite
	protected var _secondaryManagedChildren	:Sprite
	protected var _tempChildren				:Vector.<DisplayObject>;
	
	
	public function Nanny() {
		_tempChildren = new Vector.<DisplayObject>();
	}
	
	public function processDependency(reference:Object,characteristics:*):void {
		if 		(characteristics == Characteristics.VIEW_DATA) viewData = reference as ViewData;
		//else if (characteristics == Characteristics.PANORAMA) panorama = reference as Panorama;
		
	}
	
// 	protected function set panorama(value:Panorama):void {
// 		if (_panorama === value) return;
// 		if (value != null) {
// 			_managedChildren = value.managedChildren
// 			_secondaryManagedChildren = value.secondaryManagedChildren
// 		}
// 		else {
// 			_managedChildren = null
// 			_secondaryManagedChildren = null
// 		}
// 		_panorama = value;
// 	}
	
	protected function set viewData(value:ViewData):void {
		if (_viewData === value) return;
		
		if (value != null) {
			_managedChildren = (value as PanoSalado).managedChildren
			_secondaryManagedChildren = (value as PanoSalado).secondaryManagedChildren
			value.addEventListener( ViewEvent.PATH, startManagingChildren, false, 0, true );
			value.addEventListener( ViewEvent.PATH, showManagedChildren, false, 0, true );
			value.addEventListener( ViewEvent.NULL_PATH, hideManagedChildren, false, 0, true );
		}
		else {
			_viewData.removeEventListener( ViewEvent.PATH, startManagingChildren );
			_viewData.removeEventListener( ViewEvent.PATH, moveManagedChildren );
			_viewData.removeEventListener( ViewEvent.PATH, showManagedChildren );
			_viewData.removeEventListener( ViewEvent.NULL_PATH, hideManagedChildren );
			_managedChildren = null
			_secondaryManagedChildren = null
		}
		_viewData = value;
	}
	
	protected function showManagedChildren(e:Event):void {
		if (_managedChildren == null) return;
		_managedChildren.visible = true;
		_secondaryManagedChildren.visible = true;
	}
	protected function hideManagedChildren(e:Event):void {
		if (_managedChildren == null) return;
		_managedChildren.visible = false;
		_secondaryManagedChildren.visible = false;
	}
	
	protected function startManagingChildren(e:Event):void { // this ignores the first path so that pre added hotspots are nor moved
		_viewData.removeEventListener( ViewEvent.PATH, startManagingChildren );
		_viewData.addEventListener( ViewEvent.PATH, moveManagedChildren, false, 0, true );
	}
	
	protected function moveManagedChildren(e:Event=null):void { 
		if (_managedChildren == null || _secondaryManagedChildren == null) return;
		var len:int = _managedChildren.numChildren;
		var i:int = 0;
		while (0 < len) {
			_tempChildren[i] = _managedChildren.removeChildAt(0);
			len--;
			i++;
		}
		len = _secondaryManagedChildren.numChildren;
		while (0 < len) {
			_secondaryManagedChildren.removeChildAt(0);
			len--
		}
		len = _tempChildren.length;
		for (i = 0; i < len; i++) {
			_secondaryManagedChildren.addChildAt(_tempChildren[i],i);
		}
		_tempChildren.length = 0;
	}
}
}