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
package com.panozona.modules.zoomslider.model {
	
	import com.panozona.modules.zoomslider.events.SliderEvent;
	import com.panozona.modules.zoomslider.model.structure.Slider;
	import com.panozona.player.module.data.property.Size;
	import flash.events.EventDispatcher;
	
	public class SliderData extends EventDispatcher{
		
		public const slider:Slider = new Slider();
		
		private var _zoomIn:Boolean;
		private var _zoomOut:Boolean;
		
		private var _maxFov:Number;
		private var _minFov:Number;
		
		private var _mouseDrag:Boolean;
		private var _barLead:Boolean;
		
		private var _minSize:Size = new Size(1, 1);
		private var _maxSize:Size = new Size(1, 1);
		
		public function get zoomIn():Boolean {return _zoomIn;}
		public function set zoomIn(value:Boolean):void {
			if (value == _zoomIn) return;
			_zoomIn = value;
			dispatchEvent(new SliderEvent(SliderEvent.CHANGED_ZOOM));
		}
		
		public function get zoomOut():Boolean {return _zoomOut;}
		public function set zoomOut(value:Boolean):void {
			if (value == _zoomOut) return;
			_zoomOut = value;
			dispatchEvent(new SliderEvent(SliderEvent.CHANGED_ZOOM));
		}
		
		public function get maxFov():Number {return _maxFov;}
		public function set maxFov(value:Number):void {
			if (isNaN(value) || value == _maxFov) return;
			_maxFov = value;
			dispatchEvent(new SliderEvent(SliderEvent.CHANGED_FOV_LIMIT));
		}
		
		public function get minFov():Number {return _minFov;}
		public function set minFov(value:Number):void {
			if (isNaN(value) || value == _minFov) return;
			_minFov = value;
			dispatchEvent(new SliderEvent(SliderEvent.CHANGED_FOV_LIMIT));
		}
		
		public function get mouseDrag():Boolean {return _mouseDrag;}
		public function set mouseDrag(value:Boolean):void {
			if (value == _mouseDrag) return;
			_mouseDrag = value;
			dispatchEvent(new SliderEvent(SliderEvent.CHANGED_MOUSE_DRAG));
		}
		
		public function get barLead():Boolean {return _barLead;}
		public function set barLead(value:Boolean):void {
			if (value == _barLead || _mouseDrag) return;
			_barLead = value;
			dispatchEvent(new SliderEvent(SliderEvent.CHANGED_BAR_LEAD));
		}
		
		public function get minSize():Size {return _minSize};
		public function get maxSize():Size {return _maxSize};
		public function setMinMaxSize(minSize:Size, maxSize:Size):void {
			_minSize = minSize;
			_maxSize = maxSize;
			dispatchEvent(new SliderEvent(SliderEvent.CHANGED_SIZE_LIMIT));
		}
	}
}