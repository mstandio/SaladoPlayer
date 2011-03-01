/*
Copyright 2011 Marek Standio.

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
along with SaladoPlayer. If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.modules.examplemodule {
	
	import caurina.transitions.Tweener;
	import com.robertpenner.easing.*;
	import com.panozona.modules.examplemodule.data.*;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.Module;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	
	/**
	 * This is simple module that shows basics of creating SaladoPlayer Module. 
	 * 
	 * It serves as example of creating complex module configuration structure.
	 * in ExampleModule <module/> node contains many direct child nodes (<settings/>
	 * and <someParent/>). Node <settings/> cannot have child nodes, while node
	 * <someParent/> is parent of many leveled tree structure. For Example:
	 * 
	 * <module name="ExampleModule">
	 *   <settings/>
	 *   <someParent>
	 *     <someChild/>
	 *     <someChild>
	 *       <someToy/>
	 *       <someToy/>
	 *     </someChild>
	 *     <someJob/>
	 *     <someJob/>
	 *   </someParent>
	 * </module>
	 * 
	 * Each node can contain attributes of some specific types. Data from xml is obtained 
	 * by SaladoPlayer, and converted to ModuleNode tree. This tree can be easily converted 
	 * into internal module data structure. Module can also provide data validation.
	 * For details see comments in com.panozona.modules.examplemodule.data.* classes
	 * For Example:
	 * 
	 * <module name="ExampleModule">
	 *   <settings open="true" align="vertical:top,horizontal:middle"/>
	 *   <someParent info="num:-12.12,str:hello"/>
	 *     <someChild happy="false">
	 *       <someToy name="car" price="12.99"/>
	 *     </someChild>
	 *     <someJob wages="99">
	 *       <![CDATA[some job description]]>
	 *     </someJob>
	 *   </someParent>
	 * </module>
	 */
	public class ExampleModule extends Module{
		
		private var window:Sprite;
		private var btnClose:Sprite;
		private var textField:TextField;
		
		private var panoramaEventClass:Class;
		
		private var exampleModuleData:ExampleModuleData;
		
		/**
		 * Constructor sets moduleDescription. When Module is loaded, and before Module is added to stage
		 * SaladoPlayer tries accessing variable moduleDescription as com.panoznana.module.utils.ModuleDescription 
		 * class. Description is required to determine what functions of what names and of what arguments quantity 
		 * and type can be called on given module. Description is also used to print simple Module info.
		 * Description is also used in process of validating actions. For Example:
		 * 
		 * <actions>
		 *  <action id="act1" content="ExampleModule.toggleOpen()"/>
		 *  <action id="act1" content="ExampleModule.echoNothing()"/>
		 *  <action id="act1" content="ExampleModule.echoBoolean(true);ExampleModule.echoNumber(-12.12)"/>
		 *  <action id="act1" content="ExampleModule.echoAll(true,-12.12,hello_world)"/>
		 * </actions>
		 */
		public function ExampleModule() {
			super("ExampleModule", "1.0", "http://panozona.com/wiki/Module:ExampleModule");
			
			moduleDescription.addFunctionDescription("toggleOpen");
			moduleDescription.addFunctionDescription("setOpen", Boolean);
			moduleDescription.addFunctionDescription("echoBoolean", Boolean);
			moduleDescription.addFunctionDescription("echoNumber", Number);
			moduleDescription.addFunctionDescription("echoString", String);
			moduleDescription.addFunctionDescription("echoAll", Boolean, Number, String);
		}
		
		/**
		 * Entry point - module is added to stage saladoPlayer reference is set. 
		 * moduleReady is surrounded with try/cacth in case of any error here, 
		 * module will be removed. ModuleData object contains ModuleNode tree 
		 * with module configuration obtained by SaladoPlayer. 
		 * 
		 * @param	moduleData
		 */
		override protected function moduleReady(moduleData:ModuleData):void {
			
			exampleModuleData = new ExampleModuleData(moduleData, saladoPlayer); // allways read data first 
			
			panoramaEventClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			
			// add listeners 
			saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onFirstPanoramaStartedLoading, false, 0 , true);
			saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0 , true);
			saladoPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0 , true);
			saladoPlayer.manager.addEventListener(panoramaEventClass.TRANSITION_ENDED, onTransitionEnded, false, 0 , true);
			
			buildModule();
			
			stage.addEventListener(Event.RESIZE, handleStageResize, false, 0, true); 
			handleStageResize();
		}
		
		private function buildModule():void {
			btnClose = new Sprite();
			btnClose.graphics.beginFill(0xff0000);
			btnClose.graphics.drawRect(0, 0, 20, 20);
			btnClose.graphics.endFill();
			btnClose.buttonMode = true;
			btnClose.x = 200; 
			btnClose.addEventListener(MouseEvent.CLICK, btnCloseClick, false, 0 , true);
			
			textField = new TextField();
			textField.background = true;
			textField.multiline = true;
			textField.width = 200;
			textField.height = 300;
			
			window = new Sprite();
			addChild(window);
			window.addChild(btnClose);
			window.addChild(textField);
			
			textField.htmlText = printSettings();
		}
		
		private function btnCloseClick(e:Event):void {
			toggleOpen();
		}
		
		/**
		 * First panorama started loading, so all modules are loaded and added to stage
		 * now you can call other modules either directly or by executing proper actions
		 * each module must be ready to execute exposed functions after first panorama started loading;
		 */
		private function onFirstPanoramaStartedLoading(e:Event):void {
			saladoPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onFirstPanoramaStartedLoading);
			if (!exampleModuleData.settings.open) {
				this.alpha = 0;
				this.visible = false;
			}
			if (exampleModuleData.settings.open) {
				saladoPlayer.manager.runAction(exampleModuleData.settings.onOpen);
			}else {
				saladoPlayer.manager.runAction(exampleModuleData.settings.onClose);
			}
		}
		
		/**
		 * If this is not first panorama, this event is dispatched whenever 
		 * user is leaving to other panorama.
		 */
		private function onPanoramaStartedLoading(e:Event):void {
			printInfo("Started loading: " + saladoPlayer.manager.currentPanoramaData.id);
		}
		
		/**
		 * At this point new panorama is loaded, old panorama is removed
		 * but transition effect (if there is any) has not finished yet.
		 */
		private function onPanoramaLoaded(e:Event):void {
			printInfo("Done loading: " + saladoPlayer.manager.currentPanoramaData.id);
		}
		
		/**
		 * panorama was loaded, and transition effect has finished 
		 * This can be considered entry point in new panorama.
		 */
		private function onTransitionEnded(e:Event):void {
			printInfo("Transition ended: " + saladoPlayer.manager.currentPanoramaData.id);
		}
		
		/**
		 * One shuold use bounds size and not stage.stageHeight and stage.stageWidth
		 * when Saladolayer is embeded into other application, module will remain 
		 * inside panorama window. 
		 */
		private function handleStageResize(e:Event = null):void {
			if (exampleModuleData.settings.align.horizontal == Align.LEFT) {
				window.x = 0;
			}else if (exampleModuleData.settings.align.horizontal == Align.RIGHT) {
				window.x = saladoPlayer.manager.boundsWidth - window.width;
			}else if (exampleModuleData.settings.align.horizontal == Align.CENTER) {
				window.x = (saladoPlayer.manager.boundsWidth - window.width) * 0.5;
			}
			if (exampleModuleData.settings.align.vertical == Align.TOP) {
				window.y = 0;
			}else if (exampleModuleData.settings.align.vertical == Align.MIDDLE) {
				window.y = (saladoPlayer.manager.boundsHeight - window.height) * 0.5;
			}else if (exampleModuleData.settings.align.vertical == Align.BOTTOM) {
				window.y = saladoPlayer.manager.boundsHeight - window.height;
			}
			window.x += exampleModuleData.settings.move.horizontal;
			window.y += exampleModuleData.settings.move.vertical;
		}
		
		/**
		 * Example of how to gain access to settings
		 */
		private function printSettings():String {
			var result:String = "";
			result += "parent info: "+exampleModuleData.someParent.info.str +
				", " + exampleModuleData.someParent.info.num + 
				", " + exampleModuleData.someParent.info.bool;
			result += "<br>children: ";
			for each (var someChild:SomeChild in exampleModuleData.someParent.getChildrenOfGivenClass(SomeChild)) {
				result += "<br>  child is happy: " + someChild.happy;
				for each(var someToy:SomeToy in someChild.getChildrenOfGivenClass(SomeToy)) {
					result += "<br>    toy name: " + someToy.name;
					result += "<br>    toy price: " + someToy.price;
				}
			}
			result += "<br>jobs: ";
			for each (var someJob:SomeJob in exampleModuleData.someParent.getChildrenOfGivenClass(SomeJob)) {
				result += "<br>  wages: " + someJob.wages;
				result += "<br>  text: " + someJob.text;
			}
			return result;
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
		
		public function setOpen(value:Boolean):void {
			if (exampleModuleData.settings.open != value) {
				toggleOpen();
			}
		}
		
		public function echoBoolean(arg1:Boolean):void {
			printInfo("echoBoolean: " + arg1);
		}
		public function echoNumber(arg1:Number):void {
			printInfo("echoNumber: " + arg1);
		}
		public function echoString(arg1:String):void {
			printInfo("echoString: " + arg1);
		}
		public function echoAll(arg1:Boolean, arg2:Number, arg3:String):void {
			printInfo("echoAll: " + arg1 + " " + arg2 + " " + arg3);
		}
	}
}