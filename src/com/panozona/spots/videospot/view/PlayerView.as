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
package com.panozona.spots.videospot.view {
	
	import com.panozona.spots.videospot.model.VideoSpotData;
	import com.panozona.spots.videospot.model.StreamData;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Video;
	
	public class PlayerView extends Sprite {
		
		[Embed(source="../assets/bigPlay.png")]
		private static var Bitmap_bigPlay:Class;
		
		[Embed(source="../assets/bigReplay.png")]
		private static var Bitmap_bigReplay:Class;
		
		[Embed(source="../assets/stop.png")]
		private static var Bitmap_smallStop:Class;
		
		[Embed(source="../assets/pause.png")]
		private static var Bitmap_smallPause:Class;
		
		public var splash:Bitmap;
		public var video:Video;
		public var playBigButton:Sprite;
		public var replayBigButton:Sprite;
		//public var throbber // TODO: add some kind of throbber
		
		public var stopSmallButton:Sprite;
		public var pauseSmallButton:Sprite;
		public var panelSmallButtons:Sprite;
		
		public var soundView:SoundView;
		public var barView:BarView;
		
		public var videoSpotData:VideoSpotData;
		
		public function PlayerView(videoSpotData:VideoSpotData) {
			this.videoSpotData = videoSpotData;
			
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, videoSpotData.settings.size.width, videoSpotData.settings.size.height);
			graphics.endFill();
			
			playBigButton = new Sprite();
			playBigButton.buttonMode = true;
			playBigButton.addChild(new Bitmap(new Bitmap_bigPlay().bitmapData));
			playBigButton.x = (videoSpotData.settings.size.width - playBigButton.width) * 0.5;
			playBigButton.y = (videoSpotData.settings.size,height - playBigButton.height) * 0.5;
			playBigButton.visible = true;
			playBigButton.addEventListener(MouseEvent.CLICK, performPlay, false, 0, true);
			
			replayBigButton = new Sprite();
			replayBigButton.buttonMode = true;
			replayBigButton.addChild(new Bitmap(new Bitmap_bigReplay().bitmapData));
			replayBigButton.x = (videoSpotData.settings.size.width - replayBigButton.width) * 0.5;
			replayBigButton.y = (videoSpotData.settings.size.height - replayBigButton.height) * 0.5;
			replayBigButton.visible = false;
			replayBigButton.addEventListener(MouseEvent.CLICK, performReplay, false, 0, true);
			
			stopSmallButton = new Sprite();
			stopSmallButton.addChild(new Bitmap(new Bitmap_smallStop().bitmapData));
			stopSmallButton.buttonMode = true;
			stopSmallButton.x = 10;
			stopSmallButton.addEventListener(MouseEvent.CLICK, performStop, false, 0, true);
			
			pauseSmallButton = new Sprite();
			pauseSmallButton.addChild(new Bitmap(new Bitmap_smallPause().bitmapData));
			pauseSmallButton.buttonMode = true;
			pauseSmallButton.x = stopSmallButton.x + stopSmallButton.width + 10;
			pauseSmallButton.addEventListener(MouseEvent.CLICK, performPause, false, 0, true);
			
			soundView = new SoundView(videoSpotData);
			soundView.x = videoSpotData.settings.size.width - soundView.width - 10;
			soundView.y = 0;
			
			panelSmallButtons = new Sprite();
			panelSmallButtons.addChild(pauseSmallButton);
			panelSmallButtons.addChild(stopSmallButton);
			panelSmallButtons.addChild(soundView);
			panelSmallButtons.x = 0;
			panelSmallButtons.y = videoSpotData.settings.size.height - 10 - videoSpotData.playerData.barHeightExpanded - pauseSmallButton.height;
			panelSmallButtons.visible = false;
			
			barView = new BarView(videoSpotData);
			barView.y = 0;
			barView.visible = false;
			
			arrangeChildren();
			
			addEventListener(MouseEvent.ROLL_OVER, playerMouseOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, playerMouseOut, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, playerMouseUp, false, 0, true);
		}
		
		private function performPlay(e:Event):void {
			videoSpotData.streamData.streamState = StreamData.STATE_PLAY;
		}
		
		private function performReplay(e:Event):void {
			videoSpotData.streamData.seekTime = 0;
			videoSpotData.streamData.streamState = StreamData.STATE_PLAY;
		}
		
		private function performPause(e:Event):void {
			videoSpotData.streamData.streamState = StreamData.STATE_PAUSE;
		}
		
		private function performStop(e:Event):void {
			videoSpotData.streamData.streamState = StreamData.STATE_STOP;
		}
		
		private function playerMouseOver(e:Event):void {
			videoSpotData.playerData.navigationActive = true;
		}
		
		private function playerMouseOut(e:Event):void {
			videoSpotData.playerData.navigationActive = false;
			videoSpotData.barData.progressPointerDragged = false;
		}
		
		private function playerMouseUp(e:Event):void {
			videoSpotData.barData.progressPointerDragged = false;
		}
		
		public function arrangeChildren():void {
			if (splash != null) {
				addChild(splash);
			}
			if (video != null) {
				addChild(video);
			}
			addChild(barView);
			addChild(playBigButton);
			addChild(replayBigButton);
			addChild(panelSmallButtons);
		}
	}
}