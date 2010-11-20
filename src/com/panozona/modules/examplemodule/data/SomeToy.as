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
	
	
	// SomeToy is decalred structure child of SomeChild so class name is important
	// class name must match module node name NOT CASE SENSITIVE
	// for instance: <someChild> <someToy/> </someChild>
	public class SomeToy{ 
		
		// These var names are important
		// They should be of the same name as attributes names in module node
		// for instance: <someToy name="Barbie" price="19.99"/>
		// you should initialize them with default values in case when given value is not set in configuration
		
		public var name:String;
		public var price:Number;
	}
}