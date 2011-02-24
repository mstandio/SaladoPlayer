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
	 * SomeToy class IS decalred as STRUCTURE CHILD in 
	 * com.panozona.modules.examplemodule.data.SomeChild class,
	 * therefore name of this class (SomeToy) IS significant. It is 
	 * used to associate it with <someToy/> nodes. For Example:
	 * 
	 * <someChild>
	 *  <someToy/>
	 *  <someToy/>
	 * </someChild>
	 *
	 * SomeToy DOES NOT declare itself as STRUCTURE PARENT of any class.
	 * Therefore <someToy/> node cannot have any child nodes.
	 */
	public class SomeToy{ 
		
		/**
		 * This is example of "String" attribute.
		 * This var name is significant - is used to associate 
		 * it with "name" attribute in someToy node. For example: 
		 * 
		 * <someToy name="hello_world"/>
		 */
		public var name:String;
		
		/**
		 * This is example of "Number" attribute.
		 * This var name is significant - is used to associate 
		 * it with "price" attribute in someToy node. For example: 
		 * 
		 * <someToy price="num:-12.12"/>
		 * <someToy price="num:NaN"/>
		 * <someToy price="num:#FF00FF"/>
		 */
		public var price:Number;
	}
}