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
	
	import com.panozona.hotspots.videohotspot.model.StreamData;
	import com.panozona.hotspots.videohotspot.model.VideoHotspotData;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	public class StreamController {
		
		private var netStream:NetStream;
		private var soundTransform:SoundTransform;
		private var _mute:Boolean;
		private var volumeCache:Number;
		private var dataPropagationTimer:Timer;
		private var _videoHotspotData:VideoHotspotData;
		
		public function StreamController(videoHotspotData:VideoHotspotData) {
			_videoHotspotData = videoHotspotData;
			
			soundTransform = new SoundTransform();
			
			var netConnection:NetConnection = new NetConnection();
			netConnection.connect(null);
			netStream = new NetStream(netConnection);
			netStream.bufferTime = 5; //seconds of video buffered before playing start
			netStream.addEventListener(NetStatusEvent.NET_STATUS, handleStatusChange);
			
			var client:Object = new Object();
			var metaDO:Object = function(metaData:Object):void {
				_videoHotspotData.streamData.streamInitiation(metaData.duration, metaData.width, metaData.height);
			}
			client.onMetaData = metaDO;
			netStream.client = client;
			
			dataPropagationTimer = new Timer(100); // on every 1/10 second
			dataPropagationTimer.addEventListener(TimerEvent.TIMER, onTick);
		}
		
		private function handleStatusChange(e:NetStatusEvent):void {
			switch(e.info.code){
				case "NetStream.Play.Start" :
					_videoHotspotData.streamData.streamState = StreamData.STATE_PLAYING;
					dataPropagationTimer.start();
				break;
				case "NetStream.Buffer.Empty" :
					_videoHotspotData.streamData.isBuffering = true;
				break;
				case "NetStream.Buffer.Full" :
					_videoHotspotData.streamData.isBuffering = false;
				break;
				case "NetStream.Play.Stop" :
					_videoHotspotData.streamData.streamState = StreamData.STATE_FINISHED;
					dataPropagationTimer.stop();
				break;
			}
		}
		
		private function onTick(e:Event):void {
			_videoHotspotData.streamData.viewProgress = netStream.time / _videoHotspotData.streamData.totalTime;
			_videoHotspotData.streamData.loadProgress = netStream.bytesLoaded / netStream.bytesTotal;
		}
		
		public function makeVideo():Video {
			var result:Video = new Video(_videoHotspotData.settings.width, _videoHotspotData.settings.height); // TODO: change proportions perhaps
			result.smoothing = true;
			result.attachNetStream(netStream);
			_videoHotspotData.streamData.streamState = StreamData.STATE_PLAYING; // i tutaj to samo - konflikt
			dataPropagationTimer.start();
			netStream.play(_videoHotspotData.settings.videoPath);
				mute = true; // TODO: remove
			return result;
		}
		
		public function play():void {
			_videoHotspotData.streamData.streamState = StreamData.STATE_PLAYING;
			dataPropagationTimer.start();
			netStream.resume();
		}
		
		public function pause():void {
			_videoHotspotData.streamData.streamState = StreamData.STATE_PAUSED;
			dataPropagationTimer.stop();
			netStream.pause();
		}
		
		public function stop():void {
			_videoHotspotData.streamData.streamState = StreamData.STATE_STOPPED;
			dataPropagationTimer.stop();
			netStream.close();
		}
		
		public function replay():void {
			_videoHotspotData.streamData.streamState = StreamData.STATE_PLAYING;
			dataPropagationTimer.start();
			netStream.seek(0);
		}
		
		public function seek(point:Number):void {
			netStream.seek(point);
			dataPropagationTimer.start(); // TODO: GAH!
		}
		
		public function get volume():Number { //TODO: hook up volume control
			return netStream.soundTransform.volume;
		}
		
		public function set volume(value:Number):void {
			soundTransform.volume = value;
			netStream.soundTransform = soundTransform;
		}
		
		public function get mute():Boolean {
			return _mute;
		}
		
		public function set mute(value:Boolean):void {
			if (mute == value) return;
			if (mute) {
				volumeCache = soundTransform.volume;
				soundTransform.volume = 0;
				netStream.soundTransform = soundTransform;
			}else {
				soundTransform.volume = volumeCache;
				netStream.soundTransform = soundTransform;
			}
		}
	}
}