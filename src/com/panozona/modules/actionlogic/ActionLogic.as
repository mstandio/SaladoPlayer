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
package com.panozona.modules.actionlogic {
	
	import com.panozona.modules.actionlogic.controller.ScriptController;
	import com.panozona.modules.actionlogic.model.ActionLogicData;
	import com.panozona.modules.actionlogic.model.structure.Script;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	
	public class ActionLogic extends Module{
		
		private var actionLogicData:ActionLogicData;
		private var scriptController:ScriptController;
		
		public function ActionLogic() {
			super("ActionLogic", "1.1", "http://panozona.com/wiki/Module:ActionLogic");
			moduleDescription.addFunctionDescription("runScript", String);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			actionLogicData = new ActionLogicData(moduleData, saladoPlayer);
			scriptController = new ScriptController(this);
			visible = false;
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function runScript(value:String):void {
			var script:Script = actionLogicData.scriptsData.getScriptById(value);
			if (script == null) {
				printWarning("Invalid script id: " + value);
			}else {
				scriptController.runScript(script);
			}
		}
	}
}