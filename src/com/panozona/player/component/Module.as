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
along with SaladoPlayer.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.player.component{
	
	import flash.system.ApplicationDomain;
	
	public class Module extends Component {
		
		private var functionDataClass:Class;
		
		public function Module(name:String, version:String){
			super(name, version);
			functionDataClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.data.actions.FunctionData") as Class;
		}
		
		override public function execute(functionData:Object):void {
			if(functionData is functionDataClass && componentDescription.functionsDescription.hasOwnProperty(functionData.name)) {
				(this[functionData.name] as Function).apply(this, functionData.args)
			}
		}
	}
}