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
package com.panozona.player.manager.utils.loading{
	
	import com.panozona.player.manager.utils.loading.*;
	import com.panozona.player.manager.events.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	
	public class LoadablesLoader extends EventDispatcher{
		
		private var loaders:Vector.<Loader>;
		private var loadables:Vector.<ILoadable>;
		
		public function load(loadables:Vector.<ILoadable>):void {
			this.loadables = loadables;
			loaders = new Vector.<Loader>();
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			for (var i:int = 0; i < loadables.length; i++) {
				if (loadables[i].path == null || !loadables[i].path.match(/^.+(.jpg|.jpeg|.png|.bmp|.gif|.swf)$/i)) {
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOST, loadables[i].path));
					continue;
				}
				loaders[i] = new Loader();
				loaders[i].contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadableLost);
				loaders[i].contentLoaderInfo.addEventListener(Event.COMPLETE, loadableLoaded);
				loaders[i].load(new URLRequest(loadables[i].path), context);
			}
		}
		
		private function loadableLost(e:IOErrorEvent):void {
			for(var i:int = 0; i < loaders.length; i++) {
				if (loaders[i] != null && loaders[i].contentLoaderInfo === e.target) {
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOST, loaders[i].contentLoaderInfo.url));
					loaders[i].contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadableLost);
					loaders[i].contentLoaderInfo.removeEventListener(Event.COMPLETE, loadableLoaded);
					loaders[i] = null;
					checkLoadingState();
					return;
				}
			}
		}
		
		private function loadableLoaded(e:Event):void {
			for(var i:int = 0; i < loaders.length; i++){
				if (loaders[i] != null && loaders[i].contentLoaderInfo === e.target) {
					dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.LOADED, loaders[i].contentLoaderInfo.url, loaders[i].content));
					loaders[i].contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadableLost);
					loaders[i].contentLoaderInfo.removeEventListener(Event.COMPLETE, loadableLoaded);
					loaders[i] = null;
					checkLoadingState();
					return;
				}
			}
		}
		
		private function checkLoadingState():void {
			for (var i:int = 0; i < loaders.length; i++) {
				if (loaders[i] != null) {
					return;
				}
			}
			dispatchEvent(new LoadLoadableEvent(LoadLoadableEvent.FINISHED, null)); // TODO: argh
		}
	}
}
