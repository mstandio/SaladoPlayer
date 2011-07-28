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
package com.panozona.modules.jsgateway.data{
	
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class JSGatewayData {
		
		public const jsfuncttions:JSFunctions = new JSFunctions();
		public const asfuncttions:ASFunctions = new ASFunctions();
		
		public function JSGatewayData(moduleData:ModuleData, saladoPlayer:Object) {
			
			var translator:DataNodeTranslator = new DataNodeTranslator(saladoPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "jsfunctions") {
					translator.dataNodeToObject(dataNode, jsfuncttions);
				}else if (dataNode.name == "asfunctions") {
					translator.dataNodeToObject(dataNode, asfuncttions);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			if (saladoPlayer.managerData.debugMode) {
				var jsfunctionIds:Object = new Object();
				for each (var jsfunction:JSFunction in jsfuncttions.getChildrenOfGivenClass(JSFunction)) {
					if (jsfunction.id == null) throw new Error("jsfunction id not specified.");
					if (jsfunction.name == null) throw new Error("jsfunction name not specified.");
					if (jsfunctionIds[jsfunction.id] != undefined) {
						throw new Error("Repeating jsfunction id: " + jsfunction.id);
					}else {
						jsfunctionIds[jsfunction.id] = ""; // something
					}
				}
				var asfunctionNames:Object = new Object();
				for each (var asfunction:ASFunction in asfuncttions.getChildrenOfGivenClass(ASFunction)) {
					if (asfunction.name == null) throw new Error("asfunction name not specified.");
					if (asfunction.callback == null) throw new Error("asfunction callback not specified.");
					if (asfunctionNames[asfunction.name] != undefined) {
						throw new Error("Repeating asfunction name: " + asfunction.name);
					}else {
						asfunctionNames[asfunction.name] = ""; // something
					}
				}
			}
		}
	}
}