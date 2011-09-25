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
package com.panozona.modules.imagemap{
	
	import com.panozona.modules.imagemap.controller.WindowController;
	import com.panozona.modules.imagemap.model.ImageMapData;
	import com.panozona.modules.imagemap.view.WindowView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	
	public class ImageMap extends Module {
		
		private var imageMapData:ImageMapData;
		
		private var windowView:WindowView;
		private var windowController:WindowController;
		
		public function ImageMap() {
			super("ImageMap", "1.2b", "http://panozona.com/wiki/Module:ImageMap");
			moduleDescription.addFunctionDescription("toggleOpen");
			moduleDescription.addFunctionDescription("setOpen", Boolean);
			moduleDescription.addFunctionDescription("setMap", String);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			imageMapData = new ImageMapData(moduleData, saladoPlayer); // always first
			
			windowView = new WindowView(imageMapData);
			windowController = new WindowController(windowView, this);
			addChild(windowView);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(value:Boolean):void {
			imageMapData.windowData.open = value;
		}
		
		public function toggleOpen():void {
			imageMapData.windowData.open = !imageMapData.windowData.open;
		}
		
		public function setMap(value:String):void {
			imageMapData.mapData.currentMapId = value;
		}
	}
}