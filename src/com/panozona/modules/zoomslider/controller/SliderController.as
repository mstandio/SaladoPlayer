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
	
	import com.panozona.modules.zoomslider.events.SliderEvent;
	import com.panozona.modules.zoomslider.view.SliderView;
	import com.panozona.player.module.data.property.Size;
	import com.panozona.player.module.Module;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	public class SliderController {
		
		private var _sliderView:SliderView;
		private var _module:Module;
		
		private var cameraKeyBindingsClass:Class;
		private var cameraEventClass:Class;
		
		private var currentFov:Number;
		
		public function SliderController(sliderView:SliderView, module:Module) {
			_sliderView = sliderView;
			_module = module;
			
			cameraKeyBindingsClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.model.CameraKeyBindings") as Class;
			cameraEventClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.CameraEvent") as Class;
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onLimitsChange, false, 0, true);
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, onLimitsChange, false, 0, true);
			
			var elementsLoader:Loader = new Loader();
			elementsLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, elementsImageLost, false, 0, true);
			elementsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, elementsImageLoaded, false, 0, true);
			elementsLoader.load(new URLRequest(_sliderView.sliderData.slider.path));
		}
		
		private function onLimitsChange(event:Object):void {
			_sliderView.sliderData.minFov = _module.saladoPlayer.manager.maximumFieldOfView;
			_sliderView.sliderData.maxFov = _module.saladoPlayer.manager.minimumFieldOfView;
			currentFov = _module.saladoPlayer.manager.fieldOfView;
			translateValueToPosition();
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
			
			_sliderView.sliderData.addEventListener(SliderEvent.CHANGED_ZOOM, handleZoomChange, false, 0, true);
			_sliderView.sliderData.addEventListener(SliderEvent.CHANGED_FOV_LIMIT, handleFovLimitsChange, false, 0, true);
			_sliderView.sliderData.addEventListener(SliderEvent.CHANGED_MOUSE_DRAG, handleMouseDragChange, false, 0, true);
			_sliderView.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			
			if (_sliderView.sliderData.slider.listenKeys){
				_module.saladoPlayer.stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownEvent, false, 0, true);
				_module.saladoPlayer.stage.addEventListener( KeyboardEvent.KEY_UP, keyUpEvent, false, 0, true);
			}
		}
		
		private function handleZoomChange(e:SliderEvent):void {
			if (_sliderView.sliderData.zoomIn) {
				_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, cameraKeyBindingsClass.IN));
				_sliderView.showZoomIn();
			}else if (_sliderView.sliderData.zoomOut) {
				_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, cameraKeyBindingsClass.OUT));
				_sliderView.showZoomOut();
			}else {
				_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, cameraKeyBindingsClass.IN));
				_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, cameraKeyBindingsClass.OUT));
				_sliderView.showZoomStop();
			}
		}
		
		private function handleFovLimitsChange(e:SliderEvent):void {
			translateValueToPosition();
		}
		
		private function handleMouseDragChange(e:SliderEvent):void {
			if(_sliderView.sliderData.mouseDrag == true){ // handle autorotation
				_module.saladoPlayer.manager.dispatchEvent(new cameraEventClass(cameraEventClass.ACTIVE));
			}else {
				_module.saladoPlayer.manager.dispatchEvent(new cameraEventClass(cameraEventClass.INACTIVE));
			}
		}
		
		private function onEnterFrame(e:Event):void {
			if (currentFov != _module.saladoPlayer.manager.fieldOfView) {
				currentFov = _module.saladoPlayer.manager.fieldOfView;
				translateValueToPosition();
			}
			if (_sliderView.sliderData.mouseDrag) {
				if (_sliderView.bar.mouseY <= _sliderView.pointer.height * 0.5){
					_sliderView.pointer.y = 0;
				}else if (_sliderView.bar.mouseY >= _sliderView.bar.height - _sliderView.pointer.height * 0.5){
					_sliderView.pointer.y = _sliderView.bar.height - _sliderView.pointer.height;
				}else {
					_sliderView.pointer.y = _sliderView.bar.mouseY - _sliderView.pointer.height * 0.5;
				}
				currentFov = _module.saladoPlayer.manager.fieldOfView;
				translatePositionToValue();
			}
		}
		
		private function translatePositionToValue():void {
			if (isNaN(_sliderView.sliderData.minFov) || isNaN(_sliderView.sliderData.maxFov) || isNaN(currentFov)) return;
			_module.saladoPlayer.manager.fieldOfView = (_sliderView.sliderData.maxFov - _sliderView.sliderData.minFov) *
			(1 - (_sliderView.pointer.y) / (_sliderView.bar.height - _sliderView.pointer.height)) +
			_sliderView.sliderData.minFov;
		}
		
		private function translateValueToPosition():void {
			if (isNaN(_sliderView.sliderData.minFov) || isNaN(_sliderView.sliderData.maxFov) || isNaN(currentFov)) return;
			_sliderView.pointer.y = -(((currentFov - _sliderView.sliderData.minFov) /
			(_sliderView.sliderData.maxFov - _sliderView.sliderData.minFov)) - 1) *
				(_sliderView.bar.height - _sliderView.pointer.height);
		}
		
		private function keyDownEvent(e:KeyboardEvent):void {
			switch(e.keyCode){
				case cameraKeyBindingsClass.IN:
					_sliderView.showZoomIn();
				break;
				case cameraKeyBindingsClass.OUT:
					_sliderView.showZoomOut();
				break;
			}
		}
		
		private function keyUpEvent(e:KeyboardEvent):void {
			switch(e.keyCode){
				case cameraKeyBindingsClass.IN:
					_sliderView.showZoomStop();
				break;
				case cameraKeyBindingsClass.OUT:
					_sliderView.showZoomStop();
				break;
			}
		}
	}
}