package com.panozona.modues.simplemodule.data {
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class MapData{		
				
		public var label:String;
		public var path:String;
		
		private var _points:Vector.<PointData>;		
		
		public function MapData(label:String, path:String) {
			this.label = label; 
			this.path = path;
			_points = new Vector.<PointData>();						
		}			
		
		public function get points():Vector.<PointData> {
			return _points;
		}
	}
}