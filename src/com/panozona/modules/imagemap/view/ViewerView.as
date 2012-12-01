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
package com.panozona.modules.imagemap.view {
	
	import com.panozona.modules.imagemap.model.ImageMapData;
	import com.panozona.modules.imagemap.model.NavigationData;
	import com.panozona.modules.imagemap.model.ViewerData;
	import com.panozona.modules.imagemap.model.WindowData;
	import com.panozona.modules.imagemap.view.MapView;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ViewerView extends Sprite {
		
		public const containerMask:Sprite = new Sprite();
		public const container:Sprite = new Sprite();
		
		public const cursor:Bitmap = new Bitmap();
		private var _bitmapDataDrag:BitmapData;
		private var _bitmapDataHover:BitmapData;
		
		public var navigationUp:NavigationView;
		public var navigationDown:NavigationView;
		public var navigationLeft:NavigationView;
		public var navigationRight:NavigationView;
		public var navigationIn:NavigationView;
		public var navigationOut:NavigationView;
		
		private var _imageMapData:ImageMapData;
		private var _mapView:MapView;
		
		public function ViewerView(imageMapData:ImageMapData) {
			
			_imageMapData = imageMapData;
			
			_mapView = new MapView(_imageMapData);
			container.addChild(_mapView);
			
			addChild(containerMask);
			container.mask = containerMask;
			
			addChild(container);
			
			if (_imageMapData.viewerData.viewer.navMove.enabled){
				navigationLeft = new NavigationView(new NavigationData(navLeft, navStop), _imageMapData.viewerData);
				navigationRight = new NavigationView(new NavigationData(navRight, navStop), _imageMapData.viewerData);
				navigationUp = new NavigationView(new NavigationData(navUp, navStop), _imageMapData.viewerData);
				navigationDown = new NavigationView(new NavigationData(navDown, navStop), _imageMapData.viewerData);
				
				navigationLeft.alpha = 1 / _imageMapData.windowData.window.alpha;
				navigationRight.alpha = 1 / _imageMapData.windowData.window.alpha;
				navigationUp.alpha = 1 / _imageMapData.windowData.window.alpha;
				navigationDown.alpha = 1 / _imageMapData.windowData.window.alpha;
			}
			
			if (_imageMapData.viewerData.viewer.navZoom.enabled){
				navigationIn = new NavigationView(new NavigationData(navIn, navZoomStop), _imageMapData.viewerData);
				navigationOut = new NavigationView(new NavigationData(navOut, navZoomStop), _imageMapData.viewerData);
				
				navigationIn.alpha = 1 / _imageMapData.windowData.window.alpha;
				navigationOut.alpha = 1 / _imageMapData.windowData.window.alpha;
			}
			
			if (_imageMapData.viewerData.viewer.navMove.useDrag) {
				cursor.alpha = 1 / _imageMapData.windowData.window.alpha;
				cursor.visible = false;
				addChild(cursor);
				
				container.addEventListener(MouseEvent.ROLL_OVER, containerMouseOver, false, 0, true);
				container.addEventListener(MouseEvent.MOUSE_DOWN, containerMouseDown, false, 0, true);
				container.addEventListener(MouseEvent.ROLL_OUT, containerMouseOut, false, 0, true);
				container.addEventListener(MouseEvent.MOUSE_UP, containerMouseUp, false, 0, true);
			}
			
			redrawWindow();
		}
		
		public function get imageMapData():ImageMapData{
			return _imageMapData;
		}
		
		public function get viewerData():ViewerData {
			return _imageMapData.viewerData;
		}
		
		public function get windowData():WindowData {
			return _imageMapData.windowData;
		}
		
		public function get mapView():MapView {
			return _mapView;
		}
		
		public function redrawWindow():void {
			graphics.clear();
			graphics.beginFill(_imageMapData.viewerData.viewer.style.color, _imageMapData.viewerData.viewer.style.alpha);
			graphics.drawRect(0, 0, 
				_imageMapData.windowData.currentSize.width, 
				_imageMapData.windowData.currentSize.height);
			graphics.endFill();
			
			containerMask.graphics.clear();
			containerMask.graphics.beginFill(0x000000);
			containerMask.graphics.drawRect(0, 0,
				_imageMapData.windowData.currentSize.width,
				_imageMapData.windowData.currentSize.height);
			containerMask.graphics.endFill();
		}
		
		public function placeNavigation():void {
			var marginTop:Number = 5;
			var marginLeft:Number = 5;
			
			if (_imageMapData.viewerData.viewer.navMove.enabled) {
				navigationUp.rotation = 0;
				navigationLeft.rotation = -90;
				navigationRight.rotation = 90;
				navigationDown.rotation = 180;
				navigationUp.x = navigationLeft.width - navigationUp.width * 0.5 + marginLeft;
				navigationUp.y = marginTop;
				navigationLeft.x = marginLeft;
				navigationLeft.y = navigationLeft.height + navigationUp.y + navigationUp.height - 1;
				navigationRight.x = navigationLeft.x + navigationLeft.width + navigationRight.width;
				navigationRight.y = navigationUp.y + navigationUp.height - 1;
				navigationDown.x = navigationDown.width + navigationUp.x;
				navigationDown.y = navigationUp.y + navigationUp.height + navigationDown.height + navigationLeft.height - 2;
				addChild(navigationUp);
				addChild(navigationLeft);
				addChild(navigationRight);
				addChild(navigationDown);
			}
			
			if (_imageMapData.viewerData.viewer.navZoom.enabled) {
				navigationIn.rotation = 0;
				navigationOut.rotation = 180;
				if (_imageMapData.viewerData.viewer.navMove.enabled) {
					navigationIn.x = navigationUp.x;
					navigationIn.y = navigationUp.y + navigationUp.height + navigationLeft.height + navigationDown.height + marginTop;
					navigationOut.x = navigationIn.x + navigationOut.width;
					navigationOut.y = navigationIn.y + navigationOut.height + navigationIn.height - 1;
				}else {
					navigationIn.x = marginLeft;
					navigationIn.y = marginTop;
					navigationOut.x = navigationIn.x + navigationOut.width;
					navigationOut.y = navigationIn.y + navigationOut.height + navigationIn.height - 1;
				}
				addChild(navigationIn);
				addChild(navigationOut);
			}
		}
		
		public function get containerScale():Number {return _imageMapData.viewerData.scale;}
		public function set containerScale(value:Number):void {
			if (_mapView.imageMapData.mapData.size == null) return;
			_imageMapData.viewerData.scale = value;
			_mapView.mapContainer.scaleX = _mapView.mapContainer.scaleY = _imageMapData.viewerData.scale;
		}
		
		public function get containerWidth():Number {
			if (_mapView.imageMapData.mapData.size == null) return 0;
			return imageMapData.mapData.size.width * _imageMapData.viewerData.scale;
		}
		
		public function get containerHeight():Number {
			if (_mapView.imageMapData.mapData.size == null) return 0;
			return imageMapData.mapData.size.height * _imageMapData.viewerData.scale;
		}
		
		public function set bitmapDataHover(value:BitmapData):void {
			_bitmapDataHover = value;
			if (!viewerData.mouseDrag) {
				cursor.bitmapData = _bitmapDataHover;
			}
		}
		
		public function set bitmapDataDrag(value:BitmapData):void {
			_bitmapDataDrag = value;
			if (viewerData.mouseDrag) {
				cursor.bitmapData = _bitmapDataDrag;
			}
		}
		
		public function setHover():void {
			if (_bitmapDataHover != null) {
				cursor.bitmapData = _bitmapDataHover;
			}
		}
		
		public function setDrag():void {
			if (_bitmapDataDrag != null) {
				cursor.bitmapData = _bitmapDataDrag;
			}
		}
		
		private function navLeft():void {
			viewerData.moveLeft = true;
		}
		
		private function navRight():void {
			viewerData.moveRight = true;
		}
		
		private function navUp():void {
			viewerData.moveUp = true;
		}
		
		private function navDown():void {
			viewerData.moveDown = true;
		}
		
		private function navStop():void {
			viewerData.moveLeft = false;
			viewerData.moveRight = false;
			viewerData.moveUp = false;
			viewerData.moveDown = false;
		}
		
		private function navIn():void {
			viewerData.zoomIn = true;
		}
		
		private function navOut():void {
			viewerData.zoomOut = true;
		}
		
		private function navZoomStop():void {
			viewerData.zoomIn = false;
			viewerData.zoomOut = false;
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