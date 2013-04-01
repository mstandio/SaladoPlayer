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
	
	import com.panozona.modules.imagebutton.controller.WindowController;
	import com.panozona.modules.imagebutton.model.ImageButtonData;
	import com.panozona.modules.imagebutton.model.WindowData;
	import com.panozona.modules.imagebutton.view.SubButtonView;
	import com.panozona.modules.imagebutton.view.WindowView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	
	public class ImageButton extends Module{
		
		private var imageButtonData:ImageButtonData;
		private var windowControllers:Vector.<WindowController>;
		
		public function ImageButton(){
			super("ImageButton", "1.3", "http://openpano.org/links/saladoplayer/modules/imagebutton/");
			moduleDescription.addFunctionDescription("setOpen", String, Boolean);
			moduleDescription.addFunctionDescription("toggleOpen", String);
			moduleDescription.addFunctionDescription("setActive", String, Boolean);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void{
			
			imageButtonData = new ImageButtonData(moduleData, saladoPlayer);
			windowControllers = new Vector.<WindowController>();
			
			var windowView:WindowView;
			var windowController:WindowController;
			for (var i:int = imageButtonData.buttons.length - 1; i >= 0; i--){
				windowView = new WindowView(new WindowData(imageButtonData.buttons[i]));
				addChild(windowView);
				windowController = new WindowController(windowView, this);
				windowControllers.push(windowController);
			}
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(buttonId:String, value:Boolean):void{
			for (var i:int = 0; i < numChildren; i++) {
				if ((getChildAt(i) as WindowView).windowData.button.id == buttonId){
					(getChildAt(i) as WindowView).windowData.open = value;
					return;
				}
			}
			printWarning("Nonexistant button id: " + buttonId);
		}
		
		public function toggleOpen(buttonId:String):void {
			for (var i:int = 0; i < numChildren; i++) {
				if ((getChildAt(i) as WindowView).windowData.button.id == buttonId){
					(getChildAt(i) as WindowView).windowData.open = !(getChildAt(i) as WindowView).windowData.open;
					return;
				}
			}
			printWarning("Nonexistant button id: " + buttonId);
		}
		
		public function setActive(subButtonId:String, value:Boolean):void {
			for (var i:int = 0; i < numChildren; i++) {
				for (var j:int = 0; j < (getChildAt(i) as WindowView).buttonView.subButtonsContainer.numChildren; j++) {
					if (((getChildAt(i) as WindowView).buttonView.subButtonsContainer.getChildAt(j) as SubButtonView).subButtonData.subButton.id == subButtonId) {
						((getChildAt(i) as WindowView).buttonView.subButtonsContainer.getChildAt(j) as SubButtonView).subButtonData.isActive = value;
						return;
					}
				}
			}
			printWarning("Nonexistant subButton id: " + subButtonId);
		}
	}
}