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
package com.panozona.player.manager {
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.panosalado.model.Characteristics;
	import com.panosalado.model.CameraKeyBindings;
	import com.panosalado.model.Params;
	import com.panosalado.model.ViewData;
	import com.panosalado.model.ViewData;
	import com.panosalado.view.ImageHotspot;
	import com.panosalado.view.ManagedChild;
	import com.panosalado.controller.SimpleTransition;
	import com.panosalado.controller.AutorotationCamera;
	import com.panosalado.events.AutorotationEvent;
	import com.panosalado.core.PanoSalado;
	import com.panosalado.events.PanoSaladoEvent;
	
	import com.panozona.player.SaladoPlayer;
	import com.panozona.player.manager.data.ManagerData;
	import com.panozona.player.manager.data.panorama.PanoramaData;
	import com.panozona.player.manager.data.action.ActionData;
	import com.panozona.player.manager.data.action.FunctionData;
	import com.panozona.player.manager.data.hotspot.HotspotData;
	import com.panozona.player.manager.data.hotspot.Mouse;
	import com.panozona.player.manager.utils.HotspotsLoader;
	import com.panozona.player.manager.utils.ManagerDescription;
	import com.panozona.player.manager.utils.Trace;
	import com.panozona.player.manager.events.LoadHotspotEvent;
	import com.panozona.player.manager.events.LoadPanoramaEvent;
	
	/**
	 * @author mstandio
	 */
	public class Manager extends PanoSalado{
		
		private var _managerData:ManagerData;
		private var _saladoPlayer:SaladoPlayer; // parent needed to access loaded modules
		
		private var hotspotsLoader:HotspotsLoader;
		
		private var currentPanoramaData:PanoramaData;
		private var previousPanoramaData:PanoramaData;
		
		private var arrListeners:Array;  // hold hotspots mouse event listeners so that they can be removed
		private var nameToHotspot:Array; // fix for unable set .name for loaded swf files
		
		private var panoramaLocked:Boolean;
		private var pendingActionId:String;
		private var panoramaLoadingCanceled:Boolean;
		
		public function Manager() {
			super();
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}
		
		private function stageReady(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			
			_saladoPlayer = SaladoPlayer(this.parent.root);
			_managerData = _saladoPlayer.managerData;
			
			hotspotsLoader = new HotspotsLoader();
			hotspotsLoader.addEventListener(LoadHotspotEvent.BMD_CONTENT, insertHotspot, false, 0, true);
			hotspotsLoader.addEventListener(LoadHotspotEvent.SWF_CONTENT, insertHotspot, false, 0, true);
			//hotspotsLoader.addEventListener(LoadHotspotEvent.XML_CONTENT, insertHotspot, false, 0, true);
		}
		
		public override function initialize(dependencies:Array):void {
			super.initialize(dependencies);
			addEventListener(Event.COMPLETE, panoramaLoaded, false, 0, true);
			for (var i:int = 0; i < dependencies.length; i++ ) {
				if (dependencies[i] is SimpleTransition){
					dependencies[i].addEventListener( Event.COMPLETE, transitionComplete, false, 0, true);
				}
			}
		}
		
		public function loadFirstPanorama():void {
			if (_managerData.firstPanorama != null) {
				loadPanoramaById(_managerData.firstPanorama);
			}else {
				if (_managerData.panoramasData != null && _managerData.panoramasData.length > 0) {
					loadPanoramaById(_managerData.panoramasData[0].id);
				}
			}
		}
		
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
			
				if(previousPanoramaData != null){
					runAction(previousPanoramaData.onLeave);
					runAction(previousPanoramaData.onLeaveTo[currentPanoramaData.id]);
				}	
				
				Trace.instance.printInfo("loading: "+panoramaData.id+" ("+panoramaData.params.path+")");
			
				for (var i:int = 0; i < _managedChildren.numChildren; i++ ) {
					for(var j:Number = 0; j < arrListeners.length; j++){
						if (_managedChildren.getChildAt(i).hasEventListener(arrListeners[j].type)) {
							_managedChildren.getChildAt(i).removeEventListener(arrListeners[j].type, arrListeners[j].listener);
						}
					}
				}
				dispatchEvent(new LoadPanoramaEvent(LoadPanoramaEvent.PANORAMA_STARTED_LOADING, panoramaData));
				super.loadPanorama(panoramaData.params.clone());
			}
		}
		
		public function runAction(actionId:String):void {
			var actionData:ActionData = _managerData.getActionDataById(actionId);
			if (actionData == null) {
				if (actionId != null)Trace.instance.printWarning("Action not found: "+actionId);
				return;
			}
			var module:Object;
			for each(var functionData:FunctionData in actionData.functions) {
				try{
					if (functionData.owner == ManagerDescription.name) {
						if(this[functionData.name] != undefined && this[functionData.name] is Function){
							(this[functionData.name] as Function).apply(this, functionData.args);
						}else {
							Trace.instance.printWarning("Invalid function name: "+functionData.owner+"."+functionData.name);
						}
					}else {
						module = _saladoPlayer.getModuleByName(functionData.owner);
						if (module != null) {
							module.execute(functionData.name, functionData.args);
						}else {
							Trace.instance.printWarning("Invalid owner name: " + functionData.owner + "." + functionData.name);
						}
					}
				}catch (error:Error) {
					Trace.instance.printError("Could not execute "+functionData.owner+"."+functionData.name+": "+error.message);
				}
			}
		}
		
		private function insertHotspot(e:LoadHotspotEvent):void {
			var hotspotData:HotspotData = e.hotspotData;
			var managedChild:ManagedChild;
			if (e.type == LoadHotspotEvent.BMD_CONTENT){
				managedChild = new ImageHotspot(hotspotData.content);
				managedChild.buttonMode = hotspotData.handCursor;
			}else if (e.type == LoadHotspotEvent.SWF_CONTENT) {
				Object(hotspotData.content).setButtonMode(hotspotData.handCursor);
				managedChild = ManagedChild(hotspotData.content); 
				//managedChild.setArguments(childData.swfArguments);// TODO: set arguments to swf hotspots
			}
			nameToHotspot[hotspotData.id] = managedChild;
			
			if (hotspotData.mouse.onClick != null) {
				managedChild.addEventListener(MouseEvent.CLICK, getMouseEventHandler(hotspotData.mouse.onClick));
				arrListeners.push({type:MouseEvent.CLICK, listener:getMouseEventHandler(e.hotspotData.mouse.onClick)});
			}
			if (hotspotData.mouse.onPress != null) {
				managedChild.addEventListener(MouseEvent.MOUSE_DOWN, getMouseEventHandler(hotspotData.mouse.onPress));
				arrListeners.push({type:MouseEvent.MOUSE_DOWN, listener:getMouseEventHandler(e.hotspotData.mouse.onPress)});
			}
			if (hotspotData.mouse.onRelease != null) {
				managedChild.addEventListener(MouseEvent.MOUSE_UP, getMouseEventHandler(hotspotData.mouse.onRelease));
				arrListeners.push({type:MouseEvent.MOUSE_UP, listener:getMouseEventHandler(e.hotspotData.mouse.onRelease)});
			}
			if (hotspotData.mouse.onOver != null) {
				managedChild.addEventListener(MouseEvent.ROLL_OVER, getMouseEventHandler(hotspotData.mouse.onOver));
				arrListeners.push({type:MouseEvent.ROLL_OVER, listener:getMouseEventHandler(e.hotspotData.mouse.onOver)});
			}
			if (hotspotData.mouse.onOut != null) {
				managedChild.addEventListener(MouseEvent.ROLL_OUT, getMouseEventHandler(hotspotData.mouse.onOut));
				arrListeners.push({type:MouseEvent.ROLL_OUT, listener:getMouseEventHandler(e.hotspotData.mouse.onOut)});
			}
			
			var piOver180:Number = Math.PI / 180;
			var pr:Number = (-1*(-hotspotData.position.pan - 90)) * piOver180; 
			var tr:Number = -1*  hotspotData.position.tilt * piOver180;
			var xc:Number = hotspotData.position.distance * Math.cos(pr) * Math.cos(tr);
			var yc:Number = hotspotData.position.distance * Math.sin(tr);
			var zc:Number = hotspotData.position.distance * Math.sin(pr) * Math.cos(tr);
			
			managedChild.x = xc;
			managedChild.y = yc;
			managedChild.z = zc;
			managedChild.rotationY = (-hotspotData.position.pan  + hotspotData.transformation.rotationY) * piOver180;
			managedChild.rotationX = (hotspotData.position.tilt + hotspotData.transformation.rotationX) * piOver180;
			managedChild.rotationZ = hotspotData.transformation.rotationZ * piOver180
			
			managedChild.scaleX = hotspotData.transformation.scaleX;
			managedChild.scaleY = hotspotData.transformation.scaleY;
			managedChild.scaleZ = hotspotData.transformation.scaleZ;
			
			addChild(managedChild);
		}
		
		private function getMouseEventHandler(id:String):Function{
			return function(e:MouseEvent):void {
				runAction(id);
			}
		}
		
		private function panoramaLoaded(e:Event):void {
			arrListeners = new Array();
			nameToHotspot = new Array();
			hotspotsLoader.load(currentPanoramaData.hotspotsData);
			panoramaLocked = false;
			runAction(currentPanoramaData.onEnter);
			if (previousPanoramaData != null ){
				runAction(currentPanoramaData.onEnterFrom[previousPanoramaData.id]);
			}
			dispatchEvent(new LoadPanoramaEvent(LoadPanoramaEvent.PANORAMA_LOADED, currentPanoramaData));
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
		
		public function get currentPanoramaId():String {
			if (currentPanoramaData == null) return null;
			return currentPanoramaData.id;
		}
		
		public function print(value:String):void {
			Trace.instance.printInfo(value);
		}
		
		public function loadPano(panramaId:String):void {
			loadPanoramaById(panramaId);
		}
		
		public function moveToHotspot(hotspotId:String):void {
			if (!panoramaLocked && nameToHotspot[hotspotId] != undefined) {
				pendingActionId = null;
				swingToChild(nameToHotspot[hotspotId]);
				panoramaLocked = true;
				addEventListener(PanoSaladoEvent.SWING_TO_CHILD_COMPLETE, swingComplete);
			}
		}
		
		public function moveToHotspotAnd(childId:String, actionId:String):void {
			if(!panoramaLocked && nameToHotspot[childId] != undefined){
				swingToChild(nameToHotspot[childId]);
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
			if (!panoramaLocked) {
				startInertialSwing(panSpeed, tiltSpeed);
				panoramaLocked = true;
			}
		}
		
		public function stopMoving():void {
			panoramaLocked = false;
			stopInertialSwing();
		}
		
		public function advancedMoveToHotspot(hotspotId:String, fieldOfView:Number, speed:Number, tween:Function):void {
			if (!panoramaLocked && nameToHotspot[hotspotId] != undefined){
				pendingActionId = null;
				panoramaLocked = true;
				swingToChild(nameToHotspot[hotspotId], fieldOfView, speed, tween);	
				addEventListener(PanoSaladoEvent.SWING_TO_CHILD_COMPLETE, swingComplete);
			}
		}
		
		public function advancedMoveToHotspotAnd(hotspotId:String, fieldOfView:Number, speed:Number, tween:Function, actionId:String):void {
			if(!panoramaLocked && nameToHotspot[hotspotId] != undefined){
				swingToChild(nameToHotspot[hotspotId], fieldOfView, speed, tween);
				panoramaLocked = true;
				pendingActionId = actionId; 
				addEventListener(PanoSaladoEvent.SWING_TO_CHILD_COMPLETE, swingComplete);
			}
		}
		
		public function advancedMoveToView(pan:Number, tilt:Number, fieldOfView:Number, speed:Number, tween:Function):void {
			if (!panoramaLocked) {
				pendingActionId = null;
				panoramaLocked = true;
				swingTo(pan, tilt, fieldOfView, speed, tween);
				addEventListener(PanoSaladoEvent.SWING_TO_COMPLETE, swingComplete);
			}
		}
		
		public function advancedMoveToViewAnd(pan:Number, tilt:Number, fieldOfView:Number, speed:Number, tween:Function, actionId:String):void {
			if (!panoramaLocked) {
				panoramaLocked = true;
				pendingActionId = actionId;
				swingTo(pan, tilt, fieldOfView, speed, tween);
				addEventListener(PanoSaladoEvent.SWING_TO_COMPLETE, swingComplete);
			}
		}		
		
		public function advancedStartMoving(panSpeed:Number, tiltSpeed:Number, sensitivity:Number, friction:Number, threshold:Number):void {
			if (!panoramaLocked) {
				startInertialSwing(panSpeed, tiltSpeed, sensitivity, friction, threshold);
				panoramaLocked = true;
			}
		}
	}
}