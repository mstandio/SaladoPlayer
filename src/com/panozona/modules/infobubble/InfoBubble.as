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
package com.panozona.modules.infobubble{
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.ModuleData;
	
	import com.panozona.modules.infobubble.data.InfoBubbleData;
	import com.panozona.modules.infobubble.data.structure.Bubble;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class InfoBubble extends Module{
		
		private var infoBubbleData:InfoBubbleData;
		
		private var bubbleContent:Bitmap;
		private var bubbleImageLoader:Loader;
		private var currentBubbleId:String;
		private var isShowing:Boolean;
		
		public function InfoBubble(){
			super("InfoBubble", 0.1, "Marek Standio", "mstandio@o2.pl", "http://panozona.com/wiki/Module:InfoBubble");
			aboutThisModule = "Module for displaying image-based information on variours events.";
			
			moduleDescription.addFunctionDescription("showBubble", String);
			moduleDescription.addFunctionDescription("hideBubble");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			infoBubbleData = new InfoBubbleData(moduleData, debugMode); // allways first
			
			mouseEnabled = false;
			mouseChildren = false;
			
			bubbleContent = new Bitmap();
			bubbleContent.visible = false;
			addChild(bubbleContent);
			
			bubbleImageLoader = new Loader();
			bubbleImageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, bubbleImageLost, false, 0 , true);
			bubbleImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bubbleImageLoaded, false, 0 , true);
		}
		
		private function bubbleImageLost(error:IOErrorEvent):void {
			printWarning(error.toString());
		}
		
		private function bubbleImageLoaded(e:Event):void {
			bubbleContent.bitmapData = Bitmap(bubbleImageLoader.content).bitmapData;
			stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
			handleEnterFrame();
			if(isShowing) bubbleContent.visible = true;
		}
		
		private function handleEnterFrame(e:Event = null):void {			
			if (bubbleContent.width + mouseX + infoBubbleData.settings.cursorDistance > boundsWidth) {
				bubbleContent.x = mouseX - bubbleContent.width - infoBubbleData.settings.cursorDistance;
			}else {
				bubbleContent.x = mouseX + infoBubbleData.settings.cursorDistance;
			}			
			if (mouseY + bubbleContent.height * 0.5 > boundsHeight){
				bubbleContent.y = boundsHeight - bubbleContent.height;
			}else if (mouseY - bubbleContent.height * 0.5 <= 0){
				bubbleContent.y = 0;
			}else {
				bubbleContent.y = mouseY - bubbleContent.height * 0.5;
			}
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function showBubble(bubbleId:String):void {
			isShowing = true;
			if (currentBubbleId == bubbleId) {
				stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
				bubbleContent.visible = true;
				return;
			}
			for each (var bubble:Bubble in infoBubbleData.bubbles.getChildrenOfGivenClass(Bubble)) {
				if (bubble.id == bubbleId) {
					bubbleImageLoader.load(new URLRequest(bubble.path));
					currentBubbleId = bubbleId;
					return;
				}
			}
			printWarning("Could not find bubble: "+bubbleId);
		}
		
		public function hideBubble():void {
			isShowing = false;
			bubbleContent.visible = false;
			stage.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
	}
}