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
package com.panozona.modules.examplemodule.data {
	
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	
	// Settings class is not decalred as structure child of any other class, so its name is not important
	public class Settings {
		
		// These var names are important
		// They should be of the same name as attributes names in module node		
		// for instance <settings open="true" extraButtonName="a" align="horizontal:right,vertical:bottom"/>
		// you should initialize them with default values in case when var is not present in configuration
		
		public var open:Boolean = true; 
		public var extraButtonName:String; // intentionally not initialized 
		
		public var align:Align = new Align(Align.LEFT, Align.MIDDLE); // horizontal, vertical
		public var move:Move = new Move(10,0); // horizontal, vertical
	}
}