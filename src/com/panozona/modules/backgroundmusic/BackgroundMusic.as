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
package com.panozona.modules.backgroundmusic{
	
	import com.panozona.modules.backgroundmusic.data.BackgroundMusicData;
	import com.panozona.modules.backgroundmusic.data.structure.Track;
	import com.panozona.modules.backgroundmusic.data.structure.Sound;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	public class BackgroundMusic extends Module {
		
		private var backgroundMusicData:BackgroundMusicData;
		
		private var currentTrackId:String;
		private var trackIsPlaying:Boolean;
		private var trackChannel:SoundChannel;
		private var trackSound:flash.media.Sound;
		
		private var singleSoundChannel:SoundChannel;
		private var singleSoundSound:flash.media.Sound;
		
		public function BackgroundMusic() {
			super("BackgroundMusic", "1.2", "http://panozona.com/wiki/Module:BackgroundMusic");
			
			moduleDescription.addFunctionDescription("setTrack", String);
			moduleDescription.addFunctionDescription("setPlay", Boolean);
			moduleDescription.addFunctionDescription("togglePlay");
			moduleDescription.addFunctionDescription("playSound", String);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			backgroundMusicData = new BackgroundMusicData(moduleData, saladoPlayer);
			currentTrackId = backgroundMusicData.tracks.getChildrenOfGivenClass(Track)[0].id;
			
			trackChannel = new SoundChannel();
			singleSoundChannel = new SoundChannel();
			
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
					trackSound = new flash.media.Sound();
					trackSound.addEventListener(IOErrorEvent.IO_ERROR, trackLost, false, 0, true);
					trackSound.load(new URLRequest(track.path));
					var soundTransform:SoundTransform = new SoundTransform();
					soundTransform.volume = track.volume;
					trackChannel = trackSound.play(0, (track.loop ? int.MAX_VALUE : 1), soundTransform);
					trackChannel.addEventListener(Event.SOUND_COMPLETE, trackComplete, false, 0, true);
					saladoPlayer.manager.runAction(backgroundMusicData.settings.onPlay);
					backgroundMusicData.settings.play = true;
				}
			}
		}
		
		private function trackLost(e:IOErrorEvent):void {
			stopCurrentTrack();
			printWarning("File not found in track: " + currentTrackId);
		}
		
		private function trackComplete(e:Event):void {
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
		
		private function stopCurrentTrack():void {
			if(trackChannel != null){
				trackChannel.stop();
			}
			if(trackSound != null){
				trackSound.removeEventListener(IOErrorEvent.IO_ERROR, trackLost);
				trackSound = null;
				saladoPlayer.manager.runAction(backgroundMusicData.settings.onStop);
			}
			backgroundMusicData.settings.play = false;
		}
		
		private function playSingleSound(sound:Sound):void {
			singleSoundSound = new flash.media.Sound();
			singleSoundSound.addEventListener(IOErrorEvent.IO_ERROR, singleSoundLost, false, 0, true);
			singleSoundSound.load(new URLRequest(sound.path));
			var singleSoundTransform:SoundTransform = new SoundTransform();
			singleSoundTransform.volume = sound.volume;
			singleSoundChannel = singleSoundSound.play();
		}
		
		private function singleSoundLost(e:IOErrorEvent):void {
			printWarning("Error while playing sound: " + e.text);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setTrack(trackId:String):void {
			if (trackId == null || currentTrackId == trackId) return;
			for each(var track:Track in backgroundMusicData.tracks.getChildrenOfGivenClass(Track)) {
				if (track.id == trackId) {
					currentTrackId = trackId;
					if(trackSound != null) playCurrentTrack();
					return;
				}
			}
			printWarning("Track does not exist: " + trackId);
		}
		
		public function togglePlay():void {
			if(trackSound == null){
				playCurrentTrack();
			}else {
				stopCurrentTrack();
			}
		}
		
		public function setPlay(value:Boolean):void {
			if(trackSound == null && value){
				playCurrentTrack();
				return;
			}
			if(trackSound != null && !value){
				stopCurrentTrack();
				return;
			}
		}
		
		public function playSound(soundId:String):void {
			for each(var sound:Sound in backgroundMusicData.sounds.getChildrenOfGivenClass(Sound)) {
				if(sound.id == soundId){
					playSingleSound(sound);
					return;
				}
			}
			printWarning("Sound does not exist: " + soundId);
		}
	}
}