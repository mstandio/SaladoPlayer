/*
Copyright 2011 Marek Standio.

This file is part of DIY streetview player.

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
package org.diystreetview.modules.directionfixer{
	
	import org.diystreetview.modules.directionfixer.controller.*;
	import org.diystreetview.modules.directionfixer.data.*;
	import org.diystreetview.modules.directionfixer.view.*;
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	
	public class DirectionFixer extends Module{
		
		private var inOutView:InOutView;
		private var inOutController:InOutController;
		
		private var valuesView:ValuesView;
		private var valuesController:ValuesController;
		
		private var directionFixerData:DirectionFixerData;
		
		public function DirectionFixer() {
			super("DirectionFixer", "1.1", "http://diy-streetview.org");
			moduleDescription.addFunctionDescription("toggleVisibility");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			directionFixerData = new DirectionFixerData(moduleData, saladoPlayer); // allways first
			
			inOutView = new InOutView(directionFixerData);
			addChild(inOutView);
			inOutController = new InOutController(inOutView, this);
			
			valuesView = new ValuesView(directionFixerData);
			addChild(valuesView);
			valuesController = new ValuesController(valuesView, this);
		}
		
		public function toggleVisibility():void {
			directionFixerData.inOutData.open = !directionFixerData.inOutData.open;
		}
	}
}