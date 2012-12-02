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
	
	import com.panozona.modules.dropdown.events.ElementEvent;
	import com.panozona.modules.dropdown.events.BoxEvent;
	import com.panozona.modules.dropdown.model.BoxData;
	import com.panozona.modules.dropdown.model.structure.Element;
	import com.panozona.modules.dropdown.model.structure.ExtraElement;
	import com.panozona.modules.dropdown.view.ElementView;
	import com.panozona.player.module.Module;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	public class ElementController{
		
		private var _elementView:ElementView;
		private var _module:Module;
		
		public function ElementController(elementView:ElementView, module:Module, boxData:BoxData){
			_elementView = elementView;
			_module = module;
			
			_elementView.elementData.addEventListener(ElementEvent.CHANGED_MOUSE_OVER, handleElementMouseOverChange, false, 0, true);
			_elementView.elementData.addEventListener(ElementEvent.CHANGED_IS_ACTIVE, handleElementActiveChange, false, 0, true);
			
			_elementView.elementData.addEventListener(ElementEvent.CHANGED_WIDTH, handleElementWidthChange, false, 0, true);
			
			_elementView.addEventListener(MouseEvent.CLICK, handleMouseClick, false, 0, true);
			
			if(_elementView.elementData.rawElement is Element){
				var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
				_module.saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0, true);
				onPanoramaStartedLoading(null);
			}else {
				boxData.addEventListener(BoxEvent.CHANGED_CURRENT_EXTRAWAYPOINT_ID, onCurrentExtraElementIdChange, false, 0, true)
				onCurrentExtraElementIdChange(null);
			}
		}
		
		private function handleElementMouseOverChange(e:ElementEvent):void {
			if (_elementView.elementData.mouseOver) {
				onHover();
			}else {
				onPlain();
			}
		}
		
		private function handleElementActiveChange(e:ElementEvent):void {
			if (_elementView.elementData.mouseOver) {
				onHover();
			}else {
				onPlain();
			}
		}
		
		private function handleElementWidthChange(e:ElementEvent):void {
			if (_elementView.textField.width != _elementView.elementData.width) {
				_elementView.textField.width = _elementView.elementData.width;
			}
		}
		
		private function onPanoramaStartedLoading(panoramaEvent:Object):void {
			if(_elementView.elementData.rawElement is Element){
				if ((_elementView.elementData.rawElement as Element).target == _module.saladoPlayer.manager.currentPanoramaData.id){
					_elementView.elementData.isActive = true;
				}else {
					_elementView.elementData.isActive = false;
				}
			}
		}
		
		private function onCurrentExtraElementIdChange(e:Event):void {
			if ((_elementView.elementData.rawElement as ExtraElement).id == _elementView.dropDownData.boxData.currentExtraElementId) {
				_elementView.elementData.isActive = true;
			}else {
				_elementView.elementData.isActive = false;
			}
		}
		
		private function handleMouseClick(e:MouseEvent):void {
			if (_elementView.elementData.rawElement is Element){
				if (_module.saladoPlayer.manager.currentPanoramaData.id != (_elementView.elementData.rawElement as Element).target){
					_module.saladoPlayer.manager.loadPano((_elementView.elementData.rawElement as Element).target);
				}
			}else{
				_module.saladoPlayer.manager.runAction((_elementView.elementData.rawElement as ExtraElement).action);
			}
			_elementView.dropDownData.boxData.open = false;
		}
		
		private function onPlain():void {
			if (_elementView.elementData.isActive) {
				_elementView.textField.backgroundColor = _elementView.dropDownData.settings.style.activeColor;
			}else {
				_elementView.textField.backgroundColor = _elementView.dropDownData.settings.style.plainColor;
			}
		}
		
		private function onHover():void {
			if (_elementView.elementData.isActive) {
				_elementView.textField.backgroundColor = _elementView.dropDownData.settings.style.activeColor;
			}else {
				_elementView.textField.backgroundColor = _elementView.dropDownData.settings.style.hoverColor;
			}
		}
	}
}