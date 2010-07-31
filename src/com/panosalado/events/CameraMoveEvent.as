package com.panosalado.events {
	
	import flash.events.Event;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class CameraMoveEvent extends Event {
		
		public var pan:Number;
		public var tilt:Number;
		public var fieldOfView:Number;
		
		public static const CAMERA_MOVE:String = "CameraMoveEvent";
		
		public function CameraMoveEvent(pan:Number, tilt:Number, fieldOfView:Number) {
			super(CameraMoveEvent.CAMERA_MOVE);			
			this.pan = pan;
			this.tilt = tilt;
			this.fieldOfView = fieldOfView;			
		}		
	}
}