/*
Copyright 2010 Marek Standio.

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
along with SaladoPlayer.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.modules.imagemap{
	
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	
	import com.panozona.modules.imagemap.model.ImageMapData;
	
	import com.panozona.modules.imagemap.view.WindowView;
	import com.panozona.modules.imagemap.controller.WindowController;
	
	public class ImageMap extends Module {
		
		private var imageMapData:ImageMapData;
		
		private var windowView:WindowView;
		private var windowController:WindowController;
		
		public function ImageMap() {
		
			super("ImageMap", 0.1, "Marek Standio", "mstandio@o2.pl", "http://panozona.com/wiki/Module:ImageMap");
			aboutThisModule = "Module for displaying clickable maps built form external images, for navoigating between panoramas.";
			
			moduleDescription.addFunctionDescription("toggleOpen");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			imageMapData = new ImageMapData(moduleData, debugMode); // allways first
			
			windowView = new WindowView(imageMapData);
			windowController = new WindowController(windowView, this);
			addChild(windowView);
			windowController.handleResize();
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function toggleOpen():void {
			windowController.toggleOpen();
		}
	}
}