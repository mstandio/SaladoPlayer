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
package com.panozona.spots.videospot {
	
	import com.panozona.spots.videospot.conroller.PlayerController;
	import com.panozona.spots.videospot.model.VideoSpotData;
	import com.panozona.spots.videospot.model.StreamData;
	import com.panozona.spots.videospot.view.PlayerView;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	
	public class VideoSpot extends Sprite {
		
		private var playerView:PlayerView;
		private var playerController:PlayerController;
		
		protected var saladoPlayer:Object;
		protected var hotspotDataSwf:Object;
		
		protected var panoramaEvent:Object;
		
		private var videoSpotData:VideoSpotData;
		
		public function VideoSpot():void { // 1.
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function references(saladoPlayer:Object, hotspotDataSwf:Object):void { // 2.
			var saladoPlayerClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.SaladoPlayer") as Class;
			if (saladoPlayer is saladoPlayerClass) { this.saladoPlayer = saladoPlayer;}
			var hotspotDataSwfClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.data.panoramas.HotspotDataSwf") as Class;
			if (hotspotDataSwf is hotspotDataSwfClass) { this.hotspotDataSwf = hotspotDataSwf; }
		}
		
		private function init(e:Event = null):void { // 3.
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if (saladoPlayer == null || hotspotDataSwf == null) {
				printError("No SaladoPlayer reference.");
				return;
			}
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0 , true);
			
			
			try {
				videoSpotData = new VideoSpotData(hotspotDataSwf, saladoPlayer);
			}catch (e:Error) {
				printError(e.message);
				return;
			}
			
			playerView = new PlayerView(videoSpotData);
			playerView.x = - playerView.width * 0.5;
			playerView.y = - playerView.height * 0.5;
			addChild(playerView);
			
			playerController = new PlayerController(playerView);
		}
		
		private function onPanoramaStartedLoading(e:Event):void {
			videoSpotData.streamData.streamState = StreamData.STATE_STOP;
			while (numChildren) removeChildAt(0);
		}
		
		protected function printError(message:String):void {
			if (saladoPlayer != null && ("traceWindow" in saladoPlayer)) {
				saladoPlayer.traceWindow.printError("VideoSpot: " + message);
			}else{
				trace(message);
			}
		}
	}
}