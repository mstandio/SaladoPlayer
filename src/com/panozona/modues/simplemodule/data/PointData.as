package com.panozona.modues.simplemodule.data {
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class PointData{
		
		public var posX:Number;
		public var posY:Number;
		
		public var target:String;
		
		public function PointData(posX:Number, posY:Number, target:String) {
			this.posX = posX;
			this.posY = posY;
			this.target = target;			
		}			
	}
}