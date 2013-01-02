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
	
	import com.panozona.spots.videospot.events.StreamEvent;
	import com.panozona.spots.videospot.model.StreamData;
	import com.panozona.spots.videospot.model.VideoSpotData;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	public class StreamController {
		
		private var netStream:NetStream;
		private var soundTransform:SoundTransform;
		private var dataPropagationTimer:Timer;
		private var isPaused:Boolean;
		private var _videoSpotData:VideoSpotData;
		
		public function StreamController(videoSpotData:VideoSpotData) {
			_videoSpotData = videoSpotData;
			
			soundTransform = new SoundTransform();
			
			var netConnection:NetConnection = new NetConnection();
			netConnection.connect(null);
			netStream = new NetStream(netConnection);
			netStream.bufferTime = 5; //seconds of video buffered before start playing
			netStream.addEventListener(NetStatusEvent.NET_STATUS, handleStatusChange);
			
			var client:Object = new Object();
			var metaDO:Object = function(metaData:Object):void {
				_videoSpotData.streamData.streamInitiation(metaData.duration, netStream.bytesTotal, metaData.width, metaData.height);
			}
			client.onMetaData = metaDO;
			netStream.client = client;
			
			dataPropagationTimer = new Timer(100);
			dataPropagationTimer.addEventListener(TimerEvent.TIMER, onTick);
			
			_videoSpotData.streamData.addEventListener(StreamEvent.CHANGED_VOLUME_VALUE, handleVolumeChange, false, 0, true);
			_videoSpotData.streamData.addEventListener(StreamEvent.CHANGED_STREAM_STATE, handleStreamStateChange, false, 0, true);
			_videoSpotData.streamData.addEventListener(StreamEvent.CHANGED_SEEK_TIME, handleSeekTimeChange, false, 0, true);
		}
		
		public function makeVideo():Video {
			var result:Video = new Video(_videoSpotData.settings.size.width, _videoSpotData.settings.size.height);
			result.smoothing = true;
			result.attachNetStream(netStream);
			return result;
		}
		
		private function handleStatusChange(e:NetStatusEvent):void {
			switch(e.info.code){
				case "NetStream.Play.Start" :
					dataPropagationTimer.start();
				break;
				case "NetStream.Buffer.Empty" :
					_videoSpotData.streamData.isBuffering = true; // huh
				break;
				case "NetStream.Buffer.Full" :
					_videoSpotData.streamData.isBuffering = false; // huuuhhh
				break;
				case "NetStream.Play.Stop" : // finished playing
					_videoSpotData.streamData.streamState = StreamData.STATE_STOP;
				break;
			}
		}
		
		private function handleVolumeChange(e:Event):void {
			soundTransform.volume = _videoSpotData.streamData.volumeValue;
			netStream.soundTransform = soundTransform;
			trace("mam " + soundTransform.volume);
		}
		
		private function handleStreamStateChange(e:Event):void {
			switch(_videoSpotData.streamData.streamState) {
				case StreamData.STATE_PLAY:
					if (isPaused) {
						isPaused = false;
						netStream.resume();
					}else {
						dataPropagationTimer.start();
						netStream.play(_videoSpotData.settings.videoPath);
					}
				break;
				case StreamData.STATE_PAUSE:
					isPaused = true;
					netStream.pause();
				break;
				case StreamData.STATE_STOP:
					isPaused = false;
					dataPropagationTimer.stop();
					netStream.close();
				break
			}
		}
		
		private function handleSeekTimeChange(e:Event):void {
			if (_videoSpotData.streamData.streamState == StreamData.STATE_PAUSE ||
				_videoSpotData.streamData.streamState == StreamData.STATE_PLAY){
				netStream.seek(_videoSpotData.streamData.seekTime);
			}
		}
		
		private function onTick(e:Event = null):void {
			_videoSpotData.streamData.viewTime = netStream.time;
			_videoSpotData.streamData.loadedBytes = netStream.bytesLoaded;
		}
	}
}