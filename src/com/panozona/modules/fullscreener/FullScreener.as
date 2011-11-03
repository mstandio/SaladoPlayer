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
package com.panozona.modules.fullscreener{
	
	import com.panozona.modules.fullscreener.data.FullScreenerData;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.Module;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.display.StageDisplayState;
	
	public class FullScreener extends Module {
		
		private var button:Sprite;
		private var buttonBitmap:Bitmap;
		
		private var bitmapDataOffPlain:BitmapData;
		private var bitmapDataOffActive:BitmapData;
		private var bitmapDataOnPlain:BitmapData;
		private var bitmapDataOnActive:BitmapData;
		
		private var mouseOver:Boolean;
		
		private var fullScreenerData:FullScreenerData;
		
		public function FullScreener():void{
			super("FullScreener", "1.0", "http://panozona.com/wiki/Module:FullScreener");
			moduleDescription.addFunctionDescription("setFullScreenOn", Boolean);
			moduleDescription.addFunctionDescription("toggleFullScreenOn");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			fullScreenerData = new FullScreenerData(moduleData, saladoPlayer); // always first
			
			if (fullScreenerData.settings.path == null) {
				visible = false;
				mouseEnabled = false;
			}else{
				var buttonLoader:Loader = new Loader();
				buttonLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, buttonImageLost, false, 0, true);
				buttonLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, buttonImageLoaded, false, 0, true);
				buttonLoader.load(new URLRequest(fullScreenerData.settings.path));
			}
		}
		
		private function buttonImageLost(e:IOErrorEvent):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, buttonImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, buttonImageLoaded);
			printError(e.text);
		}
		
		private function buttonImageLoaded(e:Event):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, buttonImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, buttonImageLoaded);
			
			var buttonBitmapData:BitmapData = new BitmapData((e.target as LoaderInfo).width, (e.target as LoaderInfo).height, true, 0);
			buttonBitmapData.draw((e.target as LoaderInfo).content);
			
			var bWidth:Number = Math.ceil((buttonBitmapData.width - 1) / 2);
			var bHeight:Number = Math.ceil((buttonBitmapData.height - 1) / 2);
			
			bitmapDataOffPlain = new BitmapData(bWidth, bHeight, true, 0);
			bitmapDataOffPlain.copyPixels(buttonBitmapData, new Rectangle(0, 0, bWidth, bHeight), new Point(0, 0), null, null, true);
			bitmapDataOffActive = new BitmapData(bWidth, bHeight, true, 0);
			bitmapDataOffActive.copyPixels(buttonBitmapData, new Rectangle(0, bHeight + 1, bWidth, bHeight), new Point(0, 0), null, null, true);
			
			bitmapDataOnPlain = new BitmapData(bWidth, bHeight, true, 0);
			bitmapDataOnPlain.copyPixels(buttonBitmapData, new Rectangle(bWidth + 1, 0, bWidth, bHeight), new Point(0, 0), null, null, true);
			bitmapDataOnActive = new BitmapData(bWidth, bHeight, true, 0);
			bitmapDataOnActive.copyPixels(buttonBitmapData, new Rectangle(bWidth + 1, bHeight + 1, bWidth, bHeight), new Point(0, 0), null, null, true);
			
			buttonBitmap = new Bitmap();
			button = new Sprite();
			button.buttonMode = true;
			button.addChild(buttonBitmap);
			addChild(button);
			
			button.addEventListener(MouseEvent.MOUSE_UP, toggleFullscreen, false, 0, true);
			
			button.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			button.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			button.addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			saladoPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			
			handleResize();
		}
		
		private function onMouseOver(e:Event):void {
			mouseOver = true;
			buildButton();
		}
		
		private function onMouseOut(e:Event):void {
			mouseOver = false;
			buildButton();
		}
		
		private function toggleFullscreen(e:Event = null):void {
			stage.displayState = (stage.displayState == StageDisplayState.NORMAL) ?
				StageDisplayState.FULL_SCREEN :
				StageDisplayState.NORMAL;
			mouseOver = false;
		}
		
		private function buildButton():void {
			if (stage.displayState == StageDisplayState.NORMAL) {
				if (mouseOver) {
					buttonBitmap.bitmapData = bitmapDataOffActive;
				}else {
					buttonBitmap.bitmapData = bitmapDataOffPlain;
				}
			}else {
				if (mouseOver) {
					buttonBitmap.bitmapData = bitmapDataOnActive;
				}else {
					buttonBitmap.bitmapData = bitmapDataOnPlain;
				}
			}
		}
		
		private function handleResize(e:Event = null):void {
			
			buildButton();
			
			if (fullScreenerData.settings.align.horizontal == Align.LEFT) {
				button.x = 0;
			}else if (fullScreenerData.settings.align.horizontal == Align.RIGHT) {
				button.x = saladoPlayer.manager.boundsWidth - button.width;
			}else { // CENTER
				button.x = (saladoPlayer.manager.boundsWidth - button.width) * 0.5;
			}
			if (fullScreenerData.settings.align.vertical == Align.TOP){
				button.y = 0;
			}else if (fullScreenerData.settings.align.vertical == Align.BOTTOM) {
				button.y = saladoPlayer.manager.boundsHeight - button.height;
			}else { // MIDDLE
				button.y = (saladoPlayer.manager.boundsHeight - button.height) * 0.5;
			}
			button.x += fullScreenerData.settings.move.horizontal;
			button.y += fullScreenerData.settings.move.vertical;
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setFullScreenOn(value:Boolean):void {
			if (value && stage.displayState == StageDisplayState.NORMAL || !value && stage.displayState != StageDisplayState.NORMAL) {
				toggleFullscreen();
			}
		}
		
		public function toggleFullScreenOn():void {
			toggleFullscreen();
		}
	}
}
