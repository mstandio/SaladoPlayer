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
	import com.panozona.factories.examplefactory.product.ProductMaker;
	import com.panozona.player.module.data.ModuleDataFactory;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.ModuleFactory;
	import flash.display.DisplayObject;
	
	public class ExampleFactory extends ModuleFactory{
		
		protected var exampleFactoryData:ExampleFactoryData;
		protected var productMaker:ProductMaker;
		protected var productReferences:Object;
		
		public function ExampleFactory(){
			super("ExampleFactory", "1.0", "http://panozona.com/wiki/Factory:ExampleFactory");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			exampleFactoryData = new ExampleFactoryData(moduleData as ModuleDataFactory, saladoPlayer);
			productMaker = new ProductMaker(exampleFactoryData, this);
			productReferences = new Object();
		}
		
		override public function returnProduct(productId:String):DisplayObject {
			if (productReferences[productId] == undefined || productReferences[productId] == null) {
				productReferences[productId] = productMaker.make(productId);
			}
			return productReferences[productId] as DisplayObject;
		}
	}
}