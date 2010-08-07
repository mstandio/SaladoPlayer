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
	
	import flash.display.DisplayObject;
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
		
		private var _onEnter:String; // action id
		private var _onLeave:String; // action id	
		private var _onTransitionEnd:String; // action id	
		private var _onEnterSource:Object;  // panorama id to action id 
		private var _onLeaveTarget:Object;  // panorama id to action id 
		private var _onTransitionEndSource:Object; // panorama id to action id 
		
		public function PanoramaData(id:String, label:String, path:String, onEnter:String = null, onLeave:String=null, onTransitionEnd:String = null) {
			
			if (id == null || id == "") {
				throw new Error("Panorama has no id");
			}
			
			if (label == null || label == "") {
				throw new Error("Panorama: "+ id +" has no label");
			}
			
			if (path == null || path == "") {
				throw new Error("Panorama: "+ id +" has no path");
			}			
			
			_id = id;
			_label = label;						
			_params = new Params(path);
			
			_onEnter = onEnter;
			_onLeave = onLeave;
			_onTransitionEnd = onTransitionEnd
			_onEnterSource = new Object();			
			_onLeaveTarget = new Object();			
			_onTransitionEndSource = new Object();
			_childrenData = new Vector.<ChildData>();									
		}			
		
		public function get id():String {
			return _id;
		}
		
		public function get label():String {
			return _label;
		}
		
		public function get params():Params {
			return _params;
		}
		
		public function get childrenData():Vector.<ChildData> {
			return _childrenData;
		}		
		
		public function get onEnter():String {
			return _onEnter;
		}
		
		public function get onLeave():String {
			return _onLeave;
		}
		
		public function get onTransitionEnd():String {
			return _onTransitionEnd;
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