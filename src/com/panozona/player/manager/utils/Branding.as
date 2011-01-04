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
package com.panozona.player.manager.utils{
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import com.panozona.player.SaladoPlayer;
	import com.panozona.player.manager.data.global.BrandingData;
	import com.panozona.player.manager.data.global.Align;
	//import com.panozona.player.manager.data.global.Move;
	
	/**
	* ...
	* @author mstandio
	*/
	public class Branding extends Sprite{
		
		[Embed(source="../assets/powered_by_saladoplayer.png")]
		private static var Bitmap_pbsp:Class;
		
		private var brandingButton:Sprite;
		
		private var brandingData:BrandingData;
		
		public function Branding() {
			
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}
		
		private function stageReady(e:Event = null):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			
			brandingData = (this.parent as SaladoPlayer).managerData.brandingData;
			
			brandingButton = new Sprite();
			brandingButton.alpha = brandingData.alpha;
			brandingButton.buttonMode = true;
			brandingButton.addChild(new Bitmap(new Bitmap_pbsp().bitmapData, "auto", true));
			brandingButton.addEventListener(MouseEvent.MOUSE_DOWN, gotoPanoZona, false, 0, true);
			addChild(brandingButton);
			
			stage.addEventListener(Event.RESIZE, handleStageResize);
			handleStageResize();
		}
		
		private function handleStageResize(e:Event = null):void {
			
			var boundsWidth:Number = (this.parent as SaladoPlayer).manager.boundsWidth;
			var boundsHeight:Number = (this.parent as SaladoPlayer).manager.boundsHeight;
			
			if (brandingData.align.horizontal == Align.RIGHT) {
				brandingButton.x = boundsWidth - brandingButton.width;
			}else if (brandingData.align.horizontal == Align.LEFT) {
				brandingButton.x = 0;
			}else{ // center
				brandingButton.x = (boundsWidth - brandingButton.width)*0.5;
			}
			
			if (brandingData.align.vertical == Align.TOP) {
				brandingButton.y = 0;
			}else if (brandingData.align.vertical == Align.BOTTOM) {
				brandingButton.y = boundsHeight- brandingButton.height;
			}else { // middle
				brandingButton.y = (boundsHeight - brandingButton.height)*0.5;
			}
			brandingButton.x += brandingData.move.horizontal;
			brandingButton.y += brandingData.move.vertical;
		}
		
		private function gotoPanoZona(e:Event):void {
			var request:URLRequest = new URLRequest("http://panozona.com/");
			try {
				navigateToURL(request, '_BLANK');
			} catch (error:Error) {
				(this.parent as SaladoPlayer).tracer.printWarning("Could not open http://panozona.com/");
			}
		}
	}
}