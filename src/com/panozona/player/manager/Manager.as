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
package com.panozona.player.manager{
	
	import com.panozona.player.manager.data.ManagerData;
	import com.panozona.player.manager.data.ActionData;
	import com.panozona.player.manager.data.ChildMouse;
	import com.panozona.player.manager.data.FunctionData;
	import com.panozona.player.manager.data.PanoramaData;
	import com.panozona.player.manager.data.ChildData;	
	import com.panozona.player.manager.utils.Trace;
	import com.panozona.player.manager.utils.ChildrenLoader;
	import com.panozona.player.manager.events.LoadChildEvent;
	import com.panozona.player.SaladoPlayer;
	
	
	import com.panosalado.events.ViewEvent;
	import com.panosalado.events.CameraEvent;
	import com.panosalado.events.CameraMoveEvent;
	import com.panosalado.model.Characteristics;
	import com.panosalado.model.Params;
	import com.panosalado.model.ViewData;		
	import com.panosalado.model.ViewData;
	import com.panosalado.core.PanoSalado;		
	
	import flash.display.DisplayObject;
	import flash.events.Event;	
	import flash.events.MouseEvent;	
	
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**	 
	 * @author mstandio
	 */
	public class Manager extends PanoSalado{		
			
		private var _managerData:ManagerData;							
		private var saladoPlayer:SaladoPlayer;
		
		private var currentPanoId:String;
		private var loadingPanoId:String;
		
		private var childrenLoader:ChildrenLoader;
		
		public function Manager() {						
			super();			
			addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);										
		}				
		
		private function stageReady(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			saladoPlayer = SaladoPlayer(this.parent.root);
			childrenLoader = new ChildrenLoader();			
		}		
		
		
		//private function ass(e:CameraMoveEvent):void {
			//trace("costam "+e.pan);			
		//}
					
		
		// remove listeners from previous panorama children 		
		public override function initialize(dependencies:Array):void {
			super.initialize(dependencies);						
		}
		
		private function getMouseEventHandler(id:String):Function{
			return function(e:MouseEvent):void {
				runAction(id);
			}
		}
		
		public function runAction(id:String):void {
			if(saladoPlayer != null){
				for each(var actionData:ActionData in _managerData.actionsData){
					if (actionData.id == id) {
						var module:Object;
						for each(var functionData:FunctionData in actionData.functions) {						
							module = saladoPlayer.getModuleByName(functionData.owner);
							if (module != null) {
								try{
									module.execute(functionData.name, functionData.args)						
								}catch (e:Error) {
									Trace.instance.printError(e.message);
								}
							}else if(functionData.owner == "SaladoPlayer") {						
								try {
									(this[functionData.name] as Function).apply(this, functionData.args);
								}catch (e:Error) {
									Trace.instance.printError(e.message);
								}								
							}else{
								Trace.instance.printWarning("Invalid owner name: " + functionData.owner + "." + functionData.name);
							}
						}					
					}
				}
			}
		}													
				
		public function loadFirstPanorama():void {								
			// TODO: if parsing fails load panorama that is in panoramas folder (somehow)
			if (_managerData.firstPanorama != null && _managerData.firstPanorama.length > 0) {				
				loadPanoramaById(_managerData.firstPanorama);
			}else {				
				if (_managerData.panoramasData != null && _managerData.panoramasData.length > 0) {					
					loadPanoramaById(_managerData.panoramasData[0].id);
				}
			}
		}		
		
		public function loadPanoramaById(panoramaId:String):void {
			var panoramaData:PanoramaData = _managerData.getPanoramaDataById(panoramaId);
			if (panoramaData != null) {						
				loadingPanoId = panoramaData.id;												
				
				// REMOVE CHILDREN !!!!				
				// make loadchildren stop if loading new panorama before old one is done (?)
				
				
				
				super.loadPanorama(panoramaData.params);
			}			
		}			
				
		public final function panoramaLoaded(e:Event):void {			
			
		}
		
		public final function transitionComplete(e:Event):void {			
			var panoramaData:PanoramaData = _managerData.getPanoramaDataById(loadingPanoId); // TODO: make code more pretty :3						
			childrenLoader.addEventListener(LoadChildEvent.BITMAPDATA_CONTENT, insertChild, false, 0, true);
			childrenLoader.loadChildren(panoramaData.childrenData);
			
		}	
		
		public function insertChild(e:LoadChildEvent):void {
			if (e.childData.childMouse.onClick != null) {
				e.childData.managedChildReference.addEventListener(MouseEvent.CLICK, getMouseEventHandler(e.childData.childMouse.onClick), false, 0, true);
			}
			if (e.childData.childMouse.onPress != null) {
				e.childData.managedChildReference.addEventListener(MouseEvent.MOUSE_DOWN, getMouseEventHandler(e.childData.childMouse.onPress), false, 0, true);
			}
			if (e.childData.childMouse.onRelease != null) {
				e.childData.managedChildReference.addEventListener(MouseEvent.MOUSE_UP, getMouseEventHandler(e.childData.childMouse.onRelease), false, 0, true);
			}
			if (e.childData.childMouse.onMove != null) {
				e.childData.managedChildReference.addEventListener(MouseEvent.MOUSE_MOVE, getMouseEventHandler(e.childData.childMouse.onMove), false, 0, true);
			}
			if (e.childData.childMouse.onOver != null) {
				e.childData.managedChildReference.addEventListener(MouseEvent.MOUSE_OVER, getMouseEventHandler(e.childData.childMouse.onOver), false, 0, true);
			}
			if (e.childData.childMouse.onOut != null) {						
				e.childData.managedChildReference.addEventListener(MouseEvent.MOUSE_OUT, getMouseEventHandler(e.childData.childMouse.onOut), false, 0, true);
			}														
			
			addChildAt(e.childData.managedChild, e.childData.weight);
		}		
				
		public function setManagerData(value:ManagerData):void {
			if (_managerData === value) return;		
			if (value != null) {
				_managerData = value;
			}
		}				
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Formally exposed functions avaible via actions in XML settings
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
		
		public function showPanorama(PanoramaId:String):void {
			loadPanoramaById(PanoramaId);
		}
		
		public function moveToChild(ChildId:String):void {
			Trace.instance.printError("moveToChild not supported yet");
		}
		
		public function moveToView(pan:Number, tilt:Number, fieldOfView:Number):void {
			swingTo(pan, tilt, fieldOfView);
		}
		
		public function jumpToView(pan:Number, tilt:Number, fieldOfView:Number):void {
			renderAt(pan, tilt, fieldOfView);		
		}
		
		
		public function startMoving(panSpeed:Number, tiltSpeed:Number):void {
			startInertialSwing(panSpeed, tiltSpeed);			
		}
		
		public function stopMoving():void {
			stopInertialSwing();			
		}
		
		
		public function advancedStartMoving(panSpeed:Number, tiltSpeed:Number, sensitivity:Number = 0.0003, friction:Number = 0.3, threshold:Number = 0.0001):void {
			Trace.instance.printError("advancedStartMoving not supported yet");
		}
		
		public function advancedMoveToChild(childId:String, fieldOfView:Number, time:Number = 2.5, tween:String=""):void {
			Trace.instance.printError("advancedMoveToChild not supported yet");
		}
		
		public function advancedMoveTo(pan:Number, tilt:Number, fieldOfView:Number, time:Number, tween:String=""):void {
			Trace.instance.printError("advancedMoveTo not supported yet");
		}		
	}
}