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
	
	import com.panozona.modules.imagegallery.events.GroupEvent;
	import com.panozona.modules.imagegallery.events.ViewerEvent;
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
	
	public class ViewerController {
		
		private var buttonsBitmapData:BitmapData;
		private var buttonSize:Size;
		
		private var buttonControllers:Vector.<ButtonController>;
		private var buttonPrevController:ButtonController;
		private var buttonNextController:ButtonController;
		
		private var imageLoader:Loader;
		
		private var _viewerView:ViewerView;
		private var _module:Module;
		
		public function ViewerController(viewerView:ViewerView, module:Module) {
			_module = module;
			_viewerView = viewerView;
			
			buttonSize = new Size(30,30);
			
			buttonControllers = new Vector.<ButtonController>();
			
			_viewerView.buttonPrev.buttonData.onRelease = getImageIndexIncrementer(-1);
			_viewerView.buttonNext.buttonData.onRelease = getImageIndexIncrementer(1);
			buttonPrevController = new ButtonController(_viewerView.buttonPrev, _module);
			buttonNextController = new ButtonController(_viewerView.buttonNext, _module);
			
			imageLoader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLost, false, 0, true);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded, false, 0, true);
			
			_viewerView.imagegalleryData.viewerData.addEventListener(GroupEvent.CHANGED_CURRENT_GROUP_ID, handleCurrentGroupIdChange, false, 0, true);
			_viewerView.imagegalleryData.viewerData.addEventListener(ViewerEvent.CHANGED_CURRENT_IMAGE_INDEX, handleCurrentImageIndexChange, false, 0, true);
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			
			var buttonsLoader:Loader = new Loader();
			buttonsLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, buttonsImageLost, false, 0, true);
			buttonsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, buttonsImageLoaded, false, 0, true);
			buttonsLoader.load(new URLRequest(_viewerView.imagegalleryData.viewerData.viewer.path));
		}
		
		private function onPanoramaLoaded(loadPanoramaEvent:Object):void {
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaLoaded);
			if(_viewerView.imagegalleryData.viewerData.currentGroupId == null){
				_viewerView.imagegalleryData.viewerData.currentGroupId = (_viewerView.imagegalleryData.viewerData.groups.getChildrenOfGivenClass(Group)[0]).id;
			}
		}
		
		private function buttonsImageLost(e:IOErrorEvent):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, buttonsImageLost);
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
				updateButtonBarSelection();
			}
			_viewerView.buttonPrev.bitmapDataPlain = getButtonBitmap(0);
			_viewerView.buttonPrev.bitmapDataActive = getButtonBitmap(2);
			_viewerView.buttonNext.bitmapDataPlain = getButtonBitmap(0);
			_viewerView.buttonNext.bitmapDataActive = getButtonBitmap(2);
		}
		
		private function getImageIndexIncrementer(value:Number):Function {
			return function(e:MouseEvent):void {
				incrementImageIndex(value);
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
			if (buttonsBitmapData != null) {
				buildButtonsBar();
				updateButtonsBar();
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
			onWindowSizeChange();
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
		
		private function handleCurrentImageIndexChange(e:Event):void {
			updateButtonBarSelection();
			imageLoader.unload();
			var path:String = _viewerView.imagegalleryData.viewerData.getGroupById(
				_viewerView.imagegalleryData.viewerData.currentGroupId).getChildrenOfGivenClass(Image)
				[_viewerView.imagegalleryData.viewerData.currentImageIndex].path;
			//imageLoader.load(new URLRequest(path));
		}
		
		private function  updateButtonBarSelection():void {
			for ( var i:int = 0; i < _viewerView.buttonBar.numChildren; i++) {
				var buttonView:ButtonView = _viewerView.buttonBar.getChildAt(i) as ButtonView;
				if (buttonView.buttonData.imageIndex == _viewerView.imagegalleryData.viewerData.currentImageIndex) {
					buttonView.buttonData.isActive = true;
				} else {
					buttonView.buttonData.isActive = false;
				}
			}
		}
		
		private function onWindowSizeChange():void {
			_viewerView.graphics.clear();
			_viewerView.graphics.beginFill(0x00ff00);
			_viewerView.graphics.drawRect(0,0,_viewerView.imagegalleryData.windowData.window.size.width, _viewerView.imagegalleryData.windowData.window.size.height)
			_viewerView.graphics.endFill();
			
			_viewerView.buttonPrev.x = buttonSize.width * 1.5;
			_viewerView.buttonNext.x = _viewerView.imagegalleryData.windowData.window.size.width - buttonSize.width * 1.5
			_viewerView.buttonPrev.y = (_viewerView.imagegalleryData.windowData.window.size.height - buttonSize.height) * 0.5;
			_viewerView.buttonNext.y = _viewerView.buttonPrev.y;
			_viewerView.buttonPrev.rotationY = 180;
			_viewerView.buttonBar.x = (_viewerView.imagegalleryData.windowData.window.size.width - _viewerView.buttonBar.width) * 0.5;
			_viewerView.buttonBar.y = _viewerView.imagegalleryData.windowData.window.size.height - buttonSize.height * 1.5;
		}
		
		private function imageLost(e:IOErrorEvent):void {
			_module.printError("Could not load image: " + e.text);
		}
		
		private function imageLoaded(e:Event):void {
			//view.addChildAt((e.target as LoaderInfo).content, 0);
		}
	}
}