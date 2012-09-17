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
		
		public function ScrollerController(scrollerView:ScrollerView, module:Module){
			_scrollerView = scrollerView;
			_module = module;
			
			elementControlers = new Vector.<ElementController>();
			elementsView = new Vector.<ElementView>();
			
			_scrollerView.menuScrollerData.scrollerData.addEventListener(ScrollerEvent.CHANGED_CURRENT_GROUP_ID, handleCurrentGroupIdChange, false, 0, true);
			_scrollerView.menuScrollerData.scrollerData.addEventListener(ScrollerEvent.CHANGED_TOTAL_SIZE, handleWindowSizeChange, false, 0, true);
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
				if (elementData.rawElement is Element && (elementData.rawElement as Element).target == _module.saladoPlayer.manager.currentPanoramaData.id) {
					elementData.isActive = true;
				}
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
			
			// data for container position
			if (_scrollerView.menuScrollerData.scrollerData.scrollsVertical) {
				difference = _scrollerView.menuScrollerData.scrollerData.totalSize -
					_scrollerView.menuScrollerData.windowData.currentSize.height;
			} else {
				difference = _scrollerView.menuScrollerData.scrollerData.totalSize -
					_scrollerView.menuScrollerData.windowData.currentSize.width;
			}
			
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
			}
		}
		
		private function onElementLoaded(e:Event = null):void {
			recalulateTotalSize();
		}
		
		private function recalulateTotalSize():void {
			if (elementsView.length == 0) {
				return;
			}
			var counter:Number = _scrollerView.menuScrollerData.scrollerData.scroller.spacing * 3;
			if (_scrollerView.menuScrollerData.scrollerData.scrollsVertical) {
				counter += (elementsView[0].elementData.hoverSize.height
					- elementsView[0].elementData.plainSize.height) * 0.5;
			} else {
				counter += (elementsView[0].elementData.hoverSize.width
					- elementsView[0].elementData.plainSize.width) * 0.5;
			}
			for each(var elementView:ElementView in elementsView) {
				if (_scrollerView.menuScrollerData.scrollerData.scrollsVertical) {
					elementView.x = 0;
					elementView.y = counter;
					counter += elementView.elementData.plainSize.height;
				} else {
					elementView.x = counter;
					elementView.y = 0;
					counter += elementView.elementData.plainSize.width
				}
				counter += _scrollerView.menuScrollerData.scrollerData.scroller.spacing * 2;
			}
			counter += _scrollerView.menuScrollerData.scrollerData.scroller.spacing;
			if (_scrollerView.menuScrollerData.scrollerData.scrollsVertical) {
				counter += (elementsView[elementsView.length - 1].elementData.hoverSize.height 
					- elementsView[elementsView.length - 1].elementData.plainSize.height) * 0.5;
			}else {
				counter += (elementsView[elementsView.length - 1].elementData.hoverSize.width
					- elementsView[elementsView.length - 1].elementData.plainSize.width) * 0.5;
			}
			_scrollerView.menuScrollerData.scrollerData.totalSize = counter;
		}
		
		private function handleMouseOverChange(e:Event):void {
			if(_scrollerView.menuScrollerData.scrollerData.mouseOver && difference > 0){
				_module.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}else {
				_module.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function onEnterFrame(e:Event = null):void {
			var targetPosition:Number = NaN;
			var speed:Number = NaN;
			var shift:Number = NaN;
			if (_scrollerView.menuScrollerData.scrollerData.scrollsVertical) {
				speed = _scrollerView.menuScrollerData.windowData.currentSize.height * 0.1;
				targetPosition = -difference * _scrollerView.mouseY /
					_scrollerView.menuScrollerData.windowData.currentSize.height;
				shift = speed * Math.abs(targetPosition - _scrollerView.elementsContainer.y) / difference;
				if (Math.abs(targetPosition - _scrollerView.elementsContainer.y ) < 1) return;
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
				speed = _scrollerView.menuScrollerData.windowData.currentSize.width * 0.1;
				targetPosition = -difference * _scrollerView.mouseX /
					_scrollerView.menuScrollerData.windowData.currentSize.width;
				shift = speed * Math.abs(targetPosition - _scrollerView.elementsContainer.x) / difference;
				if (Math.abs(targetPosition - _scrollerView.elementsContainer.x ) < 1) return;
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