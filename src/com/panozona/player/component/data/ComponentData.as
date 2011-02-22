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
package com.panozona.player.component.data {
	
	import com.panozona.player.component.*;
	import com.panozona.player.component.utils.*;
	import com.panozona.player.manager.utils.loading.*;
	
	public class ComponentData implements ILoadable{
		
		public const nodes:Vector.<ComponentNode> = new Vector.<ComponentNode>();
		
		private var _name:String;
		private var _path:String;
		private var _descriptionReference:ComponentDescription;
		
		public function ComponentData(name:String, path:String) {
			_name = name;
			_path = path;
		}
		
		public final function get name():String {
			return _name;
		}
		
		public final function get path():String {
			return _path;
		}
		
		/**
		 * Description reference can be set only once
		 * trying to set reference again will couse an error.
		 */
		public final function set descriptionReference(description:ComponentDescription):void {
			if (_descriptionReference != null) throw new Error("Description reference allready set!");
			_descriptionReference = description;
		}
		
		/**
		 * @private
		 */
		public final function get descriptionReference():ComponentDescription {
			return _descriptionReference;
		}
	}
}