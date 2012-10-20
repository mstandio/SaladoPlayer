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
package com.panozona.modules.menuscroller {
	
	import com.panozona.modules.menuscroller.controller.WindowController;
	import com.panozona.modules.menuscroller.model.MenuScrollerData;
	import com.panozona.modules.menuscroller.model.structure.ExtraElement;
	import com.panozona.modules.menuscroller.view.ElementView;
	import com.panozona.modules.menuscroller.view.WindowView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	
	public class MenuScroller extends Module{
		
		private var menuScrollerData:MenuScrollerData;
		
		private var windowView:WindowView;
		private var windowController:WindowController;
		
		public function MenuScroller(){
			super("MenuScroller", "1.3.1", "http://panozona.com/wiki/Module:MenuScroller");
			moduleDescription.addFunctionDescription("setOpen", Boolean);
			moduleDescription.addFunctionDescription("toggleOpen");
			moduleDescription.addFunctionDescription("setGroup", String);
			moduleDescription.addFunctionDescription("setActive", String);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			menuScrollerData = new MenuScrollerData(moduleData, saladoPlayer); // always first
			
			windowView = new WindowView(menuScrollerData);
			windowController = new WindowController(windowView, this);
			addChild(windowView);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(value:Boolean):void {
			menuScrollerData.windowData.open = value;
		}
		
		public function toggleOpen():void {
			menuScrollerData.windowData.open = !menuScrollerData.windowData.open;
		}
		
		public function setGroup(value:String):void {
			if(menuScrollerData.scrollerData.getGroupById(value) != null){
				menuScrollerData.scrollerData.currentGroupId = value;
			} else {
				printWarning("Invalid group id: " + value);
			}
		}
		
		public function setActive(id:String):void {
			var elementView:ElementView;
			var found:Boolean = false;
			for (var i:int = 0; i < windowView.scrollerView.elementsContainer.numChildren; i++) {
				elementView = windowView.scrollerView.elementsContainer.getChildAt(i) as ElementView;
				if (elementView.elementData.rawElement is ExtraElement) {
					if((elementView.elementData.rawElement as ExtraElement).id == id) {
						elementView.elementData.isActive = true;
						found = true;
					}else {
						elementView.elementData.isActive = false;
					}
				}
			}
			if(!found){
				printWarning("ExtraElement not found: " + id);
			}
		}
	}
}