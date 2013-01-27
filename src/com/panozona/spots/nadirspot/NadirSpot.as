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
package com.panozona.spots.nadirspot {
	
	import com.panozona.spots.nadirspot.data.NadirSpotData;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class NadirSpot extends Sprite{
		
		private var button:Sprite;
		
		private var saladoPlayer:Object;
		private var hotspotDataSwf:Object;
		
		private var nadirSpotData:NadirSpotData;
		
		public function NadirSpot() { // 1.
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
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
			try {
				nadirSpotData = new NadirSpotData(hotspotDataSwf, saladoPlayer);
			}catch (e:Error) {
				printError(e.message);
				return;
			}
			
			var loader:Loader = new Loader();
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			context.checkPolicyFile = true;
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLost);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			loader.load(new URLRequest(nadirSpotData.settings.path), context);
		}
		
		private function imageLost(e:IOErrorEvent):void {
			printError("Could not load image: " + nadirSpotData.settings.path);
		}
		
		private var zenith:Boolean;
		
		private function imageLoaded(e:Event):void {
			button = new Sprite();
			button.addChild(new Bitmap(((e.target as LoaderInfo).content as Bitmap).bitmapData, "auto", true));
			button.x = - button.width * 0.5;
			button.y = - button.height * 0.5;
			addChild(button);
			
			zenith = nadirSpotData.settings.zenith;
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		}
		
		private function onEnterFrame(e:Event):void {
			rotationZ = zenith ? -saladoPlayer.manager.pan : saladoPlayer.manager.pan;
		}
		
		private function printError(message:String):void {
			if (saladoPlayer != null && ("traceWindow" in saladoPlayer)) {
				saladoPlayer.traceWindow.printError("NadirSpot: " + message);
			}else{
				trace(message);
			}
		}
	}
}