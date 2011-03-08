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
package com.panozona.factories.examplefactory.data{
	
	import com.panozona.player.module.data.ModuleDataFactory;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.utils.DataNodeTranslator;
	import com.panozona.factories.examplefactory.data.structure.Product;
	import com.panozona.factories.examplefactory.data.structure.Settings;
	
	public class ExampleFactoryData{
		
		public var products:Vector.<Product> = new Vector.<Product>();
		
		public function ExampleFactoryData(moduleDataFactory:ModuleDataFactory, saladoPlayer:Object){
			
			var translator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			var product:Product;
			for each(var dataNode:DataNode in moduleDataFactory.nodes) {
				if (dataNode.name == "product") {
					product = new Product();
					translator.dataNodeToObject(dataNode, product);
					products.push(product);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			if (saladoPlayer.managerData.debugMode) {
				var settingsArray:Array;
				if (products.length < 1) throw new Error("No defined products");
				var productsId:Object = new Object();
				for each(var _product:Product in products) {
					if (productsId[_product.id] != undefined) {
						throw new Error("Repeating product id: " + _product.id);
					}else {
						productsId[_product.id] = ""; // not undefined
						settingsArray = _product.getChildrenOfGivenClass(Settings);
						if (settingsArray.length != 1) {
							throw new Error("Invalid settings for product: " + _product.id);
						}
					}
				}
			}
		}
	}
}