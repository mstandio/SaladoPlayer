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
package com.panozona.hotspots.simplehotspot{
	
	import flash.display.*;
	import flash.events.*;
	import caurina.transitions.Tweener;
	
	/**
	 * This is example of swf object that can be inserted into SaladoPlayer as hotspot.
	 * It has no connection with SaladoPlayer and can be viewed as standalone swf file.
	 * It cannot be confiogured, in order to change its properties you need to alter 
	 * its source and recompile it.
	 */
	public class SimpleHotspot extends Sprite{
		
		[Embed(source="assets/blue_arrow.png")]
		private static var Bitmap_blue_arrow:Class;
		
		protected var button:Sprite;
		
		protected var initialWidth:Number;
		protected var initialHeight:Number;
		
		public function SimpleHotspot(){
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		protected function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			button = new Sprite();
			button.addChild(new Bitmap(new Bitmap_blue_arrow().bitmapData, "auto", true));
			
			initialWidth = button.width;
			initialHeight = button.height;
			
			button.x = - button.width * 0.5;
			button.y = - button.height * 0.5;
			addChild(button);
			
			button.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			button.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		}
		
		protected function mouseOver(e:MouseEvent):void {
			Tweener.addTween(button, { scaleX:1.5, time:0.25, transition:"easeOutBack" } );
			Tweener.addTween(button, { scaleY:1.5, time:0.25, transition:"easeOutBack" } );
			Tweener.addTween(button, { x: - initialWidth * 1.5 * 0.5, time:0.25, transition:"easeOutBack" } );
			Tweener.addTween(button, { y: - initialHeight * 1.5 * 0.5, time:0.25, transition:"easeOutBack" } );
		}
		
		protected function mouseOut(e:MouseEvent):void {
			Tweener.addTween(button, { scaleX:1, time:0.25, transition:"easeOutExpo" } );
			Tweener.addTween(button, { scaleY:1, time:0.25, transition:"easeOutExpo" } );
			Tweener.addTween(button, { x: - initialWidth * 0.5, time:0.25, transition:"easeOutExpo" } );
			Tweener.addTween(button, { y: - initialHeight * 0.5, time:0.25, transition:"easeOutExpo" } );
		}
	}
}