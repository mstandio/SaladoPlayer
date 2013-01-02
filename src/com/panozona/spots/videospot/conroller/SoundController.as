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
	
	import com.panozona.spots.videospot.events.PlayerEvent;
	import com.panozona.spots.videospot.events.SoundEvent;
	import com.panozona.spots.videospot.events.StreamEvent;
	import com.panozona.spots.videospot.view.SoundView;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class SoundController {
		
		private var volCache:Number;
		private var _soundView:SoundView;
		private var hidingTimer:Timer;
		
		public function SoundController(soundView:SoundView){
			_soundView = soundView;
			
			hidingTimer = new Timer(500, 1);
			hidingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onHidingTimerComplete, false, 0, true)
			
			_soundView.videoSpotData.soundData.addEventListener(SoundEvent.CHANGED_MUTE, handleMuteChange, false, 0, true);
			_soundView.videoSpotData.soundData.addEventListener(SoundEvent.CHANGED_VOLUME_BAR_OPEN, handleVolumeBarOpenChange, false, 0, true);
			_soundView.videoSpotData.soundData.addEventListener(SoundEvent.CHANGED_VOLUME_POINTER_DRAGGED, handleVolumePointerDraggedChange, false, 0, true);
			
			_soundView.videoSpotData.streamData.addEventListener(StreamEvent.CHANGED_VOLUME_VALUE, handleVolumeValueChange, false, 0, true);
			
			_soundView.videoSpotData.playerData.addEventListener(PlayerEvent.CHANGED_NAVIGATION_ACTIVE, handleNavigationActiveChange, false, 0, true);
		}
		
		private function handleMuteChange(e:Event):void {
			while(_soundView.soundButton.numChildren){
				_soundView.soundButton.removeChildAt(0);
			}
			if (_soundView.videoSpotData.soundData.mute) {
				_soundView.soundButton.addChild(_soundView.soundOffBitmap);
				volCache = _soundView.videoSpotData.streamData.volumeValue;
				_soundView.videoSpotData.streamData.volumeValue = 0;
			}else {
				_soundView.soundButton.addChild(_soundView.soundOnBitmap);
				_soundView.videoSpotData.streamData.volumeValue = (volCache == 0 ? 0.5 : volCache);
			}
		}
		
		private function handleVolumeBarOpenChange(e:Event):void {
			if (_soundView.videoSpotData.soundData.volumeBarOpen) {
				hidingTimer.stop();
				_soundView.volumeBar.visible = true;
			}else {
				hidingTimer.reset();
				hidingTimer.start();
			}
		}
		
		private function onHidingTimerComplete(e:Event):void {
			_soundView.volumeBar.visible = false;
		}
		
		private function handleVolumeValueChange(e:Event):void {
			if (_soundView.videoSpotData.streamData.volumeValue == 0) {
				_soundView.videoSpotData.soundData.mute = true;
			}else {
				_soundView.videoSpotData.soundData.mute = false;
			}
			if (!_soundView.videoSpotData.soundData.volumePointerDragged){
				translateValueToPosition();
			}
		}
		
		private function handleVolumePointerDraggedChange(e:Event):void {
			if (_soundView.videoSpotData.soundData.volumePointerDragged) {
				_soundView.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}else {
				_soundView.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function onEnterFrame(e:Event):void {
			if (_soundView.volumeBar.mouseY <= _soundView.volumePointer.height * 1.5){
				_soundView.volumePointer.y = _soundView.volumePointer.height;
			}else if (_soundView.volumeBar.mouseY >= _soundView.volumeBar.height - _soundView.volumePointer.height * 1.5){
				_soundView.volumePointer.y = _soundView.volumeBar.height - _soundView.volumePointer.height * 2;
			}else {
				_soundView.volumePointer.y = _soundView.volumeBar.mouseY - _soundView.volumePointer.height * 0.5;
			}
			translatePositionToValue();
		}
		
		private function handleNavigationActiveChange(e:Event):void {
			if (!_soundView.videoSpotData.playerData.navigationActive) {
				hidingTimer.stop();
				_soundView.volumeBar.visible = false;
			}
		}
		
		private function translatePositionToValue():void {
			_soundView.videoSpotData.streamData.volumeValue = 1 -
				(_soundView.volumePointer.y - _soundView.volumePointer.height) /
				(_soundView.volumeBar.height - _soundView.volumePointer.height * 3);
		}
		
		private function translateValueToPosition():void {
			_soundView.volumePointer.y = -(_soundView.videoSpotData.streamData.volumeValue - 1) *
					(_soundView.volumeBar.height - _soundView.volumePointer.height * 3) +
					_soundView.volumePointer.height;
		}
	}
}