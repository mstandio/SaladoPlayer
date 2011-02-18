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
		 * id of panorama that will be loaded,
		 * if not set, SaladoPlayer will load first panorama in line. 
		 */
		public var firstPanorama:String;
		
		/**
		 * Stores size of panorama window, camera limits and initial values.
		 * When some value is set, it will overwrite default values in all panoramas.
		 */
		public const params:Params = new Params(null); // empty path
		
		/**
		 * Sets default Field of view limits for global params
		 */
		public function AllPanoramasData(){
			params.minFov = 30;
			params.maxFov = 120;
		}
	}
}