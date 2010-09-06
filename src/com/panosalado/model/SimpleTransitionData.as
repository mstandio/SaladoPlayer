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

import com.robertpenner.easing.*;

public class SimpleTransitionData
{
	public var tween:Function;
	public var time:Number;
	public var property:String;
	public var startValue:Number;
	public var endValue:Number
	
	public function SimpleTransitionData() {
		tween = Linear.easeNone;
		time = 2.5;
		property = "alpha";
		startValue = 0;
		endValue = 1;
	}

}
}