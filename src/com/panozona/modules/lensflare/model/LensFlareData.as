/*
Copyright 2012 Igor Zevako.

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
package com.panozona.modules.lensflare.model{
	
	import com.panozona.modules.lensflare.model.structure.Flare;
	import com.panozona.modules.lensflare.model.structure.Flares;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class LensFlareData {
		
		public const flares:Flares = new Flares();
		
		public function LensFlareData(moduleData:ModuleData, saladoPlayer:Object){
			
			var translator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "flares") {
					translator.dataNodeToObject(dataNode, flares);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			if (saladoPlayer.managerData.debugMode) {
				if (flares.getChildrenOfGivenClass(Flare).length == 0) {
					throw new Error("No panoramas found.");
				}
				for each(var flare:Flare in flares.getChildrenOfGivenClass(Flare)) {
					if (flare.panorama == null) {
						throw new Error("Panorama id is not defined.");
					}
					if (flare.path == null || !flare.path.match(/^(.+)\.(png|gif|jpg|jpeg)$/i)) {
						throw new Error("Invalid grid image path: " + flare.path);
					}
				}
			}
		}
	}
}