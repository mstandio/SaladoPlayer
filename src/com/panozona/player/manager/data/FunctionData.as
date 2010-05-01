package com.panozona.player.manager.data {
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class FunctionData {
		
		public var target:String;
		public var name:String;
		public var params:Array; 
		
		public function FunctionData(target:String, name:String) {
			this.target = target;
			this.name = name;
			params = new Array();
		}		
	}
}