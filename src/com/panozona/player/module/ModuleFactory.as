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
package com.panozona.player.module {
	
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	
	public class ModuleFactory extends Module{
		
		protected var functionDataFactoryClass:Class;
		
		public function ModuleFactory(name:String, version:String, homeUrl:String){
			super(name, version, homeUrl);
			functionDataFactoryClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.data.actions.FunctionDataFactory") as Class;
		}
		
		public function returnProduct(productId:String):DisplayObject {
			throw new Error("Function returnProduct() must be overriden.");
		}
		
		override public function execute(functionDataFactory:Object):void {
			var product:Object;
			if (functionDataFactory is functionDataFactoryClass && moduleDescription.functionsDescription[functionDataFactory.name] != undefined) {
				for each(var target:String in functionDataFactory.targets) {
					product = returnProduct(target);
					product[functionDataFactory.name].apply(product, functionDataFactory.args);
				}
			}
		}
	}
}