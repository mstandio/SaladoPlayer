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
package com.panozona.modules.panolink{
	
	import com.panozona.modules.panolink.controller.WindowController;
	import com.panozona.modules.panolink.model.PanoLinkData;
	import com.panozona.modules.panolink.view.WindowView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	
	public class PanoLink extends Module{
		
		private var windowView:WindowView;
		private var windowController:WindowController;
		
		private var panoLinkData:PanoLinkData;
		
		public function PanoLink(){
			super("PanoLink", "0.0", "http://panozona.com/wiki/Module:PanoLink");
			
			moduleDescription.addFunctionDescription("setOpen", Boolean);
			moduleDescription.addFunctionDescription("toggleOpen");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			panoLinkData = new PanoLinkData(moduleData, saladoPlayer);
			windowView = new WindowView(panoLinkData);
			windowController = new WindowController(windowView, this);
			addChild(windowView);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(value:Boolean):void {
			if (value == panoLinkData.windowData.open) return;
			panoLinkData.windowData.open = value;
		}
		
		public function toggleOpen():void {
			panoLinkData.windowData.open = !panoLinkData.windowData.open;
		}
	}
}