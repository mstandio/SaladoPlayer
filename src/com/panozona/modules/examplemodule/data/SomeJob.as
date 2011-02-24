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
	
	/**
	 * SomeJob class IS declared as STRUCTURE CHILD in 
	 * com.panozona.modules.examplemodule.data.SomeParent class,
	 * therefore name of this class (SomeJob) IS significant. It is 
	 * used to associate it with <someJob/> nodes. For Example:
	 * 
	 * <someParent>
	 *  <someJob/>
	 *  <someJob/>
	 * </someParent>
	 *
	 * SomeJob DOES NOT declare itself as STRUCTURE PARENT of any class.
	 * Therefore <someJob/> node cannot have any child nodes.
	 */
	public class SomeJob {
		
		/**
		 * This is example of "Number" attribute.
		 * This var name is significant - is used to associate 
		 * it with "wages" attribute in someJob node. For example: 
		 * 
		 * <someJob wages="NaN"/>
		 * <someJob wages="12.12"/>
		 * <someJob wages="#FF00FF"/>
		 */
		public var wages:Number;
		
		/**
		 * This is example of "String" attribute.
		 * This var name is significant - is used to associate 
		 * it with "text" attribute in someJob node. For example: 
		 * 
		 * <someJob text="hello_world"/>
		 * 
		 * This var name is also special. Naming your variable 
		 * as "text" allows passing value of CDATA node instead. 
		 * This can be usefull for passing any Strings. For example:
		 * 
		 * <someJob>
		 *  <![CDATA[string with any characters]]>
		 * <someJob/>
		 */
		public var text:String; 
	}
}