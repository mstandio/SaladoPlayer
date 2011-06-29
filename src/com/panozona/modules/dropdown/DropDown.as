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
package com.panozona.modules.dropdown{
	
	import com.panozona.modules.dropdown.controller.BoxController;
	import com.panozona.modules.dropdown.model.DropDownData;
	import com.panozona.modules.dropdown.view.BoxView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	
	public class DropDown extends Module{
		
		private var dropDownData:DropDownData;
		
		private var boxView:BoxView;
		private var boxController:BoxController;
		
		public function DropDown(){
			super("DropDown", "1.1", "http://panozona.com/wiki/Module:DropDown");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			dropDownData = new DropDownData(moduleData, saladoPlayer);
			
			boxView = new BoxView(dropDownData);
			boxController = new BoxController(boxView, this);
			addChild(boxView);
		}
	}
}