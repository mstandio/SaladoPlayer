package com.panozona.player.manager.data {
	
	import flash.display.DisplayObject;
	import com.panosalado.model.Params;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class PanoramaData{				
				
		public var id:String;
		public var label:String;
		
		public var params:Params;
		public var children:Vector.<ChildData>; 
		
		public var onEnter:String;        // action id
		public var onLeave:String;        // action id		
		public var onLeaveTarget:Object;  // panorama id to action id 
		
		public function PanoramaData(path:String) {
			params = new Params(path);
			children = new Vector.<ChildData>();
			onLeaveTarget = new Object();
		}				
		
		public function getChildrenDisplayObjectVector():Vector.<DisplayObject> {
			if(children.length > 0){			
				var result:Vector.<DisplayObject> = new Vector.<DisplayObject>;
				for (var i:int = 0; i < children.length; i++) {
					result.push(children[i].managedChild);					
				}
				return result;
			}			
			return null;			
		}
	}
}