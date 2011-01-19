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
package com.panozona.hotspots.videohotspot.conroller {
	
	import com.panozona.hotspots.videohotspot.events.StreamEvent;
	import com.panozona.hotspots.videohotspot.events.PlayerEvent;
	import com.panozona.hotspots.videohotspot.model.StreamData;
	import com.panozona.hotspots.videohotspot.view.PlayerView;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	public class PlayerController {
		
		private var streamController:StreamController;
		private var _playerView:PlayerView;
		private var navigationExpanded:Boolean;
		
		public function PlayerController(playerView:PlayerView){
			_playerView = playerView;
			
			streamController = new StreamController(playerView.videoHotspotData);
			
			playerView.video = streamController.makeVideo();
			
			if (_playerView.videoHotspotData.settings.splashPath != null){
				var spashLoader:Loader = new Loader();
				spashLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, spashLost);
				spashLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, spashLoaded);
				spashLoader.load(new URLRequest(_playerView.videoHotspotData.settings.splashPath));
			}
			
			_playerView.videoHotspotData.streamData.addEventListener(StreamEvent.CHANGED_STREAM_STATE, handleStreamStateChange, false, 0, true);
			_playerView.videoHotspotData.streamData.addEventListener(StreamEvent.CHANGED_BYTES_LOADED, drawProgressBar, false, 0, true);
			_playerView.videoHotspotData.streamData.addEventListener(StreamEvent.CHANGED_VIEW_TIME, drawProgressBar, false, 0, true);
			_playerView.videoHotspotData.streamData.addEventListener(StreamEvent.CHANGED_IS_BUFFERING, handleStreamBufferingChange, false, 0, true);
			_playerView.videoHotspotData.playerData.addEventListener(PlayerEvent.CHANGED_NAVIGATION_ACTIVE, handleNavigationActiveChange, false, 0, true);
			_playerView.videoHotspotData.playerData.addEventListener(PlayerEvent.CHANGED_PROGRESS_POINTER_DRAGGED, handleProgressPointerDraggedChange, false, 0, true);
			_playerView.videoHotspotData.playerData.addEventListener(PlayerEvent.CHANGED_VOLUME_BAR_OPEN, handleVolumeBarOpenChange, false, 0, true);
			_playerView.videoHotspotData.playerData.addEventListener(PlayerEvent.CHANGED_VOLUME_POINTER_DRAGGED, handleVolumePointerDraggedChange, false, 0, true);
			
			_playerView.progressBar.addEventListener(MouseEvent.CLICK, seek, false, 0, true);
		}
		
		private function handleStreamBufferingChange(e:Event):void {
			 // show/hide throbber 
			 // show/hide controlls
			 // TODO: temp throbber if this one is not working
		}
		
		private function handleNavigationActiveChange(e:Event):void {
			 if (_playerView.videoHotspotData.playerData.navigationActive
				|| (!_playerView.videoHotspotData.playerData.navigationActive && _playerView.videoHotspotData.playerData.progressPointerDragged)) {
				navigationExpanded = true;
				_playerView.panelSmallButtons.visible = true;
				_playerView.progressPointer.visible = true;
			}else {
				navigationExpanded = false;
				_playerView.panelSmallButtons.visible = false;
				_playerView.progressPointer.visible = false;
			}
			
			if (navigationExpanded) {
				_playerView.progressBar.y = _playerView.videoHotspotData.settings.height - _playerView.videoHotspotData.playerData.barHeightExpanded;
			}else {
				_playerView.progressBar.y = _playerView.videoHotspotData.settings.height - _playerView.videoHotspotData.playerData.barHeightHidden;
			}
			
			drawProgressBar();
		}
		
		private function handleProgressPointerDraggedChange(e:Event):void {
			if (_playerView.videoHotspotData.playerData.progressPointerDragged) {
				_playerView.stage.addEventListener(Event.ENTER_FRAME, onEnterFrameProgress, false, 0, true);
			}else {
				_playerView.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameProgress);
				seek();
			}
		}
		
		private function handleVolumeBarOpenChange(e:Event):void {
			if(_playerView.videoHotspotData.playerData.volumeBarOpen){
				_playerView.volumeBar.visible = true;
			}else {
				_playerView.volumeBar.visible = false;
			}
		}
		
		private function handleVolumePointerDraggedChange(e:Event):void {
			if (_playerView.videoHotspotData.playerData.volumePointerDragged) {
				_playerView.stage.addEventListener(Event.ENTER_FRAME, onEnterFrameVolume, false, 0, true);
			}else {
				_playerView.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameVolume);
				// set volume ... read it somehow ... 
			}
		}
		
		private function onEnterFrameProgress(e:Event):void {
			if (_playerView.progressBar.mouseX >= _playerView.videoHotspotData.settings.width - _playerView.progressPointer.width * 0.5){
				_playerView.progressPointer.x = _playerView.videoHotspotData.settings.width - _playerView.progressPointer.width;
			}else if (_playerView.progressBar.mouseX <= _playerView.progressPointer.width * 0.5) {
				_playerView.progressPointer.x = 0;
			}else if (_playerView.progressBar.mouseX >= (_playerView.videoHotspotData.settings.width - _playerView.progressPointer.width) * _playerView.videoHotspotData.streamData.loadedBytes / _playerView.videoHotspotData.streamData.totalBytes + _playerView.progressPointer.width * 0.5) {
				_playerView.progressPointer.x = (_playerView.videoHotspotData.settings.width - _playerView.progressPointer.width) * _playerView.videoHotspotData.streamData.loadedBytes / _playerView.videoHotspotData.streamData.totalBytes + _playerView.progressPointer.width * 0.5;
			}else {
				_playerView.progressPointer.x = _playerView.progressBar.mouseX - _playerView.progressPointer.width * 0.5;
			}
		}
		
		private function onEnterFrameVolume(e:Event):void {
			if (_playerView.volumeBar.mouseY <= _playerView.volumePointer.height * 1.5){
				_playerView.volumePointer.y = _playerView.volumePointer.height;
			}else if (_playerView.volumeBar.mouseY >= _playerView.volumeBar.height - _playerView.volumePointer.height * 1.5){
				_playerView.volumePointer.y = _playerView.volumeBar.height - _playerView.volumePointer.height * 2;
			}else {
				_playerView.volumePointer.y = _playerView.volumeBar.mouseY - _playerView.volumePointer.height * 0.5;
				
			}
		}
		
		private function handleStreamStateChange (e:Event = null):void {
			switch (_playerView.videoHotspotData.streamData.streamState) { // TODO: refactor
				case StreamData.STATE_PLAY:
					_playerView.progressBar.visible = true;
					_playerView.playBigButton.visible = false;
					_playerView.replayBigButton.visible = false;
					_playerView.pauseSmallButton.visible = true;
					_playerView.stopSmallButton.visible = true;
					_playerView.muteSmallButton.visible = true;
					if (_playerView.splash != null) {
						_playerView.splash.visible = false;
					}
				break;
				case StreamData.STATE_PAUSE:
					_playerView.progressBar.visible = true;
					_playerView.playBigButton.visible = true;
					_playerView.replayBigButton.visible = false;
					_playerView.pauseSmallButton.visible = false;
					_playerView.stopSmallButton.visible = false;
					_playerView.muteSmallButton.visible = false;
				break;
				case StreamData.STATE_STOP:
					_playerView.progressBar.visible = false;
					_playerView.playBigButton.visible = true;
					_playerView.replayBigButton.visible = false;
					_playerView.pauseSmallButton.visible = false;
					_playerView.stopSmallButton.visible = false;
					_playerView.muteSmallButton.visible = false;
					if (_playerView.splash != null) {
						_playerView.splash.visible = true;
					}
					_playerView.video.visible = false;
				break;
				/*
				case StreamData.STATE_FINISHED:
					_playerView.progressBar.visible = false;
					_playerView.playBigButton.visible = false;
					_playerView.replayBigButton.visible = true;
					_playerView.pauseSmallButton.visible = false;
					_playerView.stopSmallButton.visible = false;
					_playerView.muteSmallButton.visible = false;
				break;
				*/
			}
		}
		
		private function spashLost(e:IOErrorEvent):void {
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, spashLost);
			e.target.removeEventListener(Event.COMPLETE, spashLoaded);
			_playerView.arrangeChildren();
		}
		
		private function spashLoaded(e:Event):void {
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, spashLost);
			e.target.removeEventListener(Event.COMPLETE, spashLoaded);
			_playerView.splash = new Bitmap(e.target.content.bitmapData);
			_playerView.splash.scaleX = _playerView.videoHotspotData.settings.width / _playerView.splash.width;
			_playerView.splash.scaleY = _playerView.videoHotspotData.settings.height / _playerView.splash.height;
			_playerView.arrangeChildren();
		}
		
		private function seek(e:Event = null):void {
			if (_playerView.progressBar.mouseX <= _playerView.progressPointer.width * 0.5) {
				_playerView.videoHotspotData.streamData.seekTime = 0;
			}else if (_playerView.progressBar.mouseX >= _playerView.videoHotspotData.settings.width - _playerView.progressPointer.width * 0.5) {
				_playerView.videoHotspotData.streamData.seekTime = _playerView.videoHotspotData.streamData.totalTime - 1;
			}else {
				_playerView.videoHotspotData.streamData.seekTime =((_playerView.progressBar.mouseX - _playerView.progressPointer.width * 0.5) * _playerView.videoHotspotData.streamData.totalTime) /
				(_playerView.videoHotspotData.settings.width - _playerView.progressPointer.width);
			}
		}
		
		private function drawProgressBar(e:Event = null):void {
			_playerView.progressBar.graphics.clear();
			// background
			_playerView.progressBar.graphics.beginFill(0x000000, 0);
			_playerView.progressBar.graphics.drawRect(0, 0,
				_playerView.videoHotspotData.settings.width,
				(navigationExpanded?
				_playerView.videoHotspotData.playerData.barHeightExpanded:
				_playerView.videoHotspotData.playerData.barHeightHidden)
			);
			// load progresss
			_playerView.progressBar.graphics.beginFill(0xff7f7f, 0.65);
			_playerView.progressBar.graphics.drawRect(0, 0,
				(_playerView.videoHotspotData.streamData.loadedBytes / _playerView.videoHotspotData.streamData.totalBytes < 1)?
				((_playerView.videoHotspotData.settings.width - _playerView.progressPointer.width) *
				_playerView.videoHotspotData.streamData.loadedBytes / _playerView.videoHotspotData.streamData.totalBytes +
				_playerView.progressPointer.width * 0.5):
				_playerView.videoHotspotData.settings.width,
				(navigationExpanded?
				_playerView.videoHotspotData.playerData.barHeightExpanded:
				_playerView.videoHotspotData.playerData.barHeightHidden)
			);
			// view progress
			_playerView.progressBar.graphics.beginFill(0xff0000, 0.85);
			_playerView.progressBar.graphics.drawRect(0, 0,
				(_playerView.videoHotspotData.streamData.viewTime / _playerView.videoHotspotData.streamData.totalTime < 1)?
				((_playerView.videoHotspotData.settings.width - _playerView.progressPointer.width) *
				_playerView.videoHotspotData.streamData.viewTime / _playerView.videoHotspotData.streamData.totalTime+
				_playerView.progressPointer.width * 0.5):
				_playerView.videoHotspotData.settings.width,
				(navigationExpanded?
				_playerView.videoHotspotData.playerData.barHeightExpanded:
				_playerView.videoHotspotData.playerData.barHeightHidden)
			);
			_playerView.progressBar.graphics.endFill();
			
			if (!_playerView.videoHotspotData.playerData.progressPointerDragged && navigationExpanded) {
				_playerView.progressPointer.x = (_playerView.videoHotspotData.settings.width - _playerView.progressPointer.width) *
				_playerView.videoHotspotData.streamData.viewTime / _playerView.videoHotspotData.streamData.totalTime;
			}
		}
		
	}
}