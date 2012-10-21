/*
Copyright 2012 Marek Standio.

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
along with SaladoPlayer. If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.modules.infobox.view {
	
	import com.panozona.modules.infobox.model.InfoBoxData;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class ScrollBarView extends Sprite {
		
		public const thumb:Sprite = new Sprite();
		
		private var backgroundEndingBD:BitmapData;
		private var backgroundTrunkBD:BitmapData;
		private var backgroundEndingFlippedBD:BitmapData;
		
		private var thumbEndingBD:BitmapData;
		private var thumbTrunkBD:BitmapData;
		private var thumbEndingFlippedBD:BitmapData;
		
		private var _infoBoxData:InfoBoxData;
		
		public function ScrollBarView(infoBoxData:InfoBoxData) {
			_infoBoxData = infoBoxData;
		}
		
		public function get infoBoxData():InfoBoxData {
			return _infoBoxData;
		}
		
		public function build(
			backgroundTrunkBD:BitmapData, backgroundEndingBD:BitmapData, 
			thumbTrunkBD:BitmapData, thumbEndingBD:BitmapData):void {
			
			this.backgroundEndingBD = backgroundEndingBD;
			this.backgroundTrunkBD = backgroundTrunkBD;
			
			
			this.thumbEndingBD = thumbEndingBD;
			this.thumbTrunkBD = thumbTrunkBD;
			
			
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbMouseDown, false, 0, true);
			thumb.addEventListener(MouseEvent.MOUSE_UP, thumbMouseUp, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, thumbMouseUp, false, 0, true);
			
			addChild(thumb);
		}
		
		public function draw():void {
			thumbEndingFlippedBD = new BitmapData(thumbEndingBD.width, 
				_infoBoxData.viewerData.scrollBarData.thumbLength, true, 0);
			thumbEndingFlippedBD.draw(thumbEndingBD, new Matrix(1, 0, 0, -1, 0,
				_infoBoxData.viewerData.scrollBarData.thumbLength - 1)); // dirty fix
			
			backgroundEndingFlippedBD = new BitmapData(backgroundEndingBD.width, 
				_infoBoxData.windowData.currentSize.height -_infoBoxData.viewerData.viewer.style.padding * 2, true, 0);
			backgroundEndingFlippedBD.draw(backgroundEndingBD, new Matrix(1, 0, 0, -1, 0,
				_infoBoxData.windowData.currentSize.height -_infoBoxData.viewerData.viewer.style.padding * 2));
			
			graphics.clear();
			graphics.beginBitmapFill(backgroundEndingBD, null, false);
			graphics.drawRect(0, 0, backgroundEndingBD.width,backgroundEndingBD.height);
			graphics.endFill();
			
			graphics.beginBitmapFill(backgroundTrunkBD, null, true);
			graphics.drawRect(0, backgroundEndingBD.height, backgroundTrunkBD.width,
				_infoBoxData.windowData.currentSize.height - (backgroundEndingBD.height * 2)
				-_infoBoxData.viewerData.viewer.style.padding * 2);
			graphics.endFill();
			
			graphics.beginBitmapFill(backgroundEndingFlippedBD, null, false);
			graphics.drawRect(0, 0, backgroundEndingFlippedBD.width, backgroundEndingFlippedBD.height);
			graphics.endFill();
			
			thumb.graphics.clear();
			thumb.graphics.beginBitmapFill(thumbEndingBD, null, false);
			thumb.graphics.drawRect(0, 0, thumbEndingBD.width, thumbEndingBD.height);
			thumb.graphics.endFill();
			
			thumb.graphics.beginBitmapFill(thumbTrunkBD, null, false);
			thumb.graphics.drawRect(0, thumbEndingBD.height, thumbTrunkBD.width,
				_infoBoxData.viewerData.scrollBarData.thumbLength - (thumbEndingBD.height * 2));
			thumb.graphics.endFill();
			
			thumb.graphics.beginBitmapFill(thumbEndingFlippedBD, null, false);
			thumb.graphics.drawRect(0, 0, thumbEndingFlippedBD.width, thumbEndingFlippedBD.height);
			thumb.graphics.endFill();
		}
		
		private function thumbMouseDown(e:Event):void {
			_infoBoxData.viewerData.scrollBarData.mouseDrag = true;
		}
		
		private function thumbMouseUp(e:Event):void {
			_infoBoxData.viewerData.scrollBarData.mouseDrag = false;
		}
	}
}