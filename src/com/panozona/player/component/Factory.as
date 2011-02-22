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
		
		protected var functionDataTargetClass:Class;
		
		public function Factory(name:String, version:String){
			super(name, version);
			functionDataTargetClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.data.actions.FunctionDataTarget") as Class;
		}
		
		public function returnProduct(productId:String):DisplayObject {
			throw new Error("Function returnProduct() must be overriden.");
		}
		
		override public function execute(functionDataTarget:Object):void {
			var product:Object;
			if (functionDataTarget is functionDataTargetClass && componentDescription.functionsDescription[functionData.name] != undefined) {
				for each(var target:String in functionDataTarget.targets) {
					product = returnProduct(target);
					product[functionData.name].apply(product, functionData.args)
				}
			}
		}
	}
}