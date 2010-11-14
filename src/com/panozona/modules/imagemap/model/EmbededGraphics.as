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
		[Embed(source="../assets/move_plain.png")]
			public static var BitmapMovePlain:Class;
		[Embed(source="../assets/move_right.png")]
			public static var BitmapMoveRight:Class;
		[Embed(source="../assets/move_left.png")]
			public static var BitmapMoveLeft:Class;
		[Embed(source="../assets/move_up.png")]
			public static var BitmapMoveUp:Class;
		[Embed(source="../assets/move_down.png")]
			public static var BitmapMoveDown:Class;
		[Embed(source="../assets/zoom_plain.png")]
			public static var BitmapZoomPlain:Class;
		[Embed(source="../assets/zoom_in.png")]
			public static var BitmapZoomIn:Class;
		[Embed(source="../assets/zoom_out.png")]
			public static var BitmapZoomOut:Class;
		[Embed(source="../assets/close_plain.png")]
			public static var BitmapClosePlain:Class;
		[Embed(source="../assets/close_press.png")]
			public static var BitmapClosePress:Class;
	}
}