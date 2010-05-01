package com.panozona.player.utils {	

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.Event;
	
	import com.panosalado.model.Characteristics;
	import com.panosalado.core.PanoSalado;
	import com.panosalado.model.ViewData;

	/**
	 * ...
	 * @author mstandio
	 */
	public class Trace extends Sprite{		
		
		private static const INFO:Number = 1;
		private static const WARNING:Number = 2;
		private static const ERROR:Number = 3;		
		
		private var output:TextField;		
		private var buffer:String = "";
		
		private static var __instance:Trace;
		
		public function Trace() {				
			if (__instance != null) throw new Error("Tracre is a singleton class; please access the single instance with Trace.instance.");						
			addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);				
		}		
		
		private function stageReady(e:Event):void {                                            
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);	
			
			/// configure textfield
			// add some styles for different message levels 
			output = new TextField();							
			output.width = 400;
			output.height = 200;
			addChild(output);			
			output.appendText(buffer);
			buffer = "";
		}			
		
		public static function get instance():Trace{
			if (__instance == null) __instance = new Trace();
			return __instance;			
		}				
		
		public function print( message:String):void {
			if (output != null) {
				output.appendText(message+"\n");				
			}else{
				buffer += message +"\n";
			}
		}
		
		/*
		public function print(source:Class, message:String, level:Number = 1):void {
			if (output != null) {
				output.appendText(level+" "+message+" "+source+"\n");				
			}
		}
		*/
	}
}