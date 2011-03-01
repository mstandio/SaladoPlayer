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
package com.panozona.modules.buttonsbar.model.structure{
	
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	import com.panozona.player.module.data.property.Size;
	
	public class Bar {
		
		public var visible:Boolean = true;
		public var alpha:Number = 0.75;
		public var color:Number = 0xffffff; // white
		
		/**
		 * background image, -x -y repeated, intentionally not initialized
		 */
		public var path:String; 
		
		/**
		 * when width is set to NaN, bar uses width of panorama window
		 */
		public var size:Size = new Size(NaN, 40); 
		public var align:Align = new Align(Align.RIGHT, Align.BOTTOM); // horizontal, vertical
		public var move:Move = new Move(0, 0); // horizontal, vertical
	}
}