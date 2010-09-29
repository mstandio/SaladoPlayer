/*
Copyright 2010 Marek Standio.

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
along with SaladoPlayer.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.modules.navigationbar.data{

	import com.panozona.player.module.data.PositionMargin;
	import com.panozona.player.module.data.PositionAlign;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class BackgroundBar {
		public var visible:Boolean = true;
		public var height:Number = 30;
		public var alpha:Number = 1.0;
		public var color:Number = 0xffffff; // white
		public var path:String; //  y - repeated,  intentionally not initialized
		public var align:PositionAlign = new PositionAlign(PositionAlign.RIGHT, PositionAlign.BOTTOM); // horizontal, vertical
		public var margin:PositionMargin = new PositionMargin(0,0,10,0); // top, right, bottom, left
	}
}