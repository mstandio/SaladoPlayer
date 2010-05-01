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
public class PanoSaladoEvent extends Event
{
	/**
	* The PanoSaladoEvent.SWING_TO_COMPLETE constant defines the value of the 
	* <code>type</code> property of the event object 
	* for an <code>swingToComplete</code> event.
	*
	* @eventType swingToComplete
	*/
	public static const SWING_TO_COMPLETE:String = "swingToComplete";
	
	/**
	* The PanoSaladoEvent.SWING_TO_CHILD_COMPLETE constant defines the value of the 
	* <code>type</code> property of the event object 
	* for an <code>swingToChildComplete</code> event.
	*
	* @eventType swingToChildComplete
	*/
	public static const SWING_TO_CHILD_COMPLETE:String = "swingToChildComplete";
	
	public function PanoSaladoEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
		super(type,bubbles,cancelable)
	}
}
}