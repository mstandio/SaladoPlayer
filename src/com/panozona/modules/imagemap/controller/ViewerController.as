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
package com.panozona.modules.imagemap.controller{
	
	import com.panozona.modules.imagemap.events.MapEvent;
	import com.panozona.modules.imagemap.events.WindowEvent;
	import com.panozona.modules.imagemap.events.ViewerEvent;
	import com.panozona.modules.imagemap.view.ViewerView;
	import com.panozona.player.module.Module;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	
	public class ViewerController{
		
		private var _viewerView:ViewerView;
		private var _module:Module;
		
		private var mapControler:MapController;
		
		private var moveActive:Boolean;
		private var zoomActive:Boolean;
		private var scrollActive:Boolean;
		private var focusActive:Boolean;
		
		private var mouseX:Number;
		private var mouseY:Number;
		private var focusX:Number;
		private var focusY:Number;
		private var distanceX:Number;
		private var distanceY:Number;
		
		private var onFocus:Boolean;
		
		private var deltaX:Number;
		private var deltaY:Number;
		
		private var deltaZoom:Number;
		
		private var fittingScale:Number;
		
		private const navigationControllers:Vector.<NavigationController> = new Vector.<NavigationController>();
		
		public function ViewerController(viewerView:ViewerView, module:Module) {
			_viewerView = viewerView;
			_module = module;
			
			mapControler = new MapController(viewerView.mapView, module);
			
			viewerView.imageMapData.mapData.addEventListener(MapEvent.CHANGED_SIZE, handleMapSizeChange, false, 0, true);
			viewerView.windowData.addEventListener(WindowEvent.CHANGED_CURRENT_SIZE, handleCurrentSizeChange, false, 0, true);
			handleCurrentSizeChange();
			
			if (_viewerView.viewerData.viewer.navMove.enabled){
				viewerView.viewerData.addEventListener(ViewerEvent.CHANGED_MOVE, handleMoveChange, false, 0, true);
			}
			if (_viewerView.viewerData.viewer.navZoom.enabled || _viewerView.viewerData.viewer.navZoom.useScroll){
				viewerView.viewerData.addEventListener(ViewerEvent.CHANGED_ZOOM, handleZoomChange, false, 0, true);
			}
			if (_viewerView.viewerData.viewer.navZoom.useScroll) {
				viewerView.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel, false, 0, true);
			}
			if (_viewerView.viewerData.viewer.navMove.useDrag){
				viewerView.viewerData.addEventListener(ViewerEvent.CHANGED_MOUSE_OVER, handleMouseOverChange, false, 0, true);
				viewerView.viewerData.addEventListener(ViewerEvent.CHANGED_MOUSE_DRAG, handleMouseDragChange, false, 0, true);
			}
			if (_viewerView.viewerData.viewer.autoFocus){
				viewerView.viewerData.addEventListener(ViewerEvent.CHANGED_FOCUS_POINT, handleFocusPointChange, false, 0, true);
			}
			
			var naviagationLoader:Loader = new Loader();
			naviagationLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, naviagationImageLost, false, 0, true);
			naviagationLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, naviagationImageLoaded, false, 0, true);
			naviagationLoader.load(new URLRequest(_viewerView.viewerData.viewer.path));
		}
		
		private function naviagationImageLost(e:IOErrorEvent):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, naviagationImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, naviagationImageLoaded);
			_module.printError(e.text);
		}
		
		private function naviagationImageLoaded(e:Event):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, naviagationImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, naviagationImageLoaded);
			var bitmapData:BitmapData = new BitmapData((e.target as LoaderInfo).width, (e.target as LoaderInfo).height, true, 0);
			bitmapData.draw((e.target as LoaderInfo).content);
			var navWidth:Number = Math.ceil((bitmapData.width - 3) / 4);
			var navHeight:Number = Math.ceil((bitmapData.height - 1) / 2);
			var bitmapdata1:BitmapData;
			var bitmapdata2:BitmapData;
			if(_viewerView.viewerData.viewer.navMove.enabled){
				bitmapdata1 = new BitmapData(navWidth, navHeight, true, 0);
				bitmapdata1.copyPixels(bitmapData, new Rectangle(0, 0, navWidth, navHeight), new Point(0, 0), null, null, true);
				bitmapdata2 = new BitmapData(navWidth, navHeight, true, 0);
				bitmapdata2.copyPixels(bitmapData, new Rectangle(0, navHeight + 1, navWidth, navHeight), new Point(0, 0), null, null, true);
				_viewerView.navigationUp.bitmapDataPlain = bitmapdata1;
				_viewerView.navigationUp.bitmapDataActive = bitmapdata2;
				_viewerView.navigationDown.bitmapDataPlain = bitmapdata1;
				_viewerView.navigationDown.bitmapDataActive = bitmapdata2;
				_viewerView.navigationLeft.bitmapDataPlain = bitmapdata1;
				_viewerView.navigationLeft.bitmapDataActive = bitmapdata2;
				_viewerView.navigationRight.bitmapDataPlain = bitmapdata1;
				_viewerView.navigationRight.bitmapDataActive = bitmapdata2;
				
				navigationControllers.push(new NavigationController(_viewerView.navigationUp, _module));
				navigationControllers.push(new NavigationController(_viewerView.navigationDown, _module));
				navigationControllers.push(new NavigationController(_viewerView.navigationLeft, _module));
				navigationControllers.push(new NavigationController(_viewerView.navigationRight, _module));
			}
			if (_viewerView.viewerData.viewer.navZoom.enabled) {
				bitmapdata1 = new BitmapData(navWidth, navHeight, true, 0);
				bitmapdata1.copyPixels(bitmapData, new Rectangle(navWidth + 1, 0, navWidth, navHeight), new Point(0, 0), null, null, true);
				bitmapdata2 = new BitmapData(navWidth, navHeight, true, 0);
				bitmapdata2.copyPixels(bitmapData, new Rectangle(navWidth + 1, navHeight + 1, navWidth, navHeight), new Point(0, 0), null, null, true);
				_viewerView.navigationIn.bitmapDataPlain = bitmapdata1;
				_viewerView.navigationIn.bitmapDataActive = bitmapdata2;
				bitmapdata1 = new BitmapData(navWidth, navHeight, true, 0);
				bitmapdata1.copyPixels(bitmapData, new Rectangle(navWidth * 2 + 2, 0, navWidth, navHeight), new Point(0, 0), null, null, true);
				bitmapdata2 = new BitmapData(navWidth, navHeight, true, 0);
				bitmapdata2.copyPixels(bitmapData, new Rectangle(navWidth * 2 + 2, navHeight + 1, navWidth, navHeight), new Point(0, 0), null, null, true);
				_viewerView.navigationOut.bitmapDataPlain = bitmapdata1;
				_viewerView.navigationOut.bitmapDataActive = bitmapdata2;
				
				navigationControllers.push(new NavigationController(_viewerView.navigationIn, _module));
				navigationControllers.push(new NavigationController(_viewerView.navigationOut, _module));
			}
			
			if (_viewerView.viewerData.viewer.navMove.useDrag) {
				bitmapdata1 = new BitmapData(navWidth, navHeight, true, 0);
				bitmapdata1.copyPixels(bitmapData, new Rectangle(navWidth * 3 + 3, 0, navWidth, navHeight), new Point(0, 0), null, null, true);
				bitmapdata2 = new BitmapData(navWidth, navHeight, true, 0);
				bitmapdata2.copyPixels(bitmapData, new Rectangle(navWidth * 3 + 3, navHeight + 1, navWidth, navHeight), new Point(0, 0), null, null, true);
				_viewerView.bitmapDataHover = bitmapdata1;
				_viewerView.bitmapDataDrag = bitmapdata2;
			}
			_viewerView.placeNavigation();
		}
		
		private function handleCurrentSizeChange(e:Event = null):void {
			_viewerView.redrawWindow();
			focusActive = false;
			if (_viewerView.containerWidth == 0 || _viewerView.containerHeight == 0) {
				onEnterFrame();
			}else {
				zoomActive = true; 
				onEnterFrame();
				zoomActive = false; 
			}
			deltaZoom = 0;
		}
		
		private function handleMapSizeChange(e:Event):void {
			_viewerView.container.x = (_viewerView.windowData.currentSize.width - _viewerView.containerWidth) * 0.5;
			_viewerView.container.y = (_viewerView.windowData.currentSize.height - _viewerView.containerHeight) * 0.5;
			
			focusActive = false;
			deltaZoom = _viewerView.imageMapData.viewerData.currentZoom.init - _viewerView.containerScale;
			zoomActive = true;
			onEnterFrame();
			zoomActive = false;
			deltaZoom = 0;
		}
		
		private function handleMoveChange(e:Event):void {
			if (_viewerView.viewerData.moveLeft ||
				_viewerView.viewerData.moveRight ||
				_viewerView.viewerData.moveUp ||
				_viewerView.viewerData.moveDown) {
				focusActive = false;
				moveActive = true;
				_module.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}else {
				moveActive = false;
				_module.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function handleZoomChange(e:Event):void {
			if (_viewerView.viewerData.zoomIn || _viewerView.viewerData.zoomOut) {
				focusActive = false;
				zoomActive = true;
				_module.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}else {
				zoomActive = false;
				_module.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function handleMouseWheel(e:MouseEvent):void {
			focusActive = false;
			deltaZoom = _viewerView.viewerData.viewer.navZoom.speed * e.delta;
			scrollActive = true;
			onEnterFrame();
			scrollActive = false;
			deltaZoom = 0;
		}
		
		private function handleMouseOverChange(e:Event):void {
			if (_viewerView.viewerData.mouseOver) {
				Mouse.hide();
				_viewerView.cursor.visible = true;
				_module.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
				
			}else {
				Mouse.show();
				_viewerView.cursor.visible = false;
				if(!focusActive){
					_module.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
		}
		
		private function handleMouseDragChange(e:Event):void {
			if (_viewerView.viewerData.mouseDrag) {
				focusActive = false;
				_viewerView.setDrag();
				mouseX = _viewerView.mouseX;
				mouseY = _viewerView.mouseY;
			}else {
				_viewerView.setHover();
			}
		}
		
		private function handleFocusPointChange(e:Event = null):void {
			if(!(moveActive || zoomActive || _viewerView.viewerData.mouseDrag)){
				focusX = _viewerView.viewerData.focusPoint.x;
				focusY = _viewerView.viewerData.focusPoint.y;
				distanceX = Math.abs(_viewerView.container.x + focusX - _viewerView.windowData.currentSize.width * 0.5);
				distanceY = Math.abs(_viewerView.container.y + focusY - _viewerView.windowData.currentSize.height * 0.5);
				
				focusActive = true;
				_module.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}
		}
		
		private function onEnterFrame(e:Event = null):void {
			deltaX = 0;
			deltaY = 0;
			
			if (_viewerView.viewerData.mouseOver) {
				_viewerView.cursor.x = _viewerView.mouseX - _viewerView.cursor.width * 0.5;
				_viewerView.cursor.y = _viewerView.mouseY - _viewerView.cursor.height * 0.5;
				if (_viewerView.viewerData.mouseDrag) {
					deltaX = _viewerView.mouseX - mouseX;
					deltaY = _viewerView.mouseY - mouseY;
					mouseX = _viewerView.mouseX;
					mouseY = _viewerView.mouseY;
				}
			}
			
			if (focusActive) {
				if (!isNaN(focusX)) {
					if (_viewerView.container.x + focusX != _viewerView.windowData.currentSize.width * 0.5) {
						if (_viewerView.container.x + focusX > _viewerView.windowData.currentSize.width * 0.5) {
							deltaX = - _viewerView.viewerData.viewer.navMove.speed;
							if (_viewerView.container.x + focusX + deltaX < _viewerView.windowData.currentSize.width * 0.5) {
								deltaX = _viewerView.windowData.currentSize.width * 0.5 - _viewerView.container.x - focusX;
							}
						}else {
							deltaX = _viewerView.viewerData.viewer.navMove.speed;
							if (_viewerView.container.x + focusX + deltaX > _viewerView.windowData.currentSize.width * 0.5) {
								deltaX = _viewerView.windowData.currentSize.width * 0.5 -_viewerView.container.x - focusX;
							}
						}
					}else {
						focusX = NaN;
					}
				}
				if (!isNaN(focusY)) {
					if (_viewerView.container.y + focusY != _viewerView.windowData.currentSize.height * 0.5) {
						if (_viewerView.container.y + focusY > _viewerView.windowData.currentSize.height * 0.5) {
							deltaY = - _viewerView.viewerData.viewer.navMove.speed;
							if (_viewerView.container.y + focusY + deltaY < _viewerView.windowData.currentSize.height * 0.5) {
								deltaY = _viewerView.windowData.currentSize.height * 0.5 - _viewerView.container.y - focusY;
							}
						}else {
							deltaY = _viewerView.viewerData.viewer.navMove.speed;
							if (_viewerView.container.y + focusY + deltaY > _viewerView.windowData.currentSize.height * 0.5) {
								deltaY = _viewerView.windowData.currentSize.height * 0.5 -_viewerView.container.y - focusY;
							}
						}
					}else {
						focusY = NaN;
					}
				}
				if (!isNaN(focusX) && !isNaN(focusY)) {
					if (distanceX > distanceY) {
						deltaY *= distanceY / distanceX;
					}else {
						deltaX *= distanceX / distanceY;
					}
				}
				
			}else if (moveActive) {
				if (_viewerView.viewerData.moveLeft) {
					deltaX = _viewerView.viewerData.viewer.navMove.speed;
					deltaY = 0;
				}else if (_viewerView.viewerData.moveRight) {
					deltaX = - _viewerView.viewerData.viewer.navMove.speed;
					deltaY = 0;
				}else if (_viewerView.viewerData.moveUp) {
					deltaX = 0
					deltaY = _viewerView.viewerData.viewer.navMove.speed;
				}else if (_viewerView.viewerData.moveDown) {
					deltaX = 0
					deltaY = - _viewerView.viewerData.viewer.navMove.speed;
				}
			} else if (zoomActive || scrollActive) {
				if (_viewerView.viewerData.zoomIn) {
					deltaZoom = _viewerView.viewerData.viewer.navZoom.speed;
				}else if (_viewerView.viewerData.zoomOut) {
					deltaZoom = - _viewerView.viewerData.viewer.navZoom.speed;
				}
				if (_viewerView.imageMapData.mapData.size.width * (_viewerView.containerScale + deltaZoom) < _viewerView.windowData.currentSize.width
					&& _viewerView.imageMapData.mapData.size.height * (_viewerView.containerScale + deltaZoom) < _viewerView.windowData.currentSize.height) {
					fittingScale = _viewerView.windowData.currentSize.height / _viewerView.imageMapData.mapData.size.height;
					if (_viewerView.imageMapData.mapData.size.width * fittingScale> _viewerView.windowData.currentSize.width) {
						fittingScale = _viewerView.windowData.currentSize.width / _viewerView.imageMapData.mapData.size.width;
					}
					deltaZoom = fittingScale - _viewerView.containerScale;
				}
				
				if (_viewerView.containerScale + deltaZoom > _viewerView.viewerData.currentZoom.max) {
					deltaZoom = _viewerView.viewerData.currentZoom.max - _viewerView.containerScale; 
				}
				
				if (_viewerView.containerScale + deltaZoom < _viewerView.viewerData.currentZoom.min) {
					deltaZoom = _viewerView.viewerData.currentZoom.min - _viewerView.containerScale;
				}
				if (zoomActive) {
					deltaX -= (_viewerView.windowData.currentSize.width * 0.5 - _viewerView.container.x) * deltaZoom / _viewerView.containerScale;
					deltaY -= (_viewerView.windowData.currentSize.height * 0.5 - _viewerView.container.y) * deltaZoom / _viewerView.containerScale;
				}else {
					deltaX -= (_viewerView.mouseX - _viewerView.container.x) * deltaZoom / _viewerView.containerScale;
					deltaY -= (_viewerView.mouseY - _viewerView.container.y) * deltaZoom / _viewerView.containerScale;
				}
				_viewerView.containerScale = _viewerView.containerScale + deltaZoom;
			}
			
			if (_viewerView.containerWidth < _viewerView.windowData.currentSize.width) {
				_viewerView.container.x = (_viewerView.windowData.currentSize.width - _viewerView.containerWidth) * 0.5;
			}else if (_viewerView.container.x + deltaX < 0) {
				if (_viewerView.container.x + deltaX > _viewerView.windowData.currentSize.width - _viewerView.containerWidth) {
					_viewerView.container.x += deltaX;
				}else {
					_viewerView.container.x = _viewerView.windowData.currentSize.width - _viewerView.containerWidth;
					deltaX = 0;
					focusX = NaN;
				}
			}else {
				_viewerView.container.x = 0;
				deltaX = 0;
				focusX = NaN;
			}
			if (_viewerView.containerHeight < _viewerView.windowData.currentSize.height) {
				_viewerView.container.y = (_viewerView.windowData.currentSize.height - _viewerView.containerHeight) * 0.5;
				deltaY = 0;
			}else if (_viewerView.container.y + deltaY < 0) {
				if (_viewerView.container.y + deltaY > _viewerView.windowData.currentSize.height - _viewerView.containerHeight) {
					_viewerView.container.y += deltaY;
				}else {
					_viewerView.container.y = _viewerView.windowData.currentSize.height - _viewerView.containerHeight;
					deltaY = 0;
					focusY = NaN;
				}
			}else {
				_viewerView.container.y = 0;
				deltaY = 0;
				focusY = NaN;
			}
			
			if (onFocus && deltaX != 0 || deltaY != 0){
				onFocus = false;
				_viewerView.imageMapData.viewerData.dispatchEvent(new ViewerEvent(ViewerEvent.FOCUS_LOST));
			}
			
			if (focusActive && isNaN(focusX) && isNaN(focusY)) {
				onFocus = true;
				if(!_viewerView.viewerData.mouseOver){
					_module.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
		}
	}
}