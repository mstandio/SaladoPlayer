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
package com.panozona.modules.buttonbar {
	
	import com.panozona.modules.buttonbar.controller.BarController;
	import com.panozona.modules.buttonbar.model.ButtonBarData;
	import com.panozona.modules.buttonbar.model.ButtonData;
	import com.panozona.modules.buttonbar.view.BarView;
	import com.panozona.modules.buttonbar.view.ButtonView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	
	public class ButtonBar extends Module{
		
		private var buttonBarData:ButtonBarData;
		
		private var barView:BarView;
		private var barController:BarController;
		
		public function ButtonBar(){
			super("ButtonBar", "1.2", "http://panozona.com/wiki/Module:ButtonBar");
			moduleDescription.addFunctionDescription("setActive", String, Boolean);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			buttonBarData = new ButtonBarData(moduleData, saladoPlayer);
			
			barView = new BarView(buttonBarData);
			barController = new BarController(barView, this);
			addChild(barView);
		}
		
///////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function setActive(name:String, active:Boolean):void {
			if (name == "a" || name == "b" || name == "c" || name == "d" || name == "e" ||
				name == "f" || name == "g" || name == "h" || name == "i" || name == "j"){
				barController.setButtonActive(name, active);
			}else {
				printWarning("Invalid extraButton name: " + name);
			}
		}
	}
}