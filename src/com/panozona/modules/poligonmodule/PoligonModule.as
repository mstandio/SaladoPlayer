package com.panozona.modules.poligonmodule{
	
	import com.panozona.modules.viewfinder.data.*;
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	import com.panozona.player.module.data.property.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	public class PoligonModule extends Module{
		
		private var btn:Sprite;
		
		public function PoligonModule(){
			super("PoligonModule", "0.0", "http://panozona.com/");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			buildModule();
		}
		
		private function buildModule():void {
			btn = new Sprite();
			btn.graphics.beginFill(0xff0000);
			btn.graphics.drawRect(0, 0, 20, 20);
			btn.graphics.endFill();
			btn.buttonMode = true;
			btn.x = 200; 
			btn.addEventListener(MouseEvent.CLICK, btnClick, false, 0 , true);
			addChild(btn);
		}
		
		private var counter:int = 0;
		
		private function btnClick(e:Event):void {
			for (var i:int = 0; i < 25; i++) {
				counter++;
				printInfo(""+counter);
			}
		}
	}
}