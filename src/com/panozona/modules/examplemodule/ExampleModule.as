/*
Copyright 2010 Marek Standio.

This file is part of SaladoPlayer.

SaladoPlayer is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published 
by the Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.

SaladoPlayer is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty 
of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with SaladoPlayer.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.modules.examplemodule {

	import com.panozona.modules.examplemodule.data.SomeChildData;
	import com.panozona.modules.examplemodule.data.SomeGrandchildData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.Sprite;
	
	import com.panozona.player.module.Module;
	import com.panozona.modules.examplemodule.data.ExampleModuleData;	
	import com.panozona.modules.examplemodule.labelledbutton.LabelledButton;
		
	/**
	 * This is example module presenting structure of module ande its basic functionalities. 
	 * 
	 * @author mstandio
	 */
	public class ExampleModule extends Module{		
				
		private var btn1:LabelledButton;
		private var btn2:LabelledButton;		
		private var btn3:LabelledButton;		
		private var btn4:LabelledButton;		
		private var btn5:LabelledButton;		
		private var btn6:LabelledButton;
		
		private var btnBar:Sprite;
		
		private var exampleModuleData:ExampleModuleData;
		
		// constructor should not contain anything more
		public function ExampleModule() {
			
			// name, version (max two digits after decimal point) and optional link to module details
			super("ExampleModule", 0.1, "http://panozona.com/wiki/ExampleModule");			
			
			aboutThisModule = "This is example module, <br>it demonstrates features avaible for developers";
						
			// functions that are officially exposed, 
			// so that they can be validated (names and types of arguments) in configuration on startup
			moduleDescription.addFunctionDescription("echoNothing");			
			moduleDescription.addFunctionDescription("echoBoolean", Boolean);
			moduleDescription.addFunctionDescription("echoNumber", Number);
			moduleDescription.addFunctionDescription("echoString", String);
			moduleDescription.addFunctionDescription("echoArray", Array);			
			moduleDescription.addFunctionDescription("echoAll", Boolean, Number, String, Array);			
		}					
		
		// if public functions take arguments in Boolean String Number or Array of Strings
		// than they can be called via actions 
		// <action id="act1" content="ExampleModule.echoNothing(), ExampleModule.echoArray([str1, str2])">
		// also, all public functions can be called by other modules
		
		public function echoNothing():void {
			printInfo("echoNothing: ");
		}		
		public function echoBoolean(arg1:Boolean):void {		
			printInfo("echoBoolean: "+arg1);
		}
		public function echoNumber(arg1:Number):void {		
			printInfo("echoNumber: "+arg1);
		}
		public function echoString(arg1:String):void {		
			printInfo("echoString: "+arg1);
		}
		public function echoArray(arg1:Array):void {		
			printInfo("echoArray: "+arg1+" length :"+arg1.length);
		}		
		public function echoAll(arg1:Boolean, arg2:Number, arg3:String, arg4:Array):void {
			printInfo("echoAll: "+arg1+" "+arg2+" "+arg3+" "+arg4);
		}						
		
		// entry point 
		override protected function moduleReady():void {
			
			try {
				exampleModuleData = new ExampleModuleData(moduleData);				
			}catch (error:Error) {
				printError(error.message);
			}
			
			btnBar = new Sprite();
			addChild(btnBar);						
			
			btn1 = new LabelledButton("-=# ExampleModule #=-");
			btn1.useHandCursor = false;			
			btnBar.addChild(btn1)
			
			btn2 = new LabelledButton("print settings");
			btn2.addEventListener(MouseEvent.CLICK, btn2click, false, 0 , true);
			btnBar.addChild(btn2)
			
			btn3 = new LabelledButton("print children");
			btn3.addEventListener(MouseEvent.CLICK, btn3click, false, 0 , true);
			btnBar.addChild(btn3)
			
			btn4 = new LabelledButton("swing to child hs1");
			btn4.addEventListener(MouseEvent.CLICK, btn4click, false, 0 , true);
			btnBar.addChild(btn4)
						
			btn5 = new LabelledButton("show NavigationBar");
			btn5.addEventListener(MouseEvent.CLICK, btn5click, false, 0 , true);
			btnBar.addChild(btn5)		
			
			btn6 = new LabelledButton("hide NavigationBar");
			btn6.addEventListener(MouseEvent.CLICK, btn6click, false, 0 , true);
			btnBar.addChild(btn6);
			
			btn1.y = 0;
			btn2.y = btn1.y + btn1.height + 10;
			btn3.y = btn2.y + btn2.height + 10;
			btn4.y = btn3.y + btn3.height + 10;
			btn5.y = btn4.y + btn4.height + 10;
			btn6.y = btn5.y + btn5.height + 10;			
			
			btnBar.graphics.beginFill(0xffffff);
			btnBar.graphics.drawRect(0, 0, btnBar.width, btnBar.height);
			btnBar.graphics.endFill();
			
			stage.addEventListener(Event.RESIZE, handleStageResize, false, 0, true); 			
			handleStageResize();
		}			
		
		
		private function btn2click(e:Event):void {
			printInfo(
				"<br>numberValue: " + exampleModuleData.settings.numberValue + 
				"<br>booleanValue: " + exampleModuleData.settings.booleanValue + 
				"<br>stringValue: " + exampleModuleData.settings.stringValue + 
				"<br>arrayValue: " + exampleModuleData.settings.arrayValue +
				"<br>arrayValue length: "  +exampleModuleData.settings.arrayValue.length
			);
		}
		
		private function btn3click(e:Event):void {
			var result:String="";			
			for each (var someChildData:SomeChildData in exampleModuleData.someChildrenData) {
				result += "<br>child id: "+someChildData.id;
				for each(var someGrandchildData:SomeGrandchildData in someChildData.someGrandchildren) {
					result += "<br> grandchild name: " + someGrandchildData.name;
					result += "<br>  isMale: " + someGrandchildData.isMale;
					result += "<br>  age: " + someGrandchildData.age;
					result += "<br>  pets: " + someGrandchildData.pets;
					result += "<br>  pets length: " + someGrandchildData.pets.length;
				}				
			}			
			printInfo(result);
		}
		
		// interacting with PanoSalado 
		
		private function btn4click(e:Event):void {
			try {
				saladoPlayer.manager.swingToChild(saladoPlayer.manager._getChildByName("hs1",true));			
			}catch (error:Error) {
				printError(error.message);
			}			
		}
		
		// interacting with other modules 
		
		private function btn5click(e:Event):void {			
			try{
				executeModule("NavigationBar", "setVisible", new Array(true));
			}catch (error:Error) {
				printError(error.message);
			}		
		}
		
		private function btn6click(e:Event):void {		
			try{
				executeModule("NavigationBar", "setVisible", new Array(false));
			}catch (error:Error) {
				printError(error.message);
			}		
		}		
		
		// using loading events		
		
		override protected function onPanoramaStartedLoading(loadPanoramaEvent:Object):void {
			printInfo("Started loading: " + loadPanoramaEvent.panoramaData.id);
		}
		
		
		override protected function onPanoramaLoaded(loadPanoramaEvent:Object):void {			
			printInfo("Done loading: " + loadPanoramaEvent.panoramaData.id);
		}
		
		
		override protected function onTransitionEnded(loadPanoramaEvent:Object):void {
			printInfo("Trsnsition ended: " + loadPanoramaEvent.panoramaData.id);
		}		
		
		// override me
		//protected function onCameraMove(cameraMoveEvent:Object):void {
			// see ViewFinder module
		//}
		
		private function handleStageResize(e:Event = null):void {					
			btnBar.x = 0; 
			btnBar.y = (stage.stageHeight - btnBar.height) * 0.5;
		}		
	}
}