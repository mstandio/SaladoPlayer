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
package com.panozona.modules.dropdown.model{
	
	import com.panozona.modules.dropdown.events.BoxEvent;
	import com.panozona.modules.dropdown.model.structure.ExtraElement;
	import com.panozona.modules.dropdown.model.structure.Group;
	import com.panozona.modules.dropdown.model.structure.Groups;
	import flash.events.EventDispatcher;
	
	public class BoxData extends EventDispatcher {
		
		public const groups:Groups = new Groups();
		
		private var _open:Boolean;
		private var _mouseOver:Boolean;
		
		private var _currentGroupId:String;
		private var _currentExtraElementId:String;
		
		public function get open():Boolean { return _open;}
		public function set open(value:Boolean):void {
			if (value == _open) return;
			_open = value;
			dispatchEvent(new BoxEvent(BoxEvent.CHANGED_OPEN));
		}
		
		public function get mouseOver():Boolean { return _mouseOver;}
		public function set mouseOver(value:Boolean):void {
			if (value == _mouseOver) return;
			_mouseOver = value;
			dispatchEvent(new BoxEvent(BoxEvent.CHANGED_MOUSE_OVER));
		}
		
		public function getExtraElementById(extraElementId:String):ExtraElement {
			for each(var group:Group in groups.getChildrenOfGivenClass(Group)) {
				for each(var extraElement:ExtraElement in group.getChildrenOfGivenClass(ExtraElement)) {
					if (extraElement.id == extraElementId) return extraElement;
				}
			}
			return null;
		}
		
		public function get currentExtraElementId():String {return _currentExtraElementId;}
		public function set currentExtraElementId(value:String):void {
			if (value == null || value == _currentExtraElementId) return;
			_currentExtraElementId = value;
			dispatchEvent(new BoxEvent(BoxEvent.CHANGED_CURRENT_EXTRAWAYPOINT_ID));
		}
		
		public function getGroupById(groupId:String):Group {
			for each(var group:Group in groups.getChildrenOfGivenClass(Group)) {
				if (group.id == groupId) {
					return group;
				}
			}
			return null;
		}
		
		public function get currentGroupId():String {return _currentGroupId;}
		public function set currentGroupId(value:String):void {
			if (value == null || value == _currentGroupId) return;
			_currentGroupId = value;
			dispatchEvent(new BoxEvent(BoxEvent.CHANGED_CURRENT_GROUP_ID));
		}
	}
}