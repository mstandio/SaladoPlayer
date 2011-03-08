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
package com.panozona.factories.examplefactory.product.controller {
	
	import com.panozona.factories.examplefactory.data.structure.Settings;
	import com.panozona.factories.examplefactory.product.view.ProductView;
	import com.panozona.player.module.ModuleFactory;
	
	public class ProductController{
		
		private var _productView:ProductView
		private var _moduleFactory:ModuleFactory;
		
		private var isColor2:Boolean;
		
		public function ProductController(productView:ProductView, moduleFactory:ModuleFactory):void{
			_productView = productView;
			_moduleFactory = moduleFactory;
		}
		
		public function toggleColor():void {
			_productView.graphics.clear();
			if (isColor2) {
				_productView.graphics.beginFill((_productView.productData.product.getChildrenOfGivenClass(Settings)[0] as Settings).color1);
				_productView.graphics.drawRect(-50, -50, 100, 100);
				_productView.graphics.endFill();
				isColor2 = false;
			}else {
				_productView.graphics.beginFill((_productView.productData.product.getChildrenOfGivenClass(Settings)[0] as Settings).color2);
				_productView.graphics.drawRect(-50, -50, 100, 100);
				_productView.graphics.endFill();
				isColor2 = true;
			}
		}
	}
}