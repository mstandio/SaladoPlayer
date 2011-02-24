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
package com.panozona.modules.examplemodule.data{
	
	import com.robertpenner.easing.*;
	
	/**
	 * Object of this class is included in com.panozona.modules.examplemodule.data.SomeParent
	 * class, under var named "info". Name of this class (SomeParentInfo) is not significant.
	 * Only public vars of type Boolean, Number, String and Function will be interpreted.
	 */
	public class SomeParentInfo {
		
		/**
		 * This is example of "Number" subattribute.
		 * This var name is significant - is used to associate 
		 * it with "num" subattribute in info Object. For example: 
		 *
		 * <someParent info="num:-12.12"/>
		 * <someParent info="num:NaN"/>
		 * <someParent info="num:#FF00FF"/>
		 */
		public var num:Number; 
		
		/**
		 * This is example of "Boolean" subattribute.
		 * This var name is significant - is used to associate 
		 * it with "bool" subattribute in info Object. For example: 
		 * 
		 * <someParent info="bool:true"/>
		 * <someParent info="bool:false"/>
		 */
		public var bool:Boolean;
		
		/**
		 * This is example of "String" subattribute.
		 * This var name is significant - is used to associate 
		 * it with "str" subattribute in info Object. For example: 
		 * 
		 * <someParent info="str:hello_world"/>
		 */
		public var str:String;
		
		/**
		 * This is example of "Function" subattribute.
		 * This var name is significant - is used to associate 
		 * it with "fun" subattribute in info Object. For example: 
		 * 
		 * <someParent info="fun:Linear.easeNone"/>
		 * 
		 * Function should ALWAYS have declared default value.
		 */
		public var fun:Function = Linear.easeNone;
	}
}