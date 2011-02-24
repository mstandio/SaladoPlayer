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
package com.panozona.modules.examplemodule.data {
	
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	import com.panozona.player.module.data.property.Tween;
	import com.robertpenner.easing.*;
	
	/**
	 * Settings class IS NOT declared as STRUCTURE CHILD of any other class,
	 * therefore name of this class (Settings) IS NOT significant - It could
	 * be named in any way - assotiation with <settings/> node is done in
	 * com.panozona.modules.examplemodule.data.ExampleModuleData
	 * 
	 * Settings DOES NOT declare itself as STRUCTURE PARENT of any class.
	 * Therefore <settings/> node cannot have any child nodes.
	 */
	public class Settings {
		
		/**
		 * Initial state of module. 
		 * True by default.
		 */
		public var open:Boolean = true; 
		
		/**
		 * action id called when module changes state to opened
		 * Null by default.
		 */
		public var onOpen:String;
		
		/**
		 * action id called when module changes state to closed. 
		 * Null by default.
		 */
		public var onClose:String;
		
		public var align:Align = new Align(Align.LEFT, Align.MIDDLE); // horizontal, vertical
		public var move:Move = new Move(10, 0);                       // horizontal, vertical
		public var tween:Tween =  new Tween(Linear.easeNone, 0.5);    // transition, time (s)
	}
}