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
package com.panozona.modules.infobox.controller{
	
	import caurina.transitions.Tweener;
	import com.panozona.modules.infobox.events.WindowEvent;
	import com.panozona.modules.infobox.view.WindowView;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	import com.panozona.player.module.data.property.Size;
	import com.panozona.player.module.data.property.Transition;
	import com.panozona.player.module.Module;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	
	public class WindowController{
		
		private var closeController:CloseController;
		private var viewerController:ViewerController;
		
		private var _windowView:WindowView;
		private var _module:Module;
		
		public function WindowController(windowView:WindowView, module:Module) {
			_module = module;
			_windowView = windowView;
			
			_windowView.windowData.addEventListener(WindowEvent.CHANGED_OPEN, onOpenChange, false, 0, true);
			
			var viewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(viewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			handleResize();
			
			closeController = new CloseController(windowView.closeView, _module);
			viewerController = new ViewerController(windowView.viewerView, _module);
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0, true);
		}
		
		private function onPanoramaStartedLoading(loadPanoramaEvent:Object):void {
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading);
			if (_windowView.windowData.open){
				_module.saladoPlayer.manager.runAction(_windowView.windowData.window.onOpen);
			}else {
				_module.saladoPlayer.manager.runAction(_windowView.windowData.window.onClose);
			}
		}
		
		private function handleResize(event:Event = null):void {
			var newSize:Size = new Size(0, 0);
			var newMove:Move = new Move(0, 0);
			
			newSize.width = _module.saladoPlayer.manager.boundsWidth 
				-(_windowView.windowData.window.margin.left + _windowView.windowData.window.margin.right);
			if (newSize.width > _windowView.windowData.window.maxSize.width) {
				newSize.width = _windowView.windowData.window.maxSize.width;
			}
			if (newSize.width < _windowView.windowData.window.minSize.width) {
				newSize.width = _windowView.windowData.window.minSize.width;
			}
			newSize.height = _module.saladoPlayer.manager.boundsHeight 
				-(_windowView.windowData.window.margin.top + _windowView.windowData.window.margin.bottom);
			if (newSize.height > _windowView.windowData.window.maxSize.height) {
				newSize.height = _windowView.windowData.window.maxSize.height;
			}
			if (newSize.height < _windowView.windowData.window.minSize.height) {
				newSize.height = _windowView.windowData.window.minSize.height;
			}
			if (_windowView.windowData.window.align.horizontal == Align.LEFT) {
				newMove.horizontal = _windowView.windowData.window.margin.left;
			} else if (_windowView.windowData.window.align.horizontal == Align.RIGHT) {
				newMove.horizontal = -_windowView.windowData.window.margin.right;
			} else if (_windowView.windowData.window.align.horizontal == Align.CENTER) {
				var tmpHorizontal:Number = (_module.saladoPlayer.manager.boundsWidth - newSize.width) * 0.5;
				if (tmpHorizontal + newSize.width > _module.saladoPlayer.manager.boundsWidth - _windowView.windowData.window.margin.right) {
					newMove.horizontal = (_module.saladoPlayer.manager.boundsWidth - _windowView.windowData.window.margin.right) - (tmpHorizontal + newSize.width);
				}
				if (tmpHorizontal + newMove.horizontal < _windowView.windowData.window.margin.left) {
					newMove.horizontal = _windowView.windowData.window.margin.left - tmpHorizontal;
				}
			}
			if (_windowView.windowData.window.align.vertical == Align.TOP) {
				newMove.vertical = _windowView.windowData.window.margin.top;
			} else if (_windowView.windowData.window.align.vertical == Align.BOTTOM) {
				newMove.vertical = -_windowView.windowData.window.margin.bottom;
			} else if (_windowView.windowData.window.align.vertical == Align.MIDDLE) {
				var tmpVertical:Number = (_module.saladoPlayer.manager.boundsHeight - newSize.height) * 0.5;
				if (tmpVertical + newSize.height > _module.saladoPlayer.manager.boundsHeight - _windowView.windowData.window.margin.bottom) {
					newMove.vertical = (tmpVertical + newSize.height) - (_module.saladoPlayer.manager.boundsHeight - _windowView.windowData.window.margin.bottom);
				}
				if (tmpVertical + newMove.vertical < _windowView.windowData.window.margin.top) {
					newMove.vertical = _windowView.windowData.window.margin.top - tmpVertical;
				}
			}
			_windowView.windowData.currentSize = newSize;
			_windowView.windowData.currentMove = newMove;
			placeWindow();
		}
		
		private function onOpenChange(e:Event):void {
			if (_windowView.windowData.open) {
				_module.saladoPlayer.manager.runAction(_windowView.windowData.window.onOpen);
				openWindow();
			}else {
				_module.saladoPlayer.manager.runAction(_windowView.windowData.window.onClose);
				closeWindow();
			}
		}
		
		private function openWindow():void {
			_windowView.visible = true;
			_windowView.mouseEnabled = true;
			_windowView.mouseChildren = true;
			var tweenObj:Object = new Object();
			tweenObj["time"] = _windowView.windowData.window.openTween.time;
			tweenObj["transition"] = _windowView.windowData.window.openTween.transition;
			if (_windowView.windowData.window.transition.type == Transition.FADE) {
				tweenObj["alpha"] = _windowView.windowData.window.alpha;
			}else{
				tweenObj["x"] = getWindowOpenX();
				tweenObj["y"] = getWindowOpenY();
			}
			Tweener.addTween(_windowView, tweenObj);
		}
		
		private function closeWindow():void {
			var tweenObj:Object = new Object();
			tweenObj["time"] = _windowView.windowData.window.closeTween.time;
			tweenObj["transition"] = _windowView.windowData.window.closeTween.transition;
			tweenObj["onComplete"] = closeWindowOnComplete;
			if (_windowView.windowData.window.transition.type == Transition.FADE) {
				tweenObj["alpha"] = 0;
			}else{
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
				_windowView.alpha = _windowView.windowData.window.alpha;
				_windowView.visible = true;
			}else {
				Tweener.addTween(_windowView, {x:getWindowCloseX(), y:getWindowCloseY()}); // no time parameter
				if(_windowView.windowData.window.transition.type == Transition.FADE){
					_windowView.alpha = 0;
				}
				_windowView.visible = false;
			}
		}
		
		private function getWindowOpenX():Number {
			var result:Number = 0;
			switch(_windowView.windowData.window.align.horizontal) {
				case Align.RIGHT:
					result += _module.saladoPlayer.manager.boundsWidth 
						- _windowView.windowData.currentSize.width 
						+ _windowView.windowData.currentMove.horizontal;
				break;
				case Align.LEFT:
					result += _windowView.windowData.currentMove.horizontal;
				break;
				default: // CENTER
					result += (_module.saladoPlayer.manager.boundsWidth 
						- _windowView.windowData.currentSize.width) * 0.5 
						+ _windowView.windowData.currentMove.horizontal;
			}
			return result;
		}
		
		private function getWindowOpenY():Number{
			var result:Number = 0;
			switch(_windowView.windowData.window.align.vertical) {
				case Align.TOP:
					result += _windowView.windowData.currentMove.vertical;
				break;
				case Align.BOTTOM:
					result += _module.saladoPlayer.manager.boundsHeight 
						- _windowView.windowData.currentSize.height
						+ _windowView.windowData.currentMove.vertical;
				break;
				default: // MIDDLE
					result += (_module.saladoPlayer.manager.boundsHeight 
						- _windowView.windowData.currentSize.height) * 0.5
						+ _windowView.windowData.currentMove.vertical;
			}
			return result;
		}
		
		private function getWindowCloseX():Number {
			var result:Number = 0;
			switch(_windowView.windowData.window.transition.type){
				case Transition.SLIDE_RIGHT:
					result = _module.saladoPlayer.manager.boundsWidth;
				break;
				case Transition.SLIDE_LEFT:
					result = -_windowView.windowData.currentSize.width;
				break;
				default: //SLIDE_UP, SLIDE_DOWN
					result = getWindowOpenX();
			}
			return result;
		}
		
		private function getWindowCloseY():Number{
			var result:Number = 0;
			switch(_windowView.windowData.window.transition.type){
				case Transition.SLIDE_UP:
					result = -_windowView.windowData.currentSize.height;
				break;
				case Transition.SLIDE_DOWN:
					result = _module.saladoPlayer.manager.boundsHeight;
				break;
				default: //SLIDE_LEFT, SLIDE_RIGHT
					result = getWindowOpenY();
			}
			return result;
		}
	}
}