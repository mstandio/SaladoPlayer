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
package com.panosalado.events
{

import flash.events.Event;

import com.panosalado.model.TilePyramid;

public class ReadyEvent extends Event
{
	public static var READY:String = "ready";
	
	public var tilePyramid:TilePyramid;
	
	public function ReadyEvent(type:String, tilePyramid:TilePyramid){
		this.tilePyramid = tilePyramid;
		super(type);
	}
	
	override public function clone():Event {
		return new ReadyEvent(type,tilePyramid);
	}
}
}