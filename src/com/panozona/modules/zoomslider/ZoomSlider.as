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
package com.panozona.modules.zoomslider{
	
	import com.panozona.modules.zoomslider.controller.WindowController;
	import com.panozona.modules.zoomslider.model.ZoomSliderData;
	import com.panozona.modules.zoomslider.view.WindowView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	
	public class ZoomSlider extends Module{
		
		private var windowView:WindowView;
		private var windowController:WindowController;
		
		private var zoomSliderData:ZoomSliderData;
		
		public function ZoomSlider():void{
			super("ZoomSlider", "1.2", "http://panozona.com/wiki/Module:ZoomSlider");
			
			moduleDescription.addFunctionDescription("setOpen", Boolean);
			moduleDescription.addFunctionDescription("toggleOpen");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			zoomSliderData = new ZoomSliderData(moduleData, this.saladoPlayer);
			windowView = new WindowView(zoomSliderData);
			windowController = new WindowController(windowView, this);
			addChild(windowView);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(value:Boolean):void {
			if (value == zoomSliderData.windowData.open) return;
			zoomSliderData.windowData.open = value;
		}
		
		public function toggleOpen():void {
			zoomSliderData.windowData.open = !zoomSliderData.windowData.open;
		}
	}
}