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
package com.panozona.modules.imagemap.model{
	
	/**	 
	 * @author mstandio
	 */
	public class EmbededGraphics{
		
		[Embed(source="../assets/cursor_hand_closed.png")]
			public static var BitmapCursorHandClosed:Class;
		[Embed(source="../assets/cursor_hand_opened.png")]
			public static var BitmapCursorHandOpened:Class;
		[Embed(source="../assets/navigation_move.png")]
			public static var BitmapNavigationMove:Class;
		[Embed(source="../assets/navigation_zoom.png")]
			public static var BitmapNavigationZoom:Class;
		[Embed(source="../assets/icon_map.png")]
			public static var BitmapIconMap:Class;
		[Embed(source="../assets/icon_close_plain.png")]
			public static var BitmapIconClosePlain:Class;
		[Embed(source="../assets/icon_close_press.png")]
			public static var BitmapIconClosePress:Class;
	}
}