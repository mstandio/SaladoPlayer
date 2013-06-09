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
package com.panozona.spots.dataspot{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.text.TextField;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class DataSpot extends Sprite{
		
		private var textField:TextField;
		
		public function DataSpot(){
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		protected function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			textField = new TextField();
			addChild(textField);
			
			var xmlLoader:URLLoader = new URLLoader();
			try {
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, dataLost);
				xmlLoader.addEventListener(Event.COMPLETE, dataLoaded);
				xmlLoader.load(new URLRequest("http://panozona.com/files/data.txt"));
			}catch (error:Error) {
				// get reference to saladoplayer nd print error in trace window
			}
		}
		
		protected function dataLost(event:IOErrorEvent):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, dataLost);
			event.target.removeEventListener(Event.COMPLETE, dataLoaded);
			// get reference to saladoplayer nd print error in trace window
		}
		
		protected function dataLoaded(event:Event):void {
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, dataLost);
			event.target.removeEventListener(Event.COMPLETE, dataLoaded);
			
			textField.text = event.target.data
		}
	}
}