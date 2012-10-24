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
package com.panozona.hotspots.fadingspot {
	
	import caurina.transitions.Tweener;
	import com.panozona.hotspots.fadingspot.data.FadingSpotData;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	public class FadingSpot extends Sprite{
		
		private var fadingSpotData:FadingSpotData;
		private var button:Sprite;
		
		private var saladoPlayer:Object;
		private var hotspotDataSwf:Object;
		
		public function FadingSpot() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		public function references(saladoPlayer:Object, hotspotDataSwf:Object):void {
			var saladoPlayerClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.SaladoPlayer") as Class;
			if (saladoPlayer is saladoPlayerClass) { this.saladoPlayer = saladoPlayer;}
			var hotspotDataSwfClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.data.panoramas.HotspotDataSwf") as Class;
			if (hotspotDataSwf is hotspotDataSwfClass) { this.hotspotDataSwf = hotspotDataSwf;}
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if (saladoPlayer == null || hotspotDataSwf == null) {
				printError("No SaladoPlayer reference.");
				return;
			}
			try {
				fadingSpotData = new FadingSpotData(hotspotDataSwf, saladoPlayer);
			}catch (e:Error) {
				printError(e.message);
				return;
			}
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLost);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			loader.load(new URLRequest(fadingSpotData.settings.path));
		}
		
		private function imageLost(e:IOErrorEvent):void {
			printError("Could not load image: " + fadingSpotData.settings.path);
		}
		
		private function imageLoaded(e:Event):void {
			button = new Sprite();
			button.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			button.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			button.addChild(new Bitmap(((e.target as LoaderInfo).content as Bitmap).bitmapData, "auto", true));
			button.x = -button.width * 0.5;
			button.y = -button.height * 0.5;
			button.alpha = 0;
			addChild(button);
		}
		
		private function mouseOver(e:MouseEvent):void {
			Tweener.addTween(button, {
				alpha:fadingSpotData.settings.mouseOver.alpha,
				time:fadingSpotData.settings.mouseOver.time,
				transition:fadingSpotData.settings.mouseOver.transition
			});
		}
		
		private function mouseOut(e:MouseEvent):void {
			Tweener.addTween(button, {
				alpha:fadingSpotData.settings.mouseOut.alpha,
				time:fadingSpotData.settings.mouseOut.time,
				transition:fadingSpotData.settings.mouseOut.transition
			});
		}
		
		private function printError(message:String):void {
			if (saladoPlayer != null && ("traceWindow" in saladoPlayer)) {
				saladoPlayer.traceWindow.printError("AdvancedHotspot: " + message);
			}else{
				trace(message);
			}
		}
	}
}