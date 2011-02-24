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
	
	import com.panozona.player.module.data.structure.DataParent;
	
	/**
	 * SomeChild class IS declared as STRUCTURE CHILD in 
	 * com.panozona.modules.examplemodule.data.SomeParent class,
	 * therefore name of this class (SomeChild) IS significant.
	 * It is used to associate it with <someChild/> nodes. For Example:
	 * 
	 * <someParent>
	 *  <someChild/>
	 *  <someChild/>
	 * </someParent>
	 * 
	 * SomeChild declares itself as STRUCTURE PARENT of class
	 * SomeToy. Name of this class (SomeToy) is significant - it is used
	 * to associate it with <someToy/> node. For SomeChild being 
	 * structure parent of SomeToy class means that <someChild/> node
	 * can have many <someToy/> child nodes. For Example:
	 * 
	 * <someChild>
	 *  <someToy/>
	 *  <someToy/>
	 * </someChild>
	 */
	public class SomeChild extends DataParent{
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(SomeToy);
			return result;
		}
		
		/**
		 * This is example of "Boolean" attribute.
		 * This var name is significant - is used to assiciate 
		 * it with "happy" attribute in someChild node. For example: 
		 * 
		 * <someChild happy="true"/>
		 * <someChild happy="false"/>
		 */
		public var happy:Boolean; 
	}
}