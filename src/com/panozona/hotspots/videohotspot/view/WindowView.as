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
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Video;
	
	public class WindowView extends Sprite {
		
		[Embed(source="../assets/play.png")]
		private static var Bitmap_bigPlay:Class;
		
		[Embed(source="../assets/replay.png")]
		private static var Bitmap_bigReplay:Class;
		
		[Embed(source="../assets/pause.png")]
		private static var Bitmap_smallPause:Class;
		
		[Embed(source="../assets/stop.png")]
		private static var Bitmap_smallStop:Class;
		
		public var splash:Bitmap;
		public var video:Video;
		public var playBigButton:Sprite;
		public var replayBigButton:Sprite;
		//public var throbber // TODO: add some kind of throbber
		
		public var pauseSmallButton:Sprite;
		public var stopSmallButton:Sprite;
		public var panelSmallButtons:Sprite;
		
		public var progressBar:Sprite;
		
		public var pointer:Sprite;
		
		public var videoHotspotData:VideoHotspotData;
		
		public function WindowView(videoHotspotData:VideoHotspotData) {
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
			replayBigButton = new Sprite();
			replayBigButton.buttonMode = true;
			replayBigButton.addChild(new Bitmap(new Bitmap_bigReplay().bitmapData));
			replayBigButton.x = (videoHotspotData.settings.width - replayBigButton.width) * 0.5;
			replayBigButton.y = (videoHotspotData.settings.height - replayBigButton.height) * 0.5;
			replayBigButton.visible = false;
			
			pointer = new Sprite();
			pointer.graphics.beginFill(0x000000);
			pointer.graphics.drawCircle(videoHotspotData.windowData.barHeightExpanded * 0.5,
				videoHotspotData.windowData.barHeightExpanded * 0.5,
				videoHotspotData.windowData.barHeightExpanded * 0.5 + 2);
			pointer.graphics.endFill();
			pointer.graphics.beginFill(0xffffff);
			pointer.graphics.drawCircle(videoHotspotData.windowData.barHeightExpanded * 0.5,
			videoHotspotData.windowData.barHeightExpanded * 0.5,
			videoHotspotData.windowData.barHeightExpanded * 0.5 - 1);
			pointer.graphics.endFill();
			pointer.visible = false;
			pointer.addEventListener(MouseEvent.MOUSE_DOWN, dragStart, false, 0, true);
			pointer.addEventListener(MouseEvent.MOUSE_UP, dragStop, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, dragStop, false, 0, true);
			if (stage) addStageListeners();
			else addEventListener(Event.ADDED_TO_STAGE, addStageListeners);
			
			progressBar = new Sprite();
			progressBar.addChild(pointer);
			progressBar.buttonMode = true;
			progressBar.visible = false;
			
			pauseSmallButton = new Sprite();
			pauseSmallButton.addChild(new Bitmap(new Bitmap_smallPause().bitmapData));
			pauseSmallButton.buttonMode = true;
			pauseSmallButton.x = 0;
			pauseSmallButton.visible = false;
			
			stopSmallButton = new Sprite();
			stopSmallButton.addChild(new Bitmap(new Bitmap_smallStop().bitmapData));
			stopSmallButton.buttonMode = true;
			stopSmallButton.x = pauseSmallButton.width + 10;
			stopSmallButton.visible = false;
			
			panelSmallButtons = new Sprite();
			panelSmallButtons.addChild(pauseSmallButton);
			panelSmallButtons.addChild(stopSmallButton);
			panelSmallButtons.x = videoHotspotData.settings.width - panelSmallButtons.width - 10;
			panelSmallButtons.y = videoHotspotData.settings.height - panelSmallButtons.height - 10 - videoHotspotData.windowData.barHeightExpanded;
			
			arrangeChildren();
			
			addEventListener(MouseEvent.ROLL_OVER, mouseOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, mouseOut, false, 0, true);
		}
		
		private function addStageListeners(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, addStageListeners);
			stage.addEventListener(MouseEvent.MOUSE_UP, dragStop, false, 0, true);
		}
		
		private function mouseOver(e:Event):void {
			videoHotspotData.windowData.mouseIsOver = true;
		}
		
		private function mouseOut(e:Event):void {
			videoHotspotData.windowData.mouseIsOver = false;
		}
		
		private function dragStart(e:Event):void {
			videoHotspotData.windowData.pointerDragged = true;
		}
		
		private function dragStop(e:Event):void {
			videoHotspotData.windowData.pointerDragged = false;
		}
		
		public function arrangeChildren():void {
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