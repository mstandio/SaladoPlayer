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
	
	import com.panosalado.controller.AutorotationCamera;
	import com.panozona.player.SaladoPlayer;
	import com.panozona.player.manager.events.LoadChildEvent;
	import com.panozona.player.manager.events.LoadPanoramaEvent;	
	import com.panozona.player.manager.data.ManagerData;
	import com.panozona.player.manager.data.ActionData;
	import com.panozona.player.manager.data.ChildMouse;
	import com.panozona.player.manager.data.FunctionData;
	import com.panozona.player.manager.data.PanoramaData;
	import com.panozona.player.manager.data.ChildData;
	import com.panozona.player.manager.utils.Trace;
	import com.panozona.player.manager.utils.ChildrenLoader;
	import flash.events.FullScreenEvent;

	import com.panosalado.controller.SimpleTransition;
	import com.panosalado.core.PanoSalado;
	import com.panosalado.view.ImageHotspot;
	import com.panosalado.view.ManagedChild;
	import com.panosalado.model.Characteristics;
	import com.panosalado.model.CameraKeyBindings;
	import com.panosalado.model.Params;
	import com.panosalado.model.ViewData;
	import com.panosalado.model.ViewData;
	import com.panosalado.events.AutorotationEvent;
	import com.panosalado.events.PanoSaladoEvent;
	
	import flash.display.Sprite;
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
		private var saladoPlayer:SaladoPlayer; // parent needed to access loaded modules 
		
		private var childrenLoader:ChildrenLoader;
		
		private var currentPanoramaData:PanoramaData;
		private var previousPanoramaData:PanoramaData;
		
		private var panoramaLocked:Boolean;
		
		private var arrListeners:Array; 
		private var nameToChild:Array;
		
		private var pendingActionId:String;
		private var panoramaLoadingCanceled:Boolean;
		
		private var autorotationCamera:AutorotationCamera;
		
		public function Manager() {
			super();			
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}
		
		private function stageReady(e:Event = null):void {			
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			saladoPlayer = SaladoPlayer(this.parent.root);
			_managerData = saladoPlayer.managerData;
			_managerData.arcBallCameraData.enabled = false; // gah
			childrenLoader = new ChildrenLoader();
			panoramaLoadingCanceled = false;
			childrenLoader.addEventListener(LoadChildEvent.BITMAPDATA_CONTENT, insertChild, false, 0, true);
			childrenLoader.addEventListener(LoadChildEvent.SWFDATA_CONTENT, insertChild, false, 0, true);
		}
		
		public override function initialize(dependencies:Array):void {
			super.initialize(dependencies);
			addEventListener(Event.COMPLETE, panoramaLoaded, false, 0, true);
			for (var i:int=0; i < dependencies.length; i++ ) {
				if (dependencies[i] is SimpleTransition) {
					dependencies[i].addEventListener( Event.COMPLETE, transitionComplete, false, 0, true);
				} else if (dependencies[i] is AutorotationCamera) {
					autorotationCamera = dependencies[i];
				}
			}			
		}
		
		private function panoramaLoaded(e:Event):void {
			arrListeners = new Array();
			nameToChild = new Array();
			childrenLoader.loadChildren(currentPanoramaData.childrenData);
			dispatchEvent(new LoadPanoramaEvent(LoadPanoramaEvent.PANORAMA_LOADED, currentPanoramaData));
			panoramaLocked = false;
			runAction(currentPanoramaData.onEnter);
			if (previousPanoramaData != null ){
				runAction(currentPanoramaData.onEnterFrom[previousPanoramaData.id]);
			}
		}
		
		private function transitionComplete(e:Event):void {
			runAction(currentPanoramaData.onTransitionEnd);
			if(previousPanoramaData != null){
				runAction(currentPanoramaData.onTransitionEndFrom[previousPanoramaData.id]);
			}
			dispatchEvent(new LoadPanoramaEvent(LoadPanoramaEvent.TRANSITION_ENDED, currentPanoramaData));
		}
		
		private function swingComplete(e:PanoSaladoEvent):void {
			removeEventListener(PanoSaladoEvent.SWING_TO_CHILD_COMPLETE, swingComplete);
			removeEventListener(PanoSaladoEvent.SWING_TO_COMPLETE, swingComplete);
			panoramaLocked = false;
			if (pendingActionId != null) {
				runAction(pendingActionId);				
			}
		}
		
		private function insertChild(e:LoadChildEvent):void {
			
			var childData:ChildData = e.childData;
			var managedChild:ManagedChild;
			
			if (e.type == LoadChildEvent.BITMAPDATA_CONTENT){
				managedChild = new ImageHotspot(childData.bitmapFile.bitmapData);
				managedChild.buttonMode = childData.childMouse.handCursor;
				managedChild.name = childData.id;
				
			}else if (e.type == LoadChildEvent.SWFDATA_CONTENT) {
				Object(childData.swfFile).setButtonMode(childData.childMouse.handCursor);
				managedChild = ManagedChild(childData.swfFile); 
				managedChild.setArguments(childData.swfArguments);
			}
			
			nameToChild[childData.id] = managedChild;
			
			if (childData.childMouse.onClick != null) {
				managedChild.addEventListener(MouseEvent.CLICK, getMouseEventHandler(e.childData.childMouse.onClick));
				arrListeners.push({type:MouseEvent.CLICK, listener:getMouseEventHandler(e.childData.childMouse.onClick)});
			}
			if (childData.childMouse.onPress != null) {
				managedChild.addEventListener(MouseEvent.MOUSE_DOWN, getMouseEventHandler(childData.childMouse.onPress));
				arrListeners.push({type:MouseEvent.MOUSE_DOWN, listener:getMouseEventHandler(e.childData.childMouse.onPress)});
			}
			if (childData.childMouse.onRelease != null) {
				managedChild.addEventListener(MouseEvent.MOUSE_UP, getMouseEventHandler(childData.childMouse.onRelease));
				arrListeners.push({type:MouseEvent.MOUSE_UP, listener:getMouseEventHandler(e.childData.childMouse.onRelease)});
			}
			if (childData.childMouse.onMove != null) {
				managedChild.addEventListener(MouseEvent.MOUSE_MOVE, getMouseEventHandler(childData.childMouse.onMove));
				arrListeners.push({type:MouseEvent.MOUSE_MOVE, listener:getMouseEventHandler(e.childData.childMouse.onMove)});
			}
			if (childData.childMouse.onOver != null) {
				managedChild.addEventListener(MouseEvent.MOUSE_OVER, getMouseEventHandler(childData.childMouse.onOver));
				arrListeners.push({type:MouseEvent.MOUSE_OVER, listener:getMouseEventHandler(e.childData.childMouse.onOver)});
			}
			if (childData.childMouse.onOut != null) {
				managedChild.addEventListener(MouseEvent.MOUSE_OUT, getMouseEventHandler(childData.childMouse.onOut));
				arrListeners.push({type:MouseEvent.MOUSE_OUT, listener:getMouseEventHandler(e.childData.childMouse.onOut)});
			}
			
			var piOver180:Number = Math.PI / 180;
			var pr:Number = (-1*(childData.childPosition.pan - 90)) * piOver180; 
			var tr:Number = -1*  childData.childPosition.tilt * piOver180;
			var xc:Number = childData.childPosition.distance * Math.cos(pr) * Math.cos(tr);
			var yc:Number = childData.childPosition.distance * Math.sin(tr);
			var zc:Number = childData.childPosition.distance * Math.sin(pr) * Math.cos(tr);
			
			managedChild.x = xc;
			managedChild.y = yc;
			managedChild.z = zc;
			managedChild.rotationY = (childData.childPosition.pan  + childData.childTransformation.rotationY) * piOver180;
			managedChild.rotationX = (childData.childPosition.tilt + childData.childTransformation.rotationX) * piOver180;
			managedChild.rotationZ = childData.childTransformation.rotationZ * piOver180
			
			managedChild.scaleX = childData.childTransformation.scaleX;
			managedChild.scaleY = childData.childTransformation.scaleY;
			managedChild.scaleZ = childData.childTransformation.scaleZ;
			
			
			//managedChild.name = childData.id;
			
			//Trace.instance.printInfo("weight: "+e.childData.weight);
			//addChildAt(e.childData.managedChild, e.childData.weight);
			// TODO: children shuold be inserted in order
			addChild(managedChild);
		}
		
		private function getMouseEventHandler(id:String):Function{
			return function(e:MouseEvent):void {
				runAction(id);
			}
		}
		
		public function loadFirstPanorama():void {
			if (_managerData.firstPanorama != null && _managerData.firstPanorama.length > 0) {
				loadPanoramaById(_managerData.firstPanorama);
			}else {
				if (_managerData.panoramasData != null && _managerData.panoramasData.length > 0) {
					loadPanoramaById(_managerData.panoramasData[0].id);
				}
			}
		}
		
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Funtions intended to be used only by by modules
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function loadPanoramaById(panoramaId:String):void {
			var panoramaData:PanoramaData = _managerData.getPanoramaDataById(panoramaId);
			if (panoramaData != null && !panoramaLocked && panoramaData !== currentPanoramaData) {
				if (!panoramaLoadingCanceled && currentPanoramaData != null && currentPanoramaData.onLeaveToAttempt[panoramaData.id] != null) {					
					panoramaLoadingCanceled = true;
					runAction(currentPanoramaData.onLeaveToAttempt[panoramaData.id]);					
					return;
				}
				
				panoramaLoadingCanceled = false;
				
				previousPanoramaData = currentPanoramaData;
				currentPanoramaData = panoramaData;
				panoramaLocked = true;
			
				if(previousPanoramaData != null) {
					runAction(previousPanoramaData.onLeave);
					runAction(previousPanoramaData.onLeaveTo[currentPanoramaData.id]);
				}	
				
				Trace.instance.printInfo("loading: " + panoramaData.id + " (" + panoramaData.params.path+")");
			
				for (var i:int = 0; i < _managedChildren.numChildren; i++ ) {
					for(var j:Number = 0; j<arrListeners.length; j++){
						if (_managedChildren.getChildAt(i).hasEventListener(arrListeners[j].type)) {
							_managedChildren.getChildAt(i).removeEventListener(arrListeners[j].type, arrListeners[j].listener);
						}
					}
				}
				dispatchEvent(new LoadPanoramaEvent(LoadPanoramaEvent.PANORAMA_STARTED_LOADING, panoramaData));
				super.loadPanorama(panoramaData.params.clone());
			}
		}		
		
		public function runAction(id:String):void {
			if(saladoPlayer != null && id != null){
				for each(var actionData:ActionData in _managerData.actionsData){
					if (actionData.id == id) {
						var module:Object;
						for each(var functionData:FunctionData in actionData.functions) {
							module = saladoPlayer.getModuleByName(functionData.owner);
							if (module != null) {
								try {
									module.execute(functionData.name, functionData.args);
								}catch (e:Error) {
									Trace.instance.printError(e.message);
								}
							}else if(functionData.owner == "SaladoPlayer"){
									if(this[functionData.name]!=undefined && this[functionData.name] is Function){
										try {
											(this[functionData.name] as Function).apply(this, functionData.args);
										}catch (e:Error) {
											Trace.instance.printError(e.message);
										}
									}else {
										Trace.instance.printWarning("Invalid function name: " + functionData.owner + "." + functionData.name);
									}
							}else {
								Trace.instance.printWarning("Invalid owner name: " + functionData.owner + "." + functionData.name);
							}
						}
					}
				}
			}
		}	
		
		public function toggleAutorotation():void {
			autorotationCamera.toggle();
		}
		
		public function toggleMouseCamera():void {
			if (_managerData.inertialMouseCameraData.enabled || ! _managerData.arcBallCameraData.enabled) {
				_managerData.inertialMouseCameraData.enabled = false;
				_managerData.arcBallCameraData.enabled = true;
			}else {
				_managerData.inertialMouseCameraData.enabled = true;
				_managerData.arcBallCameraData.enabled = false;
			}
		}
		
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Exposed functions intended to be used via actions in XML settings as following:
// <action id="act1" content="SaladoPlayer.print(hello), SaladoPlayer.moveToView(10,10,50)"/> 
// Functions as public are also avaible for modules.
// Those functions are descrivbed in com.panozona.player.manager.utils.ManagerDescription
// Only using those functions via actions won't trigger validator warning
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function print(value:String):void {
			Trace.instance.printInfo(value);
		}
		
		public function loadPano(panramaId:String):void {
			loadPanoramaById(panramaId);
		}
		
		public function moveToHotspot(childId:String):void {			
			if (!panoramaLocked && nameToChild[childId] != undefined) {
				pendingActionId = null;
				swingToChild(nameToChild[childId]);
				panoramaLocked = true;
				addEventListener(PanoSaladoEvent.SWING_TO_CHILD_COMPLETE, swingComplete);
			}
		}		
		
		public function moveToHotspotAnd(childId:String, actionId:String):void {
			if(!panoramaLocked && nameToChild[childId] != undefined){
				swingToChild(nameToChild[childId]);
				panoramaLocked = true;
				pendingActionId = actionId; 
				addEventListener(PanoSaladoEvent.SWING_TO_CHILD_COMPLETE, swingComplete);
			}
		}
		
		public function moveToView(pan:Number, tilt:Number, fieldOfView:Number):void {
			if (!panoramaLocked) {
				pendingActionId = null;
				panoramaLocked = true;
				swingTo(pan, tilt, fieldOfView);
				addEventListener(PanoSaladoEvent.SWING_TO_COMPLETE, swingComplete);
			}
		}
		
		public function moveToViewAnd(pan:Number, tilt:Number, fieldOfView:Number, actionId:String):void {
			if (!panoramaLocked) {
				panoramaLocked = true;
				pendingActionId = actionId;
				swingTo(pan, tilt, fieldOfView);
				addEventListener(PanoSaladoEvent.SWING_TO_COMPLETE, swingComplete);
			}
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
		
		public function advancedStartMoving(panSpeed:Number, tiltSpeed:Number, sensitivity:Number, friction:Number, threshold:Number):void {
			startInertialSwing(panSpeed, tiltSpeed, sensitivity, friction, threshold);			
		}
		
		public function advancedMoveToHotspot(childId:String, fieldOfView:Number, time:Number, tween:Function):void {
			if (!panoramaLocked && nameToChild[childId] != undefined){
				pendingActionId = null;
				panoramaLocked = true;
				swingToChild(nameToChild[childId], fieldOfView, time, tween);	
				addEventListener(PanoSaladoEvent.SWING_TO_CHILD_COMPLETE, swingComplete);
			}			
		}
		
		public function advancedMoveToHotspotAnd(childId:String, fieldOfView:Number, time:Number, tween:Function, actionId:String):void {
			if(!panoramaLocked && nameToChild[childId] != undefined){
				swingToChild(nameToChild[childId], fieldOfView, time, tween);
				panoramaLocked = true;
				pendingActionId = actionId; 
				addEventListener(PanoSaladoEvent.SWING_TO_CHILD_COMPLETE, swingComplete);
			}
		}
		
		public function advancedMoveToView(pan:Number, tilt:Number, fieldOfView:Number, time:Number, tween:Function):void {
			if (!panoramaLocked) {
				pendingActionId = null;
				panoramaLocked = true;
				swingTo(pan, tilt, fieldOfView, time, tween);
				addEventListener(PanoSaladoEvent.SWING_TO_COMPLETE, swingComplete);
			}
		}
		
		public function advancedMoveToViewAnd(pan:Number, tilt:Number, fieldOfView:Number, time:Number, tween:Function, actionId:String):void {
			if (!panoramaLocked) {
				panoramaLocked = true;
				pendingActionId = actionId;
				swingTo(pan, tilt, fieldOfView,time, tween);
				addEventListener(PanoSaladoEvent.SWING_TO_COMPLETE, swingComplete);
			}
		}
	}
}