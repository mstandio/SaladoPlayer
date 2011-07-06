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
package com.panozona.modules.imagebutton{
	
	import com.panozona.modules.imagebutton.controller.ButtonController;
	import com.panozona.modules.imagebutton.model.ButtonData;
	import com.panozona.modules.imagebutton.model.ImageButtonData;
	import com.panozona.modules.imagebutton.model.structure.Button;
	import com.panozona.modules.imagebutton.view.ButtonView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	
	public class ImageButton extends Module{
		
		private var imageButtonData:ImageButtonData;
		private var buttonControllers:Vector.<ButtonController>;
		
		public function ImageButton(){
			super("ImageButton", "1.2", "http://panozona.com/wiki/Module:ImageButton");
			moduleDescription.addFunctionDescription("setOpen", String, Boolean);
			moduleDescription.addFunctionDescription("toggleOpen", String);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void{
			
			imageButtonData = new ImageButtonData(moduleData, saladoPlayer);
			buttonControllers = new Vector.<ButtonController>();
			
			var buttonView:ButtonView;
			var buttonController:ButtonController;
			var buttons:Array = imageButtonData.buttons.getChildrenOfGivenClass(Button);
			for (var i:int = buttons.length-1; i >= 0; i--){
				buttonView = new ButtonView(new ButtonData(buttons[i]), imageButtonData);
				addChild(buttonView);
				buttonController = new ButtonController(buttonView, this);
				buttonControllers.push(buttonController);
			}
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(buttonId:String, value:Boolean):void{
			for (var i:int = 0; i < numChildren; i++) {
				if (getChildAt(i) is ButtonView && (getChildAt(i) as ButtonView).buttonData.button.id == buttonId){
					(getChildAt(i) as ButtonView).buttonData.open = value;
					return;
				}
			}
			printWarning("Nonexistant button id: " + buttonId);
		}
		
		public function toggleOpen(buttonId:String):void {
			for (var i:int = 0; i < numChildren; i++) {
				if (getChildAt(i) is ButtonView && (getChildAt(i) as ButtonView).buttonData.button.id == buttonId){
					(getChildAt(i) as ButtonView).buttonData.open = !(getChildAt(i) as ButtonView).buttonData.open;
					return;
				}
			}
			printWarning("Nonexistant button id: " + buttonId);
		}
	}
}