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
package com.panozona.player.manager.data.global{
	
	import com.panosalado.model.Params;
	
	public class AllPanoramasData{
		
		/**
		 * id of first panorama that will be loaded,
		 * if not set, SaladoPlayer will load first panorama in line. 
		 */
		public var firstPanorama:String;
		
		/**
		 * id of action that will be executed on loading first panorama
		 */
		public var firstOnEnter:String;
		
		/**
		 * id of action that will be executed on when transition effect
		 * in first panorama has finished
		 */
		public var firstOnTransitionEnd:String;
		
		public var onAutorotationStart:String;
		
		public var onAutorotationStop:String;
	}
}