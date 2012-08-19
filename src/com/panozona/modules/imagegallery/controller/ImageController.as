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
	
	import caurina.transitions.Tweener;
	import caurina.transitions.Equations;
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
		private var nextDisplayObject:DisplayObject;
		
		private var _imageView:ImageView;
		private var _module:Module;
		private var _throbberDelayTimer:Timer;
		
		private const closedMultiplier:Number = 0.5
		
		public function ImageController(imageView:ImageView, module:Module) {
			_imageView = imageView;
			_module = module;
			
			displayObjectInitSize = new Size(0, 0);
			
			imageLoader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLost, false, 0, true);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded, false, 0, true);
			
			_imageView.imagegalleryData.windowData.addEventListener(WindowEvent.CHANGED_OPEN, handleWindowOpenChange, false, 0, true);
			_imageView.imagegalleryData.viewerData.addEventListener(ViewerEvent.CHANGED_CURRENT_IMAGE_INDEX, handleCurrentImageIndexChange, false, 0, true);
			_imageView.imagegalleryData.windowData.addEventListener(WindowEvent.CHANGED_CURRENT_SIZE, handleWindowSizeChange, false, 0, true);
			_imageView.imagegalleryData.imageData.addEventListener(ImageEvent.CHANGED_MAX_SCALE, handleMaxScaleChange, false, 0, true);
			
			if (_imageView.imagegalleryData.viewerData.viewer.throbber != null ) {
				_throbberDelayTimer = new Timer(250, 1);
				_throbberDelayTimer.addEventListener(TimerEvent.TIMER, timesUp, false, 0, true);
			}
		}
		
		private function handleWindowOpenChange(e:Event = null):void {
			if (_imageView.imagegalleryData.windowData.open) {
				handleCurrentImageIndexChange();
			}else {
				startClosing();
			}
		}
		
		private function handleCurrentImageIndexChange(e:Event = null):void {
			if (!_imageView.imagegalleryData.windowData.open) {
				return;
			}
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
			var displayObjectTmp:DisplayObject = imageLoader.content;
			if (displayObjectTmp is Bitmap) {
				(displayObjectTmp as Bitmap).smoothing = true;
			}
			if (_imageView.imagegalleryData.imageData.isOpened) {
				nextDisplayObject = displayObjectTmp;
				startClosing();
			} else {
				displayObject = displayObjectTmp;
				startOpening();
			}
		}
		
		private function startOpening():void {
			_imageView.imagegalleryData.imageData.isOpening = true;
			displayObjectInitSize.width = displayObject.width;
			displayObjectInitSize.height = displayObject.height;
			recalculateMaxScale();
			displayObject.alpha = 0, 
			displayObject.scaleX = displayObject.scaleY = _imageView.imagegalleryData.imageData.maxScale * closedMultiplier;
			displayObject.x = (_imageView.imagegalleryData.windowData.currentSize.width - displayObject.width) * 0.5
			displayObject.y = (_imageView.imagegalleryData.windowData.currentSize.height - displayObject.height) * 0.5
			while (_imageView.numChildren) {
				_imageView.removeChildAt(0);
			}
			_imageView.addChild(displayObject);
			Tweener.addTween(displayObject, {
					time:0.25,
					transition:Equations.easeOutCirc,
					scaleX:_imageView.imagegalleryData.imageData.maxScale,
					scaleY:_imageView.imagegalleryData.imageData.maxScale,
					x:(_imageView.imagegalleryData.windowData.currentSize.width
						- displayObjectInitSize.width * _imageView.imagegalleryData.imageData.maxScale) * 0.5,
					y:(_imageView.imagegalleryData.windowData.currentSize.height 
						- displayObjectInitSize.height * _imageView.imagegalleryData.imageData.maxScale) * 0.5,
					alpha:1,
					onComplete:openingComplete});
		}
		
		private function openingComplete():void {
			_imageView.imagegalleryData.imageData.isOpening = false;
			_imageView.imagegalleryData.imageData.isOpened = true;
		}
		
		private function startClosing():void {
			_imageView.imagegalleryData.imageData.isClosing = true;
			Tweener.addTween(displayObject, {
					time:0.25,
					transition:Equations.easeInCirc,
					scaleX:_imageView.imagegalleryData.imageData.maxScale * closedMultiplier,
					scaleY:_imageView.imagegalleryData.imageData.maxScale * closedMultiplier,
					x:(_imageView.imagegalleryData.windowData.currentSize.width - 
						displayObjectInitSize.width * _imageView.imagegalleryData.imageData.maxScale * closedMultiplier) * 0.5,
					y:(_imageView.imagegalleryData.windowData.currentSize.height - 
						displayObjectInitSize.height * _imageView.imagegalleryData.imageData.maxScale * closedMultiplier) * 0.5,
					alpha:0,
					onComplete:closingComplete});
		}
		
		private function closingComplete():void {
			_imageView.imagegalleryData.imageData.isClosing = false;
			_imageView.imagegalleryData.imageData.isOpened = false;
			if (nextDisplayObject != null) {
				displayObject = nextDisplayObject;
				nextDisplayObject = null;
				startOpening();
			}
		}
		
		private function timesUp(e:Event):void {
			_imageView.imagegalleryData.imageData.isShowingThrobber = true;
		}
		
		private function handleWindowSizeChange(event:Event = null):void {
			if (displayObject == null) {
				return;
			}
			recalculateMaxScale();
			displayObject.x = (_imageView.imagegalleryData.windowData.currentSize.width 
				- displayObjectInitSize.width * _imageView.imagegalleryData.imageData.maxScale) * 0.5
			displayObject.y = (_imageView.imagegalleryData.windowData.currentSize.height 
				- displayObjectInitSize.height * _imageView.imagegalleryData.imageData.maxScale) * 0.5
		}
		
		private function recalculateMaxScale():void {
			var maxSize:Size = new Size(_imageView.imagegalleryData.windowData.currentSize.width 
					- _imageView.imagegalleryData.viewerData.viewer.padding,
					_imageView.imagegalleryData.windowData.currentSize.height 
					- _imageView.imagegalleryData.viewerData.viewer.padding);
			if (displayObjectInitSize.width <= maxSize.width  && displayObjectInitSize.height <= maxSize.height ) {
				_imageView.imagegalleryData.imageData.maxScale = 1;
			} else {
				var scale:Number = maxSize.height / displayObjectInitSize.height
				if (displayObjectInitSize.width * scale > maxSize.width) {
					scale = maxSize.width / displayObjectInitSize.width;
				}
				_imageView.imagegalleryData.imageData.maxScale = scale;
			}
		}
		
		private function handleMaxScaleChange(event:Event = null):void {
			if (_imageView.imagegalleryData.imageData.isOpening) {
				_imageView.imagegalleryData.imageData.isOpening = false;
				Tweener.addTween(displayObject, { // no time parameter
					scaleX:_imageView.imagegalleryData.imageData.maxScale,
					scaleY:_imageView.imagegalleryData.imageData.maxScale});
				_imageView.alpha = _imageView.imagegalleryData.windowData.window.alpha;
			} if (_imageView.imagegalleryData.imageData.isClosing) {
				_imageView.imagegalleryData.imageData.isClosing = false;
				Tweener.addTween(displayObject, { // no time parameter
					scaleX:_imageView.imagegalleryData.imageData.maxScale * closedMultiplier,
					scaleY:_imageView.imagegalleryData.imageData.maxScale * closedMultiplier});
				_imageView.alpha = 0;
			} else if (_imageView.imagegalleryData.imageData.isOpened) {
				displayObject.scaleX = displayObject.scaleY = _imageView.imagegalleryData.imageData.maxScale;
			}
		}
	}
}