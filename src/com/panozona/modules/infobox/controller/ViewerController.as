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
	
	import com.panozona.modules.infobox.view.ViewerView;
	import com.panozona.player.module.Module;
	
	public class ViewerController {
		
		private var _viewerView:ViewerView;
		private var _module:Module;
		
		public function ViewerController(viewerView:ViewerView, module:Module) {
			_module = module;
			_viewerView = viewerView;
		}
	}
}