package com.panozona.player.manager.data {
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class ActionData{
		
		public var id:String;						
		public var functions:Vector.<FunctionData>;		
		
		public function ActionData() {			
			functions = new Vector.<FunctionData>();
		}		
	}
}