/*
Copyright 2010 Zephyr Renner.

This file is part of PanoSalado.

PanoSalado is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

PanoSalado is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with PanoSalado.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.hotspots.examplehotspot {
	
	import flash.display.Bitmap;			
	import flash.events.MouseEvent;		
	
	import com.panosalado.view.SwfHotspot;
	
	import caurina.transitions.*;
	
	[SWF(width="100", height="67")]
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class ExampleHotspot extends SwfHotspot{
		
		[Embed(source="assets/blue_arrow.png")]
		private static var Bitmap_blue_arrow:Class;		
						
		public function ExampleHotspot() {
			super();			
		}
		
		override protected function hotspotReady():void {
			var buttonBitmap:Bitmap = new Bitmap(new Bitmap_blue_arrow().bitmapData, "auto", true);			
			buttonBitmap.x = - buttonBitmap.width * 0.5;
			buttonBitmap.y = - buttonBitmap.height * 0.5;									
			button.addChild(buttonBitmap);
			button.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			button.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		}
				
		// see http://hosted.zeh.com.br/tweener/docs/en-us/
		
		private function mouseOver(e:MouseEvent):void {
			Tweener.addTween(button, { scaleX:1.5, time:0.25, transition:"easeOutBack" } );
			Tweener.addTween(button, { scaleY:1.5, time:0.25, transition:"easeOutBack" } );
		}
		
		private function mouseOut(e:MouseEvent):void {
			Tweener.addTween(button, { scaleX:1, time:0.25, transition:"easeOutExpo" } );
			Tweener.addTween(button, { scaleY:1, time:0.25, transition:"easeOutExpo" } );
		}				
	}
}