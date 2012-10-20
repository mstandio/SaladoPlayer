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
package com.panozona.modules.infobox.controller {
	
	import com.panozona.modules.infobox.events.ScrollBarEvent;
	import com.panozona.modules.infobox.events.ViewerEvent;
	import com.panozona.modules.infobox.events.WindowEvent;
	import com.panozona.modules.infobox.model.structure.Article;
	import com.panozona.modules.infobox.view.ViewerView;
	import com.panozona.player.module.Module;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.text.StyleSheet;
	import flash.utils.ByteArray;
	
	public class ViewerController {
		
		private var _scrollBarController:ScrollBarController;
		
		private var _viewerView:ViewerView;
		private var _module:Module;
		
		public function ViewerController(viewerView:ViewerView, module:Module) {
			_module = module;
			_viewerView = viewerView;
			
			_scrollBarController = new ScrollBarController(_viewerView.scrollBarView, _module);
			
			if(_viewerView.infoBoxData.viewerData.viewer.css != null){
				var cssLoader:URLLoader = new URLLoader();
				cssLoader.dataFormat = URLLoaderDataFormat.BINARY;
				cssLoader.addEventListener(IOErrorEvent.IO_ERROR, cssLost);
				cssLoader.addEventListener(Event.COMPLETE, cssLoaded);
				cssLoader.load(new URLRequest(_viewerView.infoBoxData.viewerData.viewer.css));
			}
			
			_viewerView.infoBoxData.windowData.addEventListener(WindowEvent.CHANGED_CURRENT_SIZE, handleResize, false, 0, true);
			_viewerView.infoBoxData.viewerData.scrollBarData.addEventListener(ScrollBarEvent.CHANGED_IS_SHOWING, handleResize, false, 0, true);
			_viewerView.infoBoxData.viewerData.scrollBarData.addEventListener(ScrollBarEvent.CHANGED_SCROLL_BAR_WIDTH, handleResize, false, 0, true);
			_viewerView.infoBoxData.viewerData.scrollBarData.addEventListener(ScrollBarEvent.CHANGED_SCROLL_VALUE, handleScrollValueChange, false, 0, true);
			_viewerView.infoBoxData.viewerData.addEventListener(ViewerEvent.CHANGED_CURRENT_ARTICLE_ID, handleCurrentArticleIdChange, false, 0, true);
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			
			handleResize();
		}
		
		private function cssLost(event:IOErrorEvent):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, cssLost);
			event.target.removeEventListener(Event.COMPLETE, cssLoaded);
			_module.printError("Could not load: " + _viewerView.infoBoxData.viewerData.viewer.css);
		}
		
		private function cssLoaded(event:Event):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, cssLost);
			event.target.removeEventListener(Event.COMPLETE, cssLoaded);
			var input:ByteArray = event.target.data;
			try { input.uncompress(); } catch (error:Error) { }
			try {
				var styleSheet:StyleSheet = new StyleSheet();
				styleSheet.parseCSS(input.toString());
				_viewerView.textField.styleSheet = styleSheet;
			} catch (error:Error) { 
				_module.printError("Stylesheet is not valid: " + error.message);
			}
		}
		
		private function onPanoramaLoaded(loadPanoramaEvent:Object):void {
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			_module.saladoPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaLoaded);
			if(_viewerView.infoBoxData.viewerData.currentArticleId == null){
				_viewerView.infoBoxData.viewerData.currentArticleId = (_viewerView.infoBoxData.viewerData.articles.getChildrenOfGivenClass(Article)[0]).id;
			}
		}
		
		private function handleCurrentArticleIdChange(event:Event = null):void {
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, articleLost);
			xmlLoader.addEventListener(Event.COMPLETE, articleLoaded);
			xmlLoader.load(new URLRequest(_viewerView.infoBoxData.viewerData.getArticleById(_viewerView.infoBoxData.viewerData.currentArticleId).path));
		}
		
		protected function articleLost(event:IOErrorEvent):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, articleLost);
			event.target.removeEventListener(Event.COMPLETE, articleLoaded);
			_module.printError("Could not load article: " + _viewerView.infoBoxData.viewerData.getArticleById(_viewerView.infoBoxData.viewerData.currentArticleId).path);
		}
		
		protected function articleLoaded(event:Event):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, articleLost);
			event.target.removeEventListener(Event.COMPLETE, articleLoaded);
			var input:ByteArray = event.target.data;
			try { input.uncompress(); } catch (error:Error) { }
			var text:String = input.toString().replace(/~/gm, _module.saladoPlayer.loaderInfo.parameters.tilde ? _module.saladoPlayer.loaderInfo.parameters.tilde : "");
			_scrollBarController.reset();
			_viewerView.textField.setSelection(0, 0);
			_viewerView.textField.htmlText = text;
			handleResize();
		}
		
		private function handleResize(event:Event = null):void {
			_viewerView.graphics.clear();
			_viewerView.graphics.beginFill(_viewerView.infoBoxData.viewerData.viewer.style.color, _viewerView.infoBoxData.viewerData.viewer.style.alpha);
			_viewerView.graphics.drawRect(0, 0, _viewerView.infoBoxData.windowData.currentSize.width, _viewerView.infoBoxData.windowData.currentSize.height);
			_viewerView.graphics.endFill();
			
			_viewerView.textField.x = _viewerView.infoBoxData.viewerData.viewer.padding;
			_viewerView.textFieldMask.x = _viewerView.textFieldMask.y = _viewerView.infoBoxData.viewerData.viewer.padding; 
			
			_viewerView.textFieldMask.graphics.clear();
			_viewerView.textFieldMask.graphics.beginFill(0x000000);
			_viewerView.textFieldMask.graphics.drawRect(0, 0,
				(_viewerView.infoBoxData.viewerData.scrollBarData.isShowing 
					? _viewerView.infoBoxData.windowData.currentSize.width - 2 * _viewerView.infoBoxData.viewerData.viewer.padding - 
						_viewerView.infoBoxData.viewerData.scrollBarData.scrollBarWidth
					: _viewerView.infoBoxData.windowData.currentSize.width - 2 * _viewerView.infoBoxData.viewerData.viewer.padding),
				_viewerView.infoBoxData.windowData.currentSize.height - 2 * _viewerView.infoBoxData.viewerData.viewer.padding);
			_viewerView.textFieldMask.graphics.endFill();
			
			_viewerView.textField.width = _viewerView.textFieldMask.width;
			_viewerView.textField.height = _viewerView.textField.textHeight;
			
			_viewerView.infoBoxData.viewerData.textHeight = _viewerView.textField.height;
			handleScrollValueChange();
		}
		
		private function handleScrollValueChange(event:Event = null):void {
			_viewerView.textField.y = -_viewerView.infoBoxData.viewerData.scrollBarData.scrollValue 
				* (_viewerView.infoBoxData.viewerData.textHeight - _viewerView.textFieldMask.height)
				+ _viewerView.infoBoxData.viewerData.viewer.padding;
		}
	}
}