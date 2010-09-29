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
package com.panozona.modules.viewfinder{
	
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.PositionMargin;
	import com.panozona.player.module.data.PositionAlign;
	
	import com.panozona.modules.viewfinder.data.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class ViewFinder extends Module {
		
		private var txtOutput:TextField;
		private var txtFormat:TextFormat;
		private var box:Sprite;
		private var pointer:Sprite;
						
		private var viewFinderData:ViewFinderData;
		
		public function ViewFinder() {
			super("ViewFinder", 0.3, "Marek Standio", "mstandio@o2.pl", "http://panozona.com/wiki/Module:ViewFinder");
			aboutThisModule = 
			"This module shows pan, tilt and field of view of current view, marked as a dot in the middle of the screen." +
			" Module is usefull i.e. for determining position of hotspots during configuration process.";
		}
		
		override protected function moduleReady():void {
			
			viewFinderData = new ViewFinderData(moduleData,debugMode); // allways first
			
			pointer = new Sprite();
			pointer.graphics.beginFill(0x000000); 
			pointer.graphics.drawCircle(0, 0, 3);
			pointer.graphics.endFill();
			pointer.graphics.beginFill(0xffffff); 
			pointer.graphics.drawCircle(0, 0, 2);
			pointer.graphics.endFill();
			pointer.mouseEnabled = false;
			pointer.mouseChildren = false;
			addChild(pointer);
			
			txtFormat = new TextFormat();
			txtFormat.size = 10;
			txtFormat.color = "0xffffff"
			txtFormat.blockIndent = 0;
			txtFormat.font = "Courier";
			
			box = new Sprite();
			box.graphics.beginFill(0x000000);
			box.graphics.drawRect(0, 0, 100, 45);
			box.graphics.endFill();
			addChild(box);
			
			txtOutput = new TextField();
			txtOutput.selectable = false;
			txtOutput.defaultTextFormat = txtFormat;
			txtOutput.height = 45;
			txtOutput.width = 100;
			box.addChild(txtOutput);
			
			stage.addEventListener(Event.RESIZE, handleStageResize, false, 0, true);
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true );
			handleStageResize();
		}
		
		
		private function enterFrameHandler(event:Event):void {
			txtOutput.text = "pan  " + validatePan(saladoPlayer.manager._pan).toFixed(2) + 
			"\ntilt " + saladoPlayer.manager._tilt.toFixed(2) + 
			"\nfov  " + saladoPlayer.manager._fieldOfView.toFixed(2);
		}
	
		private function validatePan(pan:Number):Number {
			return - (pan - Math.round(pan / 360) * 360); 
		}
		
		private function handleStageResize(e:Event = null):void {
			
			if (viewFinderData.settings.align.horizontal == PositionAlign.RIGHT) {
				box.x = boundsWidth - box.width;
			}else if (viewFinderData.settings.align.horizontal == PositionAlign.LEFT) {
				box.x = 0;
			}else if (viewFinderData.settings.align.horizontal == PositionAlign.CENTER) {
				box.x = (boundsWidth - box.width) * 0.5;				
			}
			if (viewFinderData.settings.align.vertical == PositionAlign.BOTTOM) {
				box.y = boundsHeight - box.height;
			}else if (viewFinderData.settings.align.vertical == PositionAlign.TOP) {
				box.y = 0;
			}else if (viewFinderData.settings.align.vertical == PositionAlign.MIDDLE) {
				box.y = (boundsHeight - box.height) * 0.5;
			}
			
			box.x += viewFinderData.settings.margin.left;
			box.x -= viewFinderData.settings.margin.right;
			box.y += viewFinderData.settings.margin.top;			
			box.y -= viewFinderData.settings.margin.bottom;					
			
			pointer.x = (boundsWidth - pointer.width) * 0.5;
			pointer.y = (boundsHeight - pointer.height) * 0.5;
		}
	}
}