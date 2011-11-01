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
package com.panozona.modules.BackgroundMusic{
	
	import com.panozona.modules.BackgroundMusic.data.BackgroundMusicData;
	import com.panozona.modules.BackgroundMusic.data.structure.Track;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	public class BackgroundMusic extends Module {
		
		private var backgroundMusicData:BackgroundMusicData;
		
		private var currentTrackId:String;
		private var isPlaying:Boolean;
		
		private var soundChannel:SoundChannel;
		private var sound:Sound;
		private var _soundTransform:SoundTransform;
		
		public function BackgroundMusic() {
			super("BackgroundMusic", "1.1", "http://panozona.com/wiki/Module:BackgroundMusic");
			
			moduleDescription.addFunctionDescription("setTrack", String);
			moduleDescription.addFunctionDescription("setPlay", Boolean);
			moduleDescription.addFunctionDescription("togglePlay");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			backgroundMusicData = new BackgroundMusicData(moduleData, saladoPlayer);
			_soundTransform = new SoundTransform();
			currentTrackId = backgroundMusicData.tracks.getChildrenOfGivenClass(Track)[0].id;
			
			if (backgroundMusicData.settings.play) {
				var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
				saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onFirstPanoramaStartedLoading, false, 0, true);
			}
		}
		
		private function onFirstPanoramaStartedLoading(panoramaEvent:Object):void {
			var panoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			saladoPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onFirstPanoramaStartedLoading);
			playCurrentTrack();
		}
		
		private function playCurrentTrack():void {
			for each(var track:Track in backgroundMusicData.tracks.getChildrenOfGivenClass(Track)) {
				if (track.id == currentTrackId){
					stopCurrentTrack();
					sound = new Sound();
					sound.addEventListener(IOErrorEvent.IO_ERROR, soundLost, false, 0, true);
					sound.load(new URLRequest(track.path));
					_soundTransform.volume = track.volume;
					soundChannel = sound.play(0, (track.loop ? int.MAX_VALUE : 1), _soundTransform);
					soundChannel.addEventListener(Event.SOUND_COMPLETE, soundComplete, false, 0, true);
					saladoPlayer.manager.runAction(backgroundMusicData.settings.onPlay);
					backgroundMusicData.settings.play = true;
				}
			}
		}
		
		private function soundLost(e:Event):void {
			stopCurrentTrack();
			printWarning("File not found in track: " + currentTrackId);
		}
		
		private function stopCurrentTrack():void {
			if(soundChannel != null){
				soundChannel.stop();
			}
			if(sound != null){
				sound.removeEventListener(IOErrorEvent.IO_ERROR, soundLost);
				sound = null;
				saladoPlayer.manager.runAction(backgroundMusicData.settings.onStop);
			}
			backgroundMusicData.settings.play = false;
		}
		
		private function soundComplete(e:Event):void {
			var tracksArray:Array = backgroundMusicData.tracks.getChildrenOfGivenClass(Track);
			for (var i:int = 0; i < tracksArray.length; i++) {
				if (tracksArray[i].id == currentTrackId) {
					if (tracksArray[i].next != null) {
						currentTrackId = tracksArray[i].next;
						playCurrentTrack();
					}else {
						stopCurrentTrack();
					}
					return;
				}
			}
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setTrack(trackId:String):void {
			if (trackId == null || currentTrackId == trackId) return;
			for each(var track:Track in backgroundMusicData.tracks.getChildrenOfGivenClass(Track)) {
				if (track.id == trackId) {
					currentTrackId = trackId;
					if(sound != null) playCurrentTrack();
					return;
				}
			}
			printWarning("Track does not exist: " + trackId);
		}
		
		public function togglePlay():void {
			if(sound == null){
				playCurrentTrack();
			}else {
				stopCurrentTrack();
			}
		}
		
		public function setPlay(value:Boolean):void {
			if(sound == null && value){
				playCurrentTrack();
				return;
			}
			if(sound != null && !value){
				stopCurrentTrack();
				return;
			}
		}
	}
}