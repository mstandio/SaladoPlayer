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
package com.panosalado.model
{

import flash.utils.getQualifiedClassName;

public class Characteristics
{
	/* characteristics can be any object, not just String.  
	It should uniquely identify the dependency to the object that needs a reference to it.
	Using a string representation of the class works for objects where the will only be one of the same class in the DependencyRelay.
	If there are going to be multiple dependencies propagated through the dependency relay, it might be simpler to write in string literals,
	instead of using this class, exactly as you can use the Event.COMPLETE or "complete".
	*/
	public static var PANORAMA:String 							= "com.panosalado.view::Panorama"
	public static var VIEW_DATA:String 							= "com.panosalado.model::ViewData";
	public static var INERTIAL_MOUSE_CAMERA_DATA:String 		= "com.panosalado.model::InertialMouseCameraData";
	public static var ARC_BALL_CAMERA_DATA:String 				= "com.panosalado.model::ArcBallCameraData";
	public static var KEYBOARD_CAMERA_DATA:String 				= "com.panosalado.model::KeyboardCameraData";
	public static var AUTOROTATION_CAMERA_DATA:String 			= "com.panosalado.model::AutorotationCameraData";
	public static var SIMPLE_TRANSITION_DATA:String				= "com.panosalado.model::SimpleTransitionData";
	
}
}