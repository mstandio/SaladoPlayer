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
package com.panozona.player.manager.utils{
	
	import com.panozona.player.manager.data.AbstractModuleDescription;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class ManagerDescription{
		
		public static const name:String = "SaladoPlayer";
		public static const version:Number = 0.3;
		
		private var managerDescription:Object;
				
		public function ManagerDescription(){
			managerDescription = new Object();
			managerDescription.moduleName = ManagerDescription.name;
			managerDescription.moduleVersion = ManagerDescription.version;
			managerDescription.functionsDescription = new Object();
			
			managerDescription.functionsDescription["print"] = new Array(String);			
			managerDescription.functionsDescription["loadPano"] = new Array(String);
			managerDescription.functionsDescription["moveToChild"] = new Array(String);
			managerDescription.functionsDescription["moveToView"] = new Array(Number, Number, Number);
			managerDescription.functionsDescription["jumpToView"] = new Array(Number, Number, Number);
			managerDescription.functionsDescription["startMoving"] = new Array(Number, Number);
			managerDescription.functionsDescription["stopMoving"] = new Array();			
			
			managerDescription.functionsDescription["advancedStartMoving"] = new Array(Number, Number, Number, Number, Number);
			managerDescription.functionsDescription["advancedMoveToChild"] = new Array(String, Number, Number, String);
			managerDescription.functionsDescription["advancedMoveTo"] = new Array(Number, Number, Number, Number, String);
			managerDescription.functionsDescription["toggleFullscreen"] = new Array();
			managerDescription.functionsDescription["runAction"] = new Array(String);			
		}		
		
		public function get description():AbstractModuleDescription {
			return new AbstractModuleDescription(managerDescription);
		}		
	}
}