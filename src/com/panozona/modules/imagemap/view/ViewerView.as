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
package com.panozona.modules.imagemap.view{
	
	import com.panozona.modules.imagemap.model.ViewerData;
	import com.panozona.modules.imagemap.model.EmbededGraphics;
	import com.panozona.modules.imagemap.model.ImageMapData;
	import com.panozona.modules.imagemap.view.MapView;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ViewerView extends Sprite{
		
		public const containerMask:Sprite = new Sprite();
		public const container:Sprite = new Sprite();
		public const cursor:Bitmap = new Bitmap();
		
		private var navigationMove:Sprite;
		private var navigationZoom:Sprite;
		private var bitmapMove:Bitmap;
		private var bitmapZoom:Bitmap;
		
		private var _imageMapData:ImageMapData;
		private var _mapView:MapView;
		
		public function ViewerView(imageMapData:ImageMapData) {
			
			_imageMapData = imageMapData;
			
			containerMask.graphics.beginFill(0x000000);
			containerMask.graphics.drawRect(0, 0,
				_imageMapData.windowData.window.size.width,
				_imageMapData.windowData.window.size.height);
			containerMask.graphics.endFill();
			addChild(containerMask);
			
			container.mask = containerMask;
			addChild(container);
			
			_mapView = new MapView(_imageMapData);
			container.addChild(_mapView);
			
			if (_imageMapData.viewerData.viewer.moveEnabled){
				
				var navigationMove:Sprite = new Sprite(); // bitmap is square so it wont interact with mouse
				bitmapMove = new Bitmap(new EmbededGraphics.BitmapMovePlain().bitmapData);
				navigationMove.addChild(bitmapMove);
				navigationMove.mouseEnabled = false;
				navigationMove.x = navigationMove.y = 5; 
				navigationMove.alpha = 1 / _imageMapData.windowData.window.alpha;
				addChild(navigationMove);
				
				var moveLeft:Sprite = new Sprite();
				moveLeft.graphics.beginFill(0x000000,0);
				moveLeft.graphics.drawRect(0, 0, 18, 18);
				moveLeft.graphics.endFill();
				moveLeft.buttonMode = true;
				moveLeft.x = 4;
				moveLeft.y = (navigationMove.height - moveLeft.height) * 0.5;
				navigationMove.addChild(moveLeft);
				
				moveLeft.addEventListener(MouseEvent.MOUSE_DOWN, navLeft, false, 0, true);
				moveLeft.addEventListener(MouseEvent.MOUSE_UP, navStop, false, 0, true);
				moveLeft.addEventListener(MouseEvent.ROLL_OUT, navStop, false, 0, true);
				
				var moveRight:Sprite = new Sprite();
				moveRight.graphics.beginFill(0x000000,0);
				moveRight.graphics.drawRect(0, 0, 18, 18);
				moveRight.graphics.endFill();
				moveRight.buttonMode = true;
				moveRight.x = navigationMove.width - moveRight.width - 4;
				moveRight.y = (navigationMove.height - moveLeft.height) * 0.5;
				navigationMove.addChild(moveRight);
				
				moveRight.addEventListener(MouseEvent.MOUSE_DOWN, navRight, false, 0, true);
				moveRight.addEventListener(MouseEvent.MOUSE_UP, navStop, false, 0, true);
				moveRight.addEventListener(MouseEvent.ROLL_OUT, navStop, false, 0, true);
				
				var moveDown:Sprite = new Sprite();
				moveDown.graphics.beginFill(0x000000,0);
				moveDown.graphics.drawRect(0, 0, 18, 18);
				moveDown.graphics.endFill();
				moveDown.buttonMode = true;
				moveDown.x = (navigationMove.width - moveDown.width) * 0.5;
				moveDown.y = navigationMove.height - moveDown.height -3;
				navigationMove.addChild(moveDown);
				
				moveDown.addEventListener(MouseEvent.MOUSE_DOWN, navDown, false, 0, true);
				moveDown.addEventListener(MouseEvent.MOUSE_UP, navStop, false, 0, true);
				moveDown.addEventListener(MouseEvent.ROLL_OUT, navStop, false, 0, true);
				
				var moveUp:Sprite = new Sprite();
				moveUp.graphics.beginFill(0x000000,0);
				moveUp.graphics.drawRect(0, 0, 18, 18);
				moveUp.graphics.endFill();
				moveUp.buttonMode = true;
				moveUp.x = (navigationMove.width - moveUp.width) * 0.5;
				moveUp.y = 3;
				navigationMove.addChild(moveUp);
				
				moveUp.addEventListener(MouseEvent.MOUSE_DOWN, navUp, false, 0, true);
				moveUp.addEventListener(MouseEvent.MOUSE_UP, navStop, false, 0, true);
				moveUp.addEventListener(MouseEvent.ROLL_OUT, navStop, false, 0, true);
			}
			
			if (_imageMapData.viewerData.viewer.zoomEnabled){
				
				navigationZoom = new Sprite();
				bitmapZoom = new Bitmap(new EmbededGraphics.BitmapZoomPlain().bitmapData);
				navigationZoom.addChild(bitmapZoom);
				navigationZoom.alpha = 1 / _imageMapData.windowData.window.alpha;
				addChild(navigationZoom);
				
				if (_imageMapData.viewerData.viewer.moveEnabled) {
					navigationZoom.x = (navigationMove.width - navigationZoom.width) * 0.5 + navigationMove.x;
					navigationZoom.y = navigationMove.y + navigationMove.height + 12; 
				}else {
					navigationZoom.x = 5;
					navigationZoom.y = 5;
				}
				
				var zoomIn:Sprite = new Sprite();
				zoomIn.graphics.beginFill(0x000000,0);
				zoomIn.graphics.drawRect(0, 0, 21, 20);
				zoomIn.graphics.endFill();
				zoomIn.buttonMode = true;
				zoomIn.x = (navigationZoom.width - zoomIn.width) * 0.5;
				zoomIn.y = 0;
				navigationZoom.addChild(zoomIn);
				
				zoomIn.addEventListener(MouseEvent.MOUSE_DOWN, navZoomIn, false, 0, true);
				zoomIn.addEventListener(MouseEvent.MOUSE_UP, navZoomStop, false, 0, true);
				zoomIn.addEventListener(MouseEvent.ROLL_OUT, navZoomStop, false, 0, true);
				
				var zoomOut:Sprite = new Sprite();
				zoomOut.graphics.beginFill(0x000000,0);
				zoomOut.graphics.drawRect(0, 0, 21, 20);
				zoomOut.graphics.endFill();
				zoomOut.buttonMode = true;
				zoomOut.x = (navigationZoom.width - zoomOut.width) * 0.5 ;
				zoomOut.y = navigationZoom.height - zoomOut.height ;
				navigationZoom.addChild(zoomOut);
				
				zoomOut.addEventListener(MouseEvent.MOUSE_DOWN, navZoomOut, false, 0, true);
				zoomOut.addEventListener(MouseEvent.MOUSE_UP, navZoomStop, false, 0, true);
				zoomOut.addEventListener(MouseEvent.ROLL_OUT, navZoomStop, false, 0, true);
			}
			
			if (_imageMapData.viewerData.viewer.dragEnabled) {
				cursor.bitmapData = new EmbededGraphics.BitmapCursorHandOpened().bitmapData;
				cursor.alpha = 1 / _imageMapData.windowData.window.alpha;
				cursor.visible = false;
				addChild(cursor);
				
				container.addEventListener(MouseEvent.ROLL_OVER, containerMouseOver, false, 0, true);
				container.addEventListener(MouseEvent.MOUSE_DOWN, containerMouseDown, false, 0, true);
				container.addEventListener(MouseEvent.ROLL_OUT, containerMouseOut, false, 0, true);
				container.addEventListener(MouseEvent.MOUSE_UP, containerMouseUp, false, 0, true);
			}
		}
		
		public function get imageMapData():ImageMapData{
			return _imageMapData;
		}
		
		public function get viewerData():ViewerData {
			return _imageMapData.viewerData;
		}
		
		public function get mapView():MapView {
			return _mapView;
		}
		
		private function navLeft(e:Event):void {
			viewerData.moveLeft = true; 
			bitmapMove.bitmapData = new EmbededGraphics.BitmapMoveLeft().bitmapData;
		}
		
		private function navRight(e:Event):void {
			viewerData.moveRight = true; 
			bitmapMove.bitmapData = new EmbededGraphics.BitmapMoveRight().bitmapData;
		}
		
		private function navUp(e:Event):void {
			viewerData.moveUp = true; 
			bitmapMove.bitmapData = new EmbededGraphics.BitmapMoveUp().bitmapData;
		}
		
		private function navDown(e:Event):void {
			viewerData.moveDown = true; 
			bitmapMove.bitmapData = new EmbededGraphics.BitmapMoveDown().bitmapData;
		}
		
		private function navStop(e:Event):void {
			viewerData.moveLeft = false;
			viewerData.moveRight = false;
			viewerData.moveUp = false;
			viewerData.moveDown = false;
			bitmapMove.bitmapData = new EmbededGraphics.BitmapMovePlain().bitmapData;
		}
		
		private function navZoomIn(e:Event):void {
			viewerData.zoomIn = true; 
			bitmapZoom.bitmapData = new EmbededGraphics.BitmapZoomIn().bitmapData;
		}
		
		private function navZoomOut(e:Event):void {
			viewerData.zoomOut = true;
			bitmapZoom.bitmapData = new EmbededGraphics.BitmapZoomOut().bitmapData;
		}
		
		private function navZoomStop(e:Event):void {
			viewerData.zoomIn = false;
			viewerData.zoomOut = false;
			bitmapZoom.bitmapData = new EmbededGraphics.BitmapZoomPlain().bitmapData;
		}
		
		private function containerMouseOver(e:Event):void {
			viewerData.mouseOver = true;
			viewerData.mouseDrag = false;
		}
		
		private function containerMouseDown(e:Event):void {
			viewerData.mouseDrag = true;
		}
		
		private function containerMouseOut(e:Event):void {
			viewerData.mouseOver = false;
			viewerData.mouseDrag = false;
		}
		
		private function containerMouseUp(e:Event):void {
			viewerData.mouseDrag = false;
		}
	}
}