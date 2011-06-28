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
package com.panozona.modules.menuscroller.view{
	
	import com.panozona.modules.menuscroller.model.MenuScrollerData;
	import flash.display.Sprite;
	
	public class ScrollerView extends Sprite{
		
		private var _menuScrollerData:MenuScrollerData;
		private var _elementsContainer:Sprite;
		private var _elementsContainerMask:Sprite;
		
		public function ScrollerView(menuScrollerData:MenuScrollerData){
			_menuScrollerData = menuScrollerData;
			
			_elementsContainer = new Sprite();
			addChild(_elementsContainer);
			//_elementsContainer.mask = _elementsContainerMask;
		}
		
		public function get menuScrollerData():MenuScrollerData {
			return _menuScrollerData;
		}
		
		public function get elementsContainer():Sprite {
			return _elementsContainer;
		}
		
		public function get elementsContainerMask():Sprite {
			return _elementsContainerMask;
		}
	}
}