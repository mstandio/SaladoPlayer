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
package com.panozona.modules.imagemap.view{
	
	
	import flash.ui.Mouse;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.panozona.modules.imagemap.model.ImageMapData;
	import com.panozona.modules.imagemap.events.ContentViewerEvent;
	import com.panozona.modules.imagemap.model.ContentViewerData;
	import com.panozona.modules.imagemap.view.MapView;
	import com.panozona.modules.imagemap.model.EmbededGraphics;
	
	/**
	 * 
	 * @author mstandio
	 */
	public class ContentViewerView extends Sprite{
		
		private var _imageMapData:ImageMapData;
		
		private var _mapView:MapView;
		
		private var _container:Sprite;
		private var _containerMask:Sprite;
		
		private var _cursor:Bitmap;
		private var navigationMove:Sprite;
		private var navigationZoom:Sprite;
		
		public function ContentViewerView(imageMapData:ImageMapData) {
			
			_imageMapData = imageMapData;
			
			_containerMask = new Sprite;
			_containerMask.graphics.beginFill(0x000000);
			_containerMask.graphics.drawRect(0, 0, _imageMapData.windowData.size.width, _imageMapData.windowData.size.height);
			_containerMask.graphics.endFill();
			addChild(_containerMask);
			
			_container = new Sprite();
			_container.mask = _containerMask;
			addChild(_container);
			
			_mapView = new MapView(_imageMapData);
			container.addChild(_mapView);
			
			var navigationMoveDecoy:Sprite = new Sprite(); // bitmap is square so it wont interact with mouse
			navigationMoveDecoy.addChild(new Bitmap(new EmbededGraphics.BitmapNavigationMove().bitmapData));
			navigationMoveDecoy.mouseEnabled = false;
			navigationMoveDecoy.x = navigationMoveDecoy.y = 5; 
			navigationMoveDecoy.alpha = 1 / _imageMapData.windowData.alpha;
			addChild(navigationMoveDecoy);
			
			navigationMove = new Sprite(); // transparent circle over bitmap			
			navigationMove.x = this.navigationMove.y = 5; 
			navigationMove.alpha = 1 / _imageMapData.windowData.alpha;
			navigationMove.graphics.beginFill(0x000000,0); 
			navigationMove.graphics.drawCircle(navigationMoveDecoy.width * 0.5 , navigationMoveDecoy.height * 0.5, navigationMoveDecoy.width *0.5 -3); // -3 as margin
			navigationMove.graphics.endFill();
			addChild(navigationMove);
			
			var moveLeft:Sprite = new Sprite();
			moveLeft.graphics.beginFill(0x000000,0);
			moveLeft.graphics.drawRect(0, 0, 15, 15);
			moveLeft.graphics.endFill();
			moveLeft.buttonMode = true;
			moveLeft.x = 0;
			moveLeft.y = (navigationMove.height - moveLeft.height) * 0.5;
			navigationMove.addChild(moveLeft);
			
			var moveRight:Sprite = new Sprite();
			moveRight.graphics.beginFill(0x000000,0);
			moveRight.graphics.drawRect(0, 0, 15, 15);
			moveRight.graphics.endFill();
			moveRight.buttonMode = true;
			moveRight.x = navigationMove.width - moveRight.width;
			moveRight.y = (navigationMove.height - moveLeft.height) * 0.5;
			navigationMove.addChild(moveRight);
			
			var moveDown:Sprite = new Sprite();
			moveDown.graphics.beginFill(0x000000,0);
			moveDown.graphics.drawRect(0, 0, 15, 15);
			moveDown.graphics.endFill();
			moveDown.buttonMode = true;
			moveDown.x = (navigationMove.width - moveDown.width) * 0.5;
			moveDown.y = navigationMove.height - moveDown.height;
			navigationMove.addChild(moveDown);
			
			var moveUp:Sprite = new Sprite();
			moveUp.graphics.beginFill(0x000000,0);
			moveUp.graphics.drawRect(0, 0, 15, 15);
			moveUp.graphics.endFill();
			moveUp.buttonMode = true;
			moveUp.x = (navigationMove.width - moveUp.width) * 0.5;
			moveUp.y = 0;
			navigationMove.addChild(moveUp);
			
			navigationZoom = new Sprite();
			navigationZoom.addChild(new Bitmap(new EmbededGraphics.BitmapNavigationZoom().bitmapData));
			navigationZoom.x = (navigationMove.width - navigationZoom.width) * 0.5 + navigationMove.x;
			navigationZoom.y = navigationMove.y + navigationMove.height + 12; 
			navigationZoom.alpha = 1 / _imageMapData.windowData.alpha;
			addChild(navigationZoom);
			
			var zoomIn:Sprite = new Sprite();
			zoomIn.graphics.beginFill(0x000000,0);
			zoomIn.graphics.drawRect(0, 0, 21, 25);
			zoomIn.graphics.endFill();
			zoomIn.buttonMode = true;
			zoomIn.x = (navigationZoom.width - zoomIn.width) * 0.5;
			zoomIn.y = 0;
			navigationZoom.addChild(zoomIn);
			
			var zoomOut:Sprite = new Sprite();
			zoomOut.graphics.beginFill(0x000000,0);
			zoomOut.graphics.drawRect(0, 0, 21, 18);
			zoomOut.graphics.endFill();
			zoomOut.buttonMode = true;
			zoomOut.x = (navigationZoom.width - zoomOut.width) * 0.5 ;
			zoomOut.y = navigationZoom.height - zoomOut.height ;
			navigationZoom.addChild(zoomOut);
			
			_cursor = new Bitmap();
			_cursor.bitmapData = new EmbededGraphics.BitmapCursorHandOpened().bitmapData;
			_cursor.alpha = 1 / _imageMapData.windowData.alpha;
			_cursor.visible = false;
			addChild(_cursor);
			
			moveLeft.addEventListener(MouseEvent.MOUSE_DOWN, navLeft, false, 0, true);
			moveLeft.addEventListener(MouseEvent.MOUSE_UP, navStop, false, 0, true);
			moveLeft.addEventListener(MouseEvent.MOUSE_OUT, navStop, false, 0, true);
			
			moveRight.addEventListener(MouseEvent.MOUSE_DOWN, navRight, false, 0, true);
			moveRight.addEventListener(MouseEvent.MOUSE_UP, navStop, false, 0, true);
			moveRight.addEventListener(MouseEvent.MOUSE_OUT, navStop, false, 0, true);
			
			moveUp.addEventListener(MouseEvent.MOUSE_DOWN, navUp, false, 0, true);
			moveUp.addEventListener(MouseEvent.MOUSE_UP, navStop, false, 0, true);
			moveUp.addEventListener(MouseEvent.MOUSE_OUT, navStop, false, 0, true);
			
			moveDown.addEventListener(MouseEvent.MOUSE_DOWN, navDown, false, 0, true);
			moveDown.addEventListener(MouseEvent.MOUSE_UP, navStop, false, 0, true);
			moveDown.addEventListener(MouseEvent.MOUSE_OUT, navStop, false, 0, true);
			
			zoomIn.addEventListener(MouseEvent.MOUSE_DOWN, navZoomIn, false, 0, true);
			zoomIn.addEventListener(MouseEvent.MOUSE_UP, navZoomStop, false, 0, true);
			zoomIn.addEventListener(MouseEvent.MOUSE_OUT, navZoomStop, false, 0, true);
			
			zoomOut.addEventListener(MouseEvent.MOUSE_DOWN, navZoomOut, false, 0, true);
			zoomOut.addEventListener(MouseEvent.MOUSE_UP, navZoomStop, false, 0, true);
			zoomOut.addEventListener(MouseEvent.MOUSE_OUT, navZoomStop, false, 0, true);
			
			_container.addEventListener(MouseEvent.ROLL_OVER, containerMouseOver, false, 0, true);
			_container.addEventListener(MouseEvent.MOUSE_DOWN, containerMouseDown, false, 0, true);
			_container.addEventListener(MouseEvent.ROLL_OUT, containerMouseOut, false, 0, true);
			_container.addEventListener(MouseEvent.MOUSE_UP, containerMouseUp, false, 0, true);
		}
		
		public function get contentViewerData():ContentViewerData {
			return _imageMapData.contentViewerData;
		}
		
		public function get mapView():MapView {
			return _mapView;
		}
		
		public function get container():Sprite {
			return _container;
		}
		
		public function get containerMask():Sprite {
			return _containerMask;
		}
		
		public function get cursor():Bitmap {
			return _cursor;
		}
		
		private function navLeft(e:Event):void {
			contentViewerData.moveLeft = true; 
		}
		
		private function navRight(e:Event):void {
			contentViewerData.moveRight = true; 
		}
		
		private function navUp(e:Event):void {
			contentViewerData.moveUp = true; 
		}
		
		private function navDown(e:Event):void {
			contentViewerData.moveDown = true; 
		}
		
		private function navStop(e:Event):void {
			contentViewerData.moveLeft = false;
			contentViewerData.moveRight = false;
			contentViewerData.moveUp = false;
			contentViewerData.moveDown = false;
		}
		
		private function navZoomIn(e:Event):void {
			contentViewerData.zoomIn = true; 
		}
		
		private function navZoomOut(e:Event):void {
			contentViewerData.zoomOut = true;
		}
		
		private function navZoomStop(e:Event):void {
			contentViewerData.zoomIn = false;
			contentViewerData.zoomOut = false;
		}
		
		private function containerMouseOver(e:Event):void {
			contentViewerData.mouseOver = true;
		}
		
		private function containerMouseDown(e:Event):void {
			contentViewerData.mouseDrag = true;
		}
		
		private function containerMouseOut(e:Event):void {
			contentViewerData.mouseOver = false;
			contentViewerData.mouseDrag = false;
		}
		
		private function containerMouseUp(e:Event):void {
			contentViewerData.mouseDrag = false;
		}
	}
}