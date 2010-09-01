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
	
	import flash.display.Loader;
	import flash.system.LoaderContext;	
	import flash.system.ApplicationDomain;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import com.panozona.player.manager.events.LoadChildEvent;
	import com.panozona.player.manager.data.ChildData;	

	/**	 
	 * @author mstandio
	 */	
	public class ChildrenLoader extends EventDispatcher {				
				
		private var loaders:Vector.<Loader>;				
		private var childrenData:Vector.<ChildData>;			  	
		
		public function loadChildren(childrenData:Vector.<ChildData>):void {			
			this.childrenData = childrenData;
			loaders = new Vector.<Loader>();
			var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);			
			for(var i:int=0;i<childrenData.length;i++){
				loaders[i] = new Loader(); 			  
				loaders[i].contentLoaderInfo.addEventListener(Event.COMPLETE, childLoaded, false, 0 , true);
				loaders[i].contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, childLost);
				loaders[i].load(new URLRequest(childrenData[i].path),context);
			}		   
		}				
	
		private function childLoaded(e:Event):void {
			for(var i:int=0;i<loaders.length;i++){
				if (loaders[i].contentLoaderInfo === e.target) {					
					if (loaders[i].contentLoaderInfo.url.match(/(.*)\.swf$/i)) {						
						childrenData[i].swfFile = DisplayObject(loaders[i].content);
						dispatchEvent(new LoadChildEvent(LoadChildEvent.SWFDATA_CONTENT, childrenData[i]));
					}else if(loaders[i].contentLoaderInfo.url.match(/^(.*)\w\.(png|gif|jpg|jpeg)$/i)){
						childrenData[i].bitmapFile = Bitmap(loaders[i].content);
						dispatchEvent(new LoadChildEvent(LoadChildEvent.BITMAPDATA_CONTENT, childrenData[i]));
					}
					loaders[i].contentLoaderInfo.removeEventListener(Event.COMPLETE, childLoaded);
				}
			}			
		}
			
		private function childLost(e:IOErrorEvent):void {
			Trace.instance.printError("Could not load file: " + e.toString());
		}						
	}
}