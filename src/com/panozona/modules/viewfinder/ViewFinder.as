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
package com.panozona.modules.viewfinder{
	
	import com.panozona.modules.viewfinder.data.*;
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	import com.panozona.player.module.data.property.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	/**
	 * ViewFinder, SaladoPlayer module for displaying camera pan tilt and field of view.
	 * see <http://panozona.com/wiki/Module:ViewFinder>
	 */
	public class ViewFinder extends Module {
		
		private var txtOutput:TextField;
		private var txtFormat:TextFormat;
		private var pointer:Sprite;
		
		private var viewFinderData:ViewFinderData;
		
		/**
		 * Sets module name and version. Name is used 
		 * to obtain configuration data for given module
		 */
		public function ViewFinder():void{
			super("ViewFinder", "1.0");
		}
		
		/**
		 * Module entry point. Function is called in constructor of parent class. 
		 * Builds display objects, adds RESIZE and ENTER_FRAME listeners.
		 * 
		 * @param	moduleData Structure containing module configuration data.
		 */
		override protected function moduleReady(moduleData:ModuleData):void {
			
			viewFinderData = new ViewFinderData(moduleData, saladoPlayer.managerData.debugMode); // always first
			
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
			txtOutput.autoSize = TextFieldAutoSize.LEFT
			addChild(txtOutput);
			
			stage.addEventListener(Event.RESIZE, handleStageResize, false, 0, true);
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true );
			handleStageResize();
		}
		
		private function enterFrameHandler(event:Event):void {
			txtOutput.text = "pan  " + saladoPlayer.manager._pan.toFixed(2) + 
			"\ntilt " + saladoPlayer.manager._tilt.toFixed(2) + 
			"\nfov  " + saladoPlayer.manager._fieldOfView.toFixed(2);
		}
		
		private function handleStageResize(e:Event = null):void {
			if (viewFinderData.settings.align.horizontal == Align.LEFT) {
				txtOutput.x = 0;
			}else if (viewFinderData.settings.align.horizontal == Align.RIGHT) {
				txtOutput.x = saladoPlayer.manager.boundsWidth - txtOutput.width;
			}else { // CENTER
				txtOutput.x = (saladoPlayer.manager.boundsWidth - txtOutput.width) * 0.5;
			}
			if (viewFinderData.settings.align.vertical == Align.TOP){
				txtOutput.y = 0;
			}else if (viewFinderData.settings.align.vertical == Align.BOTTOM) {
				txtOutput.y = saladoPlayer.manager.boundsHeight - txtOutput.height;
			}else { // MIDDLE
				txtOutput.y = (saladoPlayer.manager.boundsHeight - txtOutput.height) * 0.5;
			}
			txtOutput.x += viewFinderData.settings.move.horizontal;
			txtOutput.y += viewFinderData.settings.move.vertical;
			
			pointer.x = (saladoPlayer.manager.boundsWidth - pointer.width) * 0.5;
			pointer.y = (saladoPlayer.manager.boundsHeight - pointer.height) * 0.5;
		}
	}
}
