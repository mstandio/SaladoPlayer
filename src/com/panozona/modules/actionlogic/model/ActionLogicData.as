/*
Copyright 2012 Marek Standio.

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
package com.panozona.modules.actionlogic.model {
	
	import com.panozona.modules.actionlogic.model.structure.Condition;
	import com.panozona.modules.actionlogic.model.structure.Value;
	import com.panozona.modules.actionlogic.model.structure.Script;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class ActionLogicData {
		
		public const scriptsData:ScriptsData = new ScriptsData();
		
		public function ActionLogicData(moduleData:ModuleData, saladoPlayer:Object) {
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "scripts") {
					tarnslator.dataNodeToObject(dataNode, scriptsData.scripts);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			if (saladoPlayer.managerData.debugMode) {
				var scriptIds:Object = new Object();
				for each(var script:Script in scriptsData.scripts.getChildrenOfGivenClass(Script)) {
					if (script.id == null) {
						throw new Error("Script id not specified.");
					}
					if (scriptIds[script.id] != undefined) {
						throw new Error("Repeating script id: " + script.id);
					} else {
						scriptIds[script.id] = ""; // something
						for each(var condition:Condition in script.getChildrenOfGivenClass(Condition)) {
							if (condition.onSatisfy == null) {
								throw new Error("No action assigned for condition");
							}else if (saladoPlayer.managerData.getActionDataById(condition.onSatisfy) == null) {
								throw new Error("Action does not exist: " + condition.onSatisfy);
							}
							for each(var object:Object in condition.getAllChildren()) {
								if (object is Value) {
									var panoramaId:String = (object as Value).currentPanorama;
									if (panoramaId != null && saladoPlayer.managerData.getPanoramaDataById(panoramaId) == null) {
										throw new Error("Panorama does not exist: " + panoramaId);
									}
								}
							}
						}
					}
				}
			}
		}
	}
}