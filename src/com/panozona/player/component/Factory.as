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
package com.panozona.player.component {
	
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	
	public class Factory extends Component{
		
		private var functionDataTargetClass:Class;
		
		public function Factory(name:String, version:String){
			super(name, version);
			functionDataClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.data.actions.FunctionDataTarget") as Class;
		}
		
		public function returnProduct(id:String):DisplayObject {
			throw new Error("Function returnProduct() must be overriden.");
		}
		
		override public function execute(functionData:Object):void{
			if (functionData is functionDataTargetClass && componentDescription.functionsDescription.hasOwnProperty(functionData.name)) {
				for each(var target:String in functionData.targets) {
					//this[functionData.name] as Function).apply(this, functionData.args; // TODO: apply to return product, create class product 
				}
			}
		}
	}
}