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
package com.panozona.modules.infobubble{
	
	import com.panozona.modules.infobubble.data.InfoBubbleData;
	import com.panozona.modules.infobubble.data.structure.Bubble;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	public class InfoBubble extends Module{
		
		private var infoBubbleData:InfoBubbleData;
		
		private var bubbleContent:Bitmap;
		private var bubbleImageLoader:Loader;
		private var currentBubbleId:String;
		private var isShowing:Boolean;
		
		private var panoramaEventClass:Class;
		
		public function InfoBubble(){
			super("InfoBubble", "1.0", "http://panozona.com/wiki/Module:InfoBubble");
			
			moduleDescription.addFunctionDescription("showBubble", String);
			moduleDescription.addFunctionDescription("hideBubble");
			moduleDescription.addFunctionDescription("toggleActive");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			infoBubbleData = new InfoBubbleData(moduleData, saladoPlayer); // allways first
			
			panoramaEventClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.panoramaEvent") as Class;
			saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0 , true);
			
			mouseEnabled = false;
			mouseChildren = false;
			
			bubbleContent = new Bitmap();
			bubbleContent.visible = false;
			addChild(bubbleContent);
			
			bubbleImageLoader = new Loader();
			bubbleImageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, bubbleImageLost, false, 0 , true);
			bubbleImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bubbleImageLoaded, false, 0 , true);
		}
		
		private function onPanoramaStartedLoading(loadPanoramaEvent:Object):void {
			
			saladoPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading);
			
			if (infoBubbleData.settings.active) {
				saladoPlayer.manager.runAction(infoBubbleData.settings.onActivate);
			}else {
				saladoPlayer.manager.runAction(infoBubbleData.settings.onDisactivate);
			}
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
			if (bubbleContent.width + mouseX + infoBubbleData.settings.cursorDistance > saladoPlayer.manager.boundsWidth) {
				bubbleContent.x = mouseX - bubbleContent.width - infoBubbleData.settings.cursorDistance;
			}else {
				bubbleContent.x = mouseX + infoBubbleData.settings.cursorDistance;
			}
			if (mouseY + bubbleContent.height * 0.5 > saladoPlayer.manager.boundsHeight){
				bubbleContent.y = saladoPlayer.manager.boundsHeight - bubbleContent.height;
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
			
			if (!infoBubbleData.settings.active) return;
			
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
		
		public function toggleActive():void {
			if (infoBubbleData.settings.active) {
				infoBubbleData.settings.active = false;
				saladoPlayer.manager.runAction(infoBubbleData.settings.onDisactivate);
			}else {
				infoBubbleData.settings.active = true;
				saladoPlayer.manager.runAction(infoBubbleData.settings.onActivate);
			}
		}
	}
}