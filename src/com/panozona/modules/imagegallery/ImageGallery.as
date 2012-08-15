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
package com.panozona.modules.imagegallery {
	
	import com.panozona.modules.imagegallery.controller.WindowController;
	import com.panozona.modules.imagegallery.model.ImageGalleryData
	import com.panozona.modules.imagegallery.model.WindowData;
	import com.panozona.modules.imagegallery.view.WindowView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	
	public class ImageGallery extends Module {
		
		private var imageGalleryData:ImageGalleryData;
		
		private var windowView:WindowView;
		private var windowController:WindowController;
		
		public function ImageGallery() {
			super("ImageGallery", "1.0", "http://panozona.com/wiki/Module:ImageGallery");
			moduleDescription.addFunctionDescription("setOpen", Boolean);
			moduleDescription.addFunctionDescription("toggleOpen", String);
			moduleDescription.addFunctionDescription("setGroup", String);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			imageGalleryData = new ImageGalleryData(moduleData, saladoPlayer);
			windowView = new WindowView(imageGalleryData);
			windowController = new WindowController(windowView, this);
			addChild(windowView);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(value:Boolean):void {
			imageGalleryData.windowData.open = value;
		}
		
		public function toggleOpen():void {
			imageGalleryData.windowData.open = !imageGalleryData.windowData.open;
		}
		
		public function setGroup(value:String):void {
			if(imageGalleryData.viewerData.getGroupById(value) != null){
				imageGalleryData.viewerData.currentGroupId = value;
			} else {
				printWarning("Invalid group id: " + value);
			}
		}
	}
}