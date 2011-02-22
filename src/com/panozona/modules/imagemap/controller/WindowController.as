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
package com.panozona.modules.imagemap.controller{
	
	import caurina.transitions.*;
	import com.panozona.modules.imagemap.events.WindowEvent;
	import com.panozona.modules.imagemap.model.WindowData;
	import com.panozona.modules.imagemap.view.WindowView;
	import com.panozona.player.component.data.property.Align;
	import com.panozona.player.component.Module;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	public class WindowController{
		
		private var _windowView:WindowView;
		private var _module:Module; // to get bounds width and height
		
		private var contentViewerController:ContentViewerController;
		
		/**
		 * Constructor.
		 * @param	windowView Reference to window.
		 * @param	module Reference to module, needed to obtain bounds value change.
		 */
		public function WindowController(windowView:WindowView, module:Module) {
			
			contentViewerController = new ContentViewerController(windowView.contentViewerView, module);
			
			_module = module;
			_windowView = windowView;
			
			_windowView.windowData.addEventListener(WindowEvent.CHANGED_OPEN, onOpenChange, false, 0, true);
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			
			var PanoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(PanoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0 , true);
		}
		
		/**
		 * Changes window "open" state to opposite value.
		 * @param	event 
		 */
		public function toggleOpen(event:Event = null):void {
			_windowView.windowData.open = !_windowView.windowData.open;
		}
		
		/**
		 * Places window depending on it's "open" state and other windowData values, called on bounds value change.
		 * @param	event
		 */
		public function handleResize(event:Event = null):void {
			placeWindow();
		}
		
		private function onPanoramaStartedLoading(loadPanoramaEvent:Object):void {
			var LoadPanoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.LoadPanoramaEvent") as Class;
			_module.saladoPlayer.manager.removeEventListener(LoadPanoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading);
			if (_windowView.windowData.open) {
				_module.saladoPlayer.manager.runAction(_windowView.windowData.onOpen);
			}else {
				_module.saladoPlayer.manager.runAction(_windowView.windowData.onClose);
			}
		}
		
		private function onOpenChange(e:Event):void {
			if (_windowView.windowData.open) {
				_module.saladoPlayer.manager.runAction(_windowView.windowData.onOpen);
				openWindow();
			}else {
				_module.saladoPlayer.manager.runAction(_windowView.windowData.onClose);
				closeWindow();
			}
		}
		
		private function openWindow():void {
			_windowView.visible = true;
			_windowView.mouseEnabled = true;
			_windowView.mouseChildren = true;
			var tweenObj:Object = new Object();
			tweenObj["time"] = _windowView.windowData.openTween.time;
			tweenObj["transition"] = _windowView.windowData.openTween.transition;
			
			switch(_windowView.windowData.transitionType) {
				case WindowData.OPEN_CLOSE_FADE: 
					tweenObj["alpha"] = _windowView.windowData.alpha;
				break;
				default:
					tweenObj["x"] = getWindowOpenX();
					tweenObj["y"] = getWindowOpenY();
			}
			Tweener.addTween(_windowView, tweenObj);
		}
		
		private function closeWindow():void {
			var tweenObj:Object = new Object();
			tweenObj["time"] = _windowView.windowData.closeTween.time;
			tweenObj["transition"] = _windowView.windowData.closeTween.transition; // TODO: transition in and out ?? 
			tweenObj["onComplete"] = closeWindowOnComplete;
			switch(_windowView.windowData.transitionType) {
				case WindowData.OPEN_CLOSE_FADE: 
					tweenObj["alpha"] = 0;
				break;
				default:
					tweenObj["x"] = getWindowCloseX();
					tweenObj["y"] = getWindowCloseY();
			}
			_windowView.mouseEnabled = false;
			_windowView.mouseChildren = false;
			Tweener.addTween(_windowView, tweenObj);
		}
		
		private function closeWindowOnComplete():void {
			_windowView.visible = false;
		}
		
		private function placeWindow(e:Event = null):void {
			if (_windowView.windowData.open) {
				Tweener.addTween(_windowView, {x:getWindowOpenX(), y:getWindowOpenY()});  // no time parameter
				_windowView.alpha = _windowView.windowData.alpha;
				_windowView.visible = true;
			}else {
				Tweener.addTween(_windowView, {x:getWindowCloseX(), y:getWindowCloseY()}); // no time parameter
				if(_windowView.windowData.transitionType == WindowData.OPEN_CLOSE_FADE){
					_windowView.alpha = 0;
				}
				_windowView.visible = false;
			}
		}
		
		private function getWindowOpenX():Number {
			var result:Number = 0;
			switch(_windowView.windowData.align.horizontal) {
				case Align.RIGHT:
					result += _module.saladoPlayer.manager.boundsWidth - _windowView.windowData.size.width + _windowView.windowData.move.horizontal;
				break;
				case Align.LEFT:
					result += _windowView.windowData.move.horizontal;
				break;
				default: // CENTER
					result += (_module.saladoPlayer.manager.boundsWidth - _windowView.windowData.size.width)*0.5 + _windowView.windowData.move.horizontal;
			}
			return result;
		}
		
		private function getWindowOpenY():Number{
			var result:Number = 0;
			switch(_windowView.windowData.align.vertical) {
				case Align.TOP:
					result += _windowView.windowData.move.vertical;
				break;
				case Align.BOTTOM:
					result += _module.saladoPlayer.manager.boundsHeight - _windowView.windowData.size.height + _windowView.windowData.move.vertical;
				break;
				default: // MIDDLE
					result += (_module.saladoPlayer.manager.boundsHeight - _windowView.windowData.size.height)*0.5 + _windowView.windowData.move.vertical;
			}
			return result;
		}
		
		private function getWindowCloseX():Number {
			var result:Number = 0;
			switch(_windowView.windowData.transitionType){
				case WindowData.OPEN_CLOSE_SLIDE_RIGHT:
					result = _module.saladoPlayer.manager.boundsWidth;
				break;
				case WindowData.OPEN_CLOSE_SLIDE_LEFT:
					result = -_windowView.windowData.size.width;
				break;
				default: //OPEN_CLOSE_SLIDE_UP, OPEN_CLOSE_SLIDE_DOWN 
					result = getWindowOpenX();
			}
			return result;
		}
		
		private function getWindowCloseY():Number{
			var result:Number = 0;
			switch(_windowView.windowData.transitionType){
				case WindowData.OPEN_CLOSE_SLIDE_UP:
					result = -_windowView.windowData.size.height;
				break;
				case WindowData.OPEN_CLOSE_SLIDE_DOWN:
					result = 0;
				break;
				default: //OPEN_CLOSE_SLIDE_LEFT, OPEN_CLOSE_SLIDE_RIGHT 
					result = getWindowOpenY();
			}
			return result;
		}
	}
}