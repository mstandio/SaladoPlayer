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
package org.diystreetview.modules.debugbubble{
	
	import org.diystreetview.modules.debugbubble.data.DebugBubbleData;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class DebugBubble extends Module{
		
		private var debugBubbleData:DebugBubbleData;
		private var currentBubbleId:String;
		private var isShowing:Boolean;
		private var bubbleContent:TextField;
		
		private var LoadPanoramaEventClass:Class;
		
		public function DebugBubble(){
			super("DebugBubble", "1.0", "http://diy-streetview.org");
			
			moduleDescription.addFunctionDescription("showBubble", String);
			moduleDescription.addFunctionDescription("hideBubble");
			moduleDescription.addFunctionDescription("toggleActive");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			debugBubbleData = new DebugBubbleData(moduleData, saladoPlayer); // allways first
			
			LoadPanoramaEventClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			
			saladoPlayer.manager.addEventListener(LoadPanoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0 , true);
			
			mouseEnabled = false;
			mouseChildren = false;
			
			
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = "Courier";
			
			bubbleContent = new TextField();
			bubbleContent.mouseEnabled = false;
			bubbleContent.textColor = 0xffffff;
			bubbleContent.background = true;
			bubbleContent.backgroundColor = 0x000000;
			bubbleContent.defaultTextFormat = txtFormat;
			bubbleContent.autoSize = TextFieldAutoSize.LEFT;
			
			bubbleContent.visible = false;
			addChild(bubbleContent);
		}
		
		private function onPanoramaStartedLoading(loadPanoramaEvent:Object):void {
			
			var DsvActionDataClass:Class = ApplicationDomain.currentDomain.getDefinition("org.diystreetview.player.manager.data.actions.DsvActionData") as Class;
			var FunctionDataClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.data.actions.FunctionData") as Class;
			
			var dsvActionData:Object = new DsvActionDataClass("hide_debug");
			var functionData:Object = new FunctionDataClass("DebugBubble", "hideBubble");
			dsvActionData.functions.push(functionData);
			saladoPlayer.managerData.actionsData.push(dsvActionData);
			
			for each(var hotspotData:Object in saladoPlayer.manager.currentPanoramaData.hotspotsData) {
				dsvActionData = new DsvActionDataClass("debug_"+hotspotData.id);
				functionData = new FunctionDataClass("DebugBubble", "showBubble");
				functionData.args.push(hotspotData.id);
				dsvActionData.functions.push(functionData);
				saladoPlayer.managerData.actionsData.push(dsvActionData);
				
				hotspotData.mouse.onOver = "debug_" + hotspotData.id;
				hotspotData.mouse.onOut = "hide_debug";
			}
			
			//saladoPlayer.manager.removeEventListener(LoadPanoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading);
			//if (debugBubbleData.settings.active) {
			//	saladoPlayer.manager.runAction(debugBubbleData.settings.onActivate);
			//}else {
			//	saladoPlayer.manager.runAction(debugBubbleData.settings.onDisactivate);
			//}
		}
		
		private function handleEnterFrame(e:Event = null):void {
			if (bubbleContent.width + mouseX + debugBubbleData.settings.cursorDistance > saladoPlayer.manager.boundsWidth) {
				bubbleContent.x = mouseX - bubbleContent.width - debugBubbleData.settings.cursorDistance;
			}else {
				bubbleContent.x = mouseX + debugBubbleData.settings.cursorDistance;
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
		
		public function showBubble(hotspotId:String):void {
			
			if (!debugBubbleData.settings.active) return;
			
			isShowing = true;
			if (currentBubbleId == hotspotId) {
				stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
				bubbleContent.visible = true;
				return;
			}
			var hotspotData:Object;
			for each(var data:Object in saladoPlayer.manager.currentPanoramaData.hotspotsData) {
				if (data.id == hotspotId) {
					hotspotData = data;
					break;
				}
			}
			if(hotspotData != null){
				bubbleContent.text =  "lat  " + hotspotData.gps.latitude + "\n" +
									  "lon  " + hotspotData.gps.longitude + "\n" +
									  "alt  " + hotspotData.gps.elevation + "\n" +
									  "path " + hotspotData.targetFile;
			}else {
				bubbleContent.text = "no hotspot found: " + hotspotId; 
			}
			stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
			handleEnterFrame();
			if(isShowing) bubbleContent.visible = true;
		}
		
		public function hideBubble():void {
			isShowing = false;
			bubbleContent.visible = false;
			stage.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		public function toggleActive():void {
			if (debugBubbleData.settings.active) {
				debugBubbleData.settings.active = false;
				saladoPlayer.manager.runAction(debugBubbleData.settings.onDisactivate);
			}else {
				debugBubbleData.settings.active = true;
				saladoPlayer.manager.runAction(debugBubbleData.settings.onActivate);
			}
		}
	}
}