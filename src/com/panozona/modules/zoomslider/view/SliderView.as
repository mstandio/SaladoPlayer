/*
Copyright 2012 Marek Standio.

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
package com.panozona.modules.zoomslider.view {
	
	import com.panozona.modules.zoomslider.model.SliderData;
	import com.panozona.modules.zoomslider.model.ZoomSliderData;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SliderView extends Sprite{
		
		public const pointer:Sprite = new Sprite();
		public const bar:Sprite = new Sprite();
		
		private var zoomIn:Bitmap;
		private var zoomOut:Bitmap;
		
		private var zoomInPlainBD:BitmapData;
		private var zoomOutPlainBD:BitmapData;
		private var zoomInActiveBD:BitmapData;
		private var zoomOutActiveBD:BitmapData;
		private var barBD:BitmapData;
		private var pointerBD:BitmapData;
		
		private var zoomInButton:Sprite;
		private var zoomOutButton:Sprite;
		
		private var _zoomSliderData:ZoomSliderData;
		
		public function SliderView(zoomSliderData:ZoomSliderData) {
			_zoomSliderData = zoomSliderData;
		}
		
		public function build(
			zoomInPlainBD:BitmapData, zoomOutPlainBD:BitmapData,
			zoomInActiveBD:BitmapData, zoomOutActiveBD:BitmapData,
			barBD:BitmapData, pointerBD:BitmapData):void {
			
			this.zoomInPlainBD = zoomInPlainBD;
			this.zoomOutPlainBD = zoomOutPlainBD;
			this.zoomInActiveBD = zoomInActiveBD;
			this.zoomOutActiveBD = zoomOutActiveBD;
			this.barBD = barBD;
			this.pointerBD = pointerBD;
			
			addChild(bar);
			bar.addEventListener(MouseEvent.MOUSE_DOWN, leadStart, false, 0, true);
			bar.addEventListener(MouseEvent.MOUSE_UP, leadStop, false, 0, true);
			bar.addEventListener(MouseEvent.ROLL_OUT, leadStop, false, 0, true);
			
			pointer.addChild(new Bitmap(pointerBD));
			pointer.addEventListener(MouseEvent.MOUSE_DOWN, dragStart, false, 0, true);
			pointer.addEventListener(MouseEvent.MOUSE_UP, dragStop, false, 0, true);
			pointer.addEventListener(MouseEvent.ROLL_OVER, leadStop, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, dragStop, false, 0, true);
			bar.addChild(pointer);
			
			zoomIn = new Bitmap(this.zoomInPlainBD);
			zoomInButton = new Sprite();
			zoomInButton.addChild(zoomIn);
			zoomInButton.buttonMode = true;
			
			addChild(zoomInButton);
			zoomInButton.addEventListener(MouseEvent.MOUSE_DOWN, navZoomIn, false, 0, true);
			zoomInButton.addEventListener(MouseEvent.MOUSE_UP, navZoomStop, false, 0, true);
			zoomInButton.addEventListener(MouseEvent.ROLL_OUT, navZoomStop, false, 0, true);
			
			zoomOut = new Bitmap(this.zoomOutPlainBD);
			zoomOutButton = new Sprite();
			zoomOutButton.addChild(zoomOut);
			zoomOutButton.buttonMode = true;
			
			addChild(zoomOutButton);
			zoomOutButton.addEventListener(MouseEvent.MOUSE_DOWN, navZoomOut, false, 0, true);
			zoomOutButton.addEventListener(MouseEvent.MOUSE_UP, navZoomStop, false, 0, true);
			zoomOutButton.addEventListener(MouseEvent.ROLL_OUT, navZoomStop, false, 0, true);
			
			draw();
		}
		
		public function draw():void {
			var length:Number = _zoomSliderData.sliderData.slider.slidesVertical 
				? _zoomSliderData.windowData.currentSize.height
				: _zoomSliderData.windowData.currentSize.width;
			
			bar.graphics.clear();
			bar.graphics.beginBitmapFill(barBD, null, true);
			bar.graphics.drawRect(
				0,
				0,
				barBD.width,
				length - (zoomInPlainBD.height + zoomOutPlainBD.height) * 0.5);
			bar.graphics.endFill();
			bar.y = zoomInPlainBD.height * 0.5;
			
			zoomInButton.y = 0;
			zoomOutButton.y = bar.y + length - zoomInPlainBD.height * 0.5 - zoomOutPlainBD.height;
			
			if (!_zoomSliderData.sliderData.slider.slidesVertical) {
				x = length;
				rotation = 90;
				zoomInButton.y += zoomInButton.height;
				zoomInButton.rotation = -90;
				zoomOutButton.y += zoomOutButton.height;
				zoomOutButton.rotation = -90;
			}
		}
		
		public function get zoomSliderData():ZoomSliderData {
			return _zoomSliderData;
		}
		
		public function get sliderData():SliderData {
			return _zoomSliderData.sliderData;
		}
		
		public function showZoomIn():void {
			zoomIn.bitmapData = zoomInActiveBD;
		}
		
		public function showZoomOut():void {
			zoomOut.bitmapData = zoomOutActiveBD;
		}
		
		public function showZoomStop():void {
			zoomOut.bitmapData = zoomOutPlainBD;
			zoomIn.bitmapData = zoomInPlainBD;
		}
		
		private function navZoomIn(e:Event):void {
			_zoomSliderData.sliderData.zoomIn = true;
		}
		
		private function navZoomOut(e:Event):void {
			_zoomSliderData.sliderData.zoomOut = true;
		}
		
		private function navZoomStop(e:Event):void {
			_zoomSliderData.sliderData.zoomIn = false;
			_zoomSliderData.sliderData.zoomOut = false;
		}
		
		private function dragStart(e:Event):void {
			_zoomSliderData.sliderData.mouseDrag = true;
		}
		
		private function dragStop(e:Event):void {
			_zoomSliderData.sliderData.mouseDrag = false;
		}
		
		private function leadStart(e:Event):void {
			_zoomSliderData.sliderData.barLead = true;
		}
		
		private function leadStop(e:Event):void {
			_zoomSliderData.sliderData.barLead = false;
		}
	}
}