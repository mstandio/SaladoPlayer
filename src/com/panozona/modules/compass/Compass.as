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
package com.panozona.modules.compass {
	
	import com.panozona.modules.compass.controller.WindowController;
	import com.panozona.modules.compass.model.CompassData;
	import com.panozona.modules.compass.view.WindowView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	
	public class Compass extends Module {
		
		private var compassData:CompassData;
		
		private var windowView:WindowView;
		private var windowController:WindowController;
		
		public function Compass() {
			super("Compass", "1.2", "http://panozona.com/wiki/Module:Compass");
			moduleDescription.addFunctionDescription("toggleOpen");
			moduleDescription.addFunctionDescription("setOpen", Boolean);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			compassData = new CompassData(moduleData, saladoPlayer); // always first
			
			windowView = new WindowView(compassData);
			windowController = new WindowController(windowView, this);
			addChild(windowView);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(value:Boolean):void {
			compassData.windowData.open = value;
		}
		
		public function toggleOpen():void {
			compassData.windowData.open = !compassData.windowData.open;
		}
	}
}