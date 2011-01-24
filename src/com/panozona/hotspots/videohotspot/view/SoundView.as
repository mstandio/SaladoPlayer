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
package com.panozona.hotspots.videohotspot.view{
	
	import com.panozona.hotspots.videohotspot.model.VideoHotspotData;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class SoundView extends Sprite{
		
		[Embed(source="../assets/soundOn.png")]
		private static var Bitmap_soundOn:Class;
		
		[Embed(source="../assets/soundOff.png")]
		private static var Bitmap_soundOff:Class;
		
		public var soundButton:Sprite;
		public var soundOnBitmap:Bitmap;
		public var soundOffBitmap:Bitmap;
		
		public var volumeBar:Sprite;
		public var volumePointer:Sprite;
		
		public var videoHotspotData:VideoHotspotData;
		
		public function SoundView(videoHotspotData:VideoHotspotData) {
			this.videoHotspotData = videoHotspotData;
			
			soundOnBitmap = new Bitmap(new Bitmap_soundOn().bitmapData);
			soundOffBitmap = new Bitmap(new Bitmap_soundOff().bitmapData);
			
			soundButton = new Sprite();
			soundButton.addChild(soundOnBitmap);
			soundButton.buttonMode = true;
			soundButton.addEventListener(MouseEvent.ROLL_OVER, soundMouseOver, false, 0, true);
			soundButton.addEventListener(MouseEvent.ROLL_OUT, soundMouseOut, false, 0, true);
			soundButton.addEventListener(MouseEvent.CLICK, soundMouseClick, false, 0, true);
			addChild(soundButton);
			
			volumePointer = new Sprite();
			volumePointer.buttonMode = true;
			volumePointer.graphics.beginFill(0xffffff);
			volumePointer.graphics.drawRect(0, 0, 30, 15);
			volumePointer.graphics.endFill();
			volumePointer.x = (soundButton.width - volumePointer.width) * 0.5;
			volumePointer.y = volumePointer.height;
			
			volumeBar = new Sprite();
			volumeBar.graphics.beginFill(0xffffff);
			volumeBar.graphics.drawRect(0, 0, soundButton.width , soundButton.height * 2);
			volumeBar.graphics.endFill();
			volumeBar.graphics.beginFill(0x000000);
			volumeBar.graphics.drawRect(3, 3, soundButton.width - 6 , soundButton.height * 2 - 6);
			volumeBar.graphics.endFill();
			var scaleWidth:Number = 8;
			volumeBar.graphics.beginFill(0xff0000);
			volumeBar.graphics.drawRect(
				(volumeBar.width - scaleWidth) * 0.5,
				volumePointer.height * 1.5,
				scaleWidth,
				volumeBar.height - volumePointer.height * 3);
			volumeBar.graphics.endFill();
			volumeBar.x = soundButton.x;
			volumeBar.y = soundButton.y - volumeBar.height + 3;
			volumeBar.addChild(volumePointer);
			volumeBar.addEventListener(MouseEvent.ROLL_OVER, soundMouseOver, false, 0, true);
			volumeBar.addEventListener(MouseEvent.ROLL_OUT, soundMouseOut, false, 0, true);
			volumeBar.addEventListener(MouseEvent.MOUSE_DOWN, dragVolumeStart, false, 0, true);
			volumeBar.addEventListener(MouseEvent.MOUSE_UP, dragVolumeStop, false, 0, true);
			volumeBar.visible = false;
			addChild(volumeBar);
		}
		
		private function soundMouseOver(e:Event):void {
			videoHotspotData.soundData.volumeBarOpen = true;
		}
		
		private function soundMouseOut(e:Event):void {
			videoHotspotData.soundData.volumeBarOpen = false;
			videoHotspotData.soundData.volumePointerDragged = false;
		}
		
		private function soundMouseClick(e:Event):void {
			videoHotspotData.soundData.mute = !videoHotspotData.soundData.mute;
		}
		
		private function dragVolumeStart(e:Event):void {
			videoHotspotData.soundData.volumePointerDragged = true;
		}
		
		private function dragVolumeStop(e:Event):void {
			videoHotspotData.soundData.volumePointerDragged = false;
		}
	}
}