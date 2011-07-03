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
package com.panozona.modules.menuscroller.model.structure {
	
	import caurina.transitions.Equations;
	import com.panozona.player.module.data.property.Tween;
	
	public class Scroller {
		
		public var scrollsVertical:Boolean = true;
		public var sizeLimit:Number = 150;
		public var spacing:Number = 10;
		
		public var mouseOver:Expand = new Expand(Equations.easeNone, 0.25, 1.5);
		public var mouseOut:Tween = new Tween(Equations.easeNone, 0.25);
		
		// scrollspeeed
		// scroll tween 
		// fitVisible
		// style
	}
}