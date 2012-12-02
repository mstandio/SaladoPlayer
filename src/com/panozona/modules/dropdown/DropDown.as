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
package com.panozona.modules.dropdown{
	
	import com.panozona.modules.dropdown.controller.WindowController;
	import com.panozona.modules.dropdown.model.DropDownData;
	import com.panozona.modules.dropdown.model.structure.ExtraElement;
	import com.panozona.modules.dropdown.view.ElementView;
	import com.panozona.modules.dropdown.view.WindowView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	
	public class DropDown extends Module{
		
		private var dropDownData:DropDownData;
		
		private var windowView:WindowView;
		private var windowController:WindowController;
		
		public function DropDown(){
			super("DropDown", "1.3", "http://panozona.com/wiki/Module:DropDown");
			moduleDescription.addFunctionDescription("setOpen", Boolean);
			moduleDescription.addFunctionDescription("toggleOpen");
			moduleDescription.addFunctionDescription("setGroup", String);
			moduleDescription.addFunctionDescription("setActive", String);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			dropDownData = new DropDownData(moduleData, saladoPlayer);
			
			windowView = new WindowView(dropDownData);
			windowController = new WindowController(windowView, this);
			addChild(windowView);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(value:Boolean):void {
			dropDownData.windowData.open = value;
		}
		
		public function toggleOpen():void {
			dropDownData.windowData.open = !dropDownData.windowData.open;
		}
		
		public function setGroup(id:String):void {
			if (dropDownData.boxData.getGroupById(id) == null) {
				printWarning("group not found: " + id);
			}else {
				dropDownData.boxData.currentGroupId = id;
			}
		}
		
		public function setActive(id:String):void {
			if (dropDownData.boxData.getExtraElementById(id) == null) {
				printWarning("extraElement not found: " + id);
			}else {
				dropDownData.boxData.currentExtraElementId = id;
			}
		}
	}
}