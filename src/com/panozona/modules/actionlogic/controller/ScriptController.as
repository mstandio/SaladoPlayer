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
	import com.panozona.modules.actionlogic.model.structure.Differs;
	import com.panozona.modules.actionlogic.model.structure.Equals;
	import com.panozona.modules.actionlogic.model.structure.Script;
	import com.panozona.modules.actionlogic.model.structure.Value;
	import com.panozona.player.module.Module;
	import flash.external.ExternalInterface;
	
	public class ScriptController {
		
		private var _module:Module
		
		public function ScriptController(module:Module) {
			_module = module;
		}
		
		public function runScript(script:Script):void {
			for each (var condition:Condition in script.getChildrenOfGivenClass(Condition)) {
				for each(var object:Object in condition.getAllChildren()) {
					var satisfied:Boolean = true;
					if (object is Value) {
						if (!satisfiesCurrentPanoramaId(object as Value)) {
							satisfied = false;
						}
						if (!satisfiesUrlFromPanoLink(object as Value)) {
							satisfied = false;
						}
					}
				}
				if (satisfied) {
					_module.saladoPlayer.manager.runAction(condition.onSatisfy);
				}
			}
		}
		
		private function satisfiesCurrentPanoramaId(value:Value):Boolean {
			var panoramaId:String = value.currentPanorama;
			if (panoramaId != null && _module.saladoPlayer.manager.currentPanoramaData != null) {
				if (value is Equals && _module.saladoPlayer.manager.currentPanoramaData.id != panoramaId) {
					return false;
				}else if (value is Differs && _module.saladoPlayer.manager.currentPanoramaData.id == panoramaId) {
					return false;
				}
			}
			return true;
		}
		
		private function satisfiesUrlFromPanoLink(value:Value):Boolean {
			var panolinkVersion:String = value.urlFromPanoLink;
			var url:String = ExternalInterface.call("window.location.href.toString");
			if (panolinkVersion != null && url != null) {
				if (panolinkVersion == "PanoLink-1.1") {
					if (value is Equals && !url.match(/.+cam=-?\d{1,},-?\d{1,},-?\d{1,}/i)) {
						return false;
					}else if (value is Differs && url.match(/.+cam=-?\d{1,},-?\d{1,},-?\d{1,}/i)) {
						return false;
					}
				}
			}
			return true
		}
	}
}