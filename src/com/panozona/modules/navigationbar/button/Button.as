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
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class Button extends Sprite{
				
		private var plain:Class;
		private var over:Class;
		private var press:Class;
		
		private var active:Boolean;
		private var mouseOver:Boolean;
		
		private var masterMouseDown:Function;
		private var masterMouseUp:Function;
		
		private var buttonBitmap:Bitmap;
		
		public function Button(masterMouseDown:Function = null, masterMouseUp:Function = null) {
			this.masterMouseDown = masterMouseDown;
			this.masterMouseUp = masterMouseUp;			
			buttonMode = true;			
			active = false;
			mouseOver = false;
		}		
		
		public function setBitmaps(plain:Class, over:Class = null, press:Class = null):void {
			this.plain = plain;
			this.over = over;
			this.press = press;
			
			replace(plain);
			
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
			if (over != null){
				addEventListener(MouseEvent.MOUSE_OVER, ButtonMouseOver, false, 0, true);
				addEventListener(MouseEvent.MOUSE_OUT, ButtonMouseOut, false, 0, true);
			}			
			if (press != null){
				addEventListener(MouseEvent.MOUSE_DOWN, ButtonMouseDown, false, 0, true);
				addEventListener(MouseEvent.MOUSE_UP, ButtonMouseUp, false, 0, true);
				if(over == null){
					addEventListener(MouseEvent.MOUSE_OUT, ButtonMouseOut, false, 0, true);
				}
			}			
		}			
		
		public function setActive(state:Boolean):void {
			active = state;
			if (state) {
				if (over != null && press == null) {
					replace(over);
				}else if (press != null) {
					replace(press);
				}
			}else {
				if (mouseOver) {
					replace(over);
				}else {
					replace(plain);
				}
			}
		}
		
		private function ButtonMouseOver(e:Event = null):void {
			mouseOver = true;
			if(!active){
				replace(over);
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
				if(over!=null){
					replace(over);
				}else {
					replace(plain);
				}
			}
		}		
		
		private function replace(bitmap:Class):void {
			if (buttonBitmap != null) {
				buttonBitmap.bitmapData = null;
			}			
			buttonBitmap = new Bitmap(new bitmap().bitmapData, "auto", true);
			addChild(buttonBitmap);
		}
	}
}