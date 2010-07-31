package com.panozona.modues.simplemodule {

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.Sprite;
	
	import com.panozona.player.module.Module;
	import com.panozona.modues.simplemodule.data.SimpleModuleData;
	
		
	/**
	 * This is simple module presenting structure of module ande its basic functionalities. 
	 * 
	 * @author mstandio
	 */
	public class SimpleModule extends Module{
		
		private const _moduleName:String = "SimpleModule";
		private const _moduleVersion:Number = 1.21;
		
		private var txt:TextField;
		private var btn1:Sprite;
		private var btn2:Sprite;
		
		
		public function SimpleModule() {
			super(_moduleName, _moduleVersion);
			aboutThisModule = "This is simple module"
			
			moduleDescription.addFunctionDescription("function0");
			
			moduleDescription.addFunctionDescription("function11", Boolean);
			moduleDescription.addFunctionDescription("function12", Number);
			moduleDescription.addFunctionDescription("function13", String);
			moduleDescription.addFunctionDescription("function14", Array);
			
			moduleDescription.addFunctionDescription("function21", Boolean, Number);
			moduleDescription.addFunctionDescription("function22", Number, String);			
			moduleDescription.addFunctionDescription("function23", String, Array);			
			moduleDescription.addFunctionDescription("function24", Array, Boolean);
			moduleDescription.addFunctionDescription("function25", Number, Array);
		}			
		
		public function function0():void {
			txt.text = "function 0";
		}
		
		public function function11(arg1:Boolean):void {		
			txt.text = "function 11"+arg1;
		}
		public function function12(arg1:Number):void {		
			txt.text = "function 12"+arg1;
		}
		public function function13(arg1:String):void {		
			txt.text = "function 13"+arg1;
		}
		public function function14(arg1:Array):void {		
			txt.text = "function 14"+arg1;
		}		
		public function function21(arg1:Boolean, arg2:Number):void {
			txt.text = "function 21"+ arg1 + arg2;
		}		
		public function function22(arg1:Number, arg2:String):void {
			txt.text = "function 22"+ arg1 + arg2;
		}
		
		public function function23(arg1:String, arg2:Array):void {
			txt.text = "function 23"+ arg1 + arg2;
		}
		
		public function function24(arg1:Array, arg2:Boolean):void {
			txt.text = "function 24"+ arg1 + arg2;
		}
		
		public function function25(arg1:Number, arg2:Array):void {
			txt.text = "function 25"+ arg1 + arg2;
		}				
		
		override protected function moduleReady():void {
			
			// tutaj trzeba odczytac ustawienia
			// ale gdzie je przechowywac 
			// moze lepiej miec je 
			// a co z subatrybutami ??? 
			// mamy je nadal czy nie ??? 
			
			// mozna jakies ogolne dotyczace samego polozenia 			
			
			var simpleModuleData:SimpleModuleData = new SimpleModuleData(moduleData);
						
			txt = new TextField();						
			txt.width = 200;
			txt.height = 200;						
			txt.background = true;
			txt.backgroundColor = 0x00ff00;			
			//txt.x = txt.y = 100;
			addChild(txt);
						
			
			btn1 = new Sprite();
			btn1.graphics.beginFill(0xff0000);
			btn1.graphics.drawRect(0, 0, 20, 20);
			btn1.graphics.endFill();
			addChild(btn1);
			btn1.x = 200;
			btn1.addEventListener(MouseEvent.CLICK, btn1c);
			
			btn2 = new Sprite();
			btn2.graphics.beginFill(0x0000ff);
			btn2.graphics.drawRect(0, 0, 20, 20);
			btn2.graphics.endFill();
			addChild(btn2);
			btn2.x = 255;
			btn2.addEventListener(MouseEvent.CLICK, btn2c);			
			
		}	
		
		private function btn1c(e:Event):void {
			txt.appendText("\nbtn2");			
			//function0();						
		}
		
		private function btn2c(e:Event):void {			
			txt.appendText("\nbtn2");
			//loadPanoramaById("pano2");
		}			
	}
}