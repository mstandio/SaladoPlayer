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
	
	import com.panosalado.model.Params;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class PanoramaData{
		
		private var _id:String;
		private var _label:String;
		
		private var _params:Params;
		private var _childrenData:Vector.<ChildData>; 
		
		public var onEnter:String; // action id
		public var onLeave:String; // action id	
		public var onTransitionEnd:String; // action id	
		
		private var _onEnterSource:Object; // panorama id to action id 
		private var _onLeaveTarget:Object; // panorama id to action id 
		private var _onTransitionEndSource:Object; // panorama id to action id 
		
		public function PanoramaData() {
			_onEnterSource = new Object();
			_onLeaveTarget = new Object();
			_onTransitionEndSource = new Object();
			_childrenData = new Vector.<ChildData>();
		}
		
		public function set id(value:String):void {
			if (_id != null) return;
			_id = value;
		}
		
		public function get id():String {
			return _id;
		}		
		
		public function set label(value:String):void {
			if (_label != null) return;
			_label = value;
		}
		
		public function get label():String {
			if (_label != null) return _label;
			return "label_"+_id;
		}				
		
		public function set path(path:String):void {
			if (params != null) return;
			_params = new Params(path);
		}
		
		public function get path():String {
			if (_params != null) return _params.path;
			return null;
		}
		
		public function get params():Params {
			return _params;
		}
		
		public function get childrenData():Vector.<ChildData> {
			return _childrenData;
		}
		
		public function get onEnterSource():Object {
			return _onEnterSource;
		}
		
		public function get onLeaveTarget():Object {
			return _onLeaveTarget;
		}
		
		public function get onTransitionEndSource():Object {
			return _onTransitionEndSource;
		}
	}
}