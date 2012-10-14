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
package com.panozona.modules.infobox.controller {
	 
	import com.panozona.modules.infobox.events.ViewerEvent;
	import com.panozona.modules.infobox.events.ScrollBarEvent;
	import com.panozona.modules.infobox.events.WindowEvent;
	import com.panozona.modules.infobox.view.ScrollBarView;
	import com.panozona.player.module.Module;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	public class ScrollBarController {
		
		private var _scrollBarView:ScrollBarView
		private var _module:Module
		
		public function ScrollBarController(scrollBarView:ScrollBarView, module:Module) {
			_scrollBarView = scrollBarView
			_module = module;
			
			_scrollBarView.infoBoxData.viewerData.scrollBarData.addEventListener(ScrollBarEvent.CHANGED_IS_SHOWING, handleIsShowingChange, false, 0, true);
			_scrollBarView.infoBoxData.viewerData.scrollBarData.addEventListener(ScrollBarEvent.CHANGED_MOUSE_DRAG, handleMouseDragChange, false, 0, true);
			
			var elementsLoader:Loader = new Loader();
			elementsLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, elementsImageLost, false, 0, true);
			elementsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, elementsImageLoaded, false, 0, true);
			elementsLoader.load(new URLRequest(_scrollBarView.infoBoxData.viewerData.viewer.path));
		}
		
		public function reset():void {
			_scrollBarView.infoBoxData.viewerData.scrollBarData.scrollValue = 0;
			_scrollBarView.thumb.y = 0;
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
			
			var cellWidth:Number = Math.ceil((gridBitmapData.width - 1) / 2);
			var cellHeight:Number = Math.ceil((gridBitmapData.height - 1) / 2);
			
			var backgroundTrunkBD:BitmapData = new BitmapData(cellWidth, cellHeight, true, 0);
			backgroundTrunkBD.copyPixels(gridBitmapData, new Rectangle(0, 0, cellWidth, cellHeight), new Point(0, 0), null, null, true);
			var backgroundEndingBD:BitmapData = new BitmapData(cellWidth, cellHeight, true, 0);
			backgroundEndingBD.copyPixels(gridBitmapData, new Rectangle(cellWidth + 1, 0, cellWidth, cellHeight), new Point(0, 0), null, null, true);
			var thumbTrunkBD:BitmapData = new BitmapData(cellWidth, cellHeight, true, 0);
			thumbTrunkBD.copyPixels(gridBitmapData, new Rectangle(0, cellHeight + 1, cellWidth, cellHeight), new Point(0, 0), null, null, true);
			var thumbEndingBD:BitmapData = new BitmapData(cellWidth, cellHeight, true, 0);
			thumbEndingBD.copyPixels(gridBitmapData, new Rectangle(cellWidth + 1, cellHeight + 1, cellWidth, cellHeight), new Point(0, 0), null, null, true);
			
			_scrollBarView.build(backgroundTrunkBD, backgroundEndingBD, thumbTrunkBD, thumbEndingBD);
			
			_scrollBarView.infoBoxData.viewerData.scrollBarData.scrollBarWidth = cellWidth;
			_scrollBarView.infoBoxData.viewerData.scrollBarData.minThumbHeight = 2 * cellHeight; 
			
			_scrollBarView.infoBoxData.viewerData.addEventListener(ViewerEvent.CHANGED_TEXT_HEIGHT, handleResize, false, 0, true);
			_scrollBarView.infoBoxData.windowData.addEventListener(WindowEvent.CHANGED_CURRENT_SIZE, handleResize, false, 0, true);
			handleResize();
		}
		
		private function handleResize(event:Event = null):void {
			_scrollBarView.y = _scrollBarView.infoBoxData.viewerData.viewer.padding;
			_scrollBarView.x = _scrollBarView.infoBoxData.windowData.currentSize.width - _scrollBarView.thumb.width;
			if (_scrollBarView.infoBoxData.viewerData.textHeight + _scrollBarView.infoBoxData.viewerData.viewer.padding * 2 >
				_scrollBarView.infoBoxData.windowData.currentSize.height) {
				_scrollBarView.infoBoxData.viewerData.scrollBarData.isShowing = true;
			}else {
				_scrollBarView.infoBoxData.viewerData.scrollBarData.isShowing = false;
			}
			var thumbLength:Number = (_scrollBarView.infoBoxData.windowData.currentSize.height - _scrollBarView.infoBoxData.viewerData.viewer.padding * 2) * 
				(_scrollBarView.infoBoxData.windowData.currentSize.height - _scrollBarView.infoBoxData.viewerData.viewer.padding * 2)
				/ _scrollBarView.infoBoxData.viewerData.textHeight;
				
			if (thumbLength > _scrollBarView.infoBoxData.windowData.currentSize.height - _scrollBarView.infoBoxData.viewerData.viewer.padding * 2) {
				thumbLength = _scrollBarView.infoBoxData.windowData.currentSize.height - _scrollBarView.infoBoxData.viewerData.viewer.padding * 2;
			}else if (thumbLength < _scrollBarView.infoBoxData.viewerData.scrollBarData.minThumbHeight) {
				thumbLength = _scrollBarView.infoBoxData.viewerData.scrollBarData.minThumbHeight;
			}
			_scrollBarView.infoBoxData.viewerData.scrollBarData.thumbLength = thumbLength;
			_scrollBarView.draw();
			onEnterFrame();
		}
		
		private function handleIsShowingChange(event:Event = null):void {
			if (_scrollBarView.infoBoxData.viewerData.scrollBarData.isShowing) {
				_scrollBarView.visible = true;
			}else {
				_scrollBarView.visible = false;
			}
		}
		
		private var thumbMouseY:Number = 0;
		private function handleMouseDragChange(event:Event = null):void {
			if (_scrollBarView.infoBoxData.viewerData.scrollBarData.mouseDrag) {
				thumbMouseY = _scrollBarView.thumb.mouseY;
				_module.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}else {
				thumbMouseY = 0;
				_module.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function onEnterFrame(event:Event = null):void {
			var posY:Number = (_scrollBarView.infoBoxData.viewerData.scrollBarData.mouseDrag ? _scrollBarView.mouseY : 0) - thumbMouseY;
			if (posY < 0) {
				posY = 0;
			}else if (posY > _scrollBarView.infoBoxData.windowData.currentSize.height 
				- _scrollBarView.infoBoxData.viewerData.viewer.padding * 2 - _scrollBarView.infoBoxData.viewerData.scrollBarData.thumbLength) {
				posY = _scrollBarView.infoBoxData.windowData.currentSize.height 
					- _scrollBarView.infoBoxData.viewerData.viewer.padding * 2 - _scrollBarView.infoBoxData.viewerData.scrollBarData.thumbLength;
			}
			_scrollBarView.thumb.y = posY;
			_scrollBarView.infoBoxData.viewerData.scrollBarData.scrollValue = _scrollBarView.thumb.y 
				/ (_scrollBarView.infoBoxData.windowData.currentSize.height - _scrollBarView.infoBoxData.viewerData.viewer.padding * 2 
				- _scrollBarView.infoBoxData.viewerData.scrollBarData.thumbLength); 
		}
	}
}