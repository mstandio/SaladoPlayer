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
package com.panozona.hotspots.viedohotspot {
	
	import com.panosalado.view.SwfHotspot;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class VideoHotspot extends SwfHotspot{		
			
		public function VideoHotspot(){
			super();
		}	
		
		
		override protected function hotspotReady():void {
			
			var pl:Player = new Player();
			addChild(pl.Movie(500, 300));
			//pl.Play("delicatessen.mp4");
			pl.Play("hotspots/movies/Kasabian - Vlad the Impaler [www.keepvid.com].mp4");			
		}
	}
}