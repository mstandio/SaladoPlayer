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
package com.panozona.player.manager.data {
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;	
	import flash.display.BitmapData;
	import flash.events.Event;		
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class ChildData {  				
		
		private var _id:String;									
		private var _path:String;
		private var _weight:int;
		
		private var _childMouse:ChildMouse;
		private var _childTransform:ChildTransform;
		private var _childPosition:ChildPosition;				
		
		private var _bitmapFile:Bitmap;
		private var _swfFile:DisplayObject;		
		
		public function ChildData(id:String, path:String, weight:int) {
			if (id == null || id == "" ) {
				throw new Error("No id for child");
			}
			
			if (path == null || path == "") {
				throw new Error("No path specified for child: "+id);							
			}									
			
			_id = id;			
			_path = path;
			_weight = weight;
			
			_childMouse = new ChildMouse();
			_childTransform = new ChildTransform();
			_childPosition = new ChildPosition();			
		}	
		
		
		public final function set bitmapFile(value:Bitmap):void {			
			_swfFile = null;
			_bitmapFile = value;
		}
		
		public final function set swfFile(value:DisplayObject):void {			
			_bitmapFile = null;
			_swfFile = value;
		}		
		
		public function get id():String {
			return _id;
		}
		
		public function get path():String {
			return _path;
		}
		
		public function get weight():int {
			return _weight;
		}
		
		public function get childMouse():ChildMouse{
			return _childMouse;
		}		
		
		public function get childTransform():ChildTransform{
			return _childTransform;
		}		
		
		public function get childPosition():ChildPosition{
			return _childPosition;
		}		
		
		public function get bitmapFile():Bitmap {
			return _bitmapFile;
		}
		
		public function get swfFile():DisplayObject {
			return _swfFile;
		}		
	}	
}