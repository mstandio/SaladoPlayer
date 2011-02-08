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
package com.panozona.player.manager.events {
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class LoadLoadableEvent extends Event {
		
		public static const LOADED:String = "loadableLoaded";
		public static const LOST:String = "loadableLost";
		public static const FINISHED:String = "allLoadablesLoaded";
		
		public var path:String;
		public var content:DisplayObject;
		
		public function LoadLoadableEvent(eventType:String, path:String, component:DisplayObject = null) {
			super(eventType);
			this.path = path;
			this.content = content;
		}
	}
}