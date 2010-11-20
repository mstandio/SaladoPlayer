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
package com.panozona.player.manager.data.global {
	
	import com.panozona.player.manager.data.global.Align;
	import com.panozona.player.manager.data.global.Size;
	
	/**
	 * Stores data that is used to configure trace window.
	 * 
	 * @author mstandio
	 */
	public class TraceData {
		
		/**
		 * If trace window is by default opened on lounching SaladoPlayer
		 */
		public var open:Boolean = false;
		
		/**
		 * Determinses position of trace window inside panorama.
		 */
		public var align:Align = new Align(Align.RIGHT, Align.TOP);
		
		/**
		 * Determines size of trace window.
		 */
		public var size:Size = new Size(400,100);
	}
}