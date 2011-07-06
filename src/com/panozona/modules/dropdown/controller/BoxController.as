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
			
			_boxView.dropDownData.boxData.addEventListener(BoxEvent.CHANGED_OPEN, handleOpenChanged, false, 0, true);
			
			_module.stage.addEventListener(MouseEvent.MOUSE_DOWN, cickedOnStage, false, 0, true);
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0, true);
			
			elementControllers = new Vector.<ElementController>();
			buildElementsContainer();
		}
		
		private function buildElementsContainer():void {
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
				elementView = _boxView.elementsContainer.getChildAt(i) as ElementView;
				elementView.elementData.width = finalWidth;
				elementView.y = lastY;
				lastY += elementView.height;
			}
			_boxView.textField.width = finalWidth;
			_boxView.button.x = _boxView.textField.width - _boxView.button.width;
			_boxView.button.y = 1;
			
			_boxView.elementsContainer.y = containerFoldY();
			_boxView.elementsContainerMask.y = containerUnfoldY();
			_boxView.elementsContainerMask.graphics.beginFill(0x000000)
			_boxView.elementsContainerMask.graphics.drawRect(-5, -5, _boxView.elementsContainer.width + 10, _boxView.elementsContainer.height + 10);
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
				_boxView.y = _module.saladoPlayer.manager.boundsHeight - _boxView.textField.height;
			}else { // MIDDLE
				_boxView.y = (_module.saladoPlayer.manager.boundsHeight - _boxView.textField.height) * 0.5;
			}
			_boxView.x += _boxView.dropDownData.settings.move.horizontal;
			_boxView.y += _boxView.dropDownData.settings.move.vertical;
		}
		
		private function onPanoramaStartedLoading(PanoramaEvent:Object):void {
			var elementView:ElementView;
			for each (var element:Element in _boxView.dropDownData.boxData.elements.getChildrenOfGivenClass(Element)) {
				if (element.target == _module.saladoPlayer.manager.currentPanoramaData.id) {
					_boxView.textField.text = element.label;
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
					time:_boxView.dropDownData.settings.unfoldTween.time,
					transition:_boxView.dropDownData.settings.unfoldTween.transition});
			}else {
				Tweener.addTween(_boxView.elementsContainer, {
					y:containerFoldY(),
					time:_boxView.dropDownData.settings.foldTween.time,
					transition:_boxView.dropDownData.settings.foldTween.transition,
					onComplete:onComplete});
			}
		}
		
		private function onComplete():void {
			_boxView.elementsContainer.visible = false;
			_boxView.elementsContainerMask.visible = false;
		}
		
		private function containerFoldY():Number {
			if (_boxView.dropDownData.settings.style.opensUp) {
				return 0;
			}else {
				return _boxView.textField.height - _boxView.elementsContainer.height;
			}
		}
		
		private function containerUnfoldY():Number {
			if (_boxView.dropDownData.settings.style.opensUp) {
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