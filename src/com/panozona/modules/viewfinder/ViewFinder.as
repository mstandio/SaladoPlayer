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
	
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	
	import com.panozona.modules.viewfinder.data.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ViewFinder, SaladoPlayer module for displaying camera pan tilt and field of view.
	 * @author mstandio
	 */
	public class ViewFinder extends Module {
		
		private var txtOutput:TextField;
		private var txtFormat:TextFormat;
		private var pointer:Sprite;
		
		private var viewFinderData:ViewFinderData;
		
		/**
		 * Constructor
		 * @private
		 */
		public function ViewFinder() {
			super("ViewFinder", 0.4, "Marek Standio", "mstandio@o2.pl", "http://panozona.com/wiki/Module:ViewFinder");
			aboutThisModule = "This module shows pan, tilt and field of view of current camera view, marked as a circle in the middle of panorama window. " +
							  "Module is usefull i.e. for determining position of hotspots during configuration process.";
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			viewFinderData = new ViewFinderData(moduleData, debugMode); // allways first
			
			pointer = new Sprite();
			pointer.graphics.beginFill(0x000000); 
			pointer.graphics.drawCircle(0, 0, 3);
			pointer.graphics.endFill();
			pointer.graphics.beginFill(0xffffff); 
			pointer.graphics.drawCircle(0, 0, 2);
			pointer.graphics.endFill();
			pointer.mouseEnabled = false;
			addChild(pointer);
			
			txtFormat = new TextFormat();
			txtFormat.font = "Courier";
			
			txtOutput = new TextField();
			txtOutput.mouseEnabled = false;
			txtOutput.textColor = 0xffffff;
			txtOutput.background = true;
			txtOutput.backgroundColor = 0x000000;
			txtOutput.defaultTextFormat = txtFormat;
			txtOutput.height = 45;
			txtOutput.width = 100;
			addChild(txtOutput);
			
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
			if ( pan <= -180 ) return (((pan+180)%360)-180);
			return (((pan+180)%360)-180);
		}
		
		private function handleStageResize(e:Event = null):void {
			
			if (viewFinderData.settings.align.horizontal == Align.LEFT) {
				txtOutput.x = 0;
			}else if (viewFinderData.settings.align.horizontal == Align.RIGHT) {
				txtOutput.x = boundsWidth - txtOutput.width;
			}else if (viewFinderData.settings.align.horizontal == Align.CENTER) {
				txtOutput.x = (boundsWidth - txtOutput.width) * 0.5;
			}
			
			if (viewFinderData.settings.align.vertical == Align.TOP){
				txtOutput.y = 0;
			}else if (viewFinderData.settings.align.vertical == Align.MIDDLE) {
				txtOutput.y = (boundsHeight - txtOutput.height) * 0.5;
			}else if (viewFinderData.settings.align.vertical == Align.BOTTOM) {
				txtOutput.y = boundsHeight - txtOutput.height;
			}
			
			txtOutput.x += viewFinderData.settings.move.horizontal;
			txtOutput.y += viewFinderData.settings.move.vertical;
			
			pointer.x = (boundsWidth - pointer.width) * 0.5;
			pointer.y = (boundsHeight - pointer.height) * 0.5;
		}
	}
}