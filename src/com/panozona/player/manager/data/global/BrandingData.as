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
package com.panozona.player.manager.data.global{
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class BrandingData {
		
		/**
		 * If branding button is visible
		 */
		public var visible:Boolean = true;
		
		/**
		 * Transparency of branding button
		 */
		public var alpha:Number = 0.5;
		
		/**
		 * Determinses position of branding button inside panorama.
		 */
		public var align:Align = new Align(Align.LEFT, Align.BOTTOM);
		
		/**
		 * Moves button horizontally and vertically with given distances. 
		 */
		public var move:Move = new Move(3, 0);
		
		/**
		 * Adds "Powered by SaladoPlayer" item to context menu
		 */
		public var contextMenu:Boolean = true;
	}
}
