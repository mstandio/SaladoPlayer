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
package com.panozona.modules.jsgateway.data.structure {
	
	public class Settings {
		
		public var callOnEnter:Boolean = false;
		public var callOnTransitionEnd:Boolean = false;
		public var callOnMoveEnd:Boolean = false;
		public var callOnViewChange:Boolean = false;
		
		/**
		 * The number of decimal places to pass to the javascript function
		 * when reporting the new view's coordinates onViewChange 
		 */
		public var viewChangePrecision:uint = 0;
	}
}