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
	import com.panozona.modules.menuscroller.model.ElementData;
	import com.panozona.modules.menuscroller.model.structure.Element;
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
		
		public function ScrollerController(scrollerView:ScrollerView, module:Module){
			_scrollerView = scrollerView;
			_module = module;
			
			elementControlers = new Vector.<ElementController>();
			elementsView = new Vector.<ElementView>();
			
			var elementData:ElementData;
			var elementView:ElementView;
			var elementController:ElementController;
			for each (var element:Element in _scrollerView.menuScrollerData.elements.getChildrenOfGivenClass(Element)) {
				elementData = new ElementData(element, _scrollerView.menuScrollerData.scrollerData.scroller);
				elementView = new ElementView(elementData);
				scrollerView.elementsContainer.addChild(elementView);
				elementController = new ElementController(elementView, _module);
				elementControlers.push(elementController);
				elementsView.push(elementView);
				
				elementData.addEventListener(ElementEvent.CHANGED_SIZE, onElementSizeChanged, false, 0, true);
			}
			onElementSizeChanged();
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			handleResize();
		}
		
		private function handleResize(e:Object = null):void {
			// determine size
			// place in the middle...
		}
		
		private function onElementSizeChanged(e:Event = null):void {
			var counter:int = 0;
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
				counter += _scrollerView.menuScrollerData.scrollerData.scroller.spacing;
				elementView.elementData.isShowing = true; // TODO: this needs to be calculated
			}
		}
		
		private function replaceElements():void {
			// czyli po zaladowaniu i okresleniu rozmiaru 
		}
	}
}