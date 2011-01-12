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
package com.panozona.hotspots.videohotspot.model{
	
	import com.panozona.hotspots.videohotspot.events.StreamEvent;
	import flash.events.EventDispatcher;
	
	public class StreamData extends EventDispatcher{
		
		public static const STATE_PLAYING:String = "StatePlaying";
		public static const STATE_PAUSED:String = "StatePaused";
		public static const STATE_STOPPED:String = "StateStopped";
		public static const STATE_FINISHED:String = "StateFinished";
		
		private var _totalTime:Number;
		
		private var _videoNominalWidth:Number;
		private var _videoNominalHeight:Number;
		
		private var _isBuffering:Boolean;
		private var _streamState:String;
		
		private var _loadProgress:Number; // 0.0 to 1.0
		private var _viewProgress:Number; // 0.0 to 1.0
		
		public function StreamData():void{
			_streamState = StreamData.STATE_STOPPED;
		}
		
		public function streamInitiation(totalTime:Number, videoNominalWidth:Number, videoNominalHeight:Number):void {
			_totalTime = totalTime;
			_videoNominalWidth = videoNominalWidth;
			_videoNominalHeight = videoNominalHeight;
		}
		
		public function get totalTime():Number {
			return _totalTime;
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
			if (value != StreamData.STATE_PLAYING
			&& value != StreamData.STATE_PAUSED
			&& value != StreamData.STATE_STOPPED
			&& value != StreamData.STATE_FINISHED) return;
			_streamState = value;
			dispatchEvent(new StreamEvent(StreamEvent.CHANGED_STREAM_STATE));
		}
		
		public function get streamState():String {
			return _streamState;
		}
		
		public function get loadProgress():Number {
			if (isNaN(_loadProgress)) return 0;
			return _loadProgress;
		}
		
		public function set loadProgress(value:Number):void {
			if (value == _loadProgress) return;
			_loadProgress = value;
			dispatchEvent(new StreamEvent(StreamEvent.CHANGED_LOAD_PROGRESS));
		}
		
		public function get viewProgress():Number {
			if (isNaN(_viewProgress)) return 0;
			return _viewProgress;
		}
		
		public function set viewProgress(value:Number):void {
			if (value == _viewProgress) return;
			_viewProgress = value;
			dispatchEvent(new StreamEvent(StreamEvent.CHANGED_VIEW_PROGRESS));
		}
	}
}