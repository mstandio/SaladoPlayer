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
package com.panozona.modules.compass.controller {
	
	import com.panozona.modules.compass.events.WindowEvent;
	import com.panozona.modules.compass.view.CloseView;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.Module;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	public class CloseController {
		
		private var _closeView:CloseView;
		private var _module:Module;
		
		public function CloseController(closeView:CloseView, module:Module){
			_closeView = closeView;
			_module = module;
			
			_closeView.compassData.windowData.addEventListener(WindowEvent.CHANGED_SIZE, placeonWindow, false, 0, true);
			
			if (_closeView.compassData.close.path == null) {
				module.mouseEnabled = false;
				module.mouseChildren = false;
				return;
			}
			
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLost, false, 0, true);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded, false, 0, true);
			imageLoader.load(new URLRequest(_closeView.compassData.close.path));
		}
		
		private function imageLost(error:IOErrorEvent):void {
			error.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLost);
			error.target.removeEventListener(Event.COMPLETE, imageLoaded);
			_module.printError(error.text);
		}
		
		private function imageLoaded(e:Event):void {
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, imageLost);
			e.target.removeEventListener(Event.COMPLETE, imageLoaded);
			_closeView.addChild(e.target.content)
			_closeView.addEventListener(MouseEvent.CLICK, handleMouseClick, false, 0, true);
			placeonWindow();
		}
		
		private function placeonWindow(e:Event = null):void {
			if (_closeView.compassData.close.align.horizontal == Align.LEFT) {
				_closeView.x = 0;
			}else if (_closeView.compassData.close.align.horizontal == Align.RIGHT) {
				_closeView.x = _closeView.compassData.windowData.size.width - _closeView.width;
			}else { // CENTER
				_closeView.x = (_closeView.compassData.windowData.size.width - _closeView.width) * 0.5;
			}
			if (_closeView.compassData.close.align.vertical == Align.TOP){
				_closeView.y = 0;
			}else if (_closeView.compassData.close.align.vertical == Align.BOTTOM) {
				_closeView.y = _closeView.compassData.windowData.size.height - _closeView.height;
			}else { // MIDDLE
				_closeView.y = (_closeView.compassData.windowData.size.height - _closeView.height) * 0.5;
			}
			_closeView.x += _closeView.compassData.close.move.horizontal;
			_closeView.y += _closeView.compassData.close.move.vertical;
		}
		
		private function handleMouseClick(e:Event):void {
			_closeView.compassData.windowData.open = false;
		}
	}
}