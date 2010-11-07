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
package com.panozona.modules.imagemap.controller{
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	import com.panozona.player.module.Module;
	
	import com.panozona.modules.imagemap.model.ContentViewerData;
	import com.panozona.modules.imagemap.view.ContentViewerView;
	import com.panozona.modules.imagemap.events.ContentViewerEvent;
	import com.panozona.modules.imagemap.model.EmbededGraphics;
	
	/**
	 * @author mstandio
	 */
	public class ContentViewerController{
		
		private var _contentViewerView:ContentViewerView;
		private var _module:Module;
		
		private var mapControler:MapController;
		
		private var moveActive:Boolean;
		private var zoomActive:Boolean;
		private var focusActive:Boolean;
		
		private var mouseX:Number;
		private var mouseY:Number;
		private var focusX:Number;
		private var focusY:Number;
		
		private var onFocus:Boolean;
		
		private var containerOrgWidth:Number;
		private var containerOrgHeight:Number;
		
		private var deltaX:Number;
		private var deltaY:Number;
		
		private var deltaZoom:Number;
		
		private static const moveSpeed:Number = 10;
		private static const zoomSpeed:Number = 0.03;
		
		public function ContentViewerController(contentViewerView:ContentViewerView, module:Module) {
			
			mapControler = new MapController(contentViewerView.mapView, module);
			mapControler.loadFirstMap();
			
			_contentViewerView = contentViewerView;
			_module = module;
			
			contentViewerView.contentViewerData.addEventListener(ContentViewerEvent.CHANGED_MOVE, handleMoveChange, false, 0, true);
			contentViewerView.contentViewerData.addEventListener(ContentViewerEvent.CHANGED_ZOOM, handleZoomChange, false, 0, true);
			contentViewerView.contentViewerData.addEventListener(ContentViewerEvent.CHANGED_MOUSE_OVER, handleMouseOverChange, false, 0, true);
			contentViewerView.contentViewerData.addEventListener(ContentViewerEvent.CHANGED_MOUSE_DRAG, handleMouseDragChange, false, 0, true);
			contentViewerView.contentViewerData.addEventListener(ContentViewerEvent.CHANGED_FOCUS_POINT, handleFocusPointChange, false, 0, true);
		}
		
		private function handleMoveChange(e:Event):void {
			if (_contentViewerView.contentViewerData.moveLeft ||
				_contentViewerView.contentViewerData.moveRight ||
				_contentViewerView.contentViewerData.moveUp ||
				_contentViewerView.contentViewerData.moveDown) {
				moveActive = true;
				focusActive = false;
				_module.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}else {
				moveActive = false;
				_module.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function handleZoomChange(e:Event):void {
			if (_contentViewerView.contentViewerData.zoomIn || 
				_contentViewerView.contentViewerData.zoomOut) {
				containerOrgWidth = _contentViewerView.container.width / _contentViewerView.container.scaleX;
				containerOrgHeight = _contentViewerView.container.height / _contentViewerView.container.scaleY;
				zoomActive = true;
				focusActive = false;
				_module.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}else {
				zoomActive = false;
				_module.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function handleMouseOverChange(e:Event):void {
			if (_contentViewerView.contentViewerData.mouseOver) {
				Mouse.hide();
				_contentViewerView.cursor.visible = true;
				_module.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
				
			}else {
				Mouse.show();
				_contentViewerView.cursor.visible = false;
				if(!focusActive){
					_module.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
		}
		
		private function handleMouseDragChange(e:Event):void {
			if (_contentViewerView.contentViewerData.mouseDrag) {
				_contentViewerView.cursor.bitmapData = new EmbededGraphics.BitmapCursorHandClosed().bitmapData;
				focusActive = false;
				mouseX = _contentViewerView.mouseX;
				mouseY = _contentViewerView.mouseY;
			}else {
				_contentViewerView.cursor.bitmapData = new EmbededGraphics.BitmapCursorHandOpened().bitmapData;
			}
		}
		
		private function handleFocusPointChange(e:Event):void {
			if(!(moveActive || zoomActive || _contentViewerView.contentViewerData.mouseDrag)){
				focusX = _contentViewerView.contentViewerData.focusPoint.x * _contentViewerView.container.scaleX;
				focusY = _contentViewerView.contentViewerData.focusPoint.y * _contentViewerView.container.scaleY;
				focusActive = true;
				_module.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}
		}
		
		private function onEnterFrame(e:Event):void {
			deltaX = 0;
			deltaY = 0;
			
			if (_contentViewerView.contentViewerData.mouseOver) {
				_contentViewerView.cursor.x = _contentViewerView.mouseX - _contentViewerView.cursor.width * 0.5;
				_contentViewerView.cursor.y = _contentViewerView.mouseY - _contentViewerView.cursor.height * 0.5;
				if (_contentViewerView.contentViewerData.mouseDrag) {
					deltaX = _contentViewerView.mouseX - mouseX;
					deltaY = _contentViewerView.mouseY - mouseY;
					mouseX = _contentViewerView.mouseX;
					mouseY = _contentViewerView.mouseY;
				}
			}
			
			if (focusActive) {
				if (!isNaN(focusX)) {
					if (_contentViewerView.container.x + focusX != _contentViewerView.containerMask.width * 0.5) {
						if (_contentViewerView.container.x + focusX > _contentViewerView.containerMask.width * 0.5) {
							deltaX = - moveSpeed;
							if (_contentViewerView.container.x + focusX + deltaX < _contentViewerView.containerMask.width * 0.5) {
								deltaX = _contentViewerView.containerMask.width * 0.5 - _contentViewerView.container.x - focusX;
							}
						}else {
							deltaX = moveSpeed;
							if (_contentViewerView.container.x + focusX + deltaX > _contentViewerView.containerMask.width * 0.5) {
								deltaX = _contentViewerView.containerMask.width * 0.5 -_contentViewerView.container.x - focusX;
							}
						}
					}else {
						focusX = NaN;
					}
				}
				if (!isNaN(focusY)) {
					if (_contentViewerView.container.y + focusY != _contentViewerView.containerMask.height * 0.5) {
						if (_contentViewerView.container.y + focusY > _contentViewerView.containerMask.height * 0.5) {
							deltaY = - moveSpeed;
							if (_contentViewerView.container.y + focusY + deltaY < _contentViewerView.containerMask.height * 0.5) {
								deltaY = _contentViewerView.containerMask.height * 0.5 - _contentViewerView.container.y - focusY;
							}
						}else {
							deltaY = moveSpeed;
							if (_contentViewerView.container.y + focusY + deltaY > _contentViewerView.containerMask.height * 0.5) {
								deltaY = _contentViewerView.containerMask.height * 0.5 -_contentViewerView.container.y - focusY;
							}
						}
					}else {
						focusY = NaN;
					}
				}
			}else if (moveActive) {
				if (_contentViewerView.contentViewerData.moveLeft) {
					deltaX = moveSpeed;
					deltaY = 0;
				}else if (_contentViewerView.contentViewerData.moveRight) {
					deltaX = -moveSpeed;
					deltaY = 0;
				}else if (_contentViewerView.contentViewerData.moveUp) {
					deltaX = 0
					deltaY = moveSpeed;
				}else if (_contentViewerView.contentViewerData.moveDown) {
					deltaX = 0
					deltaY = -moveSpeed;
				}
			}else if (zoomActive) {
				if (_contentViewerView.contentViewerData.zoomIn) {
					deltaZoom = zoomSpeed;
				}else if (_contentViewerView.contentViewerData.zoomOut) {
					deltaZoom = -zoomSpeed;
				}
				if (_contentViewerView.container.scaleX + deltaZoom < 2 && _contentViewerView.container.scaleY + deltaZoom < 2) {
					if (containerOrgWidth * (_contentViewerView.container.scaleX + deltaZoom) < _contentViewerView.containerMask.width || 
						containerOrgHeight * (_contentViewerView.container.scaleY + deltaZoom) < _contentViewerView.containerMask.height) {
						if (containerOrgWidth * (_contentViewerView.container.scaleX + deltaZoom) < _contentViewerView.containerMask.width) {
							deltaZoom = (_contentViewerView.containerMask.width -
							_contentViewerView.container.scaleX * containerOrgWidth) / containerOrgWidth;
						}else {
							deltaZoom = (_contentViewerView.containerMask.height -
							_contentViewerView.container.scaleY * containerOrgHeight) / containerOrgHeight;
						}
					}
					_contentViewerView.container.scaleX += deltaZoom;
					_contentViewerView.container.scaleY += deltaZoom;
					deltaX = ( - _contentViewerView.container.x + _contentViewerView.containerMask.width * 0.5) * 
					( _contentViewerView.container.scaleX / (_contentViewerView.container.scaleX + deltaZoom)  - 1);
					deltaY = ( - _contentViewerView.container.y + _contentViewerView.containerMask.height * 0.5) * 
					( _contentViewerView.container.scaleX / (_contentViewerView.container.scaleX + deltaZoom) - 1);
				}
			}
			
			if (_contentViewerView.container.x + deltaX < 0) {
				if (_contentViewerView.container.x + deltaX > _contentViewerView.containerMask.width - _contentViewerView.container.width) {
					_contentViewerView.container.x += deltaX;
				}else {
					_contentViewerView.container.x = _contentViewerView.containerMask.width - _contentViewerView.container.width;
					deltaX = 0;
					focusX = NaN;
				}
			}else{
				_contentViewerView.container.x = 0;
				deltaX = 0;
				focusX = NaN;
			}
			if (_contentViewerView.container.y + deltaY < 0) {
				if (_contentViewerView.container.y + deltaY > _contentViewerView.containerMask.height - _contentViewerView.container.height) {
					_contentViewerView.container.y += deltaY;
				}else {
					_contentViewerView.container.y = _contentViewerView.containerMask.height - _contentViewerView.container.height;
					deltaY = 0;
					focusY = NaN;
				}
			}else{
				_contentViewerView.container.y = 0;
				deltaY = 0;
				focusY = NaN;
			}
			
			if (focusActive && isNaN(focusX) && isNaN(focusY)) {
				focusActive = false;
				onFocus = true;
				if(!_contentViewerView.contentViewerData.mouseOver){
					_module.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
			
			if (onFocus && deltaX!=0 && deltaY!=0){
				onFocus = false;
				for (var i:int; i < _contentViewerView.container.numChildren; i++) {
					_contentViewerView.container.getChildAt(0).dispatchEvent(new ContentViewerEvent(ContentViewerEvent.FOCUS_LOST));
				}
			}
		}
	}
}