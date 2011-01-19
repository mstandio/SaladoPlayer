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
package com.panozona.hotspots.videohotspot {
	
	//import com.panosalado.view.SwfHotspot;
	import com.panozona.hotspots.videohotspot.conroller.PlayerController;
	import com.panozona.hotspots.videohotspot.model.VideoHotspotData;
	import com.panozona.hotspots.videohotspot.view.PlayerView;
	import flash.events.Event;
	import flash.display.Sprite;
	
	//public class VideoHotspot extends SwfHotspot {
	public class VideoHotspot extends Sprite {
		
		private var videoHotspotData:VideoHotspotData;
		
		private var playerView:PlayerView;
		private var playerController:PlayerController;
		
		public function VideoHotspot():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			//super();
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		//override protected function hotspotReady():void {
			videoHotspotData = new VideoHotspotData(); // TODO: hook it up with SaladoPlayer
			
			playerView = new PlayerView(videoHotspotData);
			//playerView.x = - playerView.width * 0.5;
			//playerView.y = - playerView.height * 0.5;
			addChild(playerView);
			
			playerController = new PlayerController(playerView);
		}
	}
}