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
package com.panosalado.view {
	
	import flash.display.Sprite;
	import flash.events.Event;	
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class SwfHotspot extends ManagedChild{
		
		protected var button:Sprite;
		
		public function SwfHotspot() {
			button = new Sprite();						
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init, false, 0 , true);					
		}		
		
		private function init(e:Event = null):void {			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild(button);
			hotspotReady();
		}		
		
		protected function hotspotReady():void {			
			throw new Error("Function hotspotReady() must be overrided");
		}						
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void {
			if (type == Event.ADDED_TO_STAGE) {
				super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}else{
				button.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
		}
		
		public function setButtonMode(value:Boolean):void{
			button.buttonMode = value;			
		}				
	}
}