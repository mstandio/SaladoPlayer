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
package com.panozona.spots.videospot.model{
	
	import com.panozona.spots.videospot.events.StreamEvent;
	import flash.events.EventDispatcher;
	
	public class StreamData extends EventDispatcher{
		
		public static const STATE_PLAY:String = "StatePlay";
		public static const STATE_PAUSE:String = "StatePause";
		public static const STATE_STOP:String = "StateStop";
		
		private var _totalTime:Number;
		private var _totalBytes:Number;
		
		private var _videoNominalWidth:Number;
		private var _videoNominalHeight:Number;
		
		private var _isBuffering:Boolean;
		private var _streamState:String;
		
		private var _loadedBytes:Number;
		private var _viewTime:Number;
		private var _seekTime:Number;
		private var _volumeValue:Number;
		
		public function StreamData():void{
			_streamState = StreamData.STATE_STOP;
			_loadedBytes = 0;
			_viewTime = 0;
			_volumeValue = 1;
		}
		
		public function streamInitiation(totalTime:Number, totalBytes:Number, videoNominalWidth:Number, videoNominalHeight:Number):void {
			_totalTime = totalTime;
			_totalBytes = totalBytes;
			_videoNominalWidth = videoNominalWidth;
			_videoNominalHeight = videoNominalHeight;
		}
		
		public function get totalTime():Number {
			return _totalTime;
		}
		
		public function get totalBytes():Number {
			return _totalBytes;
		}
		
		public function get videoNominalWidth():Number {
			return _videoNominalWidth;
		}
		
		public function get videoNominalHeight():Number {
			return _videoNominalHeight;
		}
		
		public function get isBuffering():Boolean {
			return _isBuffering;
		}
		
		public function set isBuffering(value:Boolean):void {
			if (_isBuffering == value) return;
			_isBuffering = value;
			dispatchEvent(new StreamEvent(StreamEvent.CHANGED_IS_BUFFERING));
		}
		
		public function set streamState(value:String):void {
			if (value == _streamState) return;
			if (value != StreamData.STATE_PLAY
			&& value != StreamData.STATE_PAUSE
			&& value != StreamData.STATE_STOP) return;
			_streamState = value;
			dispatchEvent(new StreamEvent(StreamEvent.CHANGED_STREAM_STATE));
		}
		
		public function get streamState():String {
			return _streamState;
		}
		
		public function get loadedBytes():Number {
			return _loadedBytes;
		}
		
		public function set loadedBytes(value:Number):void {
			if (value == _loadedBytes) return;
			_loadedBytes = value;
			dispatchEvent(new StreamEvent(StreamEvent.CHANGED_BYTES_LOADED));
		}
		
		public function get viewTime():Number {
			return _viewTime;
		}
		
		public function set viewTime(value:Number):void {
			if (value == _viewTime) return;
			_viewTime = value;
			_seekTime = value; // TODO: is this nessesery ? watch out!
			dispatchEvent(new StreamEvent(StreamEvent.CHANGED_VIEW_TIME));
		}
		
		public function get seekTime():Number {
			return _seekTime;
		}
		
		public function set seekTime(value:Number):void {
			if (value == _seekTime) return;
			_seekTime = value;
			dispatchEvent(new StreamEvent(StreamEvent.CHANGED_SEEK_TIME));
		}
		
		public function get volumeValue():Number {
			return _volumeValue;
		}
		
		public function set volumeValue(value:Number):void {
			if (value == _volumeValue) return;
			_volumeValue = value;
			dispatchEvent(new StreamEvent(StreamEvent.CHANGED_VOLUME_VALUE));
		}
	}
}