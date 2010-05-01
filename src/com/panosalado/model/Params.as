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

import com.panosalado.model.ViewData;

/**
* Params object used by PanoSalado.loadPanorama(params:Params) to specify the path for the new panorama,
* as well as any view data values to use for it.  Unspecified values will be untouched.
*/
public class Params
{
	public var path:String;
	public var pan:Number;
	public var tilt:Number;
	public var fieldOfView:Number;
	public var tierThreshold:Number;

	public var boundsWidth:Number;
	public var boundsHeight:Number;
	
	public var minimumFieldOfView:Number;
 	public var maximumFieldOfView:Number;
 	public var minimumPan:Number;
 	public var maximumPan:Number;
 	public var minimumTilt:Number;
 	public var maximumTilt:Number;


	public function Params(
		path:String, 
		pan:Number = NaN,
		tilt:Number = NaN,
		fieldOfView:Number = NaN
	) {		
		this.path = path;
		this.pan = pan;
		this.tilt = tilt;
		this.fieldOfView = fieldOfView;
	}
	
	/**
	* @private
	*/
	public function copyInto(viewData:ViewData):ViewData {
		if (path != null) viewData.path = path;
		
		var secondaryViewData:DependentViewData = viewData.secondaryViewData;
		if (!isNaN(pan)) secondaryViewData.pan = viewData.pan - pan;
		if (!isNaN(tilt)) secondaryViewData.tilt = viewData.tilt - tilt;
		if (!isNaN(fieldOfView)) secondaryViewData.fieldOfView = viewData.fieldOfView - fieldOfView;
		//if (!isNaN(tierThreshold)) secondaryViewData.tierThreshold = viewData.tierThreshold - tierThreshold;
		
		if (!isNaN(pan)) viewData.pan = pan;
		if (!isNaN(tilt)) viewData.tilt = tilt;
		if (!isNaN(fieldOfView)) viewData.fieldOfView = fieldOfView;
		if (!isNaN(tierThreshold)) viewData.tierThreshold = tierThreshold;
	
		if (!isNaN(boundsWidth)) viewData.boundsWidth = boundsWidth;
		if (!isNaN(boundsHeight)) viewData.boundsHeight = boundsHeight;
		
		if (!isNaN(minimumFieldOfView)) viewData.minimumFieldOfView = minimumFieldOfView;
		if (!isNaN(maximumFieldOfView)) viewData.maximumFieldOfView = maximumFieldOfView;
		if (!isNaN(minimumPan)) viewData.minimumPan = minimumPan;
		if (!isNaN(maximumPan)) viewData.maximumPan = maximumPan;
		if (!isNaN(minimumTilt)) viewData.minimumTilt = minimumTilt;
		if (!isNaN(maximumTilt)) viewData.maximumTilt = maximumTilt;
		return viewData;
	}
}
}