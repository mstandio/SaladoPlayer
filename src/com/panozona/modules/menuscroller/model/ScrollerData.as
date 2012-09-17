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
package com.panozona.modules.menuscroller.model {
	
	import com.panozona.modules.menuscroller.events.ScrollerEvent;
	import com.panozona.modules.menuscroller.model.structure.Group;
	import com.panozona.modules.menuscroller.model.structure.Groups;
	import com.panozona.modules.menuscroller.model.structure.Scroller;
	import flash.events.EventDispatcher;
	
	public class ScrollerData extends EventDispatcher {
		
		public const scroller:Scroller = new Scroller();
		public const groups:Groups = new Groups();
		
		public var sizeLimit:Number;
		public var scrollsVertical:Boolean;
		
		private var _currentGroupId:String;
		private var _totalSize:Number;
		private var _mouseOver:Boolean;
		
		public function ScrollerData():void {
			_totalSize = 0;
			sizeLimit = 1;
		}
		
		public function getGroupById(groupId:String):Group {
			for each(var group:Group in groups.getChildrenOfGivenClass(Group)) {
				if (group.id == groupId) return group;
			}
			return null;
		}
		
		public function get currentGroupId():String {return _currentGroupId;}
		public function set currentGroupId(value:String):void {
			if (value == null || value == _currentGroupId) return;
			_currentGroupId = value;
			dispatchEvent(new ScrollerEvent(ScrollerEvent.CHANGED_CURRENT_GROUP_ID));
		}
		
		public function get totalSize():Number { return _totalSize; }
		public function set totalSize(value:Number):void {
			if (value == _totalSize) return;
			_totalSize = value;
			dispatchEvent(new ScrollerEvent(ScrollerEvent.CHANGED_TOTAL_SIZE));
		}
		
		public function get mouseOver():Boolean { return _mouseOver; }
		public function set mouseOver(value:Boolean):void {
			if (value == _mouseOver) return;
			_mouseOver = value;
			dispatchEvent(new ScrollerEvent(ScrollerEvent.CHANGED_MOUSE_OVER));
		}
	}
}