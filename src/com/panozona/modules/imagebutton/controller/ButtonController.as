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
package com.panozona.modules.imagebutton.controller{
	
	import com.panozona.modules.imagebutton.events.ButtonEvent;
	import com.panozona.modules.imagebutton.view.ButtonView;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Transition;
	import com.panozona.player.module.Module;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.ApplicationDomain;
	import caurina.transitions.Tweener;
	
	public class ButtonController {
		
		private var _buttonView:ButtonView;
		private var _module:Module; // to get bounds width and height
		
		public function ButtonController(buttonView:ButtonView, module:Module) {
			
			_buttonView = buttonView;
			_module = module;
			_buttonView.buttonData.addEventListener(ButtonEvent.CHANGED_OPEN, onOpenChange, false, 0, true);
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0, true);
			
			var buttonLoader:Loader = new Loader();
			buttonLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, buttonImageLost);
			buttonLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, buttonImageLoaded);
			buttonLoader.load(new URLRequest(_buttonView.buttonData.button.path));
		}
		
		public function buttonImageLost(e:IOErrorEvent):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, buttonImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, buttonImageLoaded);
			_module.printError(e.toString());
		}
		
		public function buttonImageLoaded(e:Event):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, buttonImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, buttonImageLoaded);
			
			_buttonView.addChild((e.target as LoaderInfo).content);
			
			if (_buttonView.buttonData.button.text != null) {
				_buttonView.addEventListener(MouseEvent.CLICK, getMouseUrlHandler(_buttonView.buttonData.button.text));
			}
			if (_buttonView.buttonData.button.mouse.onClick != null) {
				_buttonView.addEventListener(MouseEvent.CLICK, getMouseEventHandler(_buttonView.buttonData.button.mouse.onClick));
			}
			if (_buttonView.buttonData.button.mouse.onPress != null) {
				_buttonView.addEventListener(MouseEvent.MOUSE_DOWN, getMouseEventHandler(_buttonView.buttonData.button.mouse.onPress));
			}
			if (_buttonView.buttonData.button.mouse.onRelease != null) {
				_buttonView.addEventListener(MouseEvent.MOUSE_UP, getMouseEventHandler(_buttonView.buttonData.button.mouse.onRelease));
			}
			if (_buttonView.buttonData.button.mouse.onOver != null) {
				_buttonView.addEventListener(MouseEvent.ROLL_OVER, getMouseEventHandler(_buttonView.buttonData.button.mouse.onOver));
			}
			if (_buttonView.buttonData.button.mouse.onOut != null) {
				_buttonView.addEventListener(MouseEvent.ROLL_OUT, getMouseEventHandler(_buttonView.buttonData.button.mouse.onOut));
			}
			
			handleResize();
		}
		
		private function getMouseEventHandler(actionId:String):Function{
			return function(e:MouseEvent):void {
				_module.saladoPlayer.manager.runAction(actionId);
			}
		}
		
		private function getMouseUrlHandler(url:String):Function{
			return function(e:MouseEvent):void {
				navigateToURL(new URLRequest(url), '_BLANK');
			}
		}
		
		public function handleResize(event:Event = null):void {
			placeButton();
		}
		
		private function onPanoramaStartedLoading(loadPanoramaEvent:Object):void {
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading);
			if (_buttonView.buttonData.open) {
				_module.saladoPlayer.manager.runAction(_buttonView.buttonData.button.onOpen);
			}else {
				_module.saladoPlayer.manager.runAction(_buttonView.buttonData.button.onClose);
			}
		}
		
		private function onOpenChange(e:Event):void {
			if (_buttonView.buttonData.open) {
				_module.saladoPlayer.manager.runAction(_buttonView.buttonData.button.onOpen);
				openButton();
			}else {
				_module.saladoPlayer.manager.runAction(_buttonView.buttonData.button.onClose);
				closeButton();
			}
		}
		
		private function openButton():void {
			_buttonView.visible = true;
			if(_buttonView.buttonData.button.text || _buttonView.buttonData.button.mouse.onClick
				|| _buttonView.buttonData.button.mouse.onOut || _buttonView.buttonData.button.mouse.onOver
				|| _buttonView.buttonData.button.mouse.onPress || _buttonView.buttonData.button.mouse.onRelease){
				_buttonView.mouseEnabled = true;
				_buttonView.mouseChildren = true;
			}
			var tweenObj:Object = new Object();
			tweenObj["time"] = _buttonView.buttonData.button.openTween.time;
			tweenObj["transition"] = _buttonView.buttonData.button.openTween.transition;
			switch(_buttonView.buttonData.button.transition.type){
				case Transition.FADE:
					tweenObj["alpha"] = _buttonView.buttonData.button.alpha;
				break;
				default:
					tweenObj["x"] = getButtonOpenX();
					tweenObj["y"] = getButtonOpenY();
			}
			Tweener.addTween(_buttonView, tweenObj);
		}
		
		private function closeButton():void {
			var tweenObj:Object = new Object();
			tweenObj["time"] = _buttonView.buttonData.button.closeTween.time;
			tweenObj["transition"] = _buttonView.buttonData.button.closeTween.transition;
			tweenObj["onComplete"] = closeButtonOnComplete;
			switch(_buttonView.buttonData.button.transition.type) {
				case Transition.FADE:
					tweenObj["alpha"] = 0;
				break;
				default:
					tweenObj["x"] = getButtonCloseX();
					tweenObj["y"] = getButtonCloseY();
			}
			_buttonView.mouseEnabled = false;
			_buttonView.mouseChildren = false;
			Tweener.addTween(_buttonView, tweenObj);
		}
		
		private function closeButtonOnComplete():void {
			_buttonView.visible = false;
		}
		
		private function placeButton(e:Event = null):void {
			if (_buttonView.buttonData.open) {
				Tweener.addTween(_buttonView, {x:getButtonOpenX(), y:getButtonOpenY()});
				_buttonView.alpha = _buttonView.buttonData.button.alpha;
				_buttonView.visible = true;
			}else {
				Tweener.addTween(_buttonView, {x:getButtonCloseX(), y:getButtonCloseY()});
				if(_buttonView.buttonData.button.transition.type == Transition.FADE){
					_buttonView.alpha = 0;
				}
				_buttonView.visible = false;
			}
		}
		
		private function getButtonOpenX():Number {
			var result:Number = 0;
			switch(_buttonView.buttonData.button.align.horizontal) {
				case Align.RIGHT:
					result += _module.saladoPlayer.manager.boundsWidth
						- _buttonView.width
						+ _buttonView.buttonData.button.move.horizontal;
				break;
				case Align.LEFT:
					result += _buttonView.buttonData.button.move.horizontal;
				break;
				default: // CENTER
					result += (_module.saladoPlayer.manager.boundsWidth 
						- _buttonView.width) * 0.5
						+ _buttonView.buttonData.button.move.horizontal;
			}
			return result;
		}
		
		private function getButtonOpenY():Number{
			var result:Number = 0;
			switch(_buttonView.buttonData.button.align.vertical){
				case Align.TOP:
					result += _buttonView.buttonData.button.move.vertical;
				break;
				case Align.BOTTOM:
					result += _module.saladoPlayer.manager.boundsHeight
						- _buttonView.height
						+ _buttonView.buttonData.button.move.vertical;
				break;
				default: // MIDDLE
					result += (_module.saladoPlayer.manager.boundsHeight
						- _buttonView.height) * 0.5
						+ _buttonView.buttonData.button.move.vertical;
			}
			return result;
		}
		
		private function getButtonCloseX():Number {
			var result:Number = 0;
			switch(_buttonView.buttonData.button.transition.type){
				case Transition.SLIDE_RIGHT:
					result = _module.saladoPlayer.manager.boundsWidth;
				break;
				case Transition.SLIDE_LEFT:
					result = - _buttonView.width;
				break;
				default: //SLIDE_UP, SLIDE_DOWN
					result = getButtonOpenX();
			}
			return result;
		}
		
		private function getButtonCloseY():Number{
			var result:Number = 0;
			switch(_buttonView.buttonData.button.transition.type){
				case Transition.SLIDE_UP:
					result = - _buttonView.height;
				break;
				case Transition.SLIDE_DOWN:
					result = _module.saladoPlayer.manager.boundsHeight;
				break;
				default: //SLIDE_LEFT, SLIDE_RIGHT
					result = getButtonOpenY();
			}
			return result;
		}
	}
}