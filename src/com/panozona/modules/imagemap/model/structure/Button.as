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
package com.panozona.modules.imagemap.model.structure {
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class Button{
		
		public var radius:Number = 15;
		public var plainColor:Number = 0x00ff00; // green
		public var hoverColor:Number = 0xffff00; // yellow
		public var activeColor:Number = 0xff0000; // red
		
		public var borderColor:Number = 0x000000; // black
		public var borderSize:Number = 5;
	}
}