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
package com.panozona.hotspots.videohotspot.view {
	
	import com.panozona.hotspots.videohotspot.model.VideoHotspotData;
	import com.panozona.hotspots.videohotspot.model.StreamData;
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
		
		[Embed(source="../assets/soundOn.png")]
		private static var Bitmap_smallMute:Class;
		
		public var splash:Bitmap;
		public var video:Video;
		public var playBigButton:Sprite;
		public var replayBigButton:Sprite;
		//public var throbber // TODO: add some kind of throbber
		
		public var stopSmallButton:Sprite;
		public var pauseSmallButton:Sprite;
		public var muteSmallButton:Sprite;
		public var panelSmallButtons:Sprite;
		
		public var progressBar:Sprite;
		public var progressPointer:Sprite;
		
		public var volumeBar:Sprite;
		public var volumePointer:Sprite;
		
		public var videoHotspotData:VideoHotspotData;
		
		public function PlayerView(videoHotspotData:VideoHotspotData) {
			this.videoHotspotData = videoHotspotData;
			
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, videoHotspotData.settings.width, videoHotspotData.settings.height);
			graphics.endFill();
			
			playBigButton = new Sprite();
			playBigButton.buttonMode = true;
			playBigButton.addChild(new Bitmap(new Bitmap_bigPlay().bitmapData));
			playBigButton.x = (videoHotspotData.settings.width - playBigButton.width) * 0.5;
			playBigButton.y = (videoHotspotData.settings.height - playBigButton.height) * 0.5;
			playBigButton.visible = true;
			playBigButton.addEventListener(MouseEvent.CLICK, performPlay, false, 0, true);
			
			replayBigButton = new Sprite();
			replayBigButton.buttonMode = true;
			replayBigButton.addChild(new Bitmap(new Bitmap_bigReplay().bitmapData));
			replayBigButton.x = (videoHotspotData.settings.width - replayBigButton.width) * 0.5;
			replayBigButton.y = (videoHotspotData.settings.height - replayBigButton.height) * 0.5;
			replayBigButton.visible = false;
			replayBigButton.addEventListener(MouseEvent.CLICK, performReplay, false, 0, true);
			
			progressPointer = new Sprite();
			progressPointer.graphics.beginFill(0x000000);
			progressPointer.graphics.drawCircle(videoHotspotData.playerData.barHeightExpanded * 0.5,
				videoHotspotData.playerData.barHeightExpanded * 0.5,
				videoHotspotData.playerData.barHeightExpanded * 0.5 + 2);
			progressPointer.graphics.endFill();
			progressPointer.graphics.beginFill(0xffffff);
			progressPointer.graphics.drawCircle(videoHotspotData.playerData.barHeightExpanded * 0.5,
				videoHotspotData.playerData.barHeightExpanded * 0.5,
				videoHotspotData.playerData.barHeightExpanded * 0.5 - 1);
			progressPointer.graphics.endFill();
			progressPointer.visible = false;
			progressPointer.addEventListener(MouseEvent.MOUSE_DOWN, dragProgressStart, false, 0, true);
			progressPointer.addEventListener(MouseEvent.MOUSE_UP, dragProgressStop, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, dragProgressStop, false, 0, true);
			if (stage) addStageListeners();
			else addEventListener(Event.ADDED_TO_STAGE, addStageListeners);
			
			progressBar = new Sprite();
			progressBar.addChild(progressPointer);
			progressBar.buttonMode = true;
			progressBar.visible = false;
			
			stopSmallButton = new Sprite();
			stopSmallButton.addChild(new Bitmap(new Bitmap_smallStop().bitmapData));
			stopSmallButton.buttonMode = true;
			stopSmallButton.x = 10;
			stopSmallButton.visible = false;
			stopSmallButton.addEventListener(MouseEvent.CLICK, performStop, false, 0, true);
			
			pauseSmallButton = new Sprite();
			pauseSmallButton.addChild(new Bitmap(new Bitmap_smallPause().bitmapData));
			pauseSmallButton.buttonMode = true;
			pauseSmallButton.x = stopSmallButton.x + stopSmallButton.width + 10;
			pauseSmallButton.visible = false;
			pauseSmallButton.addEventListener(MouseEvent.CLICK, performPause, false, 0, true);
			
			muteSmallButton = new Sprite();
			muteSmallButton.addChild(new Bitmap(new Bitmap_smallMute().bitmapData));
			muteSmallButton.buttonMode = true;
			muteSmallButton.x = videoHotspotData.settings.width - muteSmallButton.width - 10;
			muteSmallButton.visible = false;
			muteSmallButton.addEventListener(MouseEvent.MOUSE_OVER, muteMouseOver, false, 0, true);
			muteSmallButton.addEventListener(MouseEvent.CLICK, performMuteToggle, false, 0, true);
			
			volumePointer = new Sprite();
			volumePointer.buttonMode = true;
			volumePointer.graphics.beginFill(0xff0000);
			volumePointer.graphics.drawRect(0, 0, 30, 10);
			volumePointer.graphics.endFill();
			volumePointer.x = (muteSmallButton.width - volumePointer.width) * 0.5;
			volumePointer.y = volumePointer.height;
			
			volumePointer.addEventListener(MouseEvent.MOUSE_DOWN, dragVolumeStart, false, 0, true);
			volumePointer.addEventListener(MouseEvent.MOUSE_UP, dragVolumeStop, false, 0, true);
			
			volumeBar = new Sprite();
			volumeBar.graphics.beginFill(0x0000ff);
			volumeBar.graphics.drawRect(0, 0, muteSmallButton.width , muteSmallButton.height * 2);
			volumeBar.graphics.endFill();
			volumeBar.visible = false;
			volumeBar.x = muteSmallButton.x;
			volumeBar.y = muteSmallButton.y - volumeBar.height;
			volumeBar.addChild(volumePointer);
			
			panelSmallButtons = new Sprite();
			panelSmallButtons.addChild(pauseSmallButton);
			panelSmallButtons.addChild(stopSmallButton);
			panelSmallButtons.addChild(muteSmallButton);
			panelSmallButtons.addChild(volumeBar);
			
			panelSmallButtons.x = 0;
			panelSmallButtons.y = videoHotspotData.settings.height - muteSmallButton.height - 10 - videoHotspotData.playerData.barHeightExpanded;
			
			arrangeChildren();
			
			addEventListener(MouseEvent.ROLL_OVER, playerMouseOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, playerMouseOut, false, 0, true);
		}
		
		private function addStageListeners(e:Event = null):void { // TODO: no.
			removeEventListener(Event.ADDED_TO_STAGE, addStageListeners);
			stage.addEventListener(MouseEvent.MOUSE_UP, dragProgressStop, false, 0, true);
		}
		
		private function performReplay(e:Event):void {
			videoHotspotData.streamData.seekTime = 0;
			videoHotspotData.streamData.streamState = StreamData.STATE_PLAY;
		}
		
		private function performPause(e:Event):void {
			videoHotspotData.streamData.streamState = StreamData.STATE_PAUSE;
		}
		
		private function performStop(e:Event):void {
			videoHotspotData.streamData.streamState = StreamData.STATE_STOP;
		}
		
		private function performMuteToggle(e:Event):void {
			// TODO what about this? this needs seperate structures...
		}
		
		private function playerMouseOver(e:Event):void {
			videoHotspotData.playerData.navigationActive = true;
		}
		
		private function playerMouseOut(e:Event):void {
			videoHotspotData.playerData.navigationActive = false;
		}
		
		private function dragProgressStart(e:Event):void {
			videoHotspotData.playerData.progressPointerDragged = true;
		}
		
		private function dragProgressStop(e:Event):void {
			videoHotspotData.playerData.progressPointerDragged = false;
		}
		
		private function dragVolumeStart(e:Event):void {
			videoHotspotData.playerData.volumePointerDragged = true;
		}
		
		private function dragVolumeStop(e:Event):void {
			videoHotspotData.playerData.volumePointerDragged = false;
		}
		
		private function muteMouseOver(e:Event):void {
			videoHotspotData.playerData.volumeBarOpen = true; // TODO: add close (with timer perhaps)
		}
		
		private function performPlay(e:Event):void {
			videoHotspotData.streamData.streamState = StreamData.STATE_PLAY;
		}
		
		public function arrangeChildren():void { // TODO: no.
			if (splash != null) {
				addChild(splash);
			}
			if (video != null) {
				addChild(video);
			}
			addChild(progressBar);
			addChild(playBigButton);
			addChild(replayBigButton);
			addChild(panelSmallButtons);
		}
	}
}