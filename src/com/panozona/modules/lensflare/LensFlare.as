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
package com.panozona.modules.lensflare{
	
	import com.panozona.modules.lensflare.controller.FlareController;
	import com.panozona.modules.lensflare.model.FlareData;
	import com.panozona.modules.lensflare.model.LensFlareData;
	import com.panozona.modules.lensflare.model.structure.Flare;
	import com.panozona.modules.lensflare.view.FlareView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.system.ApplicationDomain;
	
	public class LensFlare extends Module {
		
		private var colorTransform:ColorTransform = new ColorTransform();
		
		private var lensFlareData:LensFlareData;
		private var flareControllers:Vector.<FlareController>;
		
		public function LensFlare():void {
			super("LensFlare", "1.1", "http://panozona.com/wiki/Module:LensFlare");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			lensFlareData = new LensFlareData(moduleData, saladoPlayer);
			flareControllers = new Vector.<FlareController>();
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
		}
		
		private function onPanoramaLoaded(e:Event):void {
			while (flareControllers.length > 0) {
				flareControllers.pop();
			}
			while (numChildren > 0) {
				removeChildAt(0);
			}
			for each (var flare:Flare in lensFlareData.flares.getChildrenOfGivenClass(Flare)) {
				if (saladoPlayer.manager.currentPanoramaData.id == flare.panorama) {
					var flareView:FlareView = new FlareView(new FlareData(flare));
					addChild(flareView);
					flareControllers.push(new FlareController(flareView, this));
				}
			}
			if (flareControllers.length > 0) {
				if (!hasEventListener(Event.ENTER_FRAME)) {
					addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
				}
			}else {
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function onEnterFrame(e:Event):void {
			var maxBrightness:Number = 0;
			for (var i:int = 0; i < numChildren; i++) {
				var flareBrightness:Number = (getChildAt(i) as FlareView).flareData.brightness;
				if (flareBrightness > maxBrightness) {
					maxBrightness = flareBrightness;
				}
			}
			colorTransform.redOffset = maxBrightness;
			colorTransform.greenOffset = maxBrightness;
			colorTransform.blueOffset = maxBrightness;
			saladoPlayer.manager.canvas.transform.colorTransform = colorTransform;
		}
	}
}
