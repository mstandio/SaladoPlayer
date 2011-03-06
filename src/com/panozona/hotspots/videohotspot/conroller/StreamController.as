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
	import com.panozona.hotspots.videohotspot.model.StreamData;
	import com.panozona.hotspots.videohotspot.model.VideoHotspotData;
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
		private var _videoHotspotData:VideoHotspotData;
		
		public function StreamController(videoHotspotData:VideoHotspotData) {
			_videoHotspotData = videoHotspotData;
			
			soundTransform = new SoundTransform();
			
			var netConnection:NetConnection = new NetConnection();
			netConnection.connect(null);
			netStream = new NetStream(netConnection);
			netStream.bufferTime = 5; //seconds of video buffered before start playing
			netStream.addEventListener(NetStatusEvent.NET_STATUS, handleStatusChange);
			
			var client:Object = new Object();
			var metaDO:Object = function(metaData:Object):void {
				_videoHotspotData.streamData.streamInitiation(metaData.duration, netStream.bytesTotal, metaData.width, metaData.height);
			}
			client.onMetaData = metaDO;
			netStream.client = client;
			
			dataPropagationTimer = new Timer(100);
			dataPropagationTimer.addEventListener(TimerEvent.TIMER, onTick);
			
			_videoHotspotData.streamData.addEventListener(StreamEvent.CHANGED_VOLUME_VALUE, handleVolumeChange, false, 0, true);
			_videoHotspotData.streamData.addEventListener(StreamEvent.CHANGED_STREAM_STATE, handleStreamStateChange, false, 0, true);
			_videoHotspotData.streamData.addEventListener(StreamEvent.CHANGED_SEEK_TIME, handleSeekTimeChange, false, 0, true);
		}
		
		public function makeVideo():Video {
			var result:Video = new Video(_videoHotspotData.settings.size.width, _videoHotspotData.settings.size.height);
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
					_videoHotspotData.streamData.isBuffering = true; // huh
				break;
				case "NetStream.Buffer.Full" :
					_videoHotspotData.streamData.isBuffering = false; // huuuhhh
				break;
				case "NetStream.Play.Stop" : // finished playing
					_videoHotspotData.streamData.streamState = StreamData.STATE_STOP;
				break;
			}
		}
		
		private function handleVolumeChange(e:Event):void {
			soundTransform.volume = _videoHotspotData.streamData.volumeValue;
			netStream.soundTransform = soundTransform;
			trace("mam " + soundTransform.volume);
		}
		
		private function handleStreamStateChange(e:Event):void {
			switch(_videoHotspotData.streamData.streamState) {
				case StreamData.STATE_PLAY:
					if (isPaused) {
						isPaused = false;
						netStream.resume();
					}else {
						dataPropagationTimer.start();
						netStream.play(_videoHotspotData.settings.videoPath);
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
			if (_videoHotspotData.streamData.streamState == StreamData.STATE_PAUSE ||
				_videoHotspotData.streamData.streamState == StreamData.STATE_PLAY){
				netStream.seek(_videoHotspotData.streamData.seekTime);
			}
		}
		
		private function onTick(e:Event = null):void {
			_videoHotspotData.streamData.viewTime = netStream.time;
			_videoHotspotData.streamData.loadedBytes = netStream.bytesLoaded;
		}
	}
}