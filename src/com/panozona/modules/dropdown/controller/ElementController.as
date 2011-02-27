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
	import com.panozona.modules.dropdown.model.ElementData;
	import com.panozona.modules.dropdown.view.ElementView;
	import com.panozona.player.module.Module;
	import flash.events.MouseEvent;
	
	public class ElementController{
		
		private var _elementView:ElementView; 
		private var _module:Module;
		
		public function ElementController(elementView:ElementView, module:Module){
			_elementView = elementView;
			_module = module;
			
			_elementView.elementData.addEventListener(ElementEvent.CHANGED_MOUSE_OVER, handleElementMouseOverChange, false, 0, true);
			_elementView.elementData.addEventListener(ElementEvent.CHANGED_STATE, handleElementStateChange, false, 0, true);
			_elementView.elementData.addEventListener(ElementEvent.CHANGED_WIDTH, handleElementWidthChange, false, 0, true);
			
			_elementView.addEventListener(MouseEvent.CLICK, handleMouseClick, false, 0, true);
		}
		
		private function handleElementMouseOverChange(e:ElementEvent):void {
			if (_elementView.elementData.state != ElementData.STATE_ACTIVE) {
				if (_elementView.elementData.mouseOver) {
					_elementView.elementData.state = ElementData.STATE_HOVER;
				}else {
					_elementView.elementData.state = ElementData.STATE_PLAIN;
				}
			}
		}
		
		private function handleElementStateChange(e:ElementEvent):void {
			if (_elementView.elementData.state == ElementData.STATE_PLAIN){
				_elementView.textField.backgroundColor = _elementView.dropDownData.settings.style.plainColor;
			}else if (_elementView.elementData.state == ElementData.STATE_HOVER) {
				_elementView.textField.backgroundColor = _elementView.dropDownData.settings.style.hoverColor;
			}else if (_elementView.elementData.state == ElementData.STATE_ACTIVE){
				_elementView.textField.backgroundColor = _elementView.dropDownData.settings.style.activeColor;
			}
		}
		
		private function handleElementWidthChange(e:ElementEvent):void {
			if (_elementView.textField.width != _elementView.elementData.width) {
				_elementView.textField.width == _elementView.elementData.width;
			}
		}
		
		private function handleMouseClick(e:MouseEvent):void {
			if (_elementView.elementData.state != ElementData.STATE_ACTIVE) {
				_module.saladoPlayer.manager.loadPanoramaById(_elementView.elementData.element.panorama);
			}
			_elementView.dropDownData.boxData.open = false;
		}
	}
}