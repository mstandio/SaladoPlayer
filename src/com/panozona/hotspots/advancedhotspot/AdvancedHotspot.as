/*
Copyright 2011 Marek Standio.

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
package com.panozona.hotspots.advancedhotspot{
	
	import caurina.transitions.*;
	import com.panozona.hotspots.advancedhotspot.data.AdvancedHotspotData;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	
	/**
	 * Simillar to SimpleHotspot but it can communicate with SaladoPlayer 
	 * and it can be configured. Conviguration is not validated untill hotspot is loaded.
	 */
	public class AdvancedHotspot extends Sprite{
		
		protected var button:Sprite;
		
		protected var initialWidth:Number;
		protected var initialHeight:Number;
		
		protected var mouseIsOver:Boolean;
		
		// mandatory references
		protected var saladoPlayer:Object;
		protected var hotspotDataSwf:Object;
		
		protected var advancedHotspotData:AdvancedHotspotData;
		
		public function AdvancedHotspot(){ // 1.
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		/**
		 * If swf file is passed as hotspot, where file root object has 
		 * public function with this name, and such function takes two object arguments,
		 * then SaladoPlayer tries calling it before adding swf to panorama.
		 * 
		 * @param	saladoPlayer
		 * @param	hotspotDataSwf
		 */
		public function references(saladoPlayer:Object, hotspotDataSwf:Object):void { // 2.
			var saladoPlayerClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.SaladoPlayer") as Class;
			if (saladoPlayer is saladoPlayerClass) { this.saladoPlayer = saladoPlayer;}
			var hotspotDataSwfClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.data.panoramas.HotspotDataSwf") as Class;
			if (hotspotDataSwf is hotspotDataSwfClass) { this.hotspotDataSwf = hotspotDataSwf;}
		}
		
		protected function init(e:Event = null):void { // 3.
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if (saladoPlayer == null || hotspotDataSwf == null) {
				printError("No SaladoPlayer reference.");
				return;
			}
			try {
				advancedHotspotData = new AdvancedHotspotData(hotspotDataSwf, saladoPlayer);
			}catch (e:Error) {
				printError(e.message);
				return;
			}
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLost);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			loader.load(new URLRequest(advancedHotspotData.settings.path));
		}
		
		protected function imageLost(e:IOErrorEvent):void {
			printError("Could not load image: " + advancedHotspotData.settings.path);
		}
		
		protected function imageLoaded(e:Event):void {
			button = new Sprite();
			button.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			button.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			button.addChild(new Bitmap(((e.target as LoaderInfo).content as Bitmap).bitmapData, "auto", true));
			button.x = - button.width * 0.5;
			button.y = - button.height * 0.5;
			initialWidth = button.width;
			initialHeight = button.height;
			addChild(button);
			if (advancedHotspotData.settings.beat) beatUp();
		}
		
		protected function mouseOver(e:MouseEvent):void {
			mouseIsOver = true;
			expand(
				advancedHotspotData.settings.mouseOver.scale,
				advancedHotspotData.settings.mouseOver.time,
				advancedHotspotData.settings.mouseOver.transition);
		}
		
		protected function mouseOut(e:MouseEvent):void {
			mouseIsOver = false;
			implode(
				advancedHotspotData.settings.mouseOut.time,
				advancedHotspotData.settings.mouseOut.transition);
			
			if (advancedHotspotData.settings.beat) {
				Tweener.addTween(button, {
					time:advancedHotspotData.settings.mouseOut.time,
					onComplete:beatUp
				});
			}
		}
		
		protected function beatUp():void {
			expand(
				advancedHotspotData.settings.beatUp.scale,
				advancedHotspotData.settings.beatUp.time,
				advancedHotspotData.settings.beatUp.transition,
				mouseIsOver ? null : beatDown);
		}
		
		protected function beatDown():void {
			if (mouseIsOver) return;
			implode(
				advancedHotspotData.settings.beatDown.time,
				advancedHotspotData.settings.beatDown.transition,
				mouseIsOver ? null : beatUp);
		}
		
		protected function expand(scale:Number, time:Number, transition:Function, onComplete:Function = null):void {
			Tweener.addTween(button, {
				scaleX:scale,
				scaleY:scale,
				x: -initialWidth * scale * 0.5,
				y: -initialHeight * scale * 0.5,
				time:time,
				transition:transition,
				onComplete:onComplete
			});
		}
		
		protected function implode(time:Number, transition:Function, onComplete:Function = null):void {
			Tweener.addTween(button, {
				scaleX:1,
				scaleY:1,
				x: -initialWidth * 0.5,
				y: -initialHeight * 0.5,
				time:time,
				transition:transition,
				onComplete:onComplete
			});
		}
		
		protected function printError(message:String):void {
			if (saladoPlayer != null && ("traceWindow" in saladoPlayer)) {
				saladoPlayer.traceWindow.printError("AdvancedHotspot: " + message);
			}else{
				trace(message);
			}
		}
	}
}