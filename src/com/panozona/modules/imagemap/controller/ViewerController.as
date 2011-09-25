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
package com.panozona.modules.imagemap.controller{
	
	import com.panozona.modules.imagemap.events.ViewerEvent;
	import com.panozona.modules.imagemap.events.MapEvent;
	import com.panozona.modules.imagemap.model.EmbededGraphics;
	import com.panozona.modules.imagemap.model.structure.Map;
	import com.panozona.modules.imagemap.view.ViewerView;
	import com.panozona.player.module.Module;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public class ViewerController{
		
		private var _viewerView:ViewerView;
		private var _module:Module;
		
		private var mapControler:MapController;
		
		private var moveActive:Boolean;
		private var zoomActive:Boolean;
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
		
		public function ViewerController(viewerView:ViewerView, module:Module) {
			_viewerView = viewerView;
			_module = module;
			
			mapControler = new MapController(viewerView.mapView, module);
			
			viewerView.viewerData.addEventListener(ViewerEvent.CHANGED_SIZE, handleSizeChange, false, 0, true);
			
			if (_viewerView.viewerData.viewer.moveEnabled){
				viewerView.viewerData.addEventListener(ViewerEvent.CHANGED_MOVE, handleMoveChange, false, 0, true);
			}
			if (_viewerView.viewerData.viewer.zoomEnabled || _viewerView.viewerData.viewer.scrollEnabled){
				viewerView.viewerData.addEventListener(ViewerEvent.CHANGED_ZOOM, handleZoomChange, false, 0, true);
			}
			if (_viewerView.viewerData.viewer.scrollEnabled) {
				viewerView.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel, false, 0, true);
			}
			if (_viewerView.viewerData.viewer.dragEnabled){
				viewerView.viewerData.addEventListener(ViewerEvent.CHANGED_MOUSE_OVER, handleMouseOverChange, false, 0, true);
				viewerView.viewerData.addEventListener(ViewerEvent.CHANGED_MOUSE_DRAG, handleMouseDragChange, false, 0, true);
			}
			if (_viewerView.viewerData.viewer.autofocusEnabled){
				viewerView.viewerData.addEventListener(ViewerEvent.CHANGED_FOCUS_POINT, handleFocusPointChange, false, 0, true);
			}
		}
		
		private function handleSizeChange(e:Event):void {
			var initZoom:Number = _viewerView.imageMapData.mapData.getMapById(_viewerView.imageMapData.mapData.currentMapId).initZoom;
			focusActive = false;
			zoomActive = true;
			deltaZoom = initZoom * 0.01 - _viewerView.container.scaleX;
			onEnterFrame();
			deltaZoom = 0;
			zoomActive = false;
			
			_viewerView.container.x = (_viewerView.containerMask.width -_viewerView.containerWidth) * 0.5;
			_viewerView.container.y = (_viewerView.containerMask.height - _viewerView.containerHeight) * 0.5;
			
			if (_viewerView.viewerData.viewer.autofocusEnabled) {
				handleFocusPointChange();
			}
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
			zoomActive = true;
			deltaZoom = _viewerView.viewerData.viewer.zoomSpeed * e.delta;
			onEnterFrame();
			deltaZoom = 0;
			zoomActive = false;
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
				_viewerView.cursor.bitmapData = new EmbededGraphics.BitmapCursorHandClosed().bitmapData;
				mouseX = _viewerView.mouseX;
				mouseY = _viewerView.mouseY;
			}else {
				_viewerView.cursor.bitmapData = new EmbededGraphics.BitmapCursorHandOpened().bitmapData;
			}
		}
		
		private function handleFocusPointChange(e:Event = null):void {
			if(!(moveActive || zoomActive || _viewerView.viewerData.mouseDrag)){
				focusX = _viewerView.viewerData.focusPoint.x * _viewerView.container.scaleX;
				focusY = _viewerView.viewerData.focusPoint.y * _viewerView.container.scaleY;
				distanceX = Math.abs(_viewerView.container.x + focusX - _viewerView.containerMask.width * 0.5);
				distanceY = Math.abs(_viewerView.container.y + focusY - _viewerView.containerMask.height * 0.5);
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
					if (_viewerView.container.x + focusX != _viewerView.containerMask.width * 0.5) {
						if (_viewerView.container.x + focusX > _viewerView.containerMask.width * 0.5) {
							deltaX = - _viewerView.viewerData.viewer.moveSpeed;
							if (_viewerView.container.x + focusX + deltaX < _viewerView.containerMask.width * 0.5) {
								deltaX = _viewerView.containerMask.width * 0.5 - _viewerView.container.x - focusX;
							}
						}else {
							deltaX = _viewerView.viewerData.viewer.moveSpeed;
							if (_viewerView.container.x + focusX + deltaX > _viewerView.containerMask.width * 0.5) {
								deltaX = _viewerView.containerMask.width * 0.5 -_viewerView.container.x - focusX;
							}
						}
					}else {
						focusX = NaN;
					}
				}
				if (!isNaN(focusY)) {
					if (_viewerView.container.y + focusY != _viewerView.containerMask.height * 0.5) {
						if (_viewerView.container.y + focusY > _viewerView.containerMask.height * 0.5) {
							deltaY = - _viewerView.viewerData.viewer.moveSpeed;
							if (_viewerView.container.y + focusY + deltaY < _viewerView.containerMask.height * 0.5) {
								deltaY = _viewerView.containerMask.height * 0.5 - _viewerView.container.y - focusY;
							}
						}else {
							deltaY = _viewerView.viewerData.viewer.moveSpeed;
							if (_viewerView.container.y + focusY + deltaY > _viewerView.containerMask.height * 0.5) {
								deltaY = _viewerView.containerMask.height * 0.5 -_viewerView.container.y - focusY;
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
					deltaX = _viewerView.viewerData.viewer.moveSpeed;
					deltaY = 0;
				}else if (_viewerView.viewerData.moveRight) {
					deltaX = - _viewerView.viewerData.viewer.moveSpeed;
					deltaY = 0;
				}else if (_viewerView.viewerData.moveUp) {
					deltaX = 0
					deltaY = _viewerView.viewerData.viewer.moveSpeed;
				}else if (_viewerView.viewerData.moveDown) {
					deltaX = 0
					deltaY = - _viewerView.viewerData.viewer.moveSpeed;
				}
			} else if (zoomActive) {
				if (_viewerView.viewerData.zoomIn) {
					deltaZoom = _viewerView.viewerData.viewer.zoomSpeed;
				}else if (_viewerView.viewerData.zoomOut) {
					deltaZoom = - _viewerView.viewerData.viewer.zoomSpeed;
				}
				if (_viewerView.container.scaleX + deltaZoom < 2 && _viewerView.container.scaleY + deltaZoom < 2) {
					if (_viewerView.imageMapData.viewerData.size.width * (_viewerView.container.scaleX + deltaZoom) < _viewerView.containerMask.width) {
						deltaZoom = (_viewerView.containerMask.width -
							_viewerView.container.scaleX * _viewerView.imageMapData.viewerData.size.width) / _viewerView.imageMapData.viewerData.size.width;
					}
					if (_viewerView.imageMapData.viewerData.size.height * (_viewerView.container.scaleY + deltaZoom) < _viewerView.containerMask.height) {
						deltaZoom = (_viewerView.containerMask.height -
							_viewerView.container.scaleY * _viewerView.imageMapData.viewerData.size.height) / _viewerView.imageMapData.viewerData.size.height;
					}
					_viewerView.container.scaleX += deltaZoom;
					_viewerView.container.scaleY += deltaZoom;
					deltaX = ( - _viewerView.container.x + _viewerView.containerMask.width * 0.5) * 
					( _viewerView.container.scaleX / (_viewerView.container.scaleX + deltaZoom) - 1);
					deltaY = ( - _viewerView.container.y + _viewerView.containerMask.height * 0.5) * 
					( _viewerView.container.scaleX / (_viewerView.container.scaleX + deltaZoom) - 1);
				}
			}
			if (_viewerView.container.x + deltaX < 0) {
				if (_viewerView.container.x + deltaX > _viewerView.containerMask.width - _viewerView.containerWidth) {
					_viewerView.container.x += deltaX;
				}else {
					_viewerView.container.x = _viewerView.containerMask.width - _viewerView.containerWidth;
					deltaX = 0;
					focusX = NaN;
				}
			}else{
				_viewerView.container.x = 0;
				deltaX = 0;
				focusX = NaN;
			}
			if (_viewerView.container.y + deltaY < 0) {
				if (_viewerView.container.y + deltaY > _viewerView.containerMask.height - _viewerView.containerHeight) {
					_viewerView.container.y += deltaY;
				}else {
					_viewerView.container.y = _viewerView.containerMask.height - _viewerView.containerHeight;
					deltaY = 0;
					focusY = NaN;
				}
			}else{
				_viewerView.container.y = 0;
				deltaY = 0;
				focusY = NaN;
			}
			
			if (onFocus && deltaX != 0 || deltaY != 0){
				onFocus = false;
				_viewerView.imageMapData.mapData.dispatchEvent(new ViewerEvent(ViewerEvent.FOCUS_LOST));
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