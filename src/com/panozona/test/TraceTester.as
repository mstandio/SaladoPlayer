package com.panozona.test {
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import com.panozona.player.manager.data.TraceData;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class TraceTester extends Sprite {
		
		private var Trace:Trace;		
		private var input:TextField;
		
		public function TraceTester(){
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);		
		}	
		
		private function stageReady(e:Event = null):void {                                            
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);									
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownEvent, false, 0, true );
			stage.addEventListener(Event.RESIZE, handleStageResize);
			
			input = new TextField();
			input.type = TextFieldType.INPUT;
			input.border = true;
			input.borderColor = 0xff0000;
			
			input.width = 300;
			input.height = 100; 
			addChild(input);
			
			var TraceData:TraceData = new TraceData();
			TraceData.initialVisibility = true;
			TraceData.width = 300;
			TraceData.height = 200;
						
			Trace.configure(TraceData);						
			addChild(Trace.instance);
			
			handleStageResize();
		}
		
		private function keyDownEvent( e:KeyboardEvent ):void { 
			if (e.keyCode == Keyboard.ENTER) {
				var rand:Number = Math.round(Math.random() * (2)) + 1;				
				
				
				switch (rand) {
					case 1:
						Trace.instance.printInfo(input.text);
						break;
					case 2:
						Trace.instance.printWarning(input.text);
						break;
					case 3:
						Trace.instance.printError(input.text);
						break;						
				}								
				input.text = "";
			}			
		}		
		
		private function handleStageResize(e:Event=null):void {      				
			input.x = (stage.stageWidth - input.width)*0.5;
			input.y = (stage.stageHeight - input.height)*0.5;
		}				
	}
}