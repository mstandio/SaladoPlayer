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
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	
	/**
	 * Same as SimpleHotspot but it can be configured. If Swf has public method "references"
	 * SaladoPlayer calls it before hotspot is added to panorama. 
	 */
	public class AdvancedHotspot extends Sprite{
		
		protected var button:Sprite;
		
		protected var initialWidth:Number 
		protected var initialHeight:Number;
		
		// values from xml configuration
		protected var overFunction:String = "easeOutBack";
		protected var outFunction:String = "easeOutExpo";
		protected var overTime:Number = 1;
		protected var outTime:Number = 1;
		protected var tweenScale:Number = 2;
		protected var imagePath:String;
		
		// mandatory references 
		protected var saladoPlayer:Object;
		protected var hotspotDataSwf:Object;
		
		public function AdvancedHotspot(){ // 1.
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		public function references(saladoPlayer:Object, hotspotDataSwf:Object):void {  // 2.
			var saladoPlayerClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.SaladoPlayer") as Class;
			if (saladoPlayer is saladoPlayerClass) {
				this.saladoPlayer = saladoPlayer;
			}else {
				displayError("Invalid SaladoPlayer reference.");
			}
			var hotspotDataSwfClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.data.panoramas.HotspotDataSwf") as Class;
			if (hotspotDataSwf is hotspotDataSwfClass) {
				this.hotspotDataSwf = hotspotDataSwf;
			}else {
				displayError("Invalid HotspotDataSwf reference.");
			}
		}
		
		protected function init(e:Event = null):void { // 3.
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if (saladoPlayer == null) {
				displayError("No SaladoPlayer reference.");
				return;
			}
			try {
				//var dummyXMl:XML = new XML(
				//	"<swf id=\"hs1\" path=\"hotspots.AdvancedHotspot.swf\">" +
				//		"<settings imagePath=\"hotspots/arrow.png\"/>" +
				//		"<overTween transition=\"easeOutBack\" time=\"2\" scale=\"2\"/>" +
				//		"<outTween transition=\"easeOutExpo\" time=\"2\"/>" +
				//	"</swf>");
				for each(var childNode:XML in hotspotDataSwf.xml.elements()) {
					if (childNode.localName() == "settings") {
						imagePath = childNode.@imagePath;
					}else if (childNode.localName() == "overTween") {
						overFunction = childNode.@transition;
						overTime = childNode.@time;
						tweenScale = childNode.@scale;
					}else if (childNode.localName() == "outTween") {
						outFunction = childNode.@transition;
						outTime = childNode.@time;
					}
				}
			}catch (e:Error) {
				displayError("Invalid configuration: " + e.message);
			}
			
			if (imagePath == null) {
				displayError("Invalid imagePath");
				return;
			}
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLost);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			loader.load(new URLRequest(imagePath));
		}
		
		protected function imageLost(e:IOErrorEvent):void {
			displayError("Could not load image: " + imagePath);
		}
		
		protected function imageLoaded(e:Event):void {
			button = new Sprite();
			button.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			button.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			button.addChild((e.target as LoaderInfo).content);
			button.x = - button.width * 0.5;
			button.y = - button.height * 0.5;
			initialWidth = button.width;
			initialHeight = button.height;
			addChild(button);
		}
		
		protected function mouseOver(e:MouseEvent):void {
			Tweener.addTween(button, { scaleX:tweenScale, time:overTime, transition:overFunction } );
			Tweener.addTween(button, { scaleY:tweenScale, time:overTime, transition:overFunction } );
			Tweener.addTween(button, { x: - initialWidth * tweenScale * 0.5, time:overTime, transition:overFunction } );
			Tweener.addTween(button, { y: - initialHeight * tweenScale * 0.5, time:overTime, transition:overFunction } );
		}
		
		protected function mouseOut(e:MouseEvent):void {
			Tweener.addTween(button, { scaleX:1, time:outTime, transition:outFunction } );
			Tweener.addTween(button, { scaleY:1, time:outTime, transition:outFunction } );
			Tweener.addTween(button, { x: - initialWidth * 0.5, time:outTime, transition:outFunction } );
			Tweener.addTween(button, { y: - initialHeight * 0.5, time:outTime, transition:outFunction } );
		}
		
		protected function displayError(message:String):void {
			if (saladoPlayer != null && ("traceWindow" in saladoPlayer)) {
				saladoPlayer.traceWindow.printError("AdvancedHotspot: "+message);
			}else{
				trace(message);
			}
		}
	}
}