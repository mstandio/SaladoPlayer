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
package com.panozona.modules.menuscroller.controller{
	
	import com.panozona.modules.menuscroller.events.ElementEvent;
	import com.panozona.modules.menuscroller.events.ScrollerEvent;
	import com.panozona.modules.menuscroller.events.WindowEvent;
	import com.panozona.modules.menuscroller.model.ElementData;
	import com.panozona.modules.menuscroller.model.structure.Element;
	import com.panozona.modules.menuscroller.model.structure.RawElement;
	import com.panozona.modules.menuscroller.view.ElementView;
	import com.panozona.modules.menuscroller.view.ScrollerView;
	import com.panozona.player.module.Module;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ScrollerController {
		
		private var _scrollerView:ScrollerView;
		private var _module:Module;
		
		private var elementControlers:Vector.<ElementController>;
		private var elementsView:Vector.<ElementView>;
		
		private var overDimension:Number;
		private var overOverlay:Number;
		private var difference:Number;
		
		public function ScrollerController(scrollerView:ScrollerView, module:Module){
			_scrollerView = scrollerView;
			_module = module;
			
			elementControlers = new Vector.<ElementController>();
			elementsView = new Vector.<ElementView>();
			
			overDimension = _scrollerView.menuScrollerData.scrollerData.scroller.sizeLimit * _scrollerView.menuScrollerData.scrollerData.scroller.mouseOver.scale;
			overOverlay = overDimension - _scrollerView.menuScrollerData.scrollerData.scroller.sizeLimit;
			
			var elementData:ElementData;
			var elementView:ElementView;
			var elementController:ElementController;
			for each (var rawElement:RawElement in _scrollerView.menuScrollerData.elements.getAllChildren()) {
				elementData = new ElementData(rawElement, _scrollerView.menuScrollerData.scrollerData.scroller);
				elementView = new ElementView(elementData);
				scrollerView.elementsContainer.addChild(elementView);
				elementController = new ElementController(elementView, _module);
				elementControlers.push(elementController);
				elementsView.push(elementView);
				
				elementData.addEventListener(ElementEvent.CHANGED_SIZE, onElementSizeChanged, false, 0, true);
				
				if (rawElement.mouse.onOver != null) {
					elementView.addEventListener(MouseEvent.ROLL_OVER, getMouseEventHandler(rawElement.mouse.onOver));
				}
				if (rawElement.mouse.onOut != null) {
					elementView.addEventListener(MouseEvent.ROLL_OUT, getMouseEventHandler(rawElement.mouse.onOut));
				}
			}
			
			_scrollerView.menuScrollerData.windowData.addEventListener(WindowEvent.CHANGED_ELASTIC_WIDTH, handleResize, false, 0, true);
			_scrollerView.menuScrollerData.windowData.addEventListener(WindowEvent.CHANGED_ELASTIC_HEIGHT, handleResize, false, 0, true);
			onElementSizeChanged();
			
			_scrollerView.menuScrollerData.scrollerData.addEventListener(ScrollerEvent.CHANGED_TOTAL_SIZE, handleResize, false, 0, true);
			
			_scrollerView.menuScrollerData.scrollerData.addEventListener(ScrollerEvent.CHANGED_MOUSE_OVER, handleMouseOverChange, false, 0, true);
		}
		
		private function getMouseEventHandler(actionId:String):Function{
			return function(e:MouseEvent):void {
				_module.saladoPlayer.manager.runAction(actionId);
			}
		}
		
		private function handleResize(e:Object = null):void {
			if (_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical) {
				_scrollerView.elementsContainer.x = (_scrollerView.menuScrollerData.windowData.window.size.width -
					_scrollerView.menuScrollerData.scrollerData.scroller.sizeLimit) * 0.5;
					
				_scrollerView.elementsContainer.y = _scrollerView.menuScrollerData.scrollerData.scrollValue +
					(_scrollerView.menuScrollerData.windowData.elasticHeight -
					_scrollerView.menuScrollerData.scrollerData.totalSize) * 0.5;
			}else {
				_scrollerView.elementsContainer.y = (_scrollerView.menuScrollerData.windowData.window.size.height -
					_scrollerView.menuScrollerData.scrollerData.scroller.sizeLimit) * 0.5;
					
				_scrollerView.elementsContainer.x = _scrollerView.menuScrollerData.scrollerData.scrollValue +
					(_scrollerView.menuScrollerData.windowData.elasticWidth -
					_scrollerView.menuScrollerData.scrollerData.totalSize) * 0.5;
			}
			
			// draw mask 
			_scrollerView.elementsContainerMask.graphics.clear();
			_scrollerView.elementsContainerMask.graphics.beginFill(0x000000);
			if (_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical) {
				_scrollerView.elementsContainerMask.graphics.drawRect(
					-(overDimension - _scrollerView.menuScrollerData.windowData.elasticWidth) * 0.5,
					0,
					overDimension,
					_scrollerView.menuScrollerData.windowData.elasticHeight);
			}else {
				_scrollerView.elementsContainerMask.graphics.drawRect(
				0,
				-(overDimension - _scrollerView.menuScrollerData.windowData.elasticHeight) * 0.5,
				_scrollerView.menuScrollerData.windowData.elasticWidth,
					overDimension);
			}
			_scrollerView.elementsContainerMask.graphics.endFill();
			
			if (_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical) {
				difference = _scrollerView.menuScrollerData.scrollerData.totalSize -
					_scrollerView.menuScrollerData.windowData.elasticHeight;
			}else {
				difference = _scrollerView.menuScrollerData.scrollerData.totalSize -
					_scrollerView.menuScrollerData.windowData.elasticWidth;
			}
		}
		
		private function onElementSizeChanged(e:Event = null):void {
			var counter:Number = _scrollerView.menuScrollerData.scrollerData.scroller.spacing * 3;
			if (_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical) {
				counter += ((elementsView[0].elementData.size.height * 
					_scrollerView.menuScrollerData.scrollerData.scroller.mouseOver.scale) -
					elementsView[0].elementData.size.height) * 0.5;
			}else {
				counter += ((elementsView[0].elementData.size.width *
					_scrollerView.menuScrollerData.scrollerData.scroller.mouseOver.scale) -
					elementsView[0].elementData.size.width) * 0.5;
			}
			for each(var elementView:ElementView in elementsView) {
				if (_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical) {
					elementView.x = 0;
					elementView.y = counter;
					counter += elementView.elementData.size.height;
				}else {
					elementView.x = counter;
					elementView.y = 0;
					counter += elementView.elementData.size.width
				}
				counter += _scrollerView.menuScrollerData.scrollerData.scroller.spacing * 3;
				elementView.elementData.isShowing = true; // TODO: should be calculated for "lazy loading"
			}
			if (_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical) {
				counter += ((elementsView[elementsView.length -1].elementData.size.height *
					_scrollerView.menuScrollerData.scrollerData.scroller.mouseOver.scale) -
					elementsView[elementsView.length -1].elementData.size.height) * 0.5;
			}else {
				counter += ((elementsView[elementsView.length -1].elementData.size.width *
					_scrollerView.menuScrollerData.scrollerData.scroller.mouseOver.scale) -
					elementsView[elementsView.length -1].elementData.size.width) * 0.5;
			}
			_scrollerView.menuScrollerData.scrollerData.totalSize = counter;
			
			// draw transparent rectangle under elements for mouse interaction
			_scrollerView.elementsContainer.graphics.clear();
			_scrollerView.elementsContainer.graphics.beginFill(0x000000, 0);
			if (_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical) {
				_scrollerView.elementsContainer.graphics.drawRect(-overOverlay * 0.5, 0,
					overDimension,
					_scrollerView.menuScrollerData.scrollerData.totalSize);
			}else {
				_scrollerView.elementsContainer.graphics.drawRect(0, -overOverlay * 0.5,
					_scrollerView.menuScrollerData.scrollerData.totalSize,
					overDimension);
			}
			_scrollerView.elementsContainer.graphics.endFill();
		}
		
		private function handleMouseOverChange(e:Event):void {
			if(_scrollerView.menuScrollerData.scrollerData.mouseOver && difference > 0){
				_module.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}else {
				_module.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function onEnterFrame(e:Event):void {
			if (_scrollerView.menuScrollerData.scrollerData.scroller.scrollsVertical) {
				_scrollerView.elementsContainer.y = -(difference) * _scrollerView.mouseY /
					_scrollerView.menuScrollerData.windowData.elasticHeight;
			}else {
				_scrollerView.elementsContainer.x = -(difference) * _scrollerView.mouseX /
					_scrollerView.menuScrollerData.windowData.elasticWidth;
			}
		}
	}
}