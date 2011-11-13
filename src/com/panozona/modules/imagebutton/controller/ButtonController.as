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
	
	import caurina.transitions.Tweener;
	import com.panozona.modules.imagebutton.events.ButtonEvent;
	import com.panozona.modules.imagebutton.view.ButtonView;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Transition;
	import com.panozona.player.module.Module;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	public class ButtonController {
		
		private var _buttonView:ButtonView;
		private var _module:Module;
		
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
		
		private function onPanoramaStartedLoading(loadPanoramaEvent:Object):void {
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading);
			if (_buttonView.buttonData.open) {
				_module.saladoPlayer.manager.runAction(_buttonView.buttonData.button.onOpen);
			}else {
				_module.saladoPlayer.manager.runAction(_buttonView.buttonData.button.onClose);
			}
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
			
			handleResize();
		}
		
		private function getMouseEventHandler(actionId:String):Function{
			return function(e:MouseEvent):void {
				_module.saladoPlayer.manager.runAction(actionId);
			}
		}
	}
}