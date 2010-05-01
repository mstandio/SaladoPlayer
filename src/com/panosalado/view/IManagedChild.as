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

import flash.geom.Vector3D;
import flash.geom.Matrix3D;

public interface IManagedChild 
{
	function get invalid():Boolean
	function set invalid(value:Boolean):void
	
	function get decomposition():Vector.<Vector3D>
	function set decomposition(value:Vector.<Vector3D>):void
	
	function get matrix3D():Matrix3D
	function set matrix3D(value:Matrix3D):void
}
}