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
package com.panozona.modules.actionlogic.controller {
	
	import com.panozona.modules.actionlogic.model.structure.Condition;
	import com.panozona.modules.actionlogic.model.structure.Equals;
	import com.panozona.modules.actionlogic.model.structure.Script;
	import com.panozona.player.module.Module;
	
	public class ScriptController {
		
		private var _module:Module
		
		public function ScriptController(module:Module) {
			_module = module;
		}
		
		public function runScript(script:Script):void {
			for each (var condition:Condition in script.getChildrenOfGivenClass(Condition)) {
				var satisfied:Boolean = false;
				for each(var object:Object in condition.getAllChildren()) {
					if (object is Equals) {
						var panoramaId:String = (object as Equals).currentPanorama;
						if (_module.saladoPlayer.manager.currentPanoramaData != null && _module.saladoPlayer.manager.currentPanoramaData.id == panoramaId) {
							satisfied = true;
						}
					}
				}
				if (satisfied) {
					_module.saladoPlayer.manager.runAction(condition.onSatisfy);
				}
			}
		}
	}
}