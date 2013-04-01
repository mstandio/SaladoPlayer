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
	
	import com.panozona.modules.viewfinder.data.ViewFinderData;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.Module;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ViewFinder extends Module {
		
		private var txtOutput:TextField;
		private var pointer:Sprite;
		private var viewFinderData:ViewFinderData;
		private var currentDirection:Number = 0;
		
		public function ViewFinder():void{
			super("ViewFinder", "1.3", "http://openpano.org/links/saladoplayer/modules/viewfinder/");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			viewFinderData = new ViewFinderData(moduleData, saladoPlayer); // always first
			
			if(!viewFinderData.settings.useCursor){
				pointer = new Sprite();
				pointer.graphics.beginFill(0x000000);
				pointer.graphics.drawCircle(0, 0, 3);
				pointer.graphics.endFill();
				pointer.graphics.beginFill(0xffffff);
				pointer.graphics.drawCircle(0, 0, 2);
				pointer.graphics.endFill();
				pointer.mouseEnabled = false;
				addChild(pointer);
			}
			
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = "Courier";
			txtFormat.size = 12;
			
			txtOutput = new TextField();
			txtOutput.mouseEnabled = false;
			txtOutput.textColor = 0xffffff;
			txtOutput.background = true;
			txtOutput.backgroundColor = 0x000000;
			txtOutput.defaultTextFormat = txtFormat;
			if (!viewFinderData.settings.showDirection) {
				txtOutput.height = 48;
			}else {
				txtOutput.height = 60;
			}
			txtOutput.width = 105;
			addChild(txtOutput);
			
			if (viewFinderData.settings.showDirection) {
				var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
				saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0, true);
			}
			if (viewFinderData.settings.useCursor) {
				stage.addEventListener(Event.ENTER_FRAME, enterFrameHandlerCursor, false, 0, true);
			}else{
				stage.addEventListener(Event.ENTER_FRAME, enterFrameHandlerDot, false, 0, true);
			}
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			saladoPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			handleResize();
		}
		
		private function onPanoramaStartedLoading(panoramaEvent:Object):void {
			currentDirection = saladoPlayer.manager.currentPanoramaData.direction;
		}
		
		private function enterFrameHandlerDot(event:Event):void {
			if (viewFinderData.settings.showDirection) {
				txtOutput.text = "pan  " + saladoPlayer.manager._pan.toFixed(2) +
				"\ntilt " + saladoPlayer.manager._tilt.toFixed(2) +
				"\nfov  " + saladoPlayer.manager._fieldOfView.toFixed(2) +
				"\ndir  " + validateDir(saladoPlayer.manager.pan + currentDirection).toFixed(2);
			}else{
				txtOutput.text = "pan  " + saladoPlayer.manager._pan.toFixed(2) +
				"\ntilt " + saladoPlayer.manager._tilt.toFixed(2) +
				"\nfov  " + saladoPlayer.manager._fieldOfView.toFixed(2);
			}
		}
		
		private function enterFrameHandlerCursor(event:Event):void {
			if (viewFinderData.settings.showDirection) {
				txtOutput.text = "pan  " + getCursorPan().toFixed(2) +
				"\ntilt " + getCursorTilt().toFixed(2) +
				"\nfov  " + saladoPlayer.manager._fieldOfView.toFixed(2) +
				"\ndir  " + validateDir(getCursorPan() + currentDirection).toFixed(2);
			}else {
				txtOutput.text = "pan  " + getCursorPan().toFixed(2) +
				"\ntilt " + getCursorTilt().toFixed(2) +
				"\nfov  " + saladoPlayer.manager._fieldOfView.toFixed(2);
			}
		}
		
		private function getCursorPan():Number {
			return validatePanTilt( saladoPlayer.manager._pan +
				Math.atan((saladoPlayer.manager.mouseX - saladoPlayer.manager.boundsWidth * 0.5)
				* Math.tan(saladoPlayer.manager.fieldOfView * 0.5 * __toRadians) / (saladoPlayer.manager.boundsWidth * 0.5)) * __toDegrees);
		}
		
		private var verticalFieldOfView:Number
		private function getCursorTilt():Number {
			verticalFieldOfView = __toDegrees * 2 * Math.atan((saladoPlayer.manager.boundsHeight / saladoPlayer.manager.boundsWidth)
				* Math.tan(__toRadians * 0.5 * saladoPlayer.manager.fieldOfView));
			return validatePanTilt( saladoPlayer.manager._tilt -
				Math.atan(( saladoPlayer.manager.mouseY - saladoPlayer.manager.boundsHeight * 0.5)
				* Math.tan(verticalFieldOfView * 0.5 * __toRadians) / (saladoPlayer.manager.boundsHeight * 0.5)) * __toDegrees);
		}
		
		private function validateDir(value:Number):Number {
			if ( value <= 0 || value > 360 ) return ((value + 360) % 360);
			return value;
		}
		
		private function validatePanTilt(value:Number):Number {
			if (value <= -180) value = (((value + 180) % 360) + 180);
			if (value > 180) value = (((value + 180) % 360) - 180);
			return value;
		}
		
		private function handleResize(e:Event = null):void {
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
			
			if(!viewFinderData.settings.useCursor){
				pointer.x = (saladoPlayer.manager.boundsWidth) * 0.5;
				pointer.y = (saladoPlayer.manager.boundsHeight) * 0.5;
			}
		}
		
		private var __toDegrees:Number = 180 / Math.PI;
		private var __toRadians:Number = Math.PI / 180;
	}
}
