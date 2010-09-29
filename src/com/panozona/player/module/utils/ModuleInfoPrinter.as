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
package com.panozona.player.module.utils{

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import com.panozona.player.module.data.ModuleDescription;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class ModuleInfoPrinter extends Sprite {
		
		private var moduleDescription:ModuleDescription;
		private var aboutThisModule:String;
		private var moduleInfo:TextField;
		
		public function ModuleInfoPrinter(moduleDescription:ModuleDescription, aboutThisModule:String){
			
			this.moduleDescription = moduleDescription;
			this.aboutThisModule = aboutThisModule;
			
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}
		
		private final function stageReady(e:Event = null):void {
			
			var moduleInfoFormat:TextFormat = new TextFormat(); // TODO: add clickable buttons for urls ect 
			moduleInfoFormat.blockIndent = 0;
			moduleInfoFormat.font = "Courier";
			moduleInfoFormat.color = 0xffffff;
			moduleInfoFormat.leftMargin = 10;
		
			moduleInfo = new TextField();
			moduleInfo.defaultTextFormat = moduleInfoFormat;
			moduleInfo.multiline = true;
			moduleInfo.background = true;
			moduleInfo.backgroundColor = 0x000000;
			moduleInfo.wordWrap = true;
			moduleInfo.width  = 500;
			moduleInfo.height = 300;
			moduleInfo.x = (stage.stageWidth - moduleInfo.width) * 0.5;
			moduleInfo.y = (stage.stageHeight - moduleInfo.height) * 0.5;
			addChild(moduleInfo);
			
			moduleInfo.htmlText += printDescription(aboutThisModule);
			
			var btnSize:Number = 20;
			
			var btnScrollUp:Sprite = new Sprite();
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
			addChild(btnScrollUp);
			btnScrollUp.y = moduleInfo.y + 1;
			btnScrollUp.x = moduleInfo.x + moduleInfo.width - btnSize * 2;
			
			var btnScrollDown:Sprite = new Sprite();
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
			addChild(btnScrollDown);
			btnScrollDown.y = moduleInfo.y + 1;
			btnScrollDown.x = moduleInfo.x+ moduleInfo.width - btnSize;
			
		}
		
		private function scrollUp(e:Event):void {
			addEventListener(Event.ENTER_FRAME, scrollUpOnEnter, false, 0, true);
		}
		
		private function scrollDown(e:Event):void {
			addEventListener(Event.ENTER_FRAME, scrollDownOnEnter, false, 0, true);
		}
		
		private function scrollUpOnEnter(e:Event):void {
			if (moduleInfo.scrollV > 0) {
				moduleInfo.scrollV--;
			}
		}
		
		private function scrollDownOnEnter(e:Event):void {
			if (moduleInfo.scrollV < moduleInfo.maxScrollV) {
				moduleInfo.scrollV++;
			}
		}
		
		private function scrollStop(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, scrollDownOnEnter);
			removeEventListener(Event.ENTER_FRAME, scrollUpOnEnter);
		}
		
		private function printDescription(aboutThisModule:String = null):String{
			var result:String="";
			
			if (moduleDescription.moduleHomeUrl != null) {
				result += "<br><u><font color=\u0022#0000ff\u0022><a href='event:openurl'>" + moduleDescription.moduleName + "</a></font></u>";
				moduleInfo.addEventListener(TextEvent.LINK, onClickAnchor);
			}else {
				result += "<br>"+moduleDescription.moduleName;
			}
			
			result += " v" + (( Number(moduleDescription.moduleVersion.toFixed(1)) == moduleDescription.moduleVersion)?
			moduleDescription.moduleVersion.toFixed(1):moduleDescription.moduleVersion.toFixed(2));
			
			if (moduleDescription.moduleAuthor != null) {
				result += " by ";
				if (moduleDescription.moduleAuthorContact != null) {
					result += "<u><font color=\u0022#0000ff\u0022><a href='event:opencontact'>" + moduleDescription.moduleAuthor + "</a></font></u>";
					moduleInfo.addEventListener(TextEvent.LINK, onClickAnchor);
				}else {
					result += moduleDescription.moduleAuthor;
				}
			}			
			
			if (aboutThisModule != null) {
				result += "<br><br>"+aboutThisModule;
			}
			if(moduleDescription.getFunctionsNames().length > 0){
				result += "<br/><br/>Exposed functions: ";
				for (var functionName:String in moduleDescription.functionsDescription) {
					result += "<br> "+functionName + "(";
					for each(var _class:Class in (moduleDescription.functionsDescription[functionName])) {
						result += (_class===Boolean?"Boolean":(_class===Number?"Number":(_class===String?"String":"Error!")))+ ",";
					}
					if (result.lastIndexOf(",") == result.length-1) {
						result = result.substring(0, result.length - 1);
					}
					result += ")";
				}
				
			}else {
				result += "<br/><br>No exposed functions.";
			}
			
			return result;
		}
		
		private function onClickAnchor(event:TextEvent):void {			
			try {
				if (event.text == "opencontact") {					
					navigateToURL(new URLRequest("mailto:"+moduleDescription.moduleAuthor), '_BLANK');
				}else if (event.text == "openurl") {
					navigateToURL(new URLRequest(moduleDescription.moduleHomeUrl), '_BLANK');
				}				
			} catch (e:Error) {
				moduleInfo.htmlText += "<br><br> Could not open: "+moduleDescription.moduleHomeUrl;
			}
		}		
	}
}