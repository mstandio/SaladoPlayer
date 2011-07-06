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
package com.panozona.modules.compass {
	
	import com.panozona.modules.compass.data.CompassData;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.Module;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	
	public class Compass extends Module{
		
		private var compassData:CompassData;
		
		private var dial:Bitmap;
		private var needle:Bitmap;
		private var axis:Sprite;
		
		private var currentDirection:Number = 0;
		
		private var panoramaEventClass:Class;
		
		public function Compass() {
			
			super("Compass", "1.0", "http://panozona.com/wiki/Module:Compass");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			compassData = new CompassData(moduleData, saladoPlayer);
			
			panoramaEventClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			
			saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0 , true);
			
			var compassLoader:Loader = new Loader();
			compassLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, compassImageLost, false, 0, true);
			compassLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, compassImageLoaded, false, 0, true);
			compassLoader.load(new URLRequest(compassData.settings.path));
		}
		
		private function onPanoramaLoaded(e:Event):void {
			currentDirection = saladoPlayer.manager.currentPanoramaData.direction;
		}
		
		protected function compassImageLost(error:IOErrorEvent):void {
			printError(error.text);
		}
		
		protected function compassImageLoaded(e:Event):void {
			var bitmapData:BitmapData = new BitmapData((e.target as LoaderInfo).width, (e.target as LoaderInfo).height, true, 0);
			bitmapData.draw((e.target as LoaderInfo).content);
			
			var dialBitmapdata:BitmapData = new BitmapData(bitmapData.height, bitmapData.height, true, 0);
			dialBitmapdata.copyPixels(bitmapData, new Rectangle(0, 0, bitmapData.height, bitmapData.height), new Point(0, 0), null, null, true)
			dial = new Bitmap(dialBitmapdata);
			
			var needleBitmapdata:BitmapData = new BitmapData(bitmapData.width - bitmapData.height - 1, bitmapData.height, true, 0);
			needleBitmapdata.copyPixels(bitmapData, new Rectangle(bitmapData.height + 1, 0, bitmapData.width - bitmapData.height - 1, bitmapData.height), new Point(0, 0), null, null, true);
			needle = new Bitmap(needleBitmapdata);
			needle.x = -needle.width * 0.5;
			needle.y = -needle.height * 0.5;
			
			addChild(dial)
			axis = new Sprite();
			axis.addChild(needle);
			addChild(axis);
			
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true );
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			saladoPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			handleResize();
		}
		
		private function enterFrameHandler(event:Event):void{
			axis.rotationZ = saladoPlayer.manager._pan + currentDirection;
		}
		
		private function handleResize(e:Event = null):void {
			if (compassData.settings.align.horizontal == Align.LEFT) {
				dial.x = 0;
			}else if (compassData.settings.align.horizontal == Align.RIGHT) {
				dial.x = saladoPlayer.manager.boundsWidth - dial.width;
			}else { // CENTER
				dial.x = (saladoPlayer.manager.boundsWidth - dial.width) * 0.5;
			}
			if (compassData.settings.align.vertical == Align.TOP){
				dial.y = 0;
			}else if (compassData.settings.align.vertical == Align.BOTTOM) {
				dial.y = saladoPlayer.manager.boundsHeight - dial.height;
			}else { // MIDDLE
				dial.y = (saladoPlayer.manager.boundsHeight - dial.height) * 0.5;
			}
			dial.x += compassData.settings.move.horizontal;
			dial.y += compassData.settings.move.vertical;
			
			axis.x = dial.x + dial.width * 0.5;
			axis.y = dial.y + dial.height * 0.5;
		}
	}
}