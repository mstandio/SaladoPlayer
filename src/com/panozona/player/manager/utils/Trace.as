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
package com.panozona.player.manager.utils {
	
	import com.panosalado.events.*;
	import com.panozona.player.*;
	import com.panozona.player.manager.data.global.*;
	import com.panozona.player.module.data.property.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	
	public class Trace extends Sprite {
		
		private var output:TextField;
		private var buffer:String;
		private var styleSheet:StyleSheet;
		
		private var window:Sprite;
		private var btnOpen:Sprite;
		private var btnClose:Sprite;
		private var btnScrollUp:Sprite;
		private var btnScrollDown:Sprite;
		
		private var traceData:TraceData;
		private var debugMode:Boolean = true;
		
		private var saladoPlayer:SaladoPlayer;
		
		private static var __instance:Trace;
		
		public static function get instance():Trace {
			if (__instance == null) __instance = new Trace();
			return __instance;
		}
		
		public function Trace() {
			if (__instance != null) throw new Error("Trace is a singleton class; please access the single instance with Trace.instance.");
			
			buffer = "";
			
			window = new Sprite();
			window.visible = false;
			btnOpen = new Sprite();
			btnOpen.visible = false;
			
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}
		
		private function stageReady(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			
			saladoPlayer = (this.parent as SaladoPlayer);
			
			traceData = saladoPlayer.managerData.traceData;
			debugMode = saladoPlayer.managerData.debugMode;
			
			if (!debugMode){
				buffer = "";
				return;
			}else {
				if (isNaN(traceData.size.width)  || traceData.size.width  < 100) traceData.size.width = 100;
				if (isNaN(traceData.size.height) || traceData.size.height < 50) traceData.size.height = 50;
			}
			
			var btnSize:Number = 20;
			
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = "Courier"
			txtFormat.color = 0xffffff;
			
			// btnOpen
			var label:TextField = new TextField();
			label.mouseEnabled = false;
			label.defaultTextFormat = txtFormat;
			label.text = "[trace]";
			label.autoSize = TextFieldAutoSize.LEFT;
			btnOpen.addChild(label);
			btnOpen.graphics.beginFill(0x000000);
			btnOpen.graphics.drawRect(0,0,label.width,label.height+2);
			btnOpen.graphics.endFill();
			btnOpen.addEventListener(MouseEvent.CLICK, showWindow, false, 0, true);
			btnOpen.buttonMode = true;
			if (!btnOpen.visible && !traceData.open) {
				btnOpen.visible = true;
			}
			addChild(btnOpen);
			
			// window
			window.graphics.beginFill(0x000000);
			window.graphics.drawRect(0, 0, traceData.size.width, traceData.size.height);
			window.graphics.endFill();
			if (!window.visible && traceData.open) {
				window.visible = true;
			}
			addChild(window);
			
			// stylesheet
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
			var styleLink:Object = new Object();
			styleLink.color = "#0000FF";
			styleLink.fontFamily = "mono";
			styleLink.fontSize = 11;
			styleSheet = new StyleSheet();
			styleSheet.setStyle(".line", styleLine);
			styleSheet.setStyle(".error", styleError);
			styleSheet.setStyle(".warning", styleWarning);
			styleSheet.setStyle(".info", styleInfo);
			styleSheet.setStyle(".link", styleLink);
			
			// window textfield
			output = new TextField();
			output.alwaysShowSelection = true;
			output.wordWrap = true;
			output.multiline = true;
			output.width = traceData.size.width - btnSize;
			output.height = traceData.size.height;
			output.styleSheet = styleSheet;
			output.htmlText += buffer;
			buffer = "";
			output.scrollV = output.maxScrollV;
			output.addEventListener(TextEvent.LINK, onLinkClicked);
			window.addChild(output);
			
			// window close button
			btnClose = new Sprite();
			btnClose.graphics.beginFill(0x000000);
			btnClose.graphics.drawRect(0,0,btnSize,btnSize);
			btnClose.graphics.endFill();
			btnClose.graphics.lineStyle(2, 0xffffff);
			btnClose.graphics.moveTo(btnSize/3, btnSize/3);
			btnClose.graphics.lineTo(btnSize*0.66, btnSize*0.66);
			btnClose.graphics.moveTo(btnSize/3, btnSize*0.66);
			btnClose.graphics.lineTo(btnSize * 0.66, btnSize / 3);
			btnClose.addEventListener(MouseEvent.CLICK, hideWindow, false, 0, true);
			btnClose.buttonMode = true;
			window.addChild(btnClose);
			btnClose.x = traceData.size.width-btnSize - 1;
			btnClose.y = 1;
			
			// window scroll up button
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
			window.addChild(btnScrollUp);
			btnScrollUp.x = traceData.size.width - btnSize - 1;
			btnScrollUp.y = btnSize;
			
			// window scroll down button
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
			window.addChild(btnScrollDown);
			btnScrollDown.x = traceData.size.width - btnSize - 1;
			btnScrollDown.y = traceData.size.height - btnSize - 1;
			
			saladoPlayer.manager.addEventListener(ViewEvent.BOUNDS_CHANGED, handleResize ,false, 0, true);
			handleResize();
		}
		
		public function printError(message:String):void {
			if(debugMode){
				var htmlMessage:String = "<span class=\"line\">&gt;</span><span class=\"error\">" + message + "</span><br/>";
				if (output != null) {
					output.htmlText += htmlMessage;
					countAndTruncate();
					output.scrollV = output.maxScrollV;
				}else{
					buffer += htmlMessage;
				}
			}
			showWindow();
		}
		
		public function printWarning(message:String):void {
			if(debugMode){
				var htmlMessage:String = "<span class=\"line\">&gt;</span><span class=\"warning\">" + message + "</span><br/>";
				if (output != null) {
					output.htmlText += htmlMessage;
					countAndTruncate();
					output.scrollV = output.maxScrollV;
				}else{
					buffer += htmlMessage;
				}
			}
			showWindow();
		}
		
		public function printInfo(message:String):void {
			if(debugMode){
				var htmlMessage:String = "<span class=\"line\">&gt;</span><span class=\"info\">" + message + "</span><br/>";
				if (output != null) {
					output.htmlText += htmlMessage;
					countAndTruncate();
					output.scrollV = output.maxScrollV;
				}else{
					buffer += htmlMessage;
				}
			}
		}
		
		public function printLink(url:String, text:String):void {
			if(debugMode){
				var htmlMessage:String = "<span class=\"line\">&gt;</span><span class=\"link\"><a href=\"event:"+url+"\">"+text+"</a></span><br/>";
				if (output != null) {
					output.htmlText += htmlMessage;
					countAndTruncate();
					output.scrollV = output.maxScrollV;
				}else{
					buffer += htmlMessage;
				}
			}
		}
		
		private var lineCount:Number = 0;
		
		private function countAndTruncate():void {
			lineCount++;
			if (lineCount > traceData.lineLimit) {
				var htmlText:String = output.htmlText;
				htmlText = htmlText.substring(htmlText.indexOf("<br/>") + 5);
				htmlText = htmlText.substring(htmlText.indexOf("<br/>") + 5);
				htmlText = htmlText.substring(htmlText.indexOf("<br/>") + 5);
				htmlText = htmlText.substring(htmlText.indexOf("<br/>") + 5);
				htmlText = htmlText.substring(htmlText.indexOf("<br/>") + 5);
				output.htmlText = htmlText;
				lineCount -= 5;
			}
		}
		
		private function onLinkClicked(textEvent:TextEvent):void {
			try {
				navigateToURL(new URLRequest(textEvent.text), "_BANK");
			}catch (error:Error){
				printError("Could not open: " + textEvent.text);
			}
		}
		
		private function hideWindow(e:Event = null):void {
			if(debugMode){
				window.visible = false;
				btnOpen.visible = true;
			}
		}
		
		private function showWindow(e:Event = null):void {
			if(debugMode){
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
		
		private function handleResize(e:Event = null):void {
			if (traceData.align.horizontal == Align.RIGHT) {
				btnOpen.x = saladoPlayer.manager.boundsWidth - btnOpen.width;
				window.x = saladoPlayer.manager.boundsWidth - traceData.size.width;
			}else if (traceData.align.horizontal == Align.LEFT) {
				btnOpen.x = 0;
				window.x = 0;
			}else{ // center
				btnOpen.x = (saladoPlayer.manager.boundsWidth - btnOpen.width)*0.5;
				window.x = (saladoPlayer.manager.boundsWidth - traceData.size.width) * 0.5;
			}
			if (traceData.align.vertical == Align.TOP) {
				btnOpen.y = 0;
				window.y = 0;
			}else if (traceData.align.vertical == Align.BOTTOM) {
				btnOpen.y = saladoPlayer.manager.boundsHeight- btnOpen.height;
				window.y = saladoPlayer.manager.boundsHeight - traceData.size.height;
			}else { // middle
				btnOpen.y = (saladoPlayer.manager.boundsHeight - btnOpen.height)*0.5;
				window.y = (saladoPlayer.manager.boundsHeight - traceData.size.height)*0.5;
			}
			btnOpen.x += traceData.move.horizontal;
			window.x += traceData.move.horizontal;
			btnOpen.y += traceData.move.vertical;
			window.y += traceData.move.vertical;
		}
	}
}