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
package com.panozona.player.module.data.property{
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class Tween {
		
		public var time:Number;		
		
		private var _transition:String;		
		private var _transitions:Array;
		
		public function Tween(time:Number, transition:String){
			 _transitions = new Array("linear", "easeInSine", "easeOutSine", "easeInOutSine"); 
			 //TODO: add more http://hosted.zeh.com.br/tweener/docs/en-us/misc/transitions.html
			 this.time = time;
			 this.transition = transition;
		}		
		
		public function set transition(value:String):void {
			for each (var transition:String in _transitions) {
				if (transition == value) {
					_transition = value;
					return;
				}
			}
			throw new Error("Invalid tween tranition value: "+value);
		}		
		
		public function get transition():String {
			return _transition;
		}
	}
}