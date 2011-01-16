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
	import com.panozona.hotspots.videohotspot.events.WindowEvent;
	import com.panozona.hotspots.videohotspot.model.StreamData;
	import com.panozona.hotspots.videohotspot.view.WindowView;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	public class WindowController {
		
		private var streamController:StreamController;
		private var _windowView:WindowView;
		private var navigationExpanded:Boolean;
		
		public function WindowController(windowView:WindowView){
			_windowView = windowView;
			
			streamController = new StreamController(windowView.videoHotspotData);
			
			if (_windowView.videoHotspotData.settings.splashPath != null){
				var spashLoader:Loader = new Loader();
				spashLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, spashLost);
				spashLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, spashLoaded);
				spashLoader.load(new URLRequest(_windowView.videoHotspotData.settings.splashPath));
			}
			
			_windowView.playBigButton.addEventListener(MouseEvent.CLICK, performPlay, false, 0, true);
			_windowView.replayBigButton.addEventListener(MouseEvent.CLICK, performReplay, false, 0, true);
			_windowView.pauseSmallButton.addEventListener(MouseEvent.CLICK, performPause, false, 0, true);
			_windowView.stopSmallButton.addEventListener(MouseEvent.CLICK, performStop, false, 0, true);
			
			_windowView.videoHotspotData.streamData.addEventListener(StreamEvent.CHANGED_STREAM_STATE, handleStreamStateChange, false, 0, true);
			_windowView.videoHotspotData.streamData.addEventListener(StreamEvent.CHANGED_LOAD_PROGRESS, drawProgressBar, false, 0, true);
			_windowView.videoHotspotData.streamData.addEventListener(StreamEvent.CHANGED_VIEW_PROGRESS, drawProgressBar, false, 0, true);
			_windowView.videoHotspotData.streamData.addEventListener(StreamEvent.CHANGED_IS_BUFFERING, handleStreamBufferingChange, false, 0 , true);
			_windowView.videoHotspotData.windowData.addEventListener(WindowEvent.CHANGED_MOUSE_IS_OVER, handleMouseIsOverChange, false, 0 , true);
			_windowView.videoHotspotData.windowData.addEventListener(WindowEvent.CHANGED_POINTER_DRAGGED, handlePointerDraggedChange, false, 0 , true);
			
			_windowView.progressBar.addEventListener(MouseEvent.CLICK, seek, false, 0, true);
		}
		
		private function handleStreamBufferingChange(e:Event):void {
			 // show/hide throbber 
			 // show/hide controlls
			 // TODO: temp throbber if this one is not working
		}
		
		private function handleMouseIsOverChange(e:Event):void {
			trace("is over " + _windowView.videoHotspotData.windowData.mouseIsOver);
			 if (_windowView.videoHotspotData.windowData.mouseIsOver
				|| (!_windowView.videoHotspotData.windowData.mouseIsOver && _windowView.videoHotspotData.windowData.pointerDragged)) {
				navigationExpanded = true;
				_windowView.panelSmallButtons.visible = true;
				_windowView.pointer.visible = true;
			}else {
				navigationExpanded = false;
				_windowView.panelSmallButtons.visible = false;
				_windowView.pointer.visible = false;
			}
			
			if (navigationExpanded) {
				_windowView.progressBar.y = _windowView.videoHotspotData.settings.height - _windowView.videoHotspotData.windowData.barHeightExpanded;
			}else {
				_windowView.progressBar.y = _windowView.videoHotspotData.settings.height - _windowView.videoHotspotData.windowData.barHeightHidden;
			}
			
			drawProgressBar();
		}
		
		private function handlePointerDraggedChange(e:Event):void {
			if (_windowView.videoHotspotData.windowData.pointerDragged) {
				_windowView.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}else {
				_windowView.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				seek();
			}
		}
		
		private function onEnterFrame(e:Event):void {
			if (_windowView.progressBar.mouseX >= _windowView.videoHotspotData.settings.width - _windowView.pointer.width * 0.5){
				_windowView.pointer.x = _windowView.videoHotspotData.settings.width - _windowView.pointer.width * 0.5;
			}else if (_windowView.progressBar.mouseX <= _windowView.pointer.width * 0.5){
				_windowView.pointer.x = _windowView.pointer.width * 0.5;
			}else if (_windowView.progressBar.mouseX >= (_windowView.videoHotspotData.settings.width - _windowView.pointer.width) * _windowView.videoHotspotData.streamData.loadProgress ) {
				_windowView.pointer.x = (_windowView.videoHotspotData.settings.width - _windowView.pointer.width) * _windowView.videoHotspotData.streamData.loadProgress;
			}else {
				_windowView.pointer.x = _windowView.progressBar.mouseX - _windowView.pointer.width * 0.5;
			}
		}
		
		private function handleStreamStateChange (e:Event = null):void {
			switch (_windowView.videoHotspotData.streamData.streamState) {
				case StreamData.STATE_PLAYING:
					_windowView.progressBar.visible = true;
					_windowView.playBigButton.visible = false;
					_windowView.replayBigButton.visible = false;
					_windowView.pauseSmallButton.visible = true;
					_windowView.stopSmallButton.visible = true;
					if (_windowView.splash != null) {
						_windowView.splash.visible = false;
					}
				break;
				case StreamData.STATE_PAUSED:
					_windowView.progressBar.visible = true;
					_windowView.playBigButton.visible = true;
					_windowView.replayBigButton.visible = false;
					_windowView.pauseSmallButton.visible = false;
					_windowView.stopSmallButton.visible = false;
				break;
				case StreamData.STATE_STOPPED:
					_windowView.progressBar.visible = false;
					_windowView.playBigButton.visible = true;
					_windowView.replayBigButton.visible = false;
					_windowView.pauseSmallButton.visible = false;
					_windowView.stopSmallButton.visible = false;
					if (_windowView.splash != null) {
						_windowView.splash.visible = true;
					}
					_windowView.video.visible = false;
				break;
				case StreamData.STATE_FINISHED:
					_windowView.progressBar.visible = false;
					_windowView.playBigButton.visible = false;
					_windowView.replayBigButton.visible = true;
					_windowView.pauseSmallButton.visible = false;
					_windowView.stopSmallButton.visible = false;
				break;
			}
		}
		
		private function spashLost(e:IOErrorEvent):void {
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, spashLost);
			e.target.removeEventListener(Event.COMPLETE, spashLoaded);
			_windowView.arrangeChildren();
		}
		
		private function spashLoaded(e:Event):void {
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, spashLost);
			e.target.removeEventListener(Event.COMPLETE, spashLoaded);
			_windowView.splash = new Bitmap(e.target.content.bitmapData);
			_windowView.splash.scaleX = _windowView.videoHotspotData.settings.width / _windowView.splash.width;
			_windowView.splash.scaleY = _windowView.videoHotspotData.settings.height / _windowView.splash.height;
			_windowView.arrangeChildren();
		}
		
		private function performPlay(e:Event):void {
			if (_windowView.videoHotspotData.streamData == null || _windowView.videoHotspotData.streamData.streamState == StreamData.STATE_STOPPED) {
				_windowView.video = streamController.makeVideo();
				_windowView.arrangeChildren();
			}else if (_windowView.videoHotspotData.streamData.streamState == StreamData.STATE_PAUSED) {
				streamController.play();
			}
		}
		
		private function performReplay(e:Event):void {
			streamController.replay();
		}
		
		private function performPause(e:Event):void {
			streamController.pause();
		}
		
		private function performStop(e:Event):void {
			streamController.stop();
		}
		private function seek(e:Event = null):void {
			if (_windowView.progressBar.mouseX <= _windowView.pointer.width * 0.5) {
				streamController.seek(0);
			}else if (_windowView.progressBar.mouseX >= _windowView.videoHotspotData.settings.width - _windowView.pointer.width * 0.5) {
				streamController.seek(_windowView.videoHotspotData.streamData.totalTime - 1);
			}else {
				streamController.seek(((_windowView.progressBar.mouseX - _windowView.pointer.width * 0.5) * _windowView.videoHotspotData.streamData.totalTime) /
				(_windowView.videoHotspotData.settings.width - _windowView.pointer.width));
			}
		}
		
		private function drawProgressBar(e:Event = null):void {
			_windowView.progressBar.graphics.clear();
			// background
			_windowView.progressBar.graphics.beginFill(0x000000, 0);
			_windowView.progressBar.graphics.drawRect(0, 0,
				_windowView.videoHotspotData.settings.width,
				(navigationExpanded?
				_windowView.videoHotspotData.windowData.barHeightExpanded:
				_windowView.videoHotspotData.windowData.barHeightHidden)
			);
			// load progresss
			_windowView.progressBar.graphics.beginFill(0xff7f7f, 0.65);
			_windowView.progressBar.graphics.drawRect(0, 0,
				(_windowView.videoHotspotData.streamData.loadProgress < 1)?
				((_windowView.videoHotspotData.settings.width - _windowView.pointer.width) *
				_windowView.videoHotspotData.streamData.loadProgress + _windowView.pointer.width * 0.5):
				_windowView.videoHotspotData.settings.width,
				(navigationExpanded?
				_windowView.videoHotspotData.windowData.barHeightExpanded:
				_windowView.videoHotspotData.windowData.barHeightHidden)
			);
			// view progress
			_windowView.progressBar.graphics.beginFill(0xff0000, 0.85);
			_windowView.progressBar.graphics.drawRect(0, 0,
				(_windowView.videoHotspotData.streamData.viewProgress < 1)?
				((_windowView.videoHotspotData.settings.width - _windowView.pointer.width) *
				_windowView.videoHotspotData.streamData.viewProgress + _windowView.pointer.width * 0.5):
				_windowView.videoHotspotData.settings.width,
				(navigationExpanded?
				_windowView.videoHotspotData.windowData.barHeightExpanded:
				_windowView.videoHotspotData.windowData.barHeightHidden)
			);
			_windowView.progressBar.graphics.endFill();
			
			if (!_windowView.videoHotspotData.windowData.pointerDragged && navigationExpanded) {
				_windowView.pointer.x = (_windowView.videoHotspotData.settings.width - _windowView.pointer.width) *
				_windowView.videoHotspotData.streamData.viewProgress;
			}
		}
		
	}
}