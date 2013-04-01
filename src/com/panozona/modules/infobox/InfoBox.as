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
package com.panozona.modules.infobox{
	
	import com.panozona.modules.infobox.controller.WindowController;
	import com.panozona.modules.infobox.model.InfoBoxData;
	import com.panozona.modules.infobox.view.WindowView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	
	public class InfoBox extends Module {
		
		private var infoBoxData:InfoBoxData;
		
		private var windowView:WindowView;
		private var windowController:WindowController;
		
		public function InfoBox() {
			super("InfoBox", "1.0", "http://openpano.org/links/saladoplayer/modules/infobox/");
			moduleDescription.addFunctionDescription("toggleOpen");
			moduleDescription.addFunctionDescription("setOpen", Boolean);
			moduleDescription.addFunctionDescription("setArticle", String);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			infoBoxData = new InfoBoxData(moduleData, saladoPlayer); // always first
			
			windowView = new WindowView(infoBoxData);
			windowController = new WindowController(windowView, this);
			addChild(windowView);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(value:Boolean):void {
			infoBoxData.windowData.open = value;
		}
		
		public function toggleOpen():void {
			infoBoxData.windowData.open = !infoBoxData.windowData.open;
		}
		
		public function setArticle(value:String):void {
			if(infoBoxData.viewerData.getArticleById(value) != null){
				infoBoxData.viewerData.currentArticleId = value;
			}else {
				printWarning("Invalid article id: " + value);
			}
		}
	}
}