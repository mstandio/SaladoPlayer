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
package com.panozona.modules.zoomslider.controller {
	
	import com.panozona.modules.zoomslider.view.SliderView;
	import com.panozona.player.module.data.property.Size;
	import com.panozona.player.module.Module;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	public class SliderController {
		
		private var _sliderView:SliderView;
		private var _module:Module;
		
		public function SliderController(sliderView:SliderView, module:Module) {
			_sliderView = sliderView;
			_module = module;
			
			var elementsLoader:Loader = new Loader();
			elementsLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, elementsImageLost, false, 0, true);
			elementsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, elementsImageLoaded, false, 0, true);
			elementsLoader.load(new URLRequest(_sliderView.sliderData.slider.path));
		}
		
		private function elementsImageLost(e:IOErrorEvent):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, elementsImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, elementsImageLoaded);
			_module.printError(e.text);
		}
		
		private function elementsImageLoaded(e:Event):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, elementsImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, elementsImageLoaded);
			var gridBitmapData:BitmapData = new BitmapData((e.target as LoaderInfo).width, (e.target as LoaderInfo).height, true, 0);
			gridBitmapData.draw((e.target as LoaderInfo).content);
			
			
			var cellWidth:Number = Math.ceil((gridBitmapData.width - 2) / 3);
			var cellHeight:Number = Math.ceil((gridBitmapData.height - 1) / 2);
			
			if (_sliderView.sliderData.slider.slidesVertical) {
				_sliderView.zoomSliderData.windowData.size = new Size(cellWidth, cellHeight + _sliderView.sliderData.slider.length);
			}else {
				_sliderView.zoomSliderData.windowData.size = new Size(cellHeight + _sliderView.sliderData.slider.length, cellWidth);
			}
			
			var zoomInPlainBD:BitmapData = new BitmapData(cellWidth, cellHeight, true, 0);
			zoomInPlainBD.copyPixels(gridBitmapData, new Rectangle(0, 0, cellWidth, cellHeight), new Point(0, 0), null, null, true);
			
			var zoomOutPlainBD:BitmapData = new BitmapData(cellWidth, cellHeight, true, 0);
			zoomOutPlainBD.copyPixels(gridBitmapData, new Rectangle(0, cellHeight + 1, cellWidth, cellHeight), new Point(0, 0), null, null, true);
			
			var zoomInActiveBD:BitmapData = new BitmapData(cellWidth, cellHeight, true, 0);
			zoomInActiveBD.copyPixels(gridBitmapData, new Rectangle(cellWidth + 1, 0, cellWidth, cellHeight), new Point(0, 0), null, null, true);
			
			var zoomOutActiveBD:BitmapData = new BitmapData(cellWidth, cellHeight, true, 0);
			zoomOutActiveBD.copyPixels(gridBitmapData, new Rectangle(cellWidth + 1, cellHeight + 1, cellWidth, cellHeight), new Point(0, 0), null, null, true);
			
			var barBD:BitmapData = new BitmapData(cellWidth, cellHeight, true, 0);
			barBD.copyPixels(gridBitmapData, new Rectangle(cellWidth * 2 + 2, 0, cellWidth, cellHeight), new Point(0, 0), null, null, true);
			
			var pointerBD:BitmapData = new BitmapData(cellWidth, cellHeight, true, 0);
			pointerBD.copyPixels(gridBitmapData, new Rectangle(cellWidth * 2 + 2, cellHeight + 1, cellWidth, cellHeight), new Point(0, 0), null, null, true);
			
			_sliderView.build(
				zoomInPlainBD, zoomOutPlainBD,
				zoomInActiveBD, zoomOutActiveBD,
				barBD, pointerBD);
		}
	}
}