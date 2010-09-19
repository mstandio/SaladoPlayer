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
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	
	import com.panozona.modules.examplemodule.data.*;
	
	import com.panozona.player.module.Module;
	import com.panozona.modules.examplemodule.data.ExampleModuleData;
	import com.panozona.modules.examplemodule.labelledbutton.LabelledButton;
	
	/**
	 * This is example module presenting structure of module ande its basic functionalities. 
	 * 
	 * @author mstandio
	 */
	public class ExampleModule extends Module{
		
		private var btnTitle:LabelledButton;
		private var btnClose:LabelledButton;
		private var window:Sprite;
		private var foundNavigationBar:Boolean;
		
		private var txt:TextField;
		
		private var exampleModuleData:ExampleModuleData;
		
		private var LoadPanoramaEventClass:Class;
		
		// constructor should not contain 
		// anything more then showed below
		// just for sake of clear code
		public function ExampleModule() {
			
			// mandatory name, version (max two digits after dot) and optional author and link to module details
			
			super("ExampleModule", 0.2, "Marek Standio", "http://panozona.com/wiki/Module:ExampleModule");
			
			aboutThisModule = "This is example module, it does nothing particular, it presents solutions on " +
							  "how to build modules for Saladolayer."
							  "ExampleModule can cooperate with Navigation bar, and it uses one of his bonus buttons. ";
							  "<br/>Check out source code to see how it works.";
			
			// functions that are officially exposed, so that they can be validated 
			// (names and types of arguments) in configuration on startup
			// they can be used via xml: <action id="act1" content="ExampleModule.echoNothing();ExampleModule.echoString(Hello there);"/>
			// and by other modules through executeModule: executeModule("ExampleModule", "echoNothing", new Array());
			moduleDescription.addFunctionDescription("toggleVisibility");
			moduleDescription.addFunctionDescription("echoNothing");
			moduleDescription.addFunctionDescription("echoBoolean", Boolean);
			moduleDescription.addFunctionDescription("echoNumber", Number);
			moduleDescription.addFunctionDescription("echoString", String);
			moduleDescription.addFunctionDescription("echoAll", Boolean, Number, String);
		}
		
		// Entry point - module is added to stage 
		// moduleReady is surrounded with try/cacth 
		// in case of any error here, module will be cancelled 
		override protected function moduleReady():void {
			
			// allways read data first 
			exampleModuleData = new ExampleModuleData(moduleData,debugging); 
			
			// then get classes 
			LoadPanoramaEventClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.LoadPanoramaEvent") as Class;			
			
			// then add listeners
			saladoPlayer.manager.addEventListener(LoadPanoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0 , true);
			saladoPlayer.manager.addEventListener(LoadPanoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0 , true);
			saladoPlayer.manager.addEventListener(LoadPanoramaEventClass.TRANSITION_ENDED, onTransitionEnded, false, 0 , true);
			
			// construct module
			window = new Sprite();
			addChild(window);
			
			btnTitle = new LabelledButton("-=# ExampleModule #=-");
			btnTitle.useHandCursor = false;
			window.addChild(btnTitle)
			
			btnClose = new LabelledButton("[x]");
			btnClose.addEventListener(MouseEvent.CLICK, btnCloseClick, false, 0 , true);
			btnClose.x = window.width + 10;
			window.addChild(btnClose);
			
			txt = new TextField();
			txt.background = true;
			txt.multiline = true;
			txt.width = btnTitle.width;
			txt.height = btnTitle.width* 1.5;
			txt.y = btnTitle.height + 10;
			window.addChild(txt);
			
			stage.addEventListener(Event.RESIZE, handleStageResize, false, 0, true); 
			handleStageResize();
		}
		
		// first panorama stared loading, so all modules are loaded and added to scene
		// now you can try to access them to call specyfic functions
		// each module must be ready to execute exposed functions after first panorama started loading 
		// you should not rely on transition end, trnsitions can be disabled.
		private function onPanoramaStartedLoading(loadPanoramaEvent:Object):void {
			saladoPlayer.manager.removeEventListener(LoadPanoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading);
			foundNavigationBar = moduleExists("NavigationBar");
			if (exampleModuleData.settings.navigationBarButton != null && foundNavigationBar){
				this.visible = exampleModuleData.settings.initialVisibility;
				executeModule("NavigationBar", "changeButton", new Array(exampleModuleData.settings.navigationBarButton, this.visible));
			}
			
			txt.htmlText = printSettings();
			
			//printInfo("Started loading: " + loadPanoramaEvent.panoramaData.id);
		}
		
		// 
		private function onPanoramaLoaded(loadPanoramaEvent:Object):void {
			//printInfo("Done loading: " + loadPanoramaEvent.panoramaData.id);
		}
		
		// panorama was loaded, and transition is finished 
		// i do not recommand relying in this, transition can be disabled
		// you can check if it is enabled by saladoPlayer.managerData.simpleTransitionData.enabled
		private function onTransitionEnded(loadPanoramaEvent:Object):void {
			//printInfo("Transition ended: " + loadPanoramaEvent.panoramaData.id);
		}

		// you shuold use bounds size and not stage.stageHeight and stage.stageWidth
		// when Saladolayer is embeded into other application
		// elements will remain inside its window
		private function handleStageResize(e:Event = null):void {
			window.x = 0; 
			window.y = (saladoPlayer.manager._boundsHeight - window.height) * 0.5;
		}
		
		private function btnCloseClick(e:Event):void {
			toggleVisibility();
		}
		
		// here is how to gain access to parsed settings
		// settings can be nested in any number of levels
		// every node can have attributes of type: Boolean, Number, String
		// node can also have sub-attributes of type: Boolean, Number, String (see)
		private function printSettings():String {
			var result:String = "";
			result += "info: " + exampleModuleData.someParent.info.stringSubValue +
			", " +exampleModuleData.someParent.info.numberSubValue + 
			", " +exampleModuleData.someParent.info.booleanSubValue; 
			for each (var someChild:SomeChild in exampleModuleData.someParent.getChildren()) {
				result += "<br>child id: "+someChild.id;
				for each(var someGrandchild:SomeGrandchild in someChild.getChildren()) {
					result += "<br> grandchild name: " + someGrandchild.name;
					result += "<br>  isMale: " + someGrandchild.isMale;
					result += "<br>  age: " + someGrandchild.age;
				}
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
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////	
		
		public function toggleVisibility():void {
			this.visible = !this.visible;
			if (foundNavigationBar) {
				try{
					executeModule("NavigationBar", "changeButton", new Array(exampleModuleData.settings.navigationBarButton, this.visible));
				}catch (error:Error){
					printError("NavigationBar is not compatible: " + error.message);
				}
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