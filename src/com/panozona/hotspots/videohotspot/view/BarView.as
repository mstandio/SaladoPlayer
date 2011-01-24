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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class BarView extends Sprite{
		
		public var progressBar:Sprite;
		public var progressPointer:Sprite;
		
		public var videoHotspotData:VideoHotspotData;
		
		public function BarView(videoHotspotData:VideoHotspotData){
			this.videoHotspotData = videoHotspotData;
			
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
			
			progressBar = new Sprite();
			progressBar.addChild(progressPointer);
			progressBar.buttonMode = true;
			progressBar.addEventListener(MouseEvent.MOUSE_DOWN, dragProgressStart, false, 0, true);
			progressBar.addEventListener(MouseEvent.MOUSE_UP, dragProgressStop, false, 0, true);
			addChild(progressBar);
		}
		
		private function dragProgressStart(e:Event):void {
			videoHotspotData.barData.progressPointerDragged = true;
		}
		
		private function dragProgressStop(e:Event):void {
			videoHotspotData.barData.progressPointerDragged = false;
		}
	}
}