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
package com.panozona.player.manager.data.hotspot {
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;	
	import flash.events.Event;
	
	/**
	 * Stores single hotspot configuration obtained from i.e. *.xml configuration. 
	 * 
	 * @author mstandio
	 */
	public class HotspotData {
		
		/**
		 * Identifyier, unique among other hotspots of given panorama. 
		 */
		public var id:String;
		
		/**
		 * Path to image, swf or xml file. 
		 */
		public var path:String;
		
		/**
		 * If mouse cursor is changed to hand when over hotpot.
		 */
		public var handCursor:Boolean;
		
		/**
		 * Stores contant used to display as hotspot. It can be Bitmap, DisplayObject or XML object.
		 */
		public var content:*;
		
		private var _position:Position;
		private var _mouse:Mouse;
		private var _transformation:Transformation;
		private var _swfArguments:Object; // not used anywhere yet
		
		/**
		 * Constructor.
		 */
		public function HotspotData() {
			handCursor = true;
			_position = new Position();
			_mouse = new Mouse();
			_transformation = new Transformation();
			_swfArguments = new Object();
		}
		
		/**
		 * Stores data describing pan tilt and distance. 
		 */
		public function get position():Position{
			return _position;
		}
		
		/**
		 * Stores data that binds mouse events with execution of actions. 
		 * It can also change
		 */
		public function get mouse():Mouse{
			return _mouse;
		}
		
		/**
		 * Stores data about additional geometrical transformation. 
		 */
		public function get transformation():Transformation{
			return _transformation;
		}
		
		/**
		 * Arguments passed to hotspot if path pointed to *.swf file.
		 */
		public function get swfArguments():Object {
			return _swfArguments;
		}
	}
}