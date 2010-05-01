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
package com.panosalado.loading
{

import flash.events.IOErrorEvent;
import flash.display.LoaderInfo;
import flash.net.URLLoader;
	
	public function IOErrorEventHandler(e:IOErrorEvent):void 
	{
		var url:String;
		if (e is LoaderInfo) {
			var loaderInfo:LoaderInfo = LoaderInfo(e.target);
			url = loaderInfo.url;
		}
		else if (e.target is URLLoader) {
			url = "Unknown URL: (URLLoader does not retain a reference to the current URL), file is likely NOT an image or swf"
		}
		else {
			url = "Unknown URL: class of object loading it was: " + e.target;
		}
		trace( "File not found: " + url );
	}
}