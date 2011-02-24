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
	 * SomeParent class IS NOT declared as STRUCTURE CHILD of any other class,
	 * therefore name of this class (SomeParent) IS NOT significant - It could 
	 * be named in any way - assotiation with <someParent/> node is done in 
	 * com.panozona.modules.examplemodule.data.ExampleModuleData
	 * 
	 * SomeParent declares itself as STRUCTURE PARENT of classes SomeChild and SomeJob. 
	 * Names of these classes (SomeChild and SomeJob) are significant - they are used 
	 * to associate them with <someChild/> and <someJob/> nodes. For SomeParent being 
	 * structure parent of SomeChild and SomeJob classes means that <someParent/> node
	 * can have many <someChild/> and <someJob/> child nodes in any order. For Example:
	 * 
	 * <someParent>
	 *  <someChild/>
	 *  <someChild/>
	 *  <someJob/>
	 *  <someChild/>
	 *  <someJob/>
	 * <someParent>
	 */
	public class SomeParent extends DataParent{
		
		override public function getChildrenTypes():Vector.<Class>{
			var result:Vector.<Class> = new Vector.<Class>();
			result.push(SomeChild);
			result.push(SomeJob);
			return result;
		}
		
		/**
		 * This is example of "Object" attribute.
		 * This var name is significant - is used to assiciate it with "info" 
		 * attribute in someParent node <someParent info="[...]"/>
		 */
		public var info:SomeParentInfo = new SomeParentInfo();
	}
}