/*
Copyright 2011 Marek Standio.

This file is part of DIY streetview player.

SaladoPlayer is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published
by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.

SaladoPlayer is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty
of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with SaladoPlayer. If not, see <http://www.gnu.org/licenses/>.
*/
package org.diystreetview.modules.directionfixer.data {
	
	import org.diystreetview.modules.directionfixer.events.*;
	import flash.events.*;
	
	public class LabelToDirection extends EventDispatcher{
		
		public var currentLabel:String;
		
		private var _labelToDirection:Object = new Object();
		
		public function reset():void {
			_labelToDirection = new Object();
			trace("reset");
		}
		
		public function labelExists(label:String):Boolean {
			return (_labelToDirection[label] != undefined);
		}
		
		public function getLabel(label:String):Number {
			if (labelExists(label)) return _labelToDirection[label];
			return NaN;
		}
		
		public function setLabel(label:String, direction:Number):void {
			if (label != null) {
				if (label == currentLabel && _labelToDirection[label] != direction) {
					_labelToDirection[label] = direction;
					dispatchEvent(new LabelToDirectionEvent(LabelToDirectionEvent.FOR_CURRENT_LABEL_CHANGED));
				}else {
					_labelToDirection[label] = direction;
				}
			}
		}
		
		public function get object():Object { // this is so wrong
			return _labelToDirection;
		}
	}
}