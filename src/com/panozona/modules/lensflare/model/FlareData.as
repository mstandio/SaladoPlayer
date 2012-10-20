/*
Copyright 2012 Marek Standio.

This file is part of SaladoPlayer.

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
package com.panozona.modules.lensflare.model {
	
	import com.panozona.modules.lensflare.model.structure.Flares;
	import com.panozona.modules.lensflare.model.structure.Flare;
	
	public class FlareData{
		
		private var _flare:Flare;
		private var _brightness:Number;
		
		public function FlareData(flare:Flare):void {
			_flare = flare;
			brightness = 0; // neutral
		}
		
		public function get flare():Flare {
			return _flare;
		}
		
		public function get brightness():Number { return _brightness; }
		public function set brightness(value:Number):void {
			_brightness = value;
		}
	}
}