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
package com.panosalado.view
{

import flash.display.Sprite
import flash.events.Event;
import flash.geom.Vector3D;
import flash.geom.Matrix3D;
import flash.display.IGraphicsData;

public class VectorHotspot extends ManagedChild
{
	public var _graphicsData:Vector.<IGraphicsData>
	public var invalidGraphicsData:Boolean;
	
		
	public function VectorHotspot(_graphicsData:Vector.<IGraphicsData>) {
		this.graphicsData = _graphicsData;
	}
	
	public function get graphicsData():Vector.<IGraphicsData> { return _graphicsData }
	public function set graphicsData(value:Vector.<IGraphicsData>):void {
		if (value != null) {
			_graphicsData = value;
			invalidGraphicsData = true;
			addEventListener(Event.RENDER, draw, false, 0, true);
			return;
		}
		removeEventListener(Event.RENDER, draw);
	}
	
	protected function draw(e:Event):void {
		if (!invalidGraphicsData) return;
		graphics.drawGraphicsData(_graphicsData);
		invalidGraphicsData = false;
	}
	
}
}