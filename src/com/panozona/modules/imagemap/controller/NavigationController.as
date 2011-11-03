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
package com.panozona.modules.imagemap.controller {
	
	import com.panozona.modules.imagemap.events.NavigationEvent;
	import com.panozona.modules.imagemap.view.NavigationView;
	import com.panozona.player.module.Module;
	
	public class NavigationController {
		
		private var _module:Module;
		private var _navigationView:NavigationView;
		
		public function NavigationController(navigationView:NavigationView, module:Module){
			_navigationView = navigationView;
			_module = module;
			
			_navigationView.navigationData.addEventListener(NavigationEvent.CHANGED_IS_ACTIVE, handleActiveStateChange, false, 0, true);
		}
		
		private function handleActiveStateChange(e:NavigationEvent):void {
			if (_navigationView.navigationData.isActive) {
				_navigationView.navigationData.onPress();
				_navigationView.setActive();
			}else {
				_navigationView.navigationData.onRelease();
				_navigationView.setPlain();
			}
		}
	}
}