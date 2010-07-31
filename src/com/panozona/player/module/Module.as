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
package com.panozona.player.module{
		
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;	
	
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.ModuleNode;
	import com.panozona.player.module.data.ModuleDescription;	
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class Module extends Sprite  {
					
		protected var aboutThisModule:String; 
		
		protected var _moduleData:ModuleData;
		protected var _moduleDescription:ModuleDescription;		
		
		private var SaladoPlayerClass:Class;
		private var saladoPlayer:Object;
		
		private var TraceClass:Class;
		private var tracer:Object;
		
				
		public final function Module(moduleName:String, version:Number) {						
			aboutThisModule = "This is module part of SaladoPlayer, visit panozona.com for more information";
			_moduleDescription = new ModuleDescription(moduleName, version);
			addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}		
		
		private final function stageReady(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			try {
				
				SaladoPlayerClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.SaladoPlayer") as Class;
				saladoPlayer = SaladoPlayerClass(this.root.parent);												
				
				TraceClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.utils.Trace") as Class;
				tracer = TraceClass(saladoPlayer.tracer);				
				
				_moduleData = new ModuleData(saladoPlayer.managerData.getAbstractModuleDataByName(_moduleDescription.moduleName));		
				
				try {
					moduleReady();
				}catch(error:Error){
					printError(error.message);
				}				
				
			}catch (error:Error) {
				
				while (this.numChildren > 0) {
					removeChildAt(0);
				}
				var moduleInfoFormat:TextFormat = new TextFormat(); // TODO: add clickable buttons for urls ect 
				moduleInfoFormat.blockIndent = 0;
				moduleInfoFormat.font = "Courier";
				moduleInfoFormat.color = 0xffffff;
				moduleInfoFormat.leftMargin = 10;
			
				var moduleInfo:TextField = new TextField();
				moduleInfo.defaultTextFormat = moduleInfoFormat;
				moduleInfo.background = true;
				moduleInfo.backgroundColor = 0x000000;
				moduleInfo.wordWrap = true;
				moduleInfo.multiline = true;
				moduleInfo.width  = 500;
				moduleInfo.height = 300;
				moduleInfo.x = (stage.stageWidth - moduleInfo.width) * 0.5;
				moduleInfo.y = (stage.stageHeight - moduleInfo.height) * 0.5;
				moduleInfo.text = "\n" + aboutThisModule + "\n\n" + moduleDescription.printDescription();
				addChild(moduleInfo);
				
				moduleInfo.appendText(error.message + "\n" + error.getStackTrace()); //TODO: mak it show on button click some scrolling, perhaps
			}
		}
		
		protected function moduleReady():void {			
			throw new Error("Function moduleReady() must be overrided by module");
		}				
		
		public final function get moduleDescription():ModuleDescription {
			return _moduleDescription;
		}
		
		protected final function get moduleData():ModuleData {
			return _moduleData;
		}
		
		public final function execute(functionName:String, ... args):*{
			return (this[functionName] as Function).apply(this, args);
		}	
		
		protected function printError(msg:String):void {
			if(tracer != null){
				tracer.printError(msg);
			}
		}
		
		protected function printWarning(msg:String):void {
			if(tracer != null){
				tracer.printWarning(msg);
			}
		}
		
		protected function printInfo(msg:String):void {
			if(tracer != null){
				tracer.printInfo(msg);
			}
		}					
		
		// ect ect 
		
		protected final function loadPanoramaById(panoramaId:String):void {			
			saladoPlayer.manager.loadPanoramaById(panoramaId);			
		}				
			
		protected final function _getChildAt(index:int, managed:Boolean):DisplayObject {			
			
		}
 	 	
		protected final function _getChildByName(name:String, managed:Boolean):DisplayObject{
		}
		
		protected final function _removeChildAt(index:int, managed:Boolean):DisplayObject {
			
		}

 	 	protected final function _swapChildrenAt(index1:int, index2:int, managed:Boolean):void {
			
		}

		protected final function addChild(child:DisplayObject):DisplayObject {
			
		}
	
		protected final function addChildAt(child:DisplayObject, index:int):DisplayObject{
			
		}
		
		protected final function clone(into:ViewData = null):ViewData {
			
		}

 	 	
		protected final function  contains(child:DisplayObject):Boolean {
			
		}
	 	
		protected final function  getChildIndex(child:DisplayObject):int {
	
		}
		
		protected final function  initialize(dependencies:Array):void { // nie
			
		}
 	 	
		protected final function  processDependency(reference:Object, characteristics:*):void {
			
		}
	
		protected final function  removeChild(child:DisplayObject):DisplayObject {
			
		}
		
		protected final function  render(event:Event = null, viewData:ViewData = null):void {
			
		}
		
		protected final function  renderAt(pan:Number, tilt:Number, fieldOfView:Number):void {
			
		}
 	 	
		protected final function  setChildIndex(child:DisplayObject, index:int):void {
			
		}
		
		protected final function  startInertialSwing(panSpeed:Number, tiltSpeed:Number, sensitivity:Number = 0.0003, friction:Number = 0.3, threshold:Number = 0.0001):void {
			
		}

		
		protected final function  stopInertialSwing():void {
			
		}

		protected final function  swapChildren(child1:DisplayObject, child2:DisplayObject):void {
			
		}
		
		protected final function  swingTo(pan:Number, tilt:Number, fieldOfView:Number, time:Number = 2.5, tween:Function = null):void {
			
		}
		
		protected final function  swingToChild(child:ManagedChild, fieldOfView:Number, time:Number = 2.5, tween:Function = null):void {
			
		}	
		
		
		protected function panoramaLoading():void {
			
		}
		
		protected function panoramaLoaded():void {
			
		}	
		
		protected function modulesLoaded():void {
			
		}
		
		protected function loadSettings():void { // it takes module description as argument			
			
		}				
	}
}