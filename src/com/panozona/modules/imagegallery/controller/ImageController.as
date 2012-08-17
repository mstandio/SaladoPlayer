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
package com.panozona.modules.imagegallery.controller {
	
	import com.panozona.modules.imagegallery.events.ImageEvent;
	import com.panozona.modules.imagegallery.events.ViewerEvent;
	import com.panozona.modules.imagegallery.events.WindowEvent;
	import com.panozona.modules.imagegallery.model.structure.Image;
	import com.panozona.modules.imagegallery.view.ImageView;
	import com.panozona.player.module.data.property.Size;
	import com.panozona.player.module.Module;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class ImageController {
		
		private var imageLoader:Loader;
		private var displayObject:DisplayObject;
		private var displayObjectInitSize:Size;
		
		private var _imageView:ImageView;
		private var _module:Module;
		private var _throbberDelayTimer:Timer;
		
		public function ImageController(imageView:ImageView, module:Module) {
			_imageView = imageView;
			_module = module;
			
			_imageView.imagegalleryData.viewerData.addEventListener(ViewerEvent.CHANGED_CURRENT_IMAGE_INDEX, handleCurrentImageIndexChange, false, 0, true);
			_imageView.imagegalleryData.windowData.addEventListener(WindowEvent.CHANGED_CURRENT_SIZE, handleWindowSizeChange, false, 0, true);
			_imageView.imagegalleryData.imageData.addEventListener(ImageEvent.CHANGED_MAX_SIZE, handleMaxSizeChange, false, 0, true);
			
			imageLoader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLost, false, 0, true);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded, false, 0, true);
			
			if (_imageView.imagegalleryData.viewerData.viewer.throbber != null ) {
				_throbberDelayTimer = new Timer(500, 1);
				_throbberDelayTimer.addEventListener(TimerEvent.TIMER, timesUp, false, 0, true);
			}
		}
		
		private function imageLost(e:IOErrorEvent):void {
			if (_imageView.imagegalleryData.viewerData.viewer.throbber != null) {
				_throbberDelayTimer.stop();
			}
			_module.printError("Could not load image: " + e.text);
			_imageView.imagegalleryData.imageData.isShowingThrobber = false;
		}
		
		private function imageLoaded(e:Event):void {
			if (_imageView.imagegalleryData.viewerData.viewer.throbber != null) {
				_throbberDelayTimer.stop();
			}
			_imageView.imagegalleryData.imageData.isShowingThrobber = false;
			displayObject = imageLoader.content;
			if (displayObject is Bitmap) {
				(displayObject as Bitmap).smoothing = true;
			}
			while (_imageView.numChildren) {
				_imageView.removeChildAt(0);
			}
			displayObjectInitSize = new Size(displayObject.width, displayObject.height);
			_imageView.addChild(displayObject);
			handleWindowSizeChange();
		}
		
		private function handleCurrentImageIndexChange(e:Event = null):void {
			if (_imageView.imagegalleryData.viewerData.viewer.throbber != null) {
				_throbberDelayTimer.reset();
				_throbberDelayTimer.start();
			}
			imageLoader.unload();
			var path:String = _imageView.imagegalleryData.viewerData.getGroupById(
				_imageView.imagegalleryData.viewerData.currentGroupId).getChildrenOfGivenClass(Image)
				[_imageView.imagegalleryData.viewerData.currentImageIndex].path;
			imageLoader.load(new URLRequest(path));
		}
		private function timesUp(e:Event):void {
			_imageView.imagegalleryData.imageData.isShowingThrobber = true;
		}
		
		private function handleWindowSizeChange(event:Event = null):void {
			if (displayObject == null) {
				return;
			}
			var maxSize:Size = new Size(_imageView.imagegalleryData.windowData.currentSize.width - 20, 
				_imageView.imagegalleryData.windowData.currentSize.height - 20);
			if (displayObjectInitSize.width <= maxSize.width && displayObjectInitSize.height <= maxSize.height ) {
				displayObject.scaleX = displayObject.scaleY = 1;
			} else {
				if (maxSize.width > maxSize.height) {
					if (displayObjectInitSize.width < (displayObjectInitSize.height)) {
						displayObject.scaleX = maxSize.width / displayObjectInitSize.width;
						displayObject.scaleY = displayObject.scaleX;
					} else {
						displayObject.scaleY = maxSize.height / displayObjectInitSize.height
						displayObject.scaleX = displayObject.scaleY;
					}
				} else {
					if (displayObjectInitSize.width > (displayObjectInitSize.height)) {
						displayObject.scaleX = maxSize.width / displayObjectInitSize.width;
						displayObject.scaleY = displayObject.scaleX;
					} else {
						displayObject.scaleY = maxSize.height / displayObjectInitSize.height
						displayObject.scaleX = displayObject.scaleY;
					}
				}
			}
			displayObject.x = (_imageView.imagegalleryData.windowData.currentSize.width - displayObject.width) * 0.5
			displayObject.y = (_imageView.imagegalleryData.windowData.currentSize.height - displayObject.height) * 0.5
		}
		
		private function handleMaxSizeChange(event:Event = null):void {
			
		}
	}
}