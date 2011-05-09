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
package com.panozona.modules.infobubble.controller {
	
	import caurina.transitions.Tweener;
	import com.panozona.modules.infobubble.events.BubbleEvent;
	import com.panozona.modules.infobubble.model.structure.Bubble;
	import com.panozona.modules.infobubble.view.BubbleView;
	import com.panozona.player.module.Module;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class BubbleController {
		
		private var _bubbleView:BubbleView;
		private var _module:Module;
		
		private var bubbleLoader:Loader;
		
		private var ellipseAxisX:Number;
		private var ellipseAxisY:Number;
		private var dir:Number;
		private var angle:Number; 
		
		public function BubbleController(bubbleView:BubbleView, module:Module){
			_bubbleView = bubbleView;
			_module = module;
			
			dir = (_bubbleView.infoBubbleData.bubbles.defaultAngle > 0) ? 0.5 : -0.5; // 0.5 clockwise, -0.5 counterclockwise
			
			bubbleLoader = new Loader();
			bubbleLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, bubbleLost, false, 0, true);
			bubbleLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bubbleLoaded, false, 0, true);
			
			_bubbleView.infoBubbleData.bubbleData.addEventListener(BubbleEvent.CHANGED_ENABLED, handleEnabledChange);
			_bubbleView.infoBubbleData.bubbleData.addEventListener(BubbleEvent.CHANGED_CURRENT_BUBBLE_ID, handleCurrentIdChange);
			_bubbleView.infoBubbleData.bubbleData.addEventListener(BubbleEvent.CHANGED_IS_SHOWING_BUBBLE, handleIsShowingChange);
		}
		
		private function handleEnabledChange(e:Event):void {
			if (_bubbleView.infoBubbleData.bubbleData.enabled) {
				if (_bubbleView.infoBubbleData.bubbleData.isShowingBubble) { // should have been showing but was disabled
					handleIsShowingChange();
				}
				_module.saladoPlayer.manager.runAction(_bubbleView.infoBubbleData.settings.onEnable);
			}else if(_bubbleView.numChildren > 0){
				Tweener.addTween(_bubbleView.getChildAt(0),{
					alpha:0,
					time:_bubbleView.infoBubbleData.bubbles.hideTween.time,
					transition:_bubbleView.infoBubbleData.bubbles.hideTween.transition,
					onComplete:cleanUp});
				_module.saladoPlayer.manager.runAction(_bubbleView.infoBubbleData.settings.onDisable);
			}
		}
		
		private function handleCurrentIdChange(e:Event):void {
			while (_bubbleView.numChildren) _bubbleView.removeChildAt(0);
			bubbleLoader.unload();
			for each (var bubble:Bubble in _bubbleView.infoBubbleData.bubbles.getChildrenOfGivenClass(Bubble)){
				if (bubble.id == _bubbleView.infoBubbleData.bubbleData.currentBubbleId) {
					bubbleLoader.load(new URLRequest(bubble.path));
					return;
				}
			}
			_module.printWarning("Could not find bubble: " + _bubbleView.infoBubbleData.bubbleData.currentBubbleId);
		}
		
		private function bubbleLost(error:IOErrorEvent):void {
			_module.printError(error.text);
		}
		
		private function bubbleLoaded(e:Event):void {
			while (_bubbleView.numChildren) _bubbleView.removeChildAt(0);
			_bubbleView.addChild(bubbleLoader.content);
			_bubbleView.getChildAt(0).alpha = 0;
			ellipseAxisX = Math.max(_bubbleView.width, _bubbleView.height) / 2 * Math.SQRT2;
			ellipseAxisY = Math.min(_bubbleView.width, _bubbleView.height) / 2 * Math.SQRT2;
			angle = -_bubbleView.infoBubbleData.bubbles.defaultAngle;
			handleIsShowingChange();
		}
		
		private function handleIsShowingChange(e:Event = null):void {
			if (_bubbleView.numChildren == 0) return; // nothing loaded yet
			if (!_bubbleView.infoBubbleData.bubbleData.enabled && _bubbleView.infoBubbleData.bubbleData.isShowingBubble) return; // do not show when disabled
			_bubbleView.visible = true;
			if (_bubbleView.infoBubbleData.bubbleData.isShowingBubble){
				_module.stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
				Tweener.addTween(_bubbleView.getChildAt(0),{
					alpha:1,
					time:_bubbleView.infoBubbleData.bubbles.showTween.time,
					transition:_bubbleView.infoBubbleData.bubbles.showTween.transition});
			}else {
				Tweener.addTween(_bubbleView.getChildAt(0),{
					alpha:0,
					time:_bubbleView.infoBubbleData.bubbles.hideTween.time,
					transition:_bubbleView.infoBubbleData.bubbles.hideTween.transition,
					onComplete:cleanUp});
			}
		}
		
		private function cleanUp():void {
			if (!_bubbleView.infoBubbleData.bubbleData.isShowingBubble){
				_bubbleView.visible = false;
				_module.stage.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			}
		}
		
		private function handleEnterFrame(e:Event = null):void {
			if (angle == -_bubbleView.infoBubbleData.bubbles.defaultAngle) {
				if (_module.mouseY > _module.saladoPlayer.manager.boundsHeight * 0.5) {
					dir = (_bubbleView.infoBubbleData.bubbles.defaultAngle > 0) ? 0.5 : -0.5;
				}else {
					dir = (_bubbleView.infoBubbleData.bubbles.defaultAngle > 0) ? -0.5 : 0.5;
				}
			}
			
			_bubbleView.x = _module.mouseX - Math.sin(angle * __toRadians) * ellipseAxisX - _bubbleView.width * 0.5;
			_bubbleView.y = _module.mouseY - Math.cos(angle * __toRadians) * ellipseAxisY - _bubbleView.height * 0.5;
			
			if (hasConflict()) {
				while (hasConflict()) {
					angle += dir;
					angle = validate(angle);
					_bubbleView.x = _module.mouseX - Math.sin(angle * __toRadians) * ellipseAxisX - _bubbleView.width * 0.5;
					_bubbleView.y = _module.mouseY - Math.cos(angle * __toRadians) * ellipseAxisY - _bubbleView.height * 0.5;
				}
			}else if (wontBeConflict(angle - dir)){
				while (wontBeConflict(angle - dir) && angle != -_bubbleView.infoBubbleData.bubbles.defaultAngle) {
					angle -= dir;
					angle = validate(angle);
					_bubbleView.x = _module.mouseX - Math.sin(angle * __toRadians) * ellipseAxisX - _bubbleView.width * 0.5;
					_bubbleView.y = _module.mouseY - Math.cos(angle * __toRadians) * ellipseAxisY - _bubbleView.height * 0.5;
				}
			}
		}
		
		private var bub_x:Number;
		private var bub_y:Number;
		private function wontBeConflict(angle:Number):Boolean {
			bub_x = _module.mouseX - Math.sin(angle * __toRadians) * ellipseAxisX - _bubbleView.width * 0.5;
			bub_y = _module.mouseY - Math.cos(angle * __toRadians) * ellipseAxisY - _bubbleView.height * 0.5;
			return(bub_x + _bubbleView.width <= _module.saladoPlayer.manager.boundsWidth 
			&& bub_y + _bubbleView.height <= _module.saladoPlayer.manager.boundsHeight
			&& bub_y >= 0
			&& bub_x >= 0);
		}
		
		private function hasConflict():Boolean {
			return(_bubbleView.x + _bubbleView.width > _module.saladoPlayer.manager.boundsWidth
			|| _bubbleView.y + _bubbleView.height > _module.saladoPlayer.manager.boundsHeight
			|| _bubbleView.y < 0
			|| _bubbleView.x < 0);
		}
		
		private function validate(value:Number):Number{
			if ( value <= -180 ) value = ((value + 180)%360)+180;
			if ( value >= 180 )  value = ((value + 180)%360)-180;
			return value;
		}
		
		private var __toRadians:Number = Math.PI / 180;
	}
}