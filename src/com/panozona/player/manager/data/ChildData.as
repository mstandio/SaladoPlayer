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
	import flash.events.Event;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class ChildData {
		
		private var _id:String;
		private var _path:String;		
		
		private var _childMouse:ChildMouse;
		private var _childTransformation:ChildTransformation;
		private var _childPosition:ChildPosition;
		
		private var _sfwArguments:Object; // not used anywhere yet
		
		private var _bitmapFile:Bitmap;
		private var _swfFile:DisplayObject;		
		
		public function ChildData() {
			_childMouse = new ChildMouse();
			_childTransformation = new ChildTransformation();
			_childPosition = new ChildPosition();
			_sfwArguments = new Object();
		}
		
		public function set id(value:String):void {
			if (_id != null) return;
			_id = value;
		}
		
		public function get id():String {
			return _id;
		}		
		
		public function set path(value:String):void {
			if (_path != null) return;
			_path = value;
		}
		
		public function get path():String {
			return _path;
		}				
		
		public final function set bitmapFile(value:Bitmap):void {
			_swfFile = null;
			_bitmapFile = value;
		}
		
		public final function set swfFile(value:DisplayObject):void {
			_bitmapFile = null;
			_swfFile = value;
		}
		
		public function get childMouse():ChildMouse{
			return _childMouse;
		}
		
		public function get childTransformation():ChildTransformation{
			return _childTransformation;
		}
		
		public function get childPosition():ChildPosition{
			return _childPosition;
		}		
		
		public function get sfwArguments():Object {			
			return _sfwArguments;
		}
		
		public function get bitmapFile():Bitmap {
			return _bitmapFile;
		}
		
		public function get swfFile():DisplayObject {
			return _swfFile;
		}
	}
}