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
	
	import caurina.transitions.Tweener;
	import com.panozona.modules.dropdown.controller.ElementController;
	import com.panozona.modules.dropdown.events.BoxEvent;
	import com.panozona.modules.dropdown.events.ElementEvent;
	import com.panozona.modules.dropdown.model.ElementData;
	import com.panozona.modules.dropdown.model.structure.Element;
	import com.panozona.modules.dropdown.model.structure.Elements;
	import com.panozona.modules.dropdown.model.structure.RawElement;
	import com.panozona.modules.dropdown.view.BoxView;
	import com.panozona.modules.dropdown.view.ElementView;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Size;
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
			
			_boxView.dropDownData.boxData.addEventListener(BoxEvent.CHANGED_OPEN, handleOpenChanged, false, 0, true);
			
			_module.stage.addEventListener(MouseEvent.MOUSE_DOWN, cickedOnStage, false, 0, true);
			
			elementControllers = new Vector.<ElementController>();
			buildElementsContainer();
		}
		
		private function buildElementsContainer():void {
			var elementView:ElementView;
			var elementController:ElementController;
			var elements:Elements = _boxView.dropDownData.boxData.elements;
			var finalWidth:Number = 0;
			for each(var rawElement:RawElement in elements.getAllChildren()) {
				elementView = new ElementView(new ElementData(rawElement), _boxView.dropDownData);
				if (elementView.width > finalWidth) finalWidth = elementView.width;
				_boxView.elementsContainer.addChild(elementView);
				elementController = new ElementController(elementView, _module);
				elementControllers.push(elementController);
			}
			finalWidth += _boxView.button.width;
			var lastY:Number = 0;
			for (var i:int = 0; i < _boxView.elementsContainer.numChildren; i++) {
				elementView = _boxView.elementsContainer.getChildAt(i) as ElementView;
				elementView.elementData.width = finalWidth;
				elementView.y = lastY;
				lastY += elementView.height;
				elementView.elementData.addEventListener(ElementEvent.CHANGED_IS_ACTIVE, handleActiveChange, false, 0, true);
			}
			_boxView.textField.width = finalWidth;
			_boxView.button.x = _boxView.textField.width - _boxView.button.width;
			_boxView.button.y = 1;
			
			_boxView.elementsContainer.y = containerFoldY();
			_boxView.elementsContainerMask.y = containerUnfoldY();
			_boxView.elementsContainerMask.graphics.beginFill(0x000000)
			_boxView.elementsContainerMask.graphics.drawRect( -1, -1, _boxView.elementsContainer.width + 2, _boxView.elementsContainer.height + 2);
			
			_boxView.dropDownData.windowData.finalSize = new Size(finalWidth, _boxView.textField.height);
		}
		
		private function handleActiveChange(e:Event):void {
			var elementView:ElementView;
			for (var i:int=0; i < _boxView.elementsContainer.numChildren; i++) {
				elementView = _boxView.elementsContainer.getChildAt(i) as ElementView;
				if (elementView.elementData.isActive) {
					_boxView.textField.text = elementView.elementData.rawElement.label;
					return;
				}
			}
			_boxView.textField.text = "";
		}
		
		private function handleOpenChanged(e:BoxEvent):void {
			if (_boxView.dropDownData.boxData.open) {
				_boxView.elementsContainer.visible = true;
				_boxView.elementsContainerMask.visible = true;
				Tweener.addTween(_boxView.elementsContainer, {
					y:containerUnfoldY(),
					time:_boxView.dropDownData.boxData.box.unfoldTween.time,
					transition:_boxView.dropDownData.boxData.box.unfoldTween.transition});
			}else {
				Tweener.addTween(_boxView.elementsContainer, {
					y:containerFoldY(),
					time:_boxView.dropDownData.boxData.box.foldTween.time,
					transition:_boxView.dropDownData.boxData.box.foldTween.transition,
					onComplete:onComplete});
			}
		}
		
		private function onComplete():void {
			_boxView.elementsContainer.visible = false;
			_boxView.elementsContainerMask.visible = false;
		}
		
		private function containerFoldY():Number {
			if (_boxView.dropDownData.boxData.box.opensUp) {
				return 0;
			}else {
				return _boxView.textField.height - _boxView.elementsContainer.height;
			}
		}
		
		private function containerUnfoldY():Number {
			if (_boxView.dropDownData.boxData.box.opensUp) {
				return -_boxView.elementsContainer.height;
			}else {
				return _boxView.textField.height
			}
		}
		
		private function cickedOnStage(e:MouseEvent):void {
			if(!_boxView.dropDownData.boxData.mouseOver){
				_boxView.dropDownData.boxData.open = false;
			}
		}
	}
}