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
package com.panozona.spots.videospot.conroller{
	
	import com.panozona.spots.videospot.view.BarView;
	import com.panozona.spots.videospot.events.BarEvent;
	import com.panozona.spots.videospot.events.PlayerEvent;
	import com.panozona.spots.videospot.events.StreamEvent;
	import flash.events.Event;
	
	public class BarController{
		
		private var _barView:BarView;
		
		public function BarController(barView:BarView) {
			_barView = barView;
			
			_barView.videoSpotData.playerData.addEventListener(PlayerEvent.CHANGED_NAVIGATION_ACTIVE, handleNavigationActiveChange, false, 0, true);
			
			_barView.videoSpotData.barData.addEventListener(BarEvent.CHANGED_PROGRESS_POINTER_DRAGGED, handleProgressPointerDraggedChange, false, 0, true);
			
			_barView.videoSpotData.streamData.addEventListener(StreamEvent.CHANGED_BYTES_LOADED, drawProgressBar, false, 0, true);
			_barView.videoSpotData.streamData.addEventListener(StreamEvent.CHANGED_VIEW_TIME, drawProgressBar, false, 0, true);
		}
		
		private function handleNavigationActiveChange(e:Event):void {
			if (_barView.videoSpotData.playerData.navigationActive) {
				_barView.progressBar.y = _barView.videoSpotData.settings.size.height -
					_barView.videoSpotData.playerData.barHeightExpanded;
				_barView.progressPointer.visible = true;
			}else {
				_barView.progressBar.y = _barView.videoSpotData.settings.size.height -
					_barView.videoSpotData.playerData.barHeightHidden;
				_barView.progressPointer.visible = false;
			}
			drawProgressBar();
		}
		
		private function handleProgressPointerDraggedChange(e:Event):void {
			if (_barView.videoSpotData.barData.progressPointerDragged) {
				_barView.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}else {
				_barView.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				translatePositionToValue();
			}
		}
		
		private function onEnterFrame(e:Event):void {
			if (_barView.progressBar.mouseX >= _barView.videoSpotData.settings.size.width - _barView.progressPointer.width * 0.5){
				_barView.progressPointer.x = _barView.videoSpotData.settings.size.width - _barView.progressPointer.width;
			}else if (_barView.progressBar.mouseX <= _barView.progressPointer.width * 0.5) {
				_barView.progressPointer.x = 0;
			}else if (_barView.progressBar.mouseX >= (_barView.videoSpotData.settings.size.width - _barView.progressPointer.width) *
				_barView.videoSpotData.streamData.loadedBytes / _barView.videoSpotData.streamData.totalBytes +
				_barView.progressPointer.width * 0.5) {
				_barView.progressPointer.x = (_barView.videoSpotData.settings.size.width - _barView.progressPointer.width) *
					_barView.videoSpotData.streamData.loadedBytes / _barView.videoSpotData.streamData.totalBytes +
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
				_barView.videoSpotData.settings.size.width,
				(_barView.videoSpotData.playerData.navigationActive?
				_barView.videoSpotData.playerData.barHeightExpanded:
				_barView.videoSpotData.playerData.barHeightHidden)
			);
			// load progresss
			_barView.progressBar.graphics.beginFill(0xff7f7f, 0.65);
			_barView.progressBar.graphics.drawRect(0, 0,
				(_barView.videoSpotData.streamData.loadedBytes / _barView.videoSpotData.streamData.totalBytes < 1)?
				((_barView.videoSpotData.settings.size.width - _barView.progressPointer.width) *
					_barView.videoSpotData.streamData.loadedBytes / _barView.videoSpotData.streamData.totalBytes +
					_barView.progressPointer.width * 0.5):
				_barView.videoSpotData.settings.size.width,
				(_barView.videoSpotData.playerData.navigationActive?
				_barView.videoSpotData.playerData.barHeightExpanded:
				_barView.videoSpotData.playerData.barHeightHidden)
			);
			// view progress
			_barView.progressBar.graphics.beginFill(0xff0000, 0.85);
			_barView.progressBar.graphics.drawRect(0, 0,
				(_barView.videoSpotData.streamData.viewTime / _barView.videoSpotData.streamData.totalTime < 1)?
				((_barView.videoSpotData.settings.size.width - _barView.progressPointer.width) *
					_barView.videoSpotData.streamData.viewTime / _barView.videoSpotData.streamData.totalTime+
					_barView.progressPointer.width * 0.5):
				_barView.videoSpotData.settings.size.width,
				(_barView.videoSpotData.playerData.navigationActive?
				_barView.videoSpotData.playerData.barHeightExpanded:
				_barView.videoSpotData.playerData.barHeightHidden)
			);
			_barView.progressBar.graphics.endFill();
			
			translateValueToPosition();
		}
		
		private function translatePositionToValue():void {
			if (_barView.progressBar.mouseX <= _barView.progressPointer.width * 0.5) {
					_barView.videoSpotData.streamData.seekTime = 0;
			}else if (_barView.progressBar.mouseX >= _barView.videoSpotData.settings.size.width - _barView.progressPointer.width * 0.5) {
				_barView.videoSpotData.streamData.seekTime = _barView.videoSpotData.streamData.totalTime - 1;
			}else {
				_barView.videoSpotData.streamData.seekTime = ((_barView.progressBar.mouseX - _barView.progressPointer.width * 0.5) *
					_barView.videoSpotData.streamData.totalTime) 
					/ (_barView.videoSpotData.settings.size.width - _barView.progressPointer.width);
			}
		}
		
		private function translateValueToPosition():void {
			if (!_barView.videoSpotData.barData.progressPointerDragged) {
				_barView.progressPointer.x = (_barView.videoSpotData.settings.size.width - _barView.progressPointer.width) *
					_barView.videoSpotData.streamData.viewTime / _barView.videoSpotData.streamData.totalTime;
			}
		}
	}
}