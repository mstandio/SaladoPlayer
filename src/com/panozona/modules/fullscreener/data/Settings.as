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
package com.panozona.modules.fullscreener.data {
	
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	import com.panozona.player.module.data.property.MouseOverOut;
	
	public class Settings {
		
		public var path:String = null;
		
		public var alpha: Number = 1;
		
		public const align:Align = new Align(Align.RIGHT, Align.TOP);
		public const move:Move = new Move(0, 0);
		
		public var onFullScreenOn:String = null;
		public var onFullScreenOff:String = null;
		
		public const mouse:MouseOverOut = new MouseOverOut();
	}
}