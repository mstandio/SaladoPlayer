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
package com.panozona.player.manager.utils {

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.StyleSheet;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.panozona.player.manager.data.TraceData;
	import com.panozona.player.SaladoPlayer;

	/**
	 * ...
	 * @author mstandio
	 */
	public class Trace extends Sprite {
		
		private const btnSize:Number = 20;
		
		private var output:TextField;
		private var buffer:String = "";
		private var styleSheet:StyleSheet;
		
		private var window:Sprite
		private var btnOpen:Sprite;
		private var btnClose:Sprite;
		private var btnScrollUp:Sprite;
		private var btnScrollDown:Sprite;
		
		private var traceData:TraceData;
		
		private var debugging:Boolean = true;
		
		private static var __instance:Trace;
		
		public static function get instance():Trace {
			if (__instance == null) {
				__instance = new Trace();
			}
			return __instance;
		}
		
		public function Trace() {
			
			window = new Sprite();
			window.visible = false;
			btnOpen = new Sprite();
			btnOpen.visible = false;
			
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady);
		}
		
		private function stageReady(e:Event = null):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			
			traceData = (this.parent as SaladoPlayer).managerData.traceData;
			debugging = (this.parent as SaladoPlayer).managerData.debugging;
			
			if (!debugging) {
				buffer = "";
				return;
			}else {
				if (isNaN(traceData.width)  || traceData.width  < 100) traceData.width  = 100;
				if (isNaN(traceData.height) || traceData.height < 50) traceData.height = 50
			}
			
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.blockIndent = 0;
			txtFormat.font = "Courier"
			txtFormat.color = 0xffffff;
			
			var label:TextField = new TextField(); 
			label.selectable = false;
			label.mouseEnabled = false;
			label.defaultTextFormat = txtFormat;
			label.text = "[trace]";
			label.autoSize = TextFieldAutoSize.LEFT;
			btnOpen.addChild(label);
			btnOpen.graphics.beginFill(0x000000);
			btnOpen.graphics.drawRect(0,0,label.width,label.height+2);
			btnOpen.graphics.endFill();
			btnOpen.addEventListener(MouseEvent.CLICK, showWindow,false, 0, true);
			btnOpen.buttonMode = true;
			btnOpen.useHandCursor = true;
			addChild(btnOpen);
			if (!btnOpen.visible && !traceData.initialVisibility) {
				btnOpen.visible = true;
			}
			
			// position by handleResize
			window.graphics.beginFill(0x000000);
			window.graphics.drawRect(0, 0, traceData.width, traceData.height);
			window.graphics.endFill();
			if (!window.visible && traceData.initialVisibility) {
				window.visible = true;
			}
			addChild(window);
			// position by handleResize
			
			var styleLine:Object = new Object();
			styleLine.color = "#FFFFFF";
			styleLine.fontFamily = "mono";
			styleLine.fontSize = 11;
			
			var styleError:Object = new Object();
			styleError.color = "#FF0000";
			styleError.fontFamily = "mono";
			styleError.fontSize = 11;
			
			var styleWarning:Object = new Object();
			styleWarning.color = "#FFFF00";
			styleWarning.fontFamily = "mono";
			styleWarning.fontSize = 11;
			
			var styleInfo:Object = new Object();
			styleInfo.color = "#00FF00";
			styleInfo.fontFamily = "mono";
			styleInfo.fontSize = 11;
			
			styleSheet = new StyleSheet();
			styleSheet.setStyle(".line", styleLine);
			styleSheet.setStyle(".error", styleError);
			styleSheet.setStyle(".warning", styleWarning);
			styleSheet.setStyle(".info", styleInfo);
			
			output = new TextField();
			output.alwaysShowSelection = true;
			output.wordWrap = true;
			output.multiline = true;
			output.width = traceData.width-btnSize;
			output.height = traceData.height;
			output.styleSheet = styleSheet;
			output.htmlText += buffer;
			buffer = "";
			output.scrollV = output.maxScrollV;
			window.addChild(output);
			
			btnClose = new Sprite();
			btnClose.graphics.beginFill(0x000000);
			btnClose.graphics.drawRect(0,0,btnSize,btnSize);
			btnClose.graphics.endFill();
			btnClose.graphics.lineStyle(2, 0xffffff);
			btnClose.graphics.moveTo(btnSize/3, btnSize/3);
			btnClose.graphics.lineTo(btnSize*0.66,btnSize*0.66);
			btnClose.graphics.moveTo(btnSize/3, btnSize*0.66);
			btnClose.graphics.lineTo(btnSize * 0.66, btnSize / 3);
			btnClose.addEventListener(MouseEvent.CLICK, hideWindow,false, 0, true);
			btnClose.buttonMode = true;
			btnClose.useHandCursor = true;
			window.addChild(btnClose);
			btnClose.x = traceData.width-btnSize - 1;
			btnClose.y = 1;
			
			btnScrollUp = new Sprite();
			btnScrollUp.graphics.beginFill(0x000000);
			btnScrollUp.graphics.drawRect(0, 0, btnSize, btnSize);
			btnScrollUp.graphics.endFill();
			btnScrollUp.graphics.beginFill(0xffffff);
			btnScrollUp.graphics.moveTo(btnSize / 2, btnSize / 3);
			btnScrollUp.graphics.lineTo(btnSize * 0.66, btnSize * 0.66);
			btnScrollUp.graphics.lineTo(btnSize / 3, btnSize * 0.66 );
			btnScrollUp.graphics.endFill();
			btnScrollUp.addEventListener(MouseEvent.MOUSE_DOWN, scrollUp, false, 0, true);
			btnScrollUp.addEventListener(MouseEvent.MOUSE_UP, scrollStop, false, 0, true);
			btnScrollUp.addEventListener(MouseEvent.MOUSE_OUT, scrollStop, false, 0, true);
			btnScrollUp.buttonMode = true;
			btnScrollUp.useHandCursor = true;
			window.addChild(btnScrollUp);
			btnScrollUp.x = traceData.width - btnSize - 1;
			btnScrollUp.y = btnSize;
			
			btnScrollDown = new Sprite();
			btnScrollDown.graphics.beginFill(0x000000);
			btnScrollDown.graphics.drawRect(0, 0, btnSize, btnSize);
			btnScrollDown.graphics.endFill();
			btnScrollDown.graphics.beginFill(0xffffff);
			btnScrollDown.graphics.moveTo(btnSize / 3, btnSize / 3);
			btnScrollDown.graphics.lineTo(btnSize * 0.66, btnSize / 3);
			btnScrollDown.graphics.lineTo(btnSize / 2, btnSize * 0.66 );
			btnScrollDown.graphics.endFill();
			btnScrollDown.addEventListener(MouseEvent.MOUSE_DOWN, scrollDown, false, 0, true);
			btnScrollDown.addEventListener(MouseEvent.MOUSE_UP, scrollStop, false, 0, true);
			btnScrollDown.addEventListener(MouseEvent.MOUSE_OUT, scrollStop, false, 0, true);
			btnScrollDown.buttonMode = true;
			btnScrollDown.useHandCursor = true;
			window.addChild(btnScrollDown);
			btnScrollDown.x = traceData.width - btnSize - 1;
			btnScrollDown.y = traceData.height - btnSize - 1;
		
			stage.addEventListener(Event.RESIZE, handleStageResize);
			handleStageResize();
		}
		
		public function printError(message:String):void {
			if(debugging){
				var htmMessage:String = "<span class=\"line\">&gt;</span><span class=\"error\">" + message + "</span><br/>";
				if (output != null) {
					output.htmlText += htmMessage;
					output.scrollV = output.maxScrollV;
				}else{
					buffer += htmMessage;
				}
			}
			showWindow();
		}
		
		public function printWarning(message:String):void {
			if(debugging){
				var htmMessage:String = "<span class=\"line\">&gt;</span><span class=\"warning\">" + message + "</span><br/>";
				if (output != null) {
					output.htmlText += htmMessage;
					output.scrollV = output.maxScrollV;
				}else{
					buffer += htmMessage;
				}
			}
			showWindow();
		}
		
		public function printInfo(message:String):void {
			if(debugging){
				var htmMessage:String = "<span class=\"line\">&gt;</span><span class=\"info\">" + message + "</span><br/>";
				if (output != null) {
					output.htmlText += htmMessage;
					output.scrollV = output.maxScrollV;
				}else{
					buffer += htmMessage;
				}
			}
		}		
		
		private function hideWindow(e:Event = null):void {
			window.visible = false;
			btnOpen.visible = true;
		}
		
		private function showWindow(e:Event = null):void {
			if(debugging){
				window.visible = true;
				btnOpen.visible = false;
			}
		}
		
		private function scrollUp(e:Event):void {
			addEventListener(Event.ENTER_FRAME, scrollUpOnEnter, false, 0, true);
		}
		
		private function scrollDown(e:Event):void {
			addEventListener(Event.ENTER_FRAME, scrollDownOnEnter, false, 0, true);
		}
		
		private function scrollUpOnEnter(e:Event):void {
			if (output.scrollV > 0) {
				output.scrollV--;
			}
		}
		
		private function scrollDownOnEnter(e:Event):void {
			if (output.scrollV < output.maxScrollV) {
				output.scrollV++;
			}
		}
		
		private function scrollStop(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, scrollDownOnEnter);
			removeEventListener(Event.ENTER_FRAME, scrollUpOnEnter);
		}
		
		private function handleStageResize(e:Event = null):void {
			
			var boundsWidth:Number = (this.parent as SaladoPlayer).manager.boundsWidth;
			var boundsHeight:Number= (this.parent as SaladoPlayer).manager.boundsHeight;
			
			if (traceData.horizontalAlign == "left") {
				btnOpen.x = 0;
				window.x  = 0;
			}else if (traceData.horizontalAlign == "center") {
				btnOpen.x = (boundsWidth - btnOpen.width)*0.5;
				window.x = (boundsWidth - traceData.width)*0.5;
			}else{ // right
				btnOpen.x = boundsWidth - btnOpen.width;
				window.x = boundsWidth - traceData.width;
			}
			
			if (traceData.verticalAlign == "bottom") {
				btnOpen.y = boundsHeight- btnOpen.height;
				window.y = boundsHeight - traceData.height;
			}else if (traceData.verticalAlign == "middle") {
				btnOpen.y = (boundsHeight - btnOpen.height)*0.5;
				window.y = (boundsHeight - traceData.height)*0.5;
			}else { // top
				btnOpen.y = 0;
				window.y = 0;
			}
		}
	}
}