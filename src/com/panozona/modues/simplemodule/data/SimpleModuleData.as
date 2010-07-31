package com.panozona.modues.simplemodule.data {
	
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.ModuleNode;

	/**
	 * ...
	 * @author mstandio
	 */
	public class SimpleModuleData {		
				
		public var settings:SettingsData;
		public var maps:Vector.<MapData>;
		
		public function SimpleModuleData(moduleData:ModuleData) {
			settings = new SettingsData();
			maps = new Vector.<MapData>();        		
						
			var moduleNode:ModuleNode;
			
			moduleNode = moduleData.getModuleNodeByName("settings");			
			if (moduleNode != null) {						
				settings.num = moduleNode.getAttributeByName("num", Number, 666);
				settings.boo = moduleNode.getAttributeByName("boo", Boolean, true);
				settings.arr = moduleNode.getAttributeByName("arr", Array, null);
				settings.str = moduleNode.getAttributeByName("str", String, null);
				trace("num: " + settings.num);
				trace("boo: " + settings.boo);
				trace("arr: " + settings.arr);
				trace("str: " + settings.str+" "+(settings.str==null));				
			}
			//TODO:  a co jezeli nie bedzie takiego noda ?? kto wtedy zada domyslne wartosci ???
			// czy nalezy sie tym martwic systemowo ???? czy to juz bedzie w interesie tworcy modulu ????
			
			moduleNode = moduleData.getModuleNodeByName("maps");
			if (moduleNode != null) {
				var pointData:PointData;
				//for each(var moduleNode:ModuleNode in moduleNode.children) {
					//pointData = new PointData(moduleNode.attributes) 						
										
				//}				
			}		
		}	
	}
}