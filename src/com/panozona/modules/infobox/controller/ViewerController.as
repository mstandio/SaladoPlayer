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
package com.panozona.modules.infobox.controller {
	
	import com.panozona.modules.infobox.events.WindowEvent;
	import com.panozona.modules.infobox.view.ViewerView;
	import com.panozona.player.module.Module;
	import flash.events.Event;
	
	public class ViewerController {
		
		private var _scrollBarController:ScrollBarController;
		
		private var _viewerView:ViewerView;
		private var _module:Module;
		
		public function ViewerController(viewerView:ViewerView, module:Module) {
			_module = module;
			_viewerView = viewerView;
			
			_scrollBarController = new ScrollBarController(_viewerView.scrollBarView, _module);
			
			_viewerView.infoBoxData.windowData.addEventListener(WindowEvent.CHANGED_CURRENT_SIZE, handleWindowSizeChange, false, 0, true);
			
			handleWindowSizeChange();
		}
		
		private function handleWindowSizeChange(event:Event = null):void {
			_viewerView.graphics.clear();
			_viewerView.graphics.beginFill(_viewerView.infoBoxData.viewerData.viewer.style.color, _viewerView.infoBoxData.viewerData.viewer.style.alpha);
			_viewerView.graphics.drawRect(0, 0, _viewerView.infoBoxData.windowData.currentSize.width, _viewerView.infoBoxData.windowData.currentSize.height);
			_viewerView.graphics.endFill();
		}
	}
}