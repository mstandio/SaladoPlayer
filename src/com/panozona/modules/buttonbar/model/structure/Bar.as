/*
Copyright 2011 Marek Standio.

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
package com.panozona.modules.buttonbar.model.structure{
	
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	import com.panozona.player.module.data.property.Size;
	
	public class Bar {
		
		public var visible:Boolean = false;
		public var alpha:Number = 0.5;
		public var color:Number = 0x000000; // black
		
		/**
		 * background image, x y repeated
		 * when not set color is used instead
		 */
		public var path:String = null;
		
		/**
		 * when width is set to NaN, bar uses width of panorama window
		 */
		public const size:Size = new Size(NaN, 50);
		public const move:Move = new Move(0, 0); // horizontal, vertical
	}
}