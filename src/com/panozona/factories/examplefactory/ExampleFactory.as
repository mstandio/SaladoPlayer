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
	
	import com.panozona.modules.viewfinder.data.*;
	import com.panozona.player.component.Factory;
	import com.panozona.player.component.ComponentData;
	import com.panozona.player.component.data.property.Align;
	import com.panozona.player.component.data.property.Move;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import com.panozona.factories.examplefactory.model.ExampleFactoryData;
	
	public class ExampleFactory extends Factory{
		
		protected var exampleFactoryData:ExampleFactoryData;
		
		public function ExampleFactory(){
			super("ExampleFactory", "0.5");
		}
		
		override protected function componentReady(componentData:ComponentData):void {
			exampleFactoryData = new ExampleFactoryData(componentData, saladoPlayer.managerData.debugMode);
		}
		
		override public function returnProduct(productId:String):DisplayObject {
			
		}
	}
}