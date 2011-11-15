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
	
	import com.panozona.modules.imagebutton.events.SubButtonEvent;
	import com.panozona.modules.imagebutton.view.SubButtonView;
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
	
	public class SubButtonController {
		
		private var _module:Module;
		private var _subButtonView:SubButtonView;
		
		private var bitmapDataPlain:BitmapData;
		private var bitmapDataActive:BitmapData;
		
		public function SubButtonController(subButtonView:SubButtonView, module:Module){
			_subButtonView = subButtonView;
			_module = module;
			
			var subButtonLoader:Loader = new Loader();
			subButtonLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, subButtonImageLost);
			subButtonLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, subButtonImageLoaded);
			subButtonLoader.load(new URLRequest(_subButtonView.subButtonData.subButton.path));
			
			_subButtonView.subButtonData.addEventListener(SubButtonEvent.CHANGED_MOUSE_PRESS, handleButtonMousePressChange, false, 0, true);
			_subButtonView.subButtonData.addEventListener(SubButtonEvent.CHANGED_IS_ACTIVE, handleButtonIsActiveChange, false, 0, true);
		}
		
		public function subButtonImageLost(e:IOErrorEvent):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, subButtonImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, subButtonImageLoaded);
			_module.printError(e.toString());
		}
		
		public function subButtonImageLoaded(e:Event):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, subButtonImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, subButtonImageLoaded);
			var bitmapData:BitmapData = new BitmapData((e.target as LoaderInfo).width, (e.target as LoaderInfo).height, true, 0);
			bitmapData.draw((e.target as LoaderInfo).content);
			var butWidth:Number = bitmapData.width;
			var butHeight:Number = Math.ceil((bitmapData.height - 1) / 2);
			
			bitmapDataPlain = new BitmapData(butWidth, butHeight, true, 0);
			bitmapDataPlain.copyPixels(bitmapData, new Rectangle(0, 0, butWidth, butHeight), new Point(0, 0), null, null, true);
			bitmapDataActive = new BitmapData(butWidth, butHeight, true, 0);
			bitmapDataActive.copyPixels(bitmapData, new Rectangle(0, butHeight + 1, butWidth, butHeight), new Point(0, 0), null, null, true);
			
			//todo: adjust window size
			
			if(!_subButtonView.subButtonData.isActive){
				setPlain();
			}
			
			if (_subButtonView.subButtonData.isActive) {
				setActive();
			}
			
			if (_subButtonView.windowData.button.mouse.onOver != null) {
				_subButtonView.addEventListener(MouseEvent.ROLL_OVER, getMouseEventHandler(_subButtonView.subButtonData.subButton.mouse.onOver));
			}
			if (_subButtonView.windowData.button.mouse.onOut != null) {
				_subButtonView.addEventListener(MouseEvent.ROLL_OVER, getMouseEventHandler(_subButtonView.subButtonData.subButton.mouse.onOut));
			}
		}
		
		private function getMouseEventHandler(actionId:String):Function{
			return function(e:MouseEvent):void {
				_module.saladoPlayer.manager.runAction(actionId);
			}
		}
		
		private function handleButtonMousePressChange(e:SubButtonEvent):void {
			if (_subButtonView.subButtonData.mousePress) {
				setActive();
			}else if (!_subButtonView.subButtonData.isActive) {
				setPlain();
			}
		}
		
		private function handleButtonIsActiveChange(e:SubButtonEvent):void {
			if (!_subButtonView.subButtonData.isActive) {
				setPlain();
			}else {
				setActive();
			}
		}
		
		private function setPlain():void {
			if(bitmapDataPlain != null){
				_subButtonView.bitmap.bitmapData = bitmapDataPlain;
			}
		}
		
		private function setActive():void {
			if(bitmapDataActive != null){
				_subButtonView.bitmap.bitmapData = bitmapDataActive;
			}
		}
	}
}