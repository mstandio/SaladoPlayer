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
	
	// SomeJob is decalred structure child of SomeParent so its class name is important
	// class name must match module node name NOT CASE SENSITIVE
	// for instance: <SomeParent> <someJob/> </SomeParent>
	public class SomeJob {
		
		// These var names are important
		// They should be of the same name as attributes names in module node
		// for instance <someJob wages="999" text="[something something]"/>
		// you should initialize them with default values in case when given value is not set in configuration
		
		public var wages:Number; // intentionally not initialized
		
		// if data structure class has var with that name, it can take CDATA text. 
		// <someJob>
		// 	<![CDATA[
		// 		cdata text with forbidden chars :;,
		//	]]>
		// <someJob/>
		// text can also be red as regular attribute but without forbidden chars :;,
		// <someJob text="[can't have any chars here]"/>
		public var text:String; 
	}
}