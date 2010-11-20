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
	
	import com.panozona.player.module.data.ModuleData;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.property.Move;
	import com.panozona.player.module.data.property.Align;
	
	import com.panozona.modules.examplemodule.data.*;
	
	import caurina.transitions.Tweener;
	
	/**
	 * This is example module presenting structure of module and its functionalities.
	 */
	public class ExampleModule extends Module{
		
		private var window:Sprite;
		private var btnClose:Sprite;
		
		private var txt:TextField;
		
		private var LoadPanoramaEventClass:Class;
		
		private var exampleModuleData:ExampleModuleData;
		
		// constructor should not contain anything more then showed below just for sake of clear code
		public function ExampleModule() {
			
			// mandatory name, version (max two digits after decimal point)
			// optional author, email and link to module details
			
			super("ExampleModule", 0.5, "Marek Standio", "mstandio@o2.pl", "http://panozona.com/wiki/Module:ExampleModule");
			
			aboutThisModule = "This is example module, it does nothing particular, it presents solution on " +
							  "how to build modules for SaladoPlayer. ExampleModule can cooperate with Navigation bar " +
							  "and it uses one of its extra buttons of given name."+
							  "<br/>Check out source code to see how it works.";
			
			// functions that are officially exposed, so that they can be validated 
			// (names and types of arguments) in configuration on startup
			// they can be used via xml: <action id="act1" content="ExampleModule.echoNothing();ExampleModule.echoString(Hello);"/>
			// and by other modules, for instace: 
			// executeModule("ExampleModule", "echoNothing", new Array());
			// executeModule("ExampleModule", "echoAll", new Array(true, 123, "hello"));
			moduleDescription.addFunctionDescription("toggleOpen");
			moduleDescription.addFunctionDescription("echoNothing");
			moduleDescription.addFunctionDescription("echoBoolean", Boolean);
			moduleDescription.addFunctionDescription("echoNumber", Number);
			moduleDescription.addFunctionDescription("echoString", String);
			moduleDescription.addFunctionDescription("echoAll", Boolean, Number, String);
		}
		
		// Entry point - module is added to stage 
		// moduleReady is surrounded with try/cacth 
		// in case of any error here, module will be cancelled 
		override protected function moduleReady(moduleData:ModuleData):void {
			
			// allways read data first 
			exampleModuleData = new ExampleModuleData(moduleData, debugMode); 
			
			// then get classes 
			LoadPanoramaEventClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.LoadPanoramaEvent") as Class;
			
			// then add listeners
			saladoPlayer.manager.addEventListener(LoadPanoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0 , true);
			saladoPlayer.manager.addEventListener(LoadPanoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0 , true);
			saladoPlayer.manager.addEventListener(LoadPanoramaEventClass.TRANSITION_ENDED, onTransitionEnded, false, 0 , true);
			
			// construct module
			window = new Sprite();
			addChild(window);
			
			btnClose = new Sprite();
			btnClose.graphics.beginFill(0xff0000);
			btnClose.graphics.drawRect(0, 0, 20, 20);
			btnClose.graphics.endFill();
			btnClose.buttonMode = true;
			btnClose.addEventListener(MouseEvent.CLICK, btnCloseClick, false, 0 , true);
			btnClose.x = 200; 
			window.addChild(btnClose);
			
			txt = new TextField();
			txt.background = true;
			txt.multiline = true;
			txt.width = 200;
			txt.height = 300;
			window.addChild(txt);
			
			txt.htmlText = printSettings();
			
			stage.addEventListener(Event.RESIZE, handleStageResize, false, 0, true); 
			handleStageResize();
		}
		
		// first panorama started loading, so all modules are loaded and added to scene
		// now you can try to access them to call specyfic functions
		// each module must be ready to execute exposed functions after first panorama started loading 
		private function onPanoramaStartedLoading(loadPanoramaEvent:Object):void {
			
			saladoPlayer.manager.removeEventListener(LoadPanoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading);
			
			if (!exampleModuleData.settings.open) {
				this.alpha = 0;
				this.visible = false;
			}
			
			if (exampleModuleData.settings.open) {
				saladoPlayer.manager.runAction(exampleModuleData.settings.onOpen);
			}else {
				saladoPlayer.manager.runAction(exampleModuleData.settings.onClose);
			}
			
			// or you could use something like this instead, but you are hard coding module dependency this way 
			// saladoPlayer.getModuleByName("NavigationBar").execute("setExtraButtonActive", new Array(exampleModuleData.settings.extraButtonName, this.visible));
			
			//printInfo("Started loading: " + loadPanoramaEvent.panoramaData.id);
		}
		
		// loaded panorama, before transition start
		private function onPanoramaLoaded(loadPanoramaEvent:Object):void {
			//printInfo("Done loading: " + loadPanoramaEvent.panoramaData.id);
		}
		
		// panorama was loaded, and transition is finished 
		private function onTransitionEnded(loadPanoramaEvent:Object):void {
			//printInfo("Transition ended: " + loadPanoramaEvent.panoramaData.id);
		}
		
		// you shuold use bounds size and not stage.stageHeight and stage.stageWidth
		// when Saladolayer is embeded into other application
		// elements will remain inside panorama window
		private function handleStageResize(e:Event = null):void {
			
			if (exampleModuleData.settings.align.horizontal == Align.LEFT) {
				window.x = 0;
			}else if (exampleModuleData.settings.align.horizontal == Align.RIGHT) {
				window.x = boundsWidth - window.width;
			}else if (exampleModuleData.settings.align.horizontal == Align.CENTER) {
				window.x = (boundsWidth - window.width) * 0.5;
			}
			
			if (exampleModuleData.settings.align.vertical == Align.TOP) {
				window.y = 0;
			}else if (exampleModuleData.settings.align.vertical == Align.MIDDLE) {
				window.y = (boundsHeight - window.height) * 0.5;
			}else if (exampleModuleData.settings.align.vertical == Align.BOTTOM) {
				window.y = boundsHeight - window.height;
			}
			
			window.x += exampleModuleData.settings.move.horizontal;
			window.y += exampleModuleData.settings.move.vertical;
		}
		
		private function btnCloseClick(e:Event):void {
			toggleOpen();
		}
		
		// here is how to gain access to parsed settings
		// settings can be nested in any number of levels
		// every node can have attributes of type: Boolean, Number, String
		// node can also have sub-attributes of type: Boolean, Number, String (see)
		private function printSettings():String {
			var result:String = "";
			result += "parent info: "+exampleModuleData.someParent.info.stringSubValue +
			", " +exampleModuleData.someParent.info.numberSubValue + 
			", " +exampleModuleData.someParent.info.booleanSubValue; 
			result += "<br>children: ";
			for each (var someChild:SomeChild in exampleModuleData.someParent.getChildrenOfGivenClass(SomeChild)) {
				result += "<br>  child is happy: "+someChild.happy;
				for each(var someToy:SomeToy in someChild.getChildrenOfGivenClass(SomeToy)) {
					result += "<br>    toy name: "+someToy.name;
					result += "<br>    toy price: "+someToy.price;
				}
			}
			result += "<br>jobs: ";
			for each (var someJob:SomeJob in exampleModuleData.someParent.getChildrenOfGivenClass(SomeJob)) {
				result += "<br>  wages: "+someJob.wages;
				result += "<br>  text: "+someJob.text;
			}
			return result;
		}
		
		// interacting with PanoSalado: you have access to pretty much everything
		// but you should not import any classes outside classpath com.panozona.player.module
		// everything should be threated as object and surrounded with try/catch
		// in case of any changes within those classes
		private function swingToChild(e:Event):void {
			try {
				saladoPlayer.manager.swingToChild(saladoPlayer.manager._getChildByName("hs1",true));
			}catch (error:Error) {
				printError(error.message);
			}
		}
		
		private function onClosingFinish():void {
			this.visible = false;
			
			saladoPlayer.manager.runAction(exampleModuleData.settings.onClose);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function toggleOpen():void {
			
			if (exampleModuleData.settings.open) {
				exampleModuleData.settings.open = false;
				Tweener.addTween(this, {alpha:0, transition:exampleModuleData.settings.tween.transition, time:exampleModuleData.settings.tween.time, onComplete:onClosingFinish});
			}else {
				exampleModuleData.settings.open = true;
				this.visible = true;
				Tweener.addTween(this, { alpha:1, transition:exampleModuleData.settings.tween.transition, time:exampleModuleData.settings.tween.time } );
				
				saladoPlayer.manager.runAction(exampleModuleData.settings.onOpen);
			}
		}
		
		public function echoNothing():void {
			printInfo("echoNothing!");
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
		public function echoAll(arg1:Boolean, arg2:Number, arg3:String):void {
			printInfo("echoAll: "+arg1+" "+arg2+" "+arg3);
		}
	}
}