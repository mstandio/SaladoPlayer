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

import flash.events.EventDispatcher;
import flash.display.DisplayObject;
import flash.display.Stage;
import flash.events.Event;
import flash.utils.Dictionary;

import com.panosalado.model.Characteristics;

/* 
implemented with Dictionary, instead of LinkedList, or Vector, or Array, because 
weak-keyed dictionary will not require removal of notification targets for them to 
become eligible for garbage collection. 
*/
public class StageReference extends Dictionary
{
	protected var stage:Stage;
	
	public function StageReference(weakKeys:Boolean = true):void
	{
		super(weakKeys);
	}
	
	public function processDependency(reference:Object,characteristics:*):void { 
		if (characteristics == Characteristics.VIEW_DATA) {
			(reference as EventDispatcher).addEventListener( Event.ADDED_TO_STAGE, notify, false, 0, true );
			(reference as EventDispatcher).addEventListener( Event.REMOVED_FROM_STAGE, notify, false, 0, true );
		}
	}
	
	public function addNotification(object:*, property:String = "stageReference"):void {
		if (object == null) return;
		if (!object.hasOwnProperty(property)) return;
		this[object] = property;
		if (stage != null) object[property] = stage;
	}
	
	public function removeNotification(object:*, property:String = "stageReference"):void {
		if (object == null) return;
		delete this[property];
	}
	
	protected function notify(e:Event):void
	{ 
		switch(e.type) {
			case Event.ADDED_TO_STAGE: 
				stage = (e.target as DisplayObject).stage;
				break;
			case Event.REMOVED_FROM_STAGE: 
				stage = null;
				break;
			default: return;
		}
		var object:*;
		var property:String;
		for (object in this) {
			property = this[object] as String;
			object[property] = stage;
		}
	}

}
}
