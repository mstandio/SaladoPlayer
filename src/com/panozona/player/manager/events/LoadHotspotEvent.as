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
package com.panozona.player.manager.events{
	
	import flash.events.Event;
	
	import com.panozona.player.manager.data.hotspot.HotspotData;
	
	/**
	 * 
	 * 
	 * @author mstandio
	 */
	public class LoadHotspotEvent extends Event {

		public static const BMD_CONTENT:String =  "bitmapDataContent";
		public static const SWF_CONTENT:String =  "swfContent";
		public static const XML_CONTENT:String =  "xmlContent";
		
		/**
		 * 
		 */
		public var hotspotData:HotspotData;
		
		/**
		 * Constructor.
		 * 
		 * @param	type
		 * @param	childData
		 */
		public function LoadHotspotEvent (type:String, hotspotData:HotspotData) {
			super(type);
			this.hotspotData = hotspotData;
		}
	}
}