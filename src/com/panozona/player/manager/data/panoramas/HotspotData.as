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
	
	import com.panozona.player.module.data.property.Location;
	import com.panozona.player.module.data.property.Mouse;
	import com.panozona.player.module.data.property.Transform;
	
	public class HotspotData{
		
		public var location:Location = new Location();
		public var target:String = null;
		
		public var mouse:Mouse = new Mouse();
		public var handCursor:Boolean = true;
		
		public var transform:Transform = new Transform();
		
		protected var _id:String;
		
		public function HotspotData(id:String){
			_id = id;
		}
		
		public final function get id():String{
			return _id;
		}
	}
}