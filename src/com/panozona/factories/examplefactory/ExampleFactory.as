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
package com.panozona.factories.examplefactory {
	
	import com.panozona.factories.examplefactory.data.ExampleFactoryData;
	import com.panozona.factories.examplefactory.data.structure.Product;
	import com.panozona.factories.examplefactory.product.ExampleFactoryProduct;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.ModuleDataFactory;
	import com.panozona.player.module.ModuleFactory;
	import flash.display.DisplayObject;
	
	public class ExampleFactory extends ModuleFactory{
		
		protected var exampleFactoryData:ExampleFactoryData;
		protected var productReferences:Object;
		protected var definition:Object;
		
		public function ExampleFactory(){
			super("ExampleFactory", "1.0", "http://panozona.com/wiki/Factory:ExampleFactory");
			moduleDescription.addFunctionDescription("toggleColor");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			exampleFactoryData = new ExampleFactoryData(moduleData as ModuleDataFactory, saladoPlayer);
			definition = (moduleData as ModuleDataFactory).definition;
			
			productReferences = new Object();
		}
		
		override public function returnProduct(productId:String):DisplayObject {
			if (productReferences[productId] == undefined || productReferences[productId] == null) {
				if (definition != null && definition[productId] != undefined){
					for each (var product:Product in exampleFactoryData.products){
						if (product.id == definition[productId]) {
							productReferences[productId] = new ExampleFactoryProduct(product, this);
							break;
						}
						productReferences[productId] = new ExampleFactoryProduct(exampleFactoryData.products[0], this);
					}
				}else {
					productReferences[productId] = new ExampleFactoryProduct(exampleFactoryData.products[0], this);
				}
			}
			return productReferences[productId] as DisplayObject;
		}
	}
}