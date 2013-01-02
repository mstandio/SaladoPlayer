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
package com.panozona.spots.videospot.conroller {
	
	import com.panozona.spots.videospot.events.PlayerEvent;
	import com.panozona.spots.videospot.events.StreamEvent;
	import com.panozona.spots.videospot.model.StreamData;
	import com.panozona.spots.videospot.view.PlayerView;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class PlayerController {
		
		private var streamController:StreamController;
		private var soundController:SoundController;
		private var barController:BarController;
		private var _playerView:PlayerView;
		
		private var pulseUpTween:Object;
		private var pulseDownTween:Object;
		
		public function PlayerController(playerView:PlayerView){
			_playerView = playerView;
			
			streamController = new StreamController(_playerView.videoSpotData);
			soundController = new SoundController(_playerView.soundView);
			barController = new BarController(_playerView.barView);
			
			playerView.video = streamController.makeVideo();
			
			if (_playerView.videoSpotData.settings.splashPath != null){
				var spashLoader:Loader = new Loader();
				spashLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, spashLost);
				spashLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, spashLoaded);
				spashLoader.load(new URLRequest(_playerView.videoSpotData.settings.splashPath));
			}
			
			_playerView.videoSpotData.streamData.addEventListener(StreamEvent.CHANGED_STREAM_STATE, handleStreamStateChange, false, 0, true);
			_playerView.videoSpotData.streamData.addEventListener(StreamEvent.CHANGED_IS_BUFFERING, handleStreamBufferingChange, false, 0, true);
			
			_playerView.videoSpotData.playerData.addEventListener(PlayerEvent.CHANGED_NAVIGATION_ACTIVE, handleNavigationActiveChange, false, 0, true);
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
			_playerView.splash.scaleX = _playerView.videoSpotData.settings.size.width / _playerView.splash.width;
			_playerView.splash.scaleY = _playerView.videoSpotData.settings.size.height / _playerView.splash.height;
			_playerView.arrangeChildren();
		}
		
		private function handleStreamBufferingChange(e:Event):void {
			if (_playerView.videoSpotData.streamData.isBuffering) {
				// TODO: throbber show
			}else{
				// TODO: throbber hide
			}
		}
		
		private function handleNavigationActiveChange(e:Event):void {
			if (_playerView.videoSpotData.playerData.navigationActive && _playerView.videoSpotData.streamData.streamState == StreamData.STATE_PLAY){
				_playerView.panelSmallButtons.visible = true;
			}else {
				_playerView.panelSmallButtons.visible = false;
			}
		}
		
		private function handleStreamStateChange (e:Event = null):void {
			switch (_playerView.videoSpotData.streamData.streamState) { // TODO: refactor
				case StreamData.STATE_PLAY:
					_playerView.playBigButton.visible = false;
					_playerView.replayBigButton.visible = false;
					_playerView.panelSmallButtons.visible = true;
					_playerView.barView.visible = true;
					_playerView.video.visible = true;
					if (_playerView.splash != null) {
						_playerView.splash.visible = false;
					}
				break;
				case StreamData.STATE_PAUSE:
					_playerView.playBigButton.visible = true;
					_playerView.replayBigButton.visible = false;
					_playerView.panelSmallButtons.visible = false;
					_playerView.barView.visible = true;
					_playerView.video.visible = true;
				break;
				case StreamData.STATE_STOP:
					if (_playerView.videoSpotData.streamData.totalTime - _playerView.videoSpotData.streamData.viewTime <= 0.25) {
						_playerView.playBigButton.visible = false;
						_playerView.replayBigButton.visible = true;
					}else {
						_playerView.playBigButton.visible = true;
						_playerView.replayBigButton.visible = false;
					}
					_playerView.panelSmallButtons.visible = false;
					_playerView.barView.visible = false;
					_playerView.video.visible = false;
					if (_playerView.splash != null) {
						_playerView.splash.visible = true;
					}
				break;
			}
		}
	}
}