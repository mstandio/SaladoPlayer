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
	import com.panozona.modules.imagegallery.model.ButtonData;
	import com.panozona.modules.imagegallery.model.structure.Group;
	import com.panozona.modules.imagegallery.model.structure.Image;
	import com.panozona.modules.imagegallery.view.ButtonView;
	import com.panozona.modules.imagegallery.view.ViewerView;
	import com.panozona.player.module.data.property.Size;
	import com.panozona.player.module.Module;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import org.bytearray.gif.player.GIFPlayer;
	
	public class ViewerController {
		
		private var buttonsBitmapData:BitmapData;
		private var buttonSize:Size;
		
		private var buttonControllers:Vector.<ButtonController>;
		private var buttonPrevController:ButtonController;
		private var buttonNextController:ButtonController;
		
		private var imageController:ImageController;
		
		private var _viewerView:ViewerView;
		private var _module:Module;
		
		public function ViewerController(viewerView:ViewerView, module:Module) {
			_module = module;
			_viewerView = viewerView;
			
			buttonSize = new Size(30,30);
			buttonControllers = new Vector.<ButtonController>();
			
			imageController = new ImageController(_viewerView.imageView, _module);
			
			_viewerView.buttonPrev.buttonData.onRelease = getImageIndexIncrementer(-1);
			_viewerView.buttonNext.buttonData.onRelease = getImageIndexIncrementer(1);
			buttonPrevController = new ButtonController(_viewerView.buttonPrev, _module);
			buttonNextController = new ButtonController(_viewerView.buttonNext, _module);
			
			_viewerView.imagegalleryData.viewerData.addEventListener(ViewerEvent.CHANGED_CURRENT_GROUP_ID, handleCurrentGroupIdChange, false, 0, true);
			_viewerView.imagegalleryData.viewerData.addEventListener(ViewerEvent.CHANGED_CURRENT_IMAGE_INDEX, handleCurrentImageIndexChange, false, 0, true);
			_viewerView.imagegalleryData.windowData.addEventListener(WindowEvent.CHANGED_CURRENT_SIZE, handleWindowSizeChange, false, 0, true);
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			
			var buttonsLoader:Loader = new Loader();
			buttonsLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, buttonsImageLost, false, 0, true);
			buttonsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, buttonsImageLoaded, false, 0, true);
			buttonsLoader.load(new URLRequest(_viewerView.imagegalleryData.viewerData.viewer.path));
			
			if (_viewerView.imagegalleryData.viewerData.viewer.throbber != null) {
				_viewerView.imagegalleryData.imageData.addEventListener(ImageEvent.CHANGED_IS_THROBBER_SHOWING, handleThrobberShowingChange, false, 0, true);
				_viewerView.gifPlayer.addEventListener(IOErrorEvent.IO_ERROR, throbberLost, false, 0, true);
				_viewerView.gifPlayer.addEventListener(Event.COMPLETE, throbberLoaded, false, 0, true);
				_viewerView.gifPlayer.load(new URLRequest(_viewerView.imagegalleryData.viewerData.viewer.throbber));
			}
			
			handleWindowSizeChange();
		}
		
		private function onPanoramaLoaded(loadPanoramaEvent:Object):void {
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaLoaded);
			if(_viewerView.imagegalleryData.viewerData.currentGroupId == null){
				_viewerView.imagegalleryData.viewerData.currentGroupId = (_viewerView.imagegalleryData.viewerData.groups.getChildrenOfGivenClass(Group)[0]).id;
			}
		}
		
		private function buttonsImageLost(e:IOErrorEvent):void {
			(e.target as org.bytearray.gif.player.GIFPlayer).removeEventListener(IOErrorEvent.IO_ERROR, buttonsImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, buttonsImageLoaded);
			_module.printError(e.text);
		}
		
		private function buttonsImageLoaded(e:Event):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, buttonsImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, buttonsImageLoaded);
			buttonsBitmapData = new BitmapData((e.target as LoaderInfo).width, (e.target as LoaderInfo).height, true, 0);
			buttonsBitmapData.draw((e.target as LoaderInfo).content);
			buttonSize.width = Math.ceil((buttonsBitmapData.width - 1) / 2);
			buttonSize.height = Math.ceil((buttonsBitmapData.height - 1) / 2);
			if (_viewerView.imagegalleryData.viewerData.currentGroupId != null) {
				updateButtonsBar();
				handleCurrentImageIndexChange();
			}
			_viewerView.buttonPrev.bitmapDataPlain = getButtonBitmap(0);
			_viewerView.buttonPrev.bitmapDataActive = getButtonBitmap(2);
			_viewerView.buttonNext.bitmapDataPlain = getButtonBitmap(0);
			_viewerView.buttonNext.bitmapDataActive = getButtonBitmap(2);
			handleWindowSizeChange();
		}
		
		private function getImageIndexIncrementer(value:Number):Function {
			return function(e:MouseEvent):void {
				incrementImageIndex(value);
			}
		}
		
		private function throbberLost(e:IOErrorEvent):void {
			(e.target as GIFPlayer).removeEventListener(IOErrorEvent.IO_ERROR, throbberLost);
			(e.target as GIFPlayer).removeEventListener(Event.COMPLETE, throbberLoaded);
		}
		
		private function throbberLoaded(e:Event):void {
			(e.target as GIFPlayer).removeEventListener(IOErrorEvent.IO_ERROR, throbberLost);
			(e.target as GIFPlayer).removeEventListener(Event.COMPLETE, throbberLoaded);
			handleWindowSizeChange();
			handleThrobberShowingChange();
		}
		
		private function handleThrobberShowingChange(e:Event=null):void {
			if (_viewerView.imagegalleryData.imageData.isShowingThrobber) {
				_viewerView.throbberStart()
			} else {
				_viewerView.throbberStop();
			}
		}
		
		private function incrementImageIndex(value:Number):void {
			var imagesNumber:Number = _viewerView.imagegalleryData.viewerData.getGroupById(
				_viewerView.imagegalleryData.viewerData.currentGroupId).getChildrenOfGivenClass(Image).length;
			var incrementedNumber:Number = _viewerView.imagegalleryData.viewerData.currentImageIndex;
			if (value > 0) {
				incrementedNumber++;
				if (incrementedNumber > imagesNumber - 1) {
					incrementedNumber = 0;
				}
			}else {
				incrementedNumber--;
				if (incrementedNumber < 0) {
					incrementedNumber = imagesNumber - 1;
				}
			}
			_viewerView.imagegalleryData.viewerData.currentImageIndex = incrementedNumber;
		}
		
		private function handleCurrentGroupIdChange(e:Event):void {
			if (_viewerView.imagegalleryData.viewerData.getGroupById(_viewerView.imagegalleryData.viewerData.currentGroupId)
				.getChildrenOfGivenClass(Image).length > 1) {
				if (buttonsBitmapData != null) {
					_viewerView.buttonBar.visible = true;
					_viewerView.buttonPrev.visible = true;
					_viewerView.buttonNext.visible = true;
					buildButtonsBar();
					updateButtonsBar();
				}
			} else {
				_viewerView.buttonBar.visible = false;
				_viewerView.buttonPrev.visible = false;
				_viewerView.buttonNext.visible = false;
			}
			_viewerView.imagegalleryData.viewerData.currentImageIndex = 0;
		}
		
		private function buildButtonsBar():void {
			while (_viewerView.buttonBar.numChildren) {
				_viewerView.buttonBar.removeChildAt(0);
			}
			while (buttonControllers.length) {
				buttonControllers.pop();
			}
			var imagesNumber:int = _viewerView.imagegalleryData.viewerData.getGroupById(
				_viewerView.imagegalleryData.viewerData.currentGroupId).getChildrenOfGivenClass(Image).length;
			for (var i:int = 0; i < imagesNumber; i++) {
				var buttonView:ButtonView = new ButtonView(new ButtonData(i), _viewerView.imagegalleryData);
				buttonView.buttonData.onRelease = getImageIndexSetter(i);
				buttonControllers.push(new ButtonController(buttonView, _module));
				_viewerView.buttonBar.addChild(buttonView);
			}
		}
		
		private function getImageIndexSetter(imageIndex:Number):Function{
			return function(e:MouseEvent):void {
				_viewerView.imagegalleryData.viewerData.currentImageIndex = imageIndex;
			}
		}
		
		private function updateButtonsBar():void {
			var lastX:Number = 0;
			for ( var i:int = 0; i < _viewerView.buttonBar.numChildren; i++) {
				var buttonView:ButtonView = _viewerView.buttonBar.getChildAt(i) as ButtonView;
				buttonView.bitmapDataPlain = getButtonBitmap(1);
				buttonView.bitmapDataActive = getButtonBitmap(3);
				buttonView.x = lastX;
				lastX += buttonView.width + _viewerView.imagegalleryData.viewerData.viewer.spacing;
			}
			handleWindowSizeChange();
		}
		
		// [0][1]
		// [2][3]
		private function getButtonBitmap(buttonId:int):BitmapData {
			var bmd:BitmapData = new BitmapData(buttonSize.width, buttonSize.height, true, 0);
			bmd.copyPixels(
				buttonsBitmapData,
				new Rectangle(
					(buttonId % 2) * buttonSize.width + 1 * (buttonId % 2),
					Math.floor(buttonId / 2) * buttonSize.height + 1 * Math.floor(buttonId / 2),
					buttonSize.width,
					buttonSize.height),
				new Point(0, 0),
				null,
				null,
				true);
			return bmd;
		}
		
		private function handleCurrentImageIndexChange(e:Event = null):void {
			for ( var i:int = 0; i < _viewerView.buttonBar.numChildren; i++) {
				var buttonView:ButtonView = _viewerView.buttonBar.getChildAt(i) as ButtonView;
				if (buttonView.buttonData.imageIndex == _viewerView.imagegalleryData.viewerData.currentImageIndex) {
					buttonView.buttonData.isActive = true;
				} else {
					buttonView.buttonData.isActive = false;
				}
			}
		}
		
		private function handleWindowSizeChange(event:Event = null):void {
			_viewerView.graphics.clear();
			_viewerView.graphics.beginFill(_viewerView.imagegalleryData.viewerData.viewer.style.color, _viewerView.imagegalleryData.viewerData.viewer.style.alpha);
			_viewerView.graphics.drawRect(0, 0, _viewerView.imagegalleryData.windowData.currentSize.width, _viewerView.imagegalleryData.windowData.currentSize.height);
			_viewerView.graphics.endFill();
			
			_viewerView.buttonPrev.x = buttonSize.width * 1.25;
			_viewerView.buttonNext.x = _viewerView.imagegalleryData.windowData.currentSize.width - buttonSize.width * 1.25
			_viewerView.buttonPrev.y = (_viewerView.imagegalleryData.windowData.currentSize.height - buttonSize.height) * 0.5;
			_viewerView.buttonNext.y = _viewerView.buttonPrev.y;
			_viewerView.buttonPrev.rotationY = 180;
			_viewerView.buttonBar.x = (_viewerView.imagegalleryData.windowData.currentSize.width - _viewerView.buttonBar.width) * 0.5;
			_viewerView.buttonBar.y = _viewerView.imagegalleryData.windowData.currentSize.height - buttonSize.height * 1.25;
			if (_viewerView.imagegalleryData.viewerData.viewer.throbber) {
				_viewerView.gifPlayer.x = (_viewerView.imagegalleryData.windowData.currentSize.width - _viewerView.gifPlayer.width) * 0.5;
				_viewerView.gifPlayer.y = (_viewerView.imagegalleryData.windowData.currentSize.height - _viewerView.gifPlayer.height) * 0.5;
			}
		}
	}
}