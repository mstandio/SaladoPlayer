package com.panozona.test{
	
	import com.panozona.modues.navigationbar.combobox.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class ComboboxTester extends Sprite {
		
		private var txt:TextField;
		
		private var combobox:Combobox;
		private var style:ComboboxStyle;
		
		public function ComboboxTester() {			
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);		
		}	
		
		private function stageReady(e:Event = null):void {                                            
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);									
			stage.scaleMode = StageScaleMode.NO_SCALE;

			
			this.txt = new TextField();
			this.addChild(txt);
			txt.x = -250;			
			
			var vector:Vector.<Object> = new Vector.<Object>();
						
			style = new ComboboxStyle();			
			
			var object1:Object = new Object();
			object1.label = "labella 11111";
			
			var object2:Object = new Object();
			object2.label = "labella 12222";
			
			var object3:Object = new Object();
			object3.label = "labella 33331";
			
			var object4:Object = new Object();
			object4.label = "labella 444441";
			
			vector.push(object1);
			vector.push(object2);
			vector.push(object3);
			vector.push(object4);						
			
			combobox = new Combobox(vector, style);
			combobox.x = combobox.y = 300; 			
			addChild(combobox);			
			combobox.setEnabled(true);
			
			combobox.addEventListener(ComboboxEvent.LABEL_CHANGED, labelChanged);
		}		
		
		public function labelChanged(e:ComboboxEvent):void {			
			txt.text = "label : " + e.object.label;			
		}			
	}
}