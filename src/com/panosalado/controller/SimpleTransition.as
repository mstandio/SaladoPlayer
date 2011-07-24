/*
Copyright 2010 Zephyr Renner.

This file is part of PanoSalado.

PanoSalado is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

PanoSalado is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with PanoSalado. If not, see <http://www.gnu.org/licenses/>.
*/
package com.panosalado.controller{
	
	import com.panosalado.controller.ICamera;
	import com.panosalado.events.ViewEvent;
	import com.panosalado.model.Characteristics;
	import com.panosalado.model.SimpleTransitionData;
	import com.panosalado.model.ViewData;
	import com.panosalado.utils.Animation;
	import com.robertpenner.easing.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class SimpleTransition extends EventDispatcher implements ICamera {
		
		Linear;
		Expo;
		
		protected var _data:SimpleTransitionData;
		protected var _viewData:ViewData;
		
		public function SimpleTransition(){
			
		}
		
		public function processDependency(reference:Object,characteristics:*):void {
			if (characteristics == Characteristics.SIMPLE_TRANSITION_DATA) data = reference as SimpleTransitionData;
			else if (characteristics == Characteristics.VIEW_DATA) viewData = reference as ViewData;
		}
		
		public function get data():SimpleTransitionData { return _data; }
		public function set data(value:SimpleTransitionData):void {
			if (_data === value) return;
			_data = value;
		}
		
		public function get viewData():ViewData { return _viewData; }
		public function set viewData(value:ViewData):void {
			if (_viewData === value) return;
			if (value != null)
				value.addEventListener(ViewEvent.PATH, catchFirstRender, false, 0, true);
			else 
				_viewData.removeEventListener(ViewEvent.PATH, catchFirstRender);
			_viewData = value;
		}
		
		protected function catchFirstRender(e:ViewEvent):void {
			if (_data == null) return;
			e.preventDefault(); //NB must call this to keep the secondary pano until transition is over.
			_viewData.addEventListener(ViewEvent.RENDERED, startTransition, false, 0, true);
		}
		
		protected function startTransition(e:ViewEvent):void {
			var canvas:Sprite = e.canvas;
			if (canvas == null) return;
			_viewData.removeEventListener(ViewEvent.RENDERED, startTransition);
			canvas[_data.property] = _data.startValue;
			var alphaTransition:Animation = new Animation(canvas, Vector.<String>([_data.property]), Vector.<Number>([_data.endValue]), _data.time, _data.tween);
			alphaTransition.addEventListener(Event.COMPLETE, endTransition, false, 0, true);
		}
		
		protected function endTransition(e:Event):void {
			_viewData.secondaryViewData.path = null; // this is what the default PATH handler WOULD have done.
			(e.target as EventDispatcher).removeEventListener(Event.COMPLETE, endTransition);
			dispatchEvent(new Event(Event.COMPLETE) );
		}
	}
}