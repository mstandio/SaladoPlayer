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
package com.panozona.modules.navigationbar.button {
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class BitmapButton extends Sprite {
		
		public var buttonName:String;
		
		private var plain:BitmapData;
		private var press:BitmapData;
		
		private var active:Boolean;
		private var mouseOver:Boolean;
		
		private var masterMouseDown:Function;
		private var masterMouseUp:Function;
		
		private var buttonBitmap:Bitmap;
		
		public function BitmapButton(buttonName:String, masterMouseDown:Function = null, masterMouseUp:Function = null) {
			this.buttonName = buttonName;
			this.masterMouseDown = masterMouseDown;
			this.masterMouseUp = masterMouseUp;
			buttonMode = true;
			active = false;
			mouseOver = false;
		}
		
		public function setBitmaps(plain:BitmapData, press:BitmapData = null):void {
			this.plain = plain;
			this.press = press;
			
			if(active){
				replace(press);
			}else {
				replace(plain);
			}
			
			// adding essential functionality
			if (masterMouseDown != null && masterMouseUp != null) {
				addEventListener(MouseEvent.MOUSE_DOWN, masterMouseDown, false, 0, true);
				addEventListener(MouseEvent.MOUSE_UP, masterMouseUp, false, 0, true);
				addEventListener(MouseEvent.MOUSE_OUT, masterMouseUp, false, 0, true);
			}else if (masterMouseDown != null && masterMouseUp == null) {	
				addEventListener(MouseEvent.MOUSE_DOWN, masterMouseDown, false, 0, true);
			}else if (masterMouseDown == null && masterMouseUp != null) {
				addEventListener(MouseEvent.MOUSE_UP, masterMouseUp, false, 0, true);
			}
			
			// adding animations
			if (press != null){
				addEventListener(MouseEvent.MOUSE_DOWN, ButtonMouseDown, false, 0, true);
				addEventListener(MouseEvent.MOUSE_UP, ButtonMouseUp, false, 0, true);
				addEventListener(MouseEvent.MOUSE_OUT, ButtonMouseOut, false, 0, true);
			}
		}
		
		public function setActive(state:Boolean):void {
			active = state;
			if (state) {
				if (press != null) replace(press);
			}else {
				if(plain != null) replace(plain);
			}
		}
		
		private function ButtonMouseOut(e:Event = null):void {
			mouseOver = false;
			if(!active){
				replace(plain);
			}
		}
		
		private function ButtonMouseDown(e:Event = null):void {
			if(!active){
				replace(press);
			}
		}	
		
		private function ButtonMouseUp(e:Event = null):void {
			if(!active){
				replace(plain);
			}
		}
		
		private function replace(bitmapData:BitmapData):void {
			if (buttonBitmap != null) {
				buttonBitmap.bitmapData = null;
			}
			buttonBitmap = new Bitmap(bitmapData);
			addChild(buttonBitmap);
		}
	}
}