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
package com.panozona.modules.zoomslider.model{
	
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class ZoomSliderData {
		
		public const sliderData:SliderData = new SliderData();
		public const windowData:WindowData = new WindowData();
		
		public function ZoomSliderData(moduleData:ModuleData, saladoPlayer:Object){
			
			var translator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "slider") {
					translator.dataNodeToObject(dataNode, sliderData.slider);
				}else if (dataNode.name == "window") {
					translator.dataNodeToObject(dataNode, windowData.window);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			windowData.open = windowData.window.open;
			if (sliderData.slider.length < 0) sliderData.slider.length = 0;
			
			if (saladoPlayer.managerData.debugMode) {
				if (sliderData.slider.path == null || !sliderData.slider.path.match(/^(.+)\.(png|gif|jpg|jpeg)$/i)) {
					throw new Error("Invalid path: " + sliderData.slider.path);
				}
			}
		}
	}
}