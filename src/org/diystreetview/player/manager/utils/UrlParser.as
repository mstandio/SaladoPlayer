/*
Copyright 2011 Marek Standio.

This file is part of DIY streetview player.

SaladoPlayer is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published
by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.

SaladoPlayer is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty
of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with SaladoPlayer. If not, see <http://www.gnu.org/licenses/>.
*/
package org.diystreetview.player.manager.utils{
	
	public class UrlParser {
		
		public var pano:String;
		public var pan:Number;
		public var tilt:Number;
		public var fov:Number;
		
		public function UrlParser (url:String) {
			if(url != null && url.length>0){
				url = url.slice(url.indexOf("?"), url.length);
				if (url.length > 0) {
					url = url.substring(1);
					var settings:Array = url.split("&");
					var temp:Array;
					for each(var setting:String in settings){
						temp = setting.split("=");
						if (temp[0] == "pano"){
							pano = (temp[1]);
						}else if (temp[0] == "cam"){
							temp = temp[1].split(",");
							if (temp.length > 0) {
								pan = temp[0];
							}
							if (temp.length > 1) {
								tilt = temp[1];
							}
							if (temp.length > 2) {
								fov = temp[2];
							}
							continue;
						}
					}
				}
			}
		}
	}
}