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
		
		private var infoBubbleData:InfoBubbleData 
		
		private var bubbleContainer:Sprite
		private var bubbleImageLoader:Loader;
		
		public function InfoBubble(){
			super("InfoBubble", 0.1, "Marek Standio", "mstandio@o2.pl", "http://panozona.com/wiki/Module:InfoBubble");
			aboutThisModule = "Module for displaying image-based information on variours events.";
			
			moduleDescription.addFunctionDescription("showBubble", String);
			moduleDescription.addFunctionDescription("hideBubble");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {			
			infoBubbleData = new InfoBubbleData(moduleData, debugMode); // allways first
			
			bubbleContainer = new Sprite();
			bubbleContainer.visible = false;
			bubbleContainer.mouseEnabled = false;
			bubbleContainer.mouseChildren = false;
			addChild(bubbleContainer);
			
			bubbleImageLoader = new Loader();
			bubbleImageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, bubbleImageLost, false, 0 , true);
			bubbleImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bubbleImageLoaded, false, 0 , true);
		}
		
		private function bubbleImageLost(error:IOErrorEvent):void {
			printError(error.toString());
		}
		
		private function bubbleImageLoaded(e:Event):void {
			bubbleContainer.addChild(bubbleImageLoader);
			stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
			bubbleContainer.x = mouseX
			bubbleContainer.y = mouseY;
			bubbleContainer.visible = true;
		}
		
		private function handleEnterFrame(e:Event):void {
			bubbleContainer.x = mouseX
			bubbleContainer.y = mouseY;
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function showBubble(bubbleId:String):void{
			for each (var bubble:Bubble in infoBubbleData.bubbles.getChildrenOfGivenClass(Bubble)) {
				if (bubble.id == bubbleId) {
					bubbleImageLoader.load(new URLRequest(bubble.path));
					return;
				}
			}
			printWarning("Could not find bubble: "+bubbleId);
		}
		
		public function hideBubble():void {
			bubbleContainer.visible = false;
			while (bubbleContainer.numChildren) {
				bubbleContainer.removeChildAt(0);
			}
			stage.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
	}
}