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
package com.panozona.modules.linkopener {
	
	import com.panozona.modules.linkopener.data.LinkOpenerData;
	import com.panozona.modules.linkopener.data.structure.Link;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	public class LinkOpener extends Module{
		
		private var linkOpenerData:LinkOpenerData;
		
		public function LinkOpener(){
			super("LinkOpener", "1.1", "http://openpano.org/links/saladoplayer/modules/linkopener/");
			moduleDescription.addFunctionDescription("open", String);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			visible = false;
			linkOpenerData = new LinkOpenerData(moduleData, saladoPlayer);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function open(linkId:String):void {
			for each(var link:Link in linkOpenerData.links.getChildrenOfGivenClass(Link)) {
				if (link.id == linkId) {
					navigateToURL(new URLRequest(link.content), link.target);
					return;
				}
			}
			printWarning("Calling nonexistant link: " + linkId);
		}
	}
}