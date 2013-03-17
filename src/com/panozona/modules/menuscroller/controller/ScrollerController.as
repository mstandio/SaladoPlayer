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
package com.panozona.modules.menuscroller.controller{
	
	import com.panozona.modules.menuscroller.events.ElementEvent;
	import com.panozona.modules.menuscroller.events.ScrollerEvent;
	import com.panozona.modules.menuscroller.events.WindowEvent;
	import com.panozona.modules.menuscroller.model.ElementData;
	import com.panozona.modules.menuscroller.model.structure.Element;
	import com.panozona.modules.menuscroller.model.structure.Group;
	import com.panozona.modules.menuscroller.model.structure.RawElement;
	import com.panozona.modules.menuscroller.view.ElementView;
	import com.panozona.modules.menuscroller.view.ScrollerView;
	import com.panozona.player.module.Module;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	public class ScrollerController {
		
		private var _scrollerView:ScrollerView;
		private var _module:Module;
		
		private var elementControlers:Vector.<ElementController>;
		private var elementsView:Vector.<ElementView>;
		
		private var difference:Number;
		private var focusPoint:Number;
		
		public function ScrollerController(scrollerView:ScrollerView, module:Module){
			_scrollerView = scrollerView;
			_module = module;
			
			elementControlers = new Vector.<ElementController>();
			elementsView = new Vector.<ElementView>();
			
			_scrollerView.menuScrollerData.scrollerData.addEventListener(ScrollerEvent.CHANGED_CURRENT_GROUP_ID, handleCurrentGroupIdChange, false, 0, true);
			_scrollerView.menuScrollerData.scrollerData.addEventListener(ScrollerEvent.CHANGED_MOUSE_OVER, handleMouseOverChange, false, 0, true);
			_scrollerView.menuScrollerData.windowData.addEventListener(WindowEvent.CHANGED_CURRENT_SIZE, handleWindowSizeChange, false, 0, true);
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			
			handleWindowSizeChange();
		}
		
		private function onPanoramaLoaded(loadPanoramaEvent:Object):void {
			for each(var group:Group in _scrollerView.menuScrollerData.scrollerData.groups.getChildrenOfGivenClass(Group)) {
				for each(var element:Element in group.getChildrenOfGivenClass(Element)) {
					if (_module.saladoPlayer.manager.currentPanoramaData.id == element.target) {
						_scrollerView.menuScrollerData.scrollerData.currentGroupId = group.id;
						return;
					}
				}
			}
			if(_scrollerView.menuScrollerData.scrollerData.currentGroupId == null){
				_scrollerView.menuScrollerData.scrollerData.currentGroupId = (_scrollerView.menuScrollerData.scrollerData.groups.getChildrenOfGivenClass(Group)[0]).id;
			}
		}
		
		private function handleCurrentGroupIdChange(e:Event):void {
			while (_scrollerView.elementsContainer.numChildren) {
				_scrollerView.elementsContainer.removeChildAt(0);
			}
			while (elementsView.length) {
				elementsView.pop();
			}
			while (elementControlers.length) {
				elementControlers.pop(); 
			}
			
			var currentGroup:Group = _scrollerView.menuScrollerData.scrollerData.getGroupById(_scrollerView.menuScrollerData.scrollerData.currentGroupId);
			
			var elementData:ElementData;
			var elementView:ElementView;
			var elementController:ElementController;
			
			for each (var rawElement:RawElement in currentGroup.getAllChildren()) {
				elementData = new ElementData(rawElement);
				elementData.addEventListener(ElementEvent.CHANGED_IS_LOADED, onElementLoaded, false, 0, true);
				elementData.addEventListener(ElementEvent.CHANGED_IS_ACTIVE, onElementActive, false, 0, true);
				elementView = new ElementView(_scrollerView.menuScrollerData, elementData);
				_scrollerView.elementsContainer.addChild(elementView);
				elementController = new ElementController(elementView, _module);
				elementControlers.push(elementController);
				elementsView.push(elementView);
			}
		}
		
		private function handleWindowSizeChange(e:Object = null):void {
			if (_scrollerView.menuScrollerData.scrollerData.scrollsVertical) {
				_scrollerView.menuScrollerData.scrollerData.sizeLimit = (_scrollerView.menuScrollerData.windowData.currentSize.width - 
					_scrollerView.menuScrollerData.scrollerData.scroller.padding * 2);
			}else {
				_scrollerView.menuScrollerData.scrollerData.sizeLimit = (_scrollerView.menuScrollerData.windowData.currentSize.height -
					_scrollerView.menuScrollerData.scrollerData.scroller.padding * 2);
			}
			for each(var elementController:ElementController in elementControlers) {
				elementController.recaluclateSize();
			}
			recalulateTotalSize();
			
			// draw mask
			_scrollerView.elementsContainerMask.graphics.clear();
			_scrollerView.elementsContainerMask.graphics.beginFill(0x000000);
			_scrollerView.elementsContainerMask.graphics.drawRect(0, 0, 
				_scrollerView.menuScrollerData.windowData.currentSize.width,
				_scrollerView.menuScrollerData.windowData.currentSize.height);
			_scrollerView.elementsContainerMask.graphics.endFill();
			
			// place container
			if (_scrollerView.menuScrollerData.scrollerData.scrollsVertical) {
				_scrollerView.elementsContainer.x = (_scrollerView.menuScrollerData.windowData.currentSize.width -
					_scrollerView.menuScrollerData.scrollerData.sizeLimit) * 0.5;
				if(_scrollerView.menuScrollerData.windowData.currentSize.height > _scrollerView.menuScrollerData.scrollerData.totalSize){
					_scrollerView.elementsContainer.y = (_scrollerView.menuScrollerData.windowData.currentSize.height -
						_scrollerView.menuScrollerData.scrollerData.totalSize) * 0.5;
				} else if (_scrollerView.elementsContainer.y + _scrollerView.menuScrollerData.scrollerData.totalSize < _scrollerView.menuScrollerData.windowData.currentSize.height) {
					_scrollerView.elementsContainer.y = _scrollerView.menuScrollerData.windowData.currentSize.height - _scrollerView.menuScrollerData.scrollerData.totalSize;
				} else if (_scrollerView.elementsContainer.y > 0) {
					_scrollerView.elementsContainer.y = 0;
				}
			} else {
				_scrollerView.elementsContainer.y = (_scrollerView.menuScrollerData.windowData.currentSize.height -
					_scrollerView.menuScrollerData.scrollerData.sizeLimit) * 0.5;
				if (_scrollerView.menuScrollerData.windowData.currentSize.width > _scrollerView.menuScrollerData.scrollerData.totalSize) {
					_scrollerView.elementsContainer.x = (_scrollerView.menuScrollerData.windowData.currentSize.width -
						_scrollerView.menuScrollerData.scrollerData.totalSize) * 0.5;
				} else if (_scrollerView.elementsContainer.x + _scrollerView.menuScrollerData.scrollerData.totalSize < _scrollerView.menuScrollerData.windowData.currentSize.width) {
					_scrollerView.elementsContainer.x = _scrollerView.menuScrollerData.windowData.currentSize.width - _scrollerView.menuScrollerData.scrollerData.totalSize;
				} else if (_scrollerView.elementsContainer.x > 0) {
					_scrollerView.elementsContainer.x = 0;
				}
				trace(_scrollerView.menuScrollerData.scrollerData.totalSize);
			}
			onEnterFrame();
		}
		
		private function onElementLoaded(e:Event = null):void {
			handleWindowSizeChange();
		}
		
		private function onElementActive(e:Event = null):void {
			handleWindowSizeChange();
		}
		
		private function recalulateTotalSize():void {
			focusPoint = NaN;
			if (elementsView.length == 0) {
				return;
			}
			var spacingStart:Number = 0;
			var spacingTmp:Number = _scrollerView.menuScrollerData.scrollerData.scroller.spacing;
			if (_scrollerView.menuScrollerData.scrollerData.scrollsVertical) {
				spacingTmp += (elementsView[0].elementData.hoverSize.height
					- elementsView[0].elementData.plainSize.height) * 0.5;
				spacingStart = spacingTmp + elementsView[0].elementData.plainSize.height * 0.5;
			} else {
				spacingTmp += (elementsView[0].elementData.hoverSize.width
					- elementsView[0].elementData.plainSize.width) * 0.5;
				spacingStart = spacingTmp + elementsView[0].elementData.plainSize.width * 0.5;
			}
			var counter:Number = spacingTmp;
			for each(var elementView:ElementView in elementsView) {
				if (_scrollerView.menuScrollerData.scrollerData.scrollsVertical) {
					elementView.x = 0;
					elementView.y = counter;
					counter += elementView.elementData.plainSize.height;
					if (elementView.elementData.isActive) {
						focusPoint = elementView.y + elementView.elementData.plainSize.height * 0.5;
					}
				} else {
					elementView.x = counter;
					elementView.y = 0;
					counter += elementView.elementData.plainSize.width;
					if (elementView.elementData.isActive) {
						focusPoint = elementView.x + elementView.elementData.plainSize.width * 0.5;
					}
				}
				counter += _scrollerView.menuScrollerData.scrollerData.scroller.spacing;
			}
			counter -= _scrollerView.menuScrollerData.scrollerData.scroller.spacing;
			
			var spacingEnd:Number = 0;
			spacingTmp = _scrollerView.menuScrollerData.scrollerData.scroller.spacing;
			if (_scrollerView.menuScrollerData.scrollerData.scrollsVertical) {
				spacingTmp += (elementsView[elementsView.length - 1].elementData.hoverSize.height 
					- elementsView[elementsView.length - 1].elementData.plainSize.height) * 0.5;
				spacingEnd = spacingTmp + elementsView[elementsView.length - 1].elementData.plainSize.height * 0.5;
			}else {
				spacingTmp += (elementsView[elementsView.length - 1].elementData.hoverSize.width
					- elementsView[elementsView.length - 1].elementData.plainSize.width) * 0.5;
				spacingEnd = spacingTmp + elementsView[elementsView.length - 1].elementData.plainSize.width * 0.5;
			}
			counter += spacingTmp;
			_scrollerView.menuScrollerData.scrollerData.totalSize = counter;
			if (!isNaN(focusPoint)) {
				if (focusPoint > counter * 0.5) {
					focusPoint += spacingEnd * (focusPoint - counter * 0.5) / ((counter - spacingEnd) - counter * 0.5);
				}else {
					focusPoint -= spacingStart * ((spacingStart - focusPoint) / (counter * 0.5 - spacingStart) + 1);
				}
			}
			if (_scrollerView.menuScrollerData.scrollerData.scrollsVertical) {
				difference = _scrollerView.menuScrollerData.scrollerData.totalSize -
					_scrollerView.menuScrollerData.windowData.currentSize.height;
			} else {
				difference = _scrollerView.menuScrollerData.scrollerData.totalSize -
					_scrollerView.menuScrollerData.windowData.currentSize.width;
			}
		}
		
		private function handleMouseOverChange(e:Event = null):void {
			if (_scrollerView.menuScrollerData.scrollerData.mouseOver) {
				_module.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}
		}
		
		private function onEnterFrame(e:Event = null):void {
			var speed:Number = _scrollerView.menuScrollerData.scrollerData.scroller.speed; 
			var targetPosition:Number = 0;
			var shift:Number = 0;
			if (_scrollerView.menuScrollerData.scrollerData.scrollsVertical) {
				if (_scrollerView.menuScrollerData.windowData.currentSize.height > _scrollerView.menuScrollerData.scrollerData.totalSize){
					targetPosition = (_scrollerView.menuScrollerData.windowData.currentSize.height -
						_scrollerView.menuScrollerData.scrollerData.totalSize) * 0.5;
				}else  if(_scrollerView.menuScrollerData.scrollerData.mouseOver){
					targetPosition = -difference * _scrollerView.mouseY /
						_scrollerView.menuScrollerData.windowData.currentSize.height;
				}else if (!isNaN(focusPoint)){
					targetPosition = -difference * focusPoint / _scrollerView.menuScrollerData.scrollerData.totalSize;
				}
				if (Math.abs(targetPosition - _scrollerView.elementsContainer.y) < 1 && !_scrollerView.menuScrollerData.scrollerData.mouseOver) {
					_module.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					return;
				}
				shift = speed * Math.abs(targetPosition - _scrollerView.elementsContainer.y);
				if (targetPosition < _scrollerView.elementsContainer.y) {
					if (targetPosition > _scrollerView.elementsContainer.y - shift) {
						_scrollerView.elementsContainer.y = targetPosition
					} else {
						_scrollerView.elementsContainer.y -= shift;
					}
				} else {
					if (targetPosition < _scrollerView.elementsContainer.y + shift) {
						_scrollerView.elementsContainer.y = targetPosition;
					} else {
						_scrollerView.elementsContainer.y += shift;
					}
				}
			} else {
				if(_scrollerView.menuScrollerData.windowData.currentSize.width > _scrollerView.menuScrollerData.scrollerData.totalSize){
					targetPosition = (_scrollerView.menuScrollerData.windowData.currentSize.width -
						_scrollerView.menuScrollerData.scrollerData.totalSize) * 0.5;
				}else if(_scrollerView.menuScrollerData.scrollerData.mouseOver){
					targetPosition = -difference * _scrollerView.mouseX /
						_scrollerView.menuScrollerData.windowData.currentSize.width;
				}else if (!isNaN(focusPoint)) {
					targetPosition = -difference * focusPoint / _scrollerView.menuScrollerData.scrollerData.totalSize;
				}
				if (Math.abs(targetPosition - _scrollerView.elementsContainer.x ) < 1 && !_scrollerView.menuScrollerData.scrollerData.mouseOver) {
					_module.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					return;
				}
				shift = speed * Math.abs(targetPosition - _scrollerView.elementsContainer.x);
				if (targetPosition < _scrollerView.elementsContainer.x) {
					if (targetPosition > _scrollerView.elementsContainer.x - shift) {
						_scrollerView.elementsContainer.x = targetPosition
					} else {
						_scrollerView.elementsContainer.x -= shift;
					}
				} else {
					if (targetPosition < _scrollerView.elementsContainer.x + shift) {
						_scrollerView.elementsContainer.x = targetPosition;
					} else {
						_scrollerView.elementsContainer.x += shift;
					}
				}
			}
		}
	}
}