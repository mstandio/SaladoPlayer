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
package com.panozona.modules.linkopener.data{
	
	
	import com.panozona.modules.linkopener.data.structure.Link;
	import com.panozona.modules.linkopener.data.structure.Links;
	
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class LinkOpenerData {
		
		public const links:Links = new Links();
		
		public function LinkOpenerData(moduleData:ModuleData, saladoPlayer:Object) {
			
			var translator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "links") {
					translator.dataNodeToObject(dataNode, links);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			if (saladoPlayer.managerData.debugMode) {
				var linkIds:Object = new Object();
				for each (var link:Link in links.getChildrenOfGivenClass(Link)) {
					if (link.id == null) throw new Error("link id not specified.");
					if (link.content == null) throw new Error("link content not specified.");
					if (linkIds[link.id] != undefined) {
						throw new Error("Repeating link id: " + link.id);
					}else {
						linkIds[link.id] = ""; // something
					}
				}
			}
		}
	}
}