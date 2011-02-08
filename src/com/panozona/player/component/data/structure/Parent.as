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
package com.panozona.player.component.data.structure{
	
	public class Parent{
		
		private var _children:Array = new Array();
		
		public function getChildrenOfGivenClass(childClass:Class):Array {
			var result:Array = new Array;
			for each (var child:Object in _children) {
				if (child is childClass) result.push(child);
			}
			return result;
		}
		
		public function getAllChildren():Array {
			return _children;
		}
		
		public function getChildrenTypes():Vector.<Class> {
			throw new Error("You must override getChildrenTypes()");
		}
	}
}