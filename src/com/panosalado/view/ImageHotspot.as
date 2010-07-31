package com.panosalado.view {

	import flash.display.Sprite
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import flash.display.Bitmap;
	import flash.display.BitmapData;	
	
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class ImageHotspot extends ManagedChild{
			
		public var _bitmapData:BitmapData;
		public var invalidGraphicsData:Boolean;
		
		public function ImageHotspot(bitmapData:BitmapData) {						
			this.bitmapData = bitmapData;
			buttonMode = true;
		}
	
		public function get bitmapData():BitmapData { return _bitmapData; }
		public function set bitmapData(value:BitmapData):void {
			if (value != null) {				
				_bitmapData = value;
				invalidGraphicsData = true;
				addEventListener(Event.RENDER, draw, false, 0, true);
				return;
			}
			removeEventListener(Event.RENDER, draw);			
		}
	
		protected function draw(e:Event):void {						
			if (!invalidGraphicsData) return;
			graphics.beginBitmapFill(bitmapData);			
			graphics.drawRect(0, 0, bitmapData.width, bitmapData.height);
			graphics.endFill();									
			invalidGraphicsData = false;			
		}			
	}		
}


	
