package com.panozona.test {
	
	import com.panozona.modules.navigationbar.button.Button;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
			
	/**
	 * ...
	 * @author mstandio
	 */
	public class ButtonTest extends Sprite{
		
	[Embed(source="assets/left_plain.png")]
		private static var Bitmap_left_plain:Class;				
	[Embed(source= "assets/left_press.png")]		
		private static var Bitmap_left_press:Class;				
		
		private var	btnLeft:Button;
		
		private var txt:TextField;
		
		public function ButtonTest(){ 
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);		
		}	
		
		private function stageReady(e:Event = null):void {                                            
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);									
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.txt = new TextField();
			this.addChild(txt);
			txt.x = -250;			
			
			
			btnLeft = new Button(leftPress, leftRelease);		 
			btnLeft.setBitmaps(Bitmap_left_plain,Bitmap_left_plain, Bitmap_left_press);
			btnLeft.x = btnLeft.y = 200;
			addChild(btnLeft);
		
		}
		
		private function leftPress(e:Event):void {			
			txt.text = "press";
		}				
		private function leftRelease(e:Event):void {			
			txt.text = "release";
		}		
	}
}