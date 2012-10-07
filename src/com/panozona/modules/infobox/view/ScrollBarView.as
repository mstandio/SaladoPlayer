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
	
	import flash.geom.Matrix;
	
	public class ScrollBarView extends Sprite {
		
		public const thumb:Sprite = new Sprite();
		
		private var backgroundTrunkBD:BitmapData;
		private var thumbTrunkBD:BitmapData;
		
		private var backgroundEnding:Bitmap;
		private var backgroundEndingFlipped:Bitmap;
		private var thumbEnding:Bitmap;
		private var thumbEndingFlipped:Bitmap;
		
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
				
			this.backgroundTrunkBD = backgroundTrunkBD;
			this.thumbTrunkBD = thumbTrunkBD;
			
			var matrix:Matrix = matrix = new Matrix( 1, 0, 0, -1, 0, backgroundEndingBD.height);
			var backgroundEndingFlippedBD:BitmapData = new BitmapData(backgroundEndingBD.width, backgroundEndingBD.height, true, 0);
			backgroundEndingFlippedBD.draw(backgroundEndingBD, matrix, null, null, null, true);
			
			var thumbEndingFlippedBD:BitmapData = new BitmapData(thumbEndingBD.width, thumbEndingBD.height, true, 0);
			thumbEndingFlippedBD.draw(thumbEndingBD, matrix, null, null, null, true);
			
			backgroundEnding = new Bitmap(backgroundEndingBD);
			backgroundEndingFlipped = new Bitmap(backgroundEndingFlippedBD);
			
			addChild(backgroundEnding);
			addChild(backgroundEndingFlipped);
			
			thumbEnding = new Bitmap(thumbEndingBD);
			thumbEndingFlipped = new Bitmap(thumbEndingFlippedBD);
			
			thumb.addChild(thumbEnding)
			thumb.addChild(thumbEndingFlipped);
			
			addChild(thumb);
		}
		
		public function draw():void {
			graphics.clear();
			graphics.beginBitmapFill(backgroundTrunkBD, null, true);
			graphics.drawRect(
				0,
				backgroundEnding.height,
				backgroundTrunkBD.width,
				_infoBoxData.windowData.currentSize.height - (backgroundEnding.height + backgroundEndingFlipped.height));
			graphics.endFill();
			backgroundEnding.x = 0;
			backgroundEnding.y = 0;
			backgroundEndingFlipped.x = 0;
			backgroundEndingFlipped.y = _infoBoxData.windowData.currentSize.height - backgroundEndingFlipped.height;
			
			thumb.graphics.clear();
			thumb.graphics.beginBitmapFill(thumbTrunkBD, null, true);
			thumb.graphics.drawRect(
				0,
				thumbEnding.height,
				thumbTrunkBD.width,
				_infoBoxData.viewerData.scrollBarData.thumbLength - (thumbEnding.height + thumbEndingFlipped.height));
			thumb.graphics.endFill();
			thumbEnding.x = 0;
			thumbEnding.y = 0;
			thumbEndingFlipped.x = 0;
			thumbEndingFlipped.y = _infoBoxData.viewerData.scrollBarData.thumbLength - thumbEndingFlipped.height;
		}
	}
}