/*
Copyright 2011 Marek Standio.

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
along with SaladoPlayer. If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.player.manager.data.panoramas {
	
	import com.panozona.player.component.data.property.*;
	import flash.display.*;
	
	public class HotspotData{
		
		public const location:Location = new Location();
		public const transform:Transform = new Transform();
		
		public const mouse:Mouse = new Mouse();
		public var handCursor:Boolean = true;
		
		private var _id:String;
		
		public function HotspotData(id:String){
			_id = id;
		}
		
		public final function get id():String{
			return _id;
		}
	}
}