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
package com.panozona.factories.examplefactory.product.view{
	
	import com.panozona.factories.examplefactory.product.model.ProductData;
	import com.panozona.factories.examplefactory.data.structure.Settings;
	import flash.display.Sprite;
	
	public class ProductView extends Sprite{
		
		public var productData:ProductData;
		
		public function ProductView(productData:ProductData){
			this.productData = productData;
			
			graphics.beginFill((productData.product.getChildrenOfGivenClass(Settings)[0] as Settings).color1);
			graphics.drawRect(-50, -50, 100, 100);
			graphics.endFill();
		}
	}
}
