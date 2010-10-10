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
package com.panozona.player.manager.data.panorama {
	
	import com.panosalado.model.Params;
	import com.panozona.player.manager.data.hotspot.HotspotData;
	
	/**
	 * Stores data of single panorama. 
	 * 
	 * @author mstandio
	 */
	public class PanoramaData {
		
		/**
		 * Identifyier, unique among other panoramas.s 
		 */
		public var id:String;
		
		/**
		 * Short panorama description.
		 */
		public var label:String;
		
		/**
		 * What action to perform when entering to panorama.
		 */
		public var onEnter:String; 
		
		/**
		 * What action to perform when transition effect is finished after entering to panorama.
		 */
		public var onTransitionEnd:String; 
		
		/**
		 * What action to perform when user is leaving to other panorama.
		 */
		public var onLeave:String;
		
		private var _onEnterFrom:Object; 
		private var _onTransitionEndFrom:Object; 
		private var _onLeaveTo:Object; 
		private var _onLeaveToAttempt:Object; 
		private var _params:Params;
		private var _hotspotsData:Vector.<HotspotData>; 
		
		/**
		 * Constructor.
		 */
		public function PanoramaData() {
			_onEnterFrom = new Object();
			_onTransitionEndFrom = new Object();
			_onLeaveTo = new Object();
			_onLeaveToAttempt = new Object();
			_hotspotsData = new Vector.<HotspotData>();
			_params = new Params(null);
		}
		
		public function set path(path:String):void {
			_params.path = path;
		}
		
		/**
		 * Path pointing to file describing type of displayed panorama.
		 */
		public function get path():String {
			if (_params != null) return _params.path;
			return null;
		}
		
		/**
		 * Stores size of panorama window, camera properties limits and initial values.
		 */
		public function get params():Params {
			return _params;
		}
		
		/**
		 * Vector of HotspotData objects.
		 */
		public function get hotspotsData():Vector.<HotspotData> {
			return _hotspotsData;
		}
		
		/**
		 * Object where keys are ids of panoramas and values are ids of actions.
		 * Action is executed when entering from panorama of given id.
		 */
		public function get onEnterFrom():Object {
			return _onEnterFrom;
		}
		
		/**
		 * Object where keys are ids of panoramas and values are ids of actions.
		 * Action is executed when transition effect is finished after entering from panorama of given id.
		 */
		public function get onTransitionEndFrom():Object {
			return _onTransitionEndFrom;
		}
		
		/**
		 * Object where keys are ids of panoramas and values are ids of actions.
		 * Action is executed when leaving to panorama of given id.
		 */
		public function get onLeaveTo():Object {
			return _onLeaveTo;
		}
		
		/**
		 * Object where keys are ids of panoramas and values are ids of actions.
		 * Setting this attribute prevents from loading panorama.
		 * Action is executed when user tries to leave to panorama of given id.
		 */
		public function get onLeaveToAttempt():Object {
			return _onLeaveToAttempt;
		}
	}
}