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
package com.panozona.modules.imagemap.model {
	
	import flash.events.EventDispatcher;
	
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	import com.panozona.player.module.data.property.Size;
	import com.panozona.player.module.data.property.Tween;
	
	import com.panozona.modules.imagemap.events.WindowEvent;
	
	/**
	 * @author mstandio
	 */
	public class WindowData extends EventDispatcher{
		
		public static var OPEN_CLOSE_FADE:String = "fade";
		public static var OPEN_CLOSE_SLIDE_UP:String = "slideUp";
		public static var OPEN_CLOSE_SLIDE_DOWN:String = "slideDown";
		public static var OPEN_CLOSE_SLIDE_LEFT:String = "slideLeft";
		public static var OPEN_CLOSE_SLIDE_RIGHT:String = "slideRight";
		
		private var _open:Boolean = true;
		public var align:Align = new Align(Align.RIGHT, Align.TOP);
		public var move:Move = new Move( -20, 20);
		public var size:Size = new Size(400, 300);
		public var tween:Tween = new Tween(0.5,"linear");
		private var _alpha:Number = 1.0;
		private var _animation:String = WindowData.OPEN_CLOSE_SLIDE_RIGHT;
		
		public var onOpen:String;  // actions executed 
		public var onClose:String; // on window visibility change
		
		public function get animation():String{
			return _animation;
		}
		
		public function get open():Boolean{return _open}
		public function set open(value:Boolean):void {
			if (value == _open) return;
			_open = value;
			dispatchEvent(new WindowEvent(WindowEvent.CHANGED_OPEN));
		}
		
		public function set animation(value:String):void {
			if (value == WindowData.OPEN_CLOSE_SLIDE_RIGHT||
				value == WindowData.OPEN_CLOSE_SLIDE_LEFT ||
				value == WindowData.OPEN_CLOSE_SLIDE_UP ||
				value == WindowData.OPEN_CLOSE_SLIDE_DOWN ||
				value == WindowData.OPEN_CLOSE_FADE) {
				_animation = value;
			}else {
				throw new Error("Invalid animation value: "+value);
			}
		}
		
		public function get alpha():Number {return _alpha;}
		public function set alpha(value:Number):void {
			if (value == 0) throw new Error("Alpha cannot be equal: "+value);
			_alpha = value;
		}
	}
}