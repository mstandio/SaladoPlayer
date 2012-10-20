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
package com.panozona.modules.menuscroller.controller {
	
	import caurina.transitions.Tweener;
	import com.panozona.modules.menuscroller.events.ElementEvent;
	import com.panozona.modules.menuscroller.model.structure.Element;
	import com.panozona.modules.menuscroller.model.structure.ExtraElement;
	import com.panozona.modules.menuscroller.model.structure.Scroller;
	import com.panozona.modules.menuscroller.view.ElementView;
	import com.panozona.player.module.data.property.Size;
	import com.panozona.player.module.Module;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	public class ElementController {
		
		private var initSize:Size; 
		private var plainScale:Number;
		private var hoverScale:Number;
		
		private var _elementView:ElementView;
		private var _module:Module;
		
		public function ElementController(elementView:ElementView, module:Module) {
			_elementView = elementView;
			_module = module;
			
			initSize = new Size(1, 1);
			hoverScale = 1;
			
			if (elementView.elementData.rawElement is Element){
				var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
				_module.saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			}
			if (elementView.elementData.rawElement.mouse.onOver != null) {
				elementView.addEventListener(MouseEvent.ROLL_OVER, getMouseEventHandler(elementView.elementData.rawElement.mouse.onOver));
			}
			if (elementView.elementData.rawElement.mouse.onOut != null) {
				elementView.addEventListener(MouseEvent.ROLL_OUT, getMouseEventHandler(elementView.elementData.rawElement.mouse.onOut));
			}
			
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLost, false, 0, true);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded, false, 0, true);
			imageLoader.load(new URLRequest(_elementView.elementData.rawElement.path));
		}
		
		private function getMouseEventHandler(actionId:String):Function {
			return function(e:MouseEvent):void {
				_module.saladoPlayer.manager.runAction(actionId);
			}
		}
		
		private function onPanoramaLoaded(panoramaEvent:Object):void {
			if (_module.saladoPlayer.manager.currentPanoramaData.id == (_elementView.elementData.rawElement as Element).target) {
				_elementView.elementData.isActive = true;
			}else {
				_elementView.elementData.isActive = false;
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
			
			_elementView.content = e.target.content;
			initSize.width = _elementView.content.width;
			initSize.height = _elementView.content.height;
			
			_elementView.addEventListener(MouseEvent.CLICK, handleMouseClick, false, 0, true);
			_elementView.elementData.addEventListener(ElementEvent.CHANGED_IS_ACTIVE, handleMouseOverChange, false, 0, true);
			_elementView.elementData.addEventListener(ElementEvent.CHANGED_MOUSE_OVER, handleMouseOverChange, false, 0, true);
			
			recaluclateSize();
			_elementView.elementData.isLoaded = true;
		}
		
		public function recaluclateSize():void {
			if (_elementView.content == null) {
				return;
			}
			var scrollsVertical:Boolean = _elementView.menuScrollerData.scrollerData.scrollsVertical;
			var plainSize:Size = new Size(
				scrollsVertical ? _elementView.menuScrollerData.scrollerData.sizeLimit : NaN,
				scrollsVertical ? NaN : _elementView.menuScrollerData.scrollerData.sizeLimit);
			if (scrollsVertical) { // constant width
				plainSize.height = (initSize.height * _elementView.menuScrollerData.scrollerData.sizeLimit) / initSize.width;
				plainScale = plainSize.height / initSize.height;
				hoverScale = _elementView.menuScrollerData.windowData.currentSize.width / plainSize.width;
			} else { // constant height
				plainSize.width = (initSize.width * _elementView.menuScrollerData.scrollerData.sizeLimit) / initSize.height;
				plainScale = plainSize.width / initSize.width;
				hoverScale = _elementView.menuScrollerData.windowData.currentSize.height / plainSize.height;
			}
			var hoverSize:Size = new Size(plainSize.width * hoverScale, plainSize.height * hoverScale);
			_elementView.applyScale(plainScale);
			_elementView.elementData.plainSize = plainSize;
			_elementView.elementData.hoverSize = hoverSize;
			
			handleMouseOverChange(null, false);
		}
		
		private function handleMouseClick(e:Event):void {
			if (_elementView.elementData.rawElement is Element){
				if (_module.saladoPlayer.manager.currentPanoramaData.id != (_elementView.elementData.rawElement as Element).target){
					_module.saladoPlayer.manager.loadPano((_elementView.elementData.rawElement as Element).target);
				}
			} else{
				_module.saladoPlayer.manager.runAction((_elementView.elementData.rawElement as ExtraElement).action);
			}
		}
		
		private function handleMouseOverChange(e:Event, useTime:Boolean = true):void {
			if (_elementView.elementData.mouseOver) {
				onHover(useTime);
			} else {
				onPlain(useTime);
			}
		}
		
		private function onPlain(useTime:Boolean):void {
			var scroller:Scroller =  _elementView.menuScrollerData.scrollerData.scroller;
			if (_elementView.elementData.isActive) {
				Tweener.addTween(_elementView.content, {
					scaleX: plainScale * ((hoverScale - 1)/2 + 1),
					scaleY: plainScale * ((hoverScale - 1)/2 + 1),
					x: -_elementView.elementData.plainSize.width * ((hoverScale - 1)/2 + 1) * 0.5,
					y: -_elementView.elementData.plainSize.height * ((hoverScale - 1)/2 + 1) * 0.5,
					time: useTime ? scroller.outTween.time * 0.5 : 0,
					transition: scroller.outTween.transition
				});
			} else {
				Tweener.addTween(_elementView.content, {
					scaleX: plainScale,
					scaleY: plainScale,
					x: -_elementView.elementData.plainSize.width * 0.5,
					y: -_elementView.elementData.plainSize.height * 0.5,
					time: useTime ? scroller.outTween.time : 0,
					transition: scroller.outTween.transition
				});
			}
		}
		
		private function onHover(useTime:Boolean):void {
			var scroller:Scroller =  _elementView.menuScrollerData.scrollerData.scroller;
			if (_elementView.elementData.isActive) {
				Tweener.addTween(_elementView.content, {
					scaleX: plainScale * hoverScale,
					scaleY: plainScale * hoverScale,
					x: -_elementView.elementData.plainSize.width * hoverScale * 0.5,
					y: -_elementView.elementData.plainSize.height * hoverScale * 0.5,
					time: useTime ? scroller.overTween.time * 0.5 : 0,
					transition: scroller.overTween.transition
				});
			} else {
				Tweener.addTween(_elementView.content, {
					scaleX: plainScale * hoverScale,
					scaleY: plainScale * hoverScale,
					y: -_elementView.elementData.plainSize.height * hoverScale * 0.5,
					x: -_elementView.elementData.plainSize.width * hoverScale * 0.5,
					time: useTime ? scroller.overTween.time : 0,
					transition: scroller.overTween.transition
				});
			}
		}
	}
}