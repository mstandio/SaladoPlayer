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
package com.panozona.player.manager.utils {
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.net.URLRequest;
	
	import com.panozona.player.manager.data.hotspot.HotspotData;
	import com.panozona.player.manager.events.LoadHotspotEvent;
	
	/**
	 * 
	 * @author mstandio
	 */
	public class HotspotsLoader extends EventDispatcher {
		
		private var _loaders:Vector.<Loader>;
		private var _hotspotsData:Vector.<HotspotData>;
		
		/**
		 * 
		 * @param	hotspotsData
		 */
		public function load(hotspotsData:Vector.<HotspotData>):void {
			_hotspotsData = hotspotsData;
			_loaders = new Vector.<Loader>();
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			for(var i:int = 0; i < _hotspotsData.length; i++){
				_loaders[i] = new Loader();
				_loaders[i].contentLoaderInfo.addEventListener(Event.COMPLETE, hotspotLoaded);
				_loaders[i].contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, hotspotLost);
				_loaders[i].load(new URLRequest(hotspotsData[i].path), context);
			}
		}
		
		private function hotspotLoaded(e:Event):void {
			for(var i:int = 0; i < _loaders.length; i++){
				if (_loaders[i] != null && _loaders[i].contentLoaderInfo === e.target) {
					if (_loaders[i].contentLoaderInfo.url.match(/^(.*)\.swf$/i)) {
						_hotspotsData[i].content = DisplayObject(_loaders[i].content);
						dispatchEvent(new LoadHotspotEvent(LoadHotspotEvent.SWF_CONTENT, _hotspotsData[i]));
					}else if(_loaders[i].contentLoaderInfo.url.match(/^(.*)\.(png|gif|jpg|jpeg)$/i)){
						_hotspotsData[i].content = Bitmap(_loaders[i].content).bitmapData;
						dispatchEvent(new LoadHotspotEvent(LoadHotspotEvent.BMD_CONTENT, _hotspotsData[i]));
					}else if (_loaders[i].contentLoaderInfo.url.match(/^(.*)\.xml$/i)) {
						try{
							_hotspotsData[i].content = XML(_loaders[i].content);
							dispatchEvent(new LoadHotspotEvent(LoadHotspotEvent.XML_CONTENT, _hotspotsData[i]));
						}catch (error:Error) {
							Trace.instance.printError("Hotspot XML error: "+error.message);
						}
					}else {
						Trace.instance.printError("Not supported file: "+_loaders[i].contentLoaderInfo.url);
					}
					_loaders[i].contentLoaderInfo.removeEventListener(Event.COMPLETE, hotspotLoaded);
					_loaders[i].contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, hotspotLost);
					_loaders[i] = null;
				}
			}
		}
		
		private function hotspotLost(error:IOErrorEvent):void {
			for(var i:int = 0; i < _loaders.length; i++){
				if (_loaders[i] != null && _loaders[i].contentLoaderInfo == error.target) {
					_loaders[i].contentLoaderInfo.removeEventListener(Event.COMPLETE, hotspotLoaded);
					_loaders[i].contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, hotspotLost);
					_loaders[i] = null;
				}
			}
			Trace.instance.printError("Could not load hotspot file: "+error.text);
		}
	}
}
