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

You should have received a copy of the GNU General Public Licensep
along with SaladoPlayer.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.player.module{
		
	
	import flash.display.DisplayObject; import flash.display.StageDisplayState;
	import flash.events.Event;	
	import flash.events.KeyboardEvent;
	import flash.display.Sprite;	
	import flash.system.ApplicationDomain;	
	
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.ModuleNode;
	import com.panozona.player.module.data.ModuleDescription;	
	
	import com.panozona.player.module.utils.ModuleInfoPrinter;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class Module extends Sprite  {
					
		protected var aboutThisModule:String; 
		
		protected var _moduleData:ModuleData;
		protected var _moduleDescription:ModuleDescription;		
		
		protected var SaladoPlayerClass:Class;
		protected var saladoPlayer:Object;
		
		private var LoadPanoramaEventClass:Class;
		private var CameraMoveEventClass:Class;
		private var CameraKeyBindingsClass:Class;
		private var AutorotationEventClass:Class;
		
		private var TraceClass:Class;
		private var tracer:Object;				
				
		public final function Module(moduleName:String, moduleVersion:Number, moduleHomeUrl:String = null) {			
			_moduleDescription = new ModuleDescription(moduleName, moduleVersion, moduleHomeUrl);			
			
			// default information
			aboutThisModule = "This is module part of SaladoPlayer";
			
			addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}		
		
		private final function stageReady(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			try {
				
				SaladoPlayerClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.SaladoPlayer") as Class;
				saladoPlayer = this.parent as SaladoPlayerClass;
				
				TraceClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.utils.Trace") as Class;
				tracer = saladoPlayer.tracer as TraceClass;
				
				LoadPanoramaEventClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.LoadPanoramaEvent") as Class;
				
				CameraMoveEventClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.CameraMoveEvent") as Class;
				
				AutorotationEventClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.AutorotationEvent") as Class;
				
				CameraKeyBindingsClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.model.CameraKeyBindings") as Class;				
				
				_moduleData = new ModuleData(saladoPlayer.managerData.getAbstractModuleDataByName(_moduleDescription.moduleName));		
				
				saladoPlayer.manager.addEventListener(LoadPanoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0 , true);
				saladoPlayer.manager.addEventListener(LoadPanoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0 , true);
				saladoPlayer.manager.addEventListener(LoadPanoramaEventClass.TRANSITION_ENDED, onTransitionEnded, false, 0 , true);
				
				try {
					moduleReady();
				}catch (error:Error) {
					while(numChildren) {
						removeChildAt(0);
					}					
					printError(error.message);					
				}				
				
			}catch (error:Error){
				addChild(new ModuleInfoPrinter(_moduleDescription, aboutThisModule, error));
			}
		}	
				
		protected final function cameraMotionTracking(enabled:Boolean):void {
			if (enabled) {
				saladoPlayer.manager.addEventListener(CameraMoveEventClass.CAMERA_MOVE, onCameraMove, false, 0 , true);
			}else {
				saladoPlayer.manager.removeEventListener(CameraMoveEventClass.CAMERA_MOVE, onCameraMove);
			}	
		}		
		
		protected final function autorotationStateTracking(enabled:Boolean):void {
			if (enabled) {
				saladoPlayer.manager.addEventListener(AutorotationEventClass.AUTOROTATION_STARTED, onAutorotationStarted, false, 0 , true);
				saladoPlayer.manager.addEventListener(AutorotationEventClass.AUTOROTATION_STOPPED, onAutorotationStopped, false, 0 , true);
			}else {
				saladoPlayer.manager.removeEventListener(AutorotationEventClass.AUTOROTATION_STARTED, onAutorotationStarted);
				saladoPlayer.manager.removeEventListener(AutorotationEventClass.AUTOROTATION_STOPPED, onAutorotationStopped);
			}	
		}
		
		protected function moduleReady():void {			
			throw new Error("Function moduleReady() must be overrided by this module");
		}						
		
		protected final function get moduleData():ModuleData {			
			return _moduleData;
		}
		
		// to be used by Manager
		public final function get moduleDescription():ModuleDescription {
			return _moduleDescription;
		}
		
		// to be used by other modules  
		public final function execute(functionName:String, args:Array):*{			
			return (this[functionName] as Function).apply(this, args);
		}					
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Following Functions avaible for modules 
		// also modules can access any public functions and variables of SaladoPlayer 
		// including manager that extends PanoSalado e.g. PanoSalado.manager.swingToChild(...)
		// or managerData e.g.  PanoSalado.managerData.getActionDataById("someid")
		// module should not import any classes from com.panozona.player, it should get variables as Objects and catch possible errors
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
			
		// override me
		protected function onPanoramaStartedLoading(loadPanoramaEvent:Object):void {
			
		}
		
		// override me
		protected function onPanoramaLoaded(loadPanoramaEvent:Object):void {			
			
		}
		
		// override me
		protected function onTransitionEnded(loadPanoramaEvent:Object):void {
			
		}		
		
		// override me
		protected function onCameraMove(cameraMoveEvent:Object):void {
			// see ViewFinder module
		}
		
		// override me
		protected function onAutorotationStarted(autorotationEvent:Object):void {
			
		}
		
		// override me
		protected function onAutorotationStopped(autorotationEvent:Object):void {
			
		}
		
		
		
		protected function printError(msg:String):void {
			if(tracer != null){
				tracer.printError(_moduleDescription.moduleName+":"+msg);
			}
		}
		
		public final function printWarning(msg:String):void {
			if(tracer != null){
				tracer.printWarning(_moduleDescription.moduleName+":"+msg);
			}
		}
		
		public final function printInfo(msg:String):void {
			if(tracer != null){
				tracer.printInfo(_moduleDescription.moduleName+":"+msg);
			}
		}	
		
		public final function executeModule(moduleName:String, functionName:String, args:Array):*{			
			return saladoPlayer.getModuleByName(moduleName).execute(functionName, args);
		}		
		
		public final function loadPanoramaById(panoramaId:String):void {
			saladoPlayer.manager.loadPanoramaById(panoramaId);
		}
		
		public final function toggleFullscreen():void {
			saladoPlayer.manager.toggleFullscreen();
		}		
		
		public final function toggleAutorotation():void {						
			saladoPlayer.managerData.autorotationCameraData.toggleRotation();		
		}
		
		public final function keyLeft(isDown:Boolean):void {			
			if(isDown){
				stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, CameraKeyBindingsClass.LEFT)); 
			}else {
				stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, CameraKeyBindingsClass.LEFT)); 
			}
		}
		
		public final function keyRight(isDown:Boolean):void {			
			if(isDown){
				stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, CameraKeyBindingsClass.RIGHT)); 
			}else {
				stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, CameraKeyBindingsClass.RIGHT)); 
			}
		}
		
		public final function keyUp(isDown:Boolean):void {
			if(isDown){
				stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, CameraKeyBindingsClass.UP)); 
			}else {
				stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, CameraKeyBindingsClass.UP)); 
			}
		}
		
		public final function keyDown(isDown:Boolean):void {
			if(isDown){
				stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, CameraKeyBindingsClass.DOWN)); 
			}else {
				stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, CameraKeyBindingsClass.DOWN)); 
			}
		}	
		
		public final function keyIn(isDown:Boolean):void {			
			if(isDown){
				stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, CameraKeyBindingsClass.IN)); 
			}else {
				stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, CameraKeyBindingsClass.IN)); 
			}
		}
		
		public final function keyOut(isDown:Boolean):void {			
			if(isDown){
				stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, CameraKeyBindingsClass.OUT)); 
			}else {
				stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, CameraKeyBindingsClass.OUT)); 
			}
		}		
	}
}