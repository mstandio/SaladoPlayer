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
package com.panozona.modules.dropdown.controller{
	
	import com.panozona.modules.dropdown.controller.ElementController;
	import com.panozona.modules.dropdown.events.BoxEvent;
	import com.panozona.modules.dropdown.model.ElementData;
	import com.panozona.modules.dropdown.model.structure.Element;
	import com.panozona.modules.dropdown.model.structure.Elements;
	import com.panozona.modules.dropdown.view.BoxView;
	import com.panozona.modules.dropdown.view.ElementView;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.Module;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	public class BoxController {
		
		private var _boxView:BoxView;
		private var _module:Module;
		
		private var elementControllers:Vector.<ElementController>;
		
		public function BoxController(boxView:BoxView, module:Module){
			_boxView = boxView;
			_module = module;
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			
			_boxView.dropDownData.boxData.addEventListener(BoxEvent.CHANGED_CURRENT_PANORAMA_ID, handleCurrentPanoramaIdChanged, false, 0, true);
			_boxView.dropDownData.boxData.addEventListener(BoxEvent.CHANGED_OPEN, handleOpenChanged, false, 0, true);
			
			_module.stage.addEventListener(MouseEvent.MOUSE_DOWN, cickedOnStage, false, 0, true);
			
			elementControllers = new Vector.<ElementController>();
			buildElementsContainer();
		}
		
		public function handleResize(e:Event = null):void {
			if (_boxView.dropDownData.settings.align.horizontal == Align.LEFT) {
				_boxView.x = 0;
			}else if (_boxView.dropDownData.settings.align.horizontal == Align.RIGHT) {
				_boxView.x = _module.saladoPlayer.manager.boundsWidth - _boxView.width;
			}else { // CENTER
				_boxView.x = (_module.saladoPlayer.manager.boundsWidth - _boxView.width) * 0.5;
			}
			if (_boxView.dropDownData.settings.align.vertical == Align.TOP){
				_boxView.y = 0;
			}else if (_boxView.dropDownData.settings.align.vertical == Align.BOTTOM) {
				_boxView.y = _module.saladoPlayer.manager.boundsHeight - _boxView.height;
			}else { // MIDDLE
				_boxView.y = (_module.saladoPlayer.manager.boundsHeight - _boxView.height) * 0.5;
			}
			_boxView.x += _boxView.dropDownData.settings.move.horizontal;
			_boxView.y += _boxView.dropDownData.settings.move.vertical;
		}
		
		private function handleCurrentPanoramaIdChanged(e:BoxEvent):void {
			var elementView:ElementView;
			var newLabel:String = "";
			for (var i:int = 0; i < _boxView.elementsContainer.numChildren; i++) {
				elementView = _boxView.elementsContainer.getChildAt(_boxView.dropDownData.settings.style.opensUp ?
					(_boxView.elementsContainer.numChildren - 1 - i) :
					(i)) as ElementView;
				if (elementView.elementData.element.panorama == _boxView.dropDownData.boxData.currentPanoramaId) {
					elementView.elementData.state = ElementData.STATE_ACTIVE;
					newLabel = elementView.elementData.element.label;
				}else {
					if (elementView.elementData.mouseOver) {
						elementView.elementData.state = ElementData.STATE_HOVER;
					}else{
						elementView.elementData.state = ElementData.STATE_PLAIN;
					}
				}
			}
			_boxView.textField.text = newLabel;
		}
		
		private function handleOpenChanged(e:BoxEvent):void {
			_boxView.elementsContainer.visible = _boxView.dropDownData.boxData.open;
		}
		
		private function buildElementsContainer():void {
			while (_boxView.elementsContainer.numChildren) {
				_boxView.elementsContainer.removeChildAt(0);
			}
			while (elementControllers.length) {
				elementControllers.pop();
			}
			var elementView:ElementView;
			var elementController:ElementController;
			var elements:Elements = _boxView.dropDownData.boxData.elements;
			var finalWidth:Number = 0;
			for each(var element:Element in elements.getChildrenOfGivenClass(Element)) {
				elementView = new ElementView(new ElementData(element), _boxView.dropDownData);
				if (elementView.width > finalWidth) finalWidth = elementView.width;
				_boxView.elementsContainer.addChild(elementView);
				elementController = new ElementController(elementView, _module);
				elementControllers.push(elementController);
			}
			finalWidth += _boxView.button.width; 
			var lastY:Number = 0;
			for (var i:int = 0; i < _boxView.elementsContainer.numChildren; i++) {
				elementView = _boxView.elementsContainer.getChildAt(_boxView.dropDownData.settings.style.opensUp ?
					(_boxView.elementsContainer.numChildren - 1 - i) :
					(i)) as ElementView;
				elementView.y = lastY;
				lastY += (!_boxView.dropDownData.settings.style.opensUp) ?
					elementView.height :
					- elementView.height;
				elementView.width = finalWidth;
			}
			
			if (_boxView.dropDownData.settings.style.opensUp) {
				_boxView.elementsContainer.y = -_boxView.textField.height + 1;
			}else {
				_boxView.elementsContainer.y = _boxView.textField.height;
			}
			_boxView.textField.width = finalWidth;
			_boxView.button.x = _boxView.textField.width - _boxView.button.width;
			_boxView.button.y = 1;
		}
		
		private function cickedOnStage(e:MouseEvent):void {
			if(!_boxView.dropDownData.boxData.mouseOver){
				_boxView.dropDownData.boxData.open = false;
			}
		}
	}
}