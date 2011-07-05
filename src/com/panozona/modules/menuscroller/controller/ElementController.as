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
package com.panozona.modules.menuscroller.controller {
	
	import caurina.transitions.Tweener;
	import com.panozona.modules.menuscroller.events.ElementEvent;
	import com.panozona.modules.menuscroller.model.ElementData;
	import com.panozona.modules.menuscroller.view.ElementView;
	import com.panozona.player.module.data.property.Size;
	import com.panozona.player.module.Module;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	public class ElementController {
		
		private var contentInitScale:Number;
		
		private var _elementView:ElementView;
		private var _module:Module;
		
		public function ElementController(elementView:ElementView, module:Module) {
			_elementView = elementView;
			_module = module;
			
			elementView.elementData.addEventListener(ElementEvent.CHANGED_IS_SHOWING, handleIsShowingChange, false, 0, true);
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
		}
		
		private function onPanoramaLoaded(panoramaEvent:Object):void {
			if (_module.saladoPlayer.manager.currentPanoramaData.id == _elementView.elementData.element.target) {
				_elementView.elementData.isActive = true;
			}else {
				_elementView.elementData.isActive = false;
			}
		}
		
		private function handleIsShowingChange(e:Event):void {
			if (_elementView.elementData.isShowing) {
				if (_elementView.elementData.loaded) {
					_elementView.visible = true;
				}else {
					var imageLoader:Loader = new Loader();
					imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLost, false, 0, true);
					imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded, false, 0, true);
					imageLoader.load(new URLRequest(_elementView.elementData.element.path));
					_elementView.elementData.loaded = true;
				}
			}else {
				_elementView.visible = false;
			}
		}
		
		private function imageLost(error:IOErrorEvent):void {
			error.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLost);
			error.target.removeEventListener(Event.COMPLETE, imageLoaded);
			_module.printError(error.text);
		}
		
		private function imageLoaded(e:Event):void {
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLost);
			e.target.removeEventListener(Event.COMPLETE, imageLoaded);
			
			var displayObject:DisplayObject = e.target.content;
			
			var size:Size = new Size(
				_elementView.elementData.scroller.scrollsVertical ? _elementView.elementData.scroller.sizeLimit : NaN,
				_elementView.elementData.scroller.scrollsVertical ? NaN : _elementView.elementData.scroller.sizeLimit);
			
			if (_elementView.elementData.scroller.scrollsVertical) { // constant width
				size.height = (displayObject.height * _elementView.elementData.scroller.sizeLimit) / displayObject.width;
				displayObject.scaleX = displayObject.scaleY = size.height / displayObject.height;
			} else { // constant height
				size.width = (displayObject.width * _elementView.elementData.scroller.sizeLimit) / displayObject.height;
				displayObject.scaleX = displayObject.scaleY = size.width / displayObject.width;
			}
			contentInitScale = displayObject.scaleX;
			_elementView.elementData.size = size; // ScrollerController listenes to size change
			_elementView.content = displayObject;
			
			_elementView.addEventListener(MouseEvent.CLICK, handleMouseClick, false, 0, true);
			
			_elementView.elementData.addEventListener(ElementEvent.CHANGED_IS_ACTIVE, handleMouseOverChange, false, 0, true);
			_elementView.elementData.addEventListener(ElementEvent.CHANGED_MOUSE_OVER, handleMouseOverChange, false, 0, true);
			handleMouseOverChange();
		}
		
		private function handleMouseClick(e:Event):void {
			if (_module.saladoPlayer.manager.currentPanoramaData.id != _elementView.elementData.element.target){
				_module.saladoPlayer.manager.loadPano(_elementView.elementData.element.target);
			}
		}
		
		private function handleMouseOverChange(e:Event = null):void {
			if (_elementView.elementData.mouseOver) {
				onHover();
			}else {
				onPlain();
			}
		}
		
		private function onPlain():void {
			if (_elementView.elementData.isActive) {
				Tweener.addTween(_elementView._content, {
					scaleX: contentInitScale * ((_elementView.elementData.scroller.mouseOver.scale - 1)/2 + 1),
					scaleY: contentInitScale * ((_elementView.elementData.scroller.mouseOver.scale - 1)/2 + 1),
					x: -_elementView.elementData.size.width * ((_elementView.elementData.scroller.mouseOver.scale - 1)/2 + 1) * 0.5,
					y: -_elementView.elementData.size.height * ((_elementView.elementData.scroller.mouseOver.scale - 1)/2 + 1) * 0.5,
					time:_elementView.elementData.scroller.mouseOut.time * 0.5,
					transition:_elementView.elementData.scroller.mouseOut.transition
				});
			}else{
				Tweener.addTween(_elementView._content, {
					scaleX: contentInitScale,
					scaleY: contentInitScale,
					x: -_elementView.elementData.size.width * 0.5,
					y: -_elementView.elementData.size.height * 0.5,
					time:_elementView.elementData.scroller.mouseOut.time,
					transition:_elementView.elementData.scroller.mouseOut.transition
				});
			}
		}
		
		private function onHover():void {
			if (_elementView.elementData.isActive) {
				Tweener.addTween(_elementView._content, {
					scaleX: contentInitScale * _elementView.elementData.scroller.mouseOver.scale,
					scaleY: contentInitScale * _elementView.elementData.scroller.mouseOver.scale,
					x: -_elementView.elementData.size.width * _elementView.elementData.scroller.mouseOver.scale * 0.5,
					y: -_elementView.elementData.size.height * _elementView.elementData.scroller.mouseOver.scale * 0.5,
					time:_elementView.elementData.scroller.mouseOver.time * 0.5,
					transition:_elementView.elementData.scroller.mouseOver.transition
				});
			}else {
				Tweener.addTween(_elementView._content, {
					scaleX: contentInitScale * _elementView.elementData.scroller.mouseOver.scale,
					scaleY: contentInitScale * _elementView.elementData.scroller.mouseOver.scale,
					x: -_elementView.elementData.size.width * _elementView.elementData.scroller.mouseOver.scale * 0.5,
					y: -_elementView.elementData.size.height * _elementView.elementData.scroller.mouseOver.scale * 0.5,
					time:_elementView.elementData.scroller.mouseOver.time,
					transition:_elementView.elementData.scroller.mouseOver.transition
				});
			}
		}
	}
}