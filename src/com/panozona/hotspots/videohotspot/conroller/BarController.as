/*
Copyright 2010 Marek Standio.

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
along with SaladoPlayer.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.hotspots.videohotspot.conroller{
	
	import com.panozona.hotspots.videohotspot.view.BarView;
	import com.panozona.hotspots.videohotspot.events.BarEvent;
	import com.panozona.hotspots.videohotspot.events.PlayerEvent;
	import com.panozona.hotspots.videohotspot.events.StreamEvent;
	import flash.events.Event;
	
	public class BarController{
		
		private var _barView:BarView;
		
		public function BarController(barView:BarView) {
			_barView = barView;
			
			_barView.videoHotspotData.playerData.addEventListener(PlayerEvent.CHANGED_NAVIGATION_ACTIVE, handleNavigationActiveChange, false, 0, true);
			
			_barView.videoHotspotData.barData.addEventListener(BarEvent.CHANGED_PROGRESS_POINTER_DRAGGED, handleProgressPointerDraggedChange, false, 0, true);
			
			_barView.videoHotspotData.streamData.addEventListener(StreamEvent.CHANGED_BYTES_LOADED, drawProgressBar, false, 0, true);
			_barView.videoHotspotData.streamData.addEventListener(StreamEvent.CHANGED_VIEW_TIME, drawProgressBar, false, 0, true);
		}
		
		private function handleNavigationActiveChange(e:Event):void {
			if (_barView.videoHotspotData.playerData.navigationActive) {
				_barView.progressBar.y = _barView.videoHotspotData.settings.size.height -
					_barView.videoHotspotData.playerData.barHeightExpanded;
				_barView.progressPointer.visible = true;
			}else {
				_barView.progressBar.y = _barView.videoHotspotData.settings.size.height -
					_barView.videoHotspotData.playerData.barHeightHidden;
				_barView.progressPointer.visible = false;
			}
			drawProgressBar();
		}
		
		private function handleProgressPointerDraggedChange(e:Event):void {
			if (_barView.videoHotspotData.barData.progressPointerDragged) {
				_barView.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}else {
				_barView.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				translatePositionToValue();
			}
		}
		
		private function onEnterFrame(e:Event):void {
			if (_barView.progressBar.mouseX >= _barView.videoHotspotData.settings.size.width - _barView.progressPointer.width * 0.5){
				_barView.progressPointer.x = _barView.videoHotspotData.settings.size.width - _barView.progressPointer.width;
			}else if (_barView.progressBar.mouseX <= _barView.progressPointer.width * 0.5) {
				_barView.progressPointer.x = 0;
			}else if (_barView.progressBar.mouseX >= (_barView.videoHotspotData.settings.size.width - _barView.progressPointer.width) *
				_barView.videoHotspotData.streamData.loadedBytes / _barView.videoHotspotData.streamData.totalBytes +
				_barView.progressPointer.width * 0.5) {
				_barView.progressPointer.x = (_barView.videoHotspotData.settings.size.width - _barView.progressPointer.width) *
					_barView.videoHotspotData.streamData.loadedBytes / _barView.videoHotspotData.streamData.totalBytes +
					_barView.progressPointer.width * 0.5;
			}else {
				_barView.progressPointer.x = _barView.progressBar.mouseX - _barView.progressPointer.width * 0.5;
			}
		}
		
		private function drawProgressBar(e:Event = null):void {
			_barView.progressBar.graphics.clear();
			// background
			_barView.progressBar.graphics.beginFill(0x000000, 0);
			_barView.progressBar.graphics.drawRect(0, 0,
				_barView.videoHotspotData.settings.size.width,
				(_barView.videoHotspotData.playerData.navigationActive?
				_barView.videoHotspotData.playerData.barHeightExpanded:
				_barView.videoHotspotData.playerData.barHeightHidden)
			);
			// load progresss
			_barView.progressBar.graphics.beginFill(0xff7f7f, 0.65);
			_barView.progressBar.graphics.drawRect(0, 0,
				(_barView.videoHotspotData.streamData.loadedBytes / _barView.videoHotspotData.streamData.totalBytes < 1)?
				((_barView.videoHotspotData.settings.size.width - _barView.progressPointer.width) *
					_barView.videoHotspotData.streamData.loadedBytes / _barView.videoHotspotData.streamData.totalBytes +
					_barView.progressPointer.width * 0.5):
				_barView.videoHotspotData.settings.size.width,
				(_barView.videoHotspotData.playerData.navigationActive?
				_barView.videoHotspotData.playerData.barHeightExpanded:
				_barView.videoHotspotData.playerData.barHeightHidden)
			);
			// view progress
			_barView.progressBar.graphics.beginFill(0xff0000, 0.85);
			_barView.progressBar.graphics.drawRect(0, 0,
				(_barView.videoHotspotData.streamData.viewTime / _barView.videoHotspotData.streamData.totalTime < 1)?
				((_barView.videoHotspotData.settings.size.width - _barView.progressPointer.width) *
					_barView.videoHotspotData.streamData.viewTime / _barView.videoHotspotData.streamData.totalTime+
					_barView.progressPointer.width * 0.5):
				_barView.videoHotspotData.settings.size.width,
				(_barView.videoHotspotData.playerData.navigationActive?
				_barView.videoHotspotData.playerData.barHeightExpanded:
				_barView.videoHotspotData.playerData.barHeightHidden)
			);
			_barView.progressBar.graphics.endFill();
			
			translateValueToPosition();
		}
		
		private function translatePositionToValue():void {
			if (_barView.progressBar.mouseX <= _barView.progressPointer.width * 0.5) {
					_barView.videoHotspotData.streamData.seekTime = 0;
			}else if (_barView.progressBar.mouseX >= _barView.videoHotspotData.settings.size.width - _barView.progressPointer.width * 0.5) {
				_barView.videoHotspotData.streamData.seekTime = _barView.videoHotspotData.streamData.totalTime - 1;
			}else {
				_barView.videoHotspotData.streamData.seekTime = ((_barView.progressBar.mouseX - _barView.progressPointer.width * 0.5) *
					_barView.videoHotspotData.streamData.totalTime) 
					/ (_barView.videoHotspotData.settings.size.width - _barView.progressPointer.width);
			}
		}
		
		private function translateValueToPosition():void {
			if (!_barView.videoHotspotData.barData.progressPointerDragged) {
				_barView.progressPointer.x = (_barView.videoHotspotData.settings.size.width - _barView.progressPointer.width) *
					_barView.videoHotspotData.streamData.viewTime / _barView.videoHotspotData.streamData.totalTime;
			}
		}
	}
}