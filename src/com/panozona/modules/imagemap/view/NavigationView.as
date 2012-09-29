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
package com.panozona.modules.imagemap.view {
	
	import com.panozona.modules.imagemap.model.NavigationData;
	import com.panozona.modules.imagemap.model.ViewerData;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class NavigationView extends Sprite {
		
		private var bitmap:Bitmap;
		private var _bitmapDataActive:BitmapData;
		private var _bitmapDataPlain:BitmapData;
		
		private var _navigationData:NavigationData;
		private var _viewerData:ViewerData;
		
		public function NavigationView(navigationData:NavigationData, viewerData:ViewerData){
			_navigationData = navigationData;
			_viewerData = viewerData;
			buttonMode = true;
			
			bitmap = new Bitmap();
			
			addChild(bitmap);
			addEventListener(MouseEvent.MOUSE_DOWN, onMousePress, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, onMouseRelease, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, onMouseRelease, false, 0, true);
		}
		
		public function get navigationData():NavigationData{
			return _navigationData;
		}
		
		public function get viewerData():ViewerData {
			return _viewerData;
		}
		
		public function set bitmapDataPlain(value:BitmapData):void {
			_bitmapDataPlain = value;
			if (!_navigationData.isActive) {
				bitmap.bitmapData = _bitmapDataPlain;
			}
		}
		
		public function set bitmapDataActive(value:BitmapData):void {
			_bitmapDataActive = value;
			if (_navigationData.isActive) {
				bitmap.bitmapData = _bitmapDataActive;
			}
		}
		
		public function setPlain():void {
			if(_bitmapDataPlain != null){
				bitmap.bitmapData = _bitmapDataPlain;
			}
		}
		
		public function setActive():void {
			if(_bitmapDataActive != null){
				bitmap.bitmapData = _bitmapDataActive;
			}
		}
		
		private function onMousePress(e:MouseEvent):void {
			_navigationData.isActive = true;
		}
		
		private function onMouseRelease(e:MouseEvent):void {
			_navigationData.isActive = false;
		}
	}
}