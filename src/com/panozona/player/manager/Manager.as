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
	
	import com.panosalado.controller.*;
	import com.panosalado.core.*;
	import com.panosalado.events.*;
	import com.panosalado.view.*;
	import com.panozona.player.*;
	import com.panozona.player.component.*;
	import com.panozona.player.manager.data.*;
	import com.panozona.player.manager.data.actions.*;
	import com.panozona.player.manager.data.panoramas.*;
	import com.panozona.player.manager.events.*;
	import com.panozona.player.manager.utils.*;
	import com.panozona.player.manager.utils.loading.ILoadable;
	import com.panozona.player.manager.utils.loading.LoadablesLoader;
	import flash.events.*;
	import flash.utils.*;
	
	public class Manager extends PanoSalado{
		
		public const description:ComponentDescription = new ComponentDescription("SaladoPlayer", "1.0.1", "http://panozona.com/");
		
		private var currentPanoramaData:PanoramaData;
		private var previousPanoramaData:PanoramaData;
		private var arrListeners:Array;  // hold hotspots mouse event listeners so that they can be removed
		
		private var _loadedHotspots:Dictionary;
		private var _productHotspots:Dictionary;
		
		private var panoramaLocked:Boolean;
		private var pendingActionId:String;
		private var panoramaLoadingCanceled:Boolean;
		
		private var _managerData:ManagerData;
		private var _saladoPlayer:SaladoPlayer; // parent needed to access loaded modules
		
		public function Manager() {
			
			description.addFunctionDescription("print", String);
			description.addFunctionDescription("loadPano", String);
			description.addFunctionDescription("moveToHotspot", String);
			description.addFunctionDescription("moveToHotspotAnd", String, String);
			description.addFunctionDescription("moveToView", Number, Number, Number);
			description.addFunctionDescription("moveToViewAnd", Number, Number, Number, String);
			description.addFunctionDescription("jumpToView", Number, Number, Number);
			description.addFunctionDescription("startMoving", Number, Number);
			description.addFunctionDescription("stopMoving");
			description.addFunctionDescription("advancedMoveToHotspot", String, Number, Number, Function);
			description.addFunctionDescription("advancedMoveToHotspotAnd", String, Number, Number, Function, String);
			description.addFunctionDescription("advancedMoveToView", Number, Number, Number, Number, Function);
			description.addFunctionDescription("advancedMoveToViewAnd", Number, Number, Number, Number, Function, String);
			description.addFunctionDescription("advancedStartMoving", Number, Number, Number, Number, Number);
			description.addFunctionDescription("runAction", String);
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady);
		}
		
		private function stageReady(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			_saladoPlayer = SaladoPlayer(this.parent.root);
			_managerData = _saladoPlayer.managerData;
		}
		
		public override function initialize(dependencies:Array):void {
			super.initialize(dependencies);
			addEventListener(Event.COMPLETE, panoramaLoaded, false, 0, true);
			for (var i:int = 0; i < dependencies.length; i++ ) {
				if (dependencies[i] is SimpleTransition){
					dependencies[i].addEventListener( Event.COMPLETE, transitionComplete, false, 0, true);
					// WRONG it should throw to viewData here events by himslef. just as autorotation 
				}
			}
		}
		
		public function loadFirstPanorama():void {
			if (_managerData.allPanoramasData.firstPanorama != null) {
				loadPanoramaById(_managerData.allPanoramasData.firstPanorama);
			}else {
				if (_managerData.panoramasData != null && _managerData.panoramasData.length > 0) {
					loadPanoramaById(_managerData.panoramasData[0].id);
				}
			}
		}
		
		// TODO: this locekd should be better aimed 
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
				
				Trace.instance.printInfo("loading: " + panoramaData.id + " (" + panoramaData.params.path + ")");
				
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
					if (functionData.owner == description.name) {
						if(this[functionData.name] != undefined && this[functionData.name] is Function){
							(this[functionData.name] as Function).apply(this, functionData.args);
						}else {
							Trace.instance.printWarning("Invalid function name: "+functionData.owner+"."+functionData.name);
						}
					}else {
						/*
						module = _saladoPlayer.getModuleByName(functionData.owner);
						if (module != null) {
							module.execute(functionData.name, functionData.args);
						}else {
							Trace.instance.printWarning("Invalid owner name: " + functionData.owner + "." + functionData.name);
						}
						*/
					}
				}catch (error:Error) {
					Trace.instance.printError("Could not execute "+functionData.owner+"."+functionData.name+": "+error.message);
				}
			}
		}
		
		protected function loadHotspots(panoramaData:PanoramaData):void {
			var hotspotsLoader:LoadablesLoader = new LoadablesLoader();
			hotspotsLoader.addEventListener(LoadLoadableEvent.LOST, hotspotLost);
			hotspotsLoader.addEventListener(LoadLoadableEvent.LOADED, hotspotLoaded);
			hotspotsLoader.addEventListener(LoadLoadableEvent.FINISHED, hotspotsFinished);
			hotspotsLoader.load(Vector.<ILoadable>(panoramaData.hotspotsDataLoad));
			for each(var hotspotDataProduct:HotspotDataProduct in panoramaData.hotspotsDataProduct) {
				// call factory and insert hotspots....
			}
		}
		
		protected function hotspotLost(event:LoadLoadableEvent):void {
			_saladoPlayer.traceWindow.printError("Could not load hotspot: " + event.loadable.path);
		}
		
		protected function hotspotLoaded(event:LoadLoadableEvent):void {
			var hotspotData:HotspotData = (event.loadable as HotspotData);
			var managedChild:ManagedChild;
			
			//if (event.content is Sprite){
				// moze zrobic inny typ moze cos takiego 
			//}else {
			managedChild = new Hotspot(event.content);
			//}
			
			_loadedHotspots = new Dictionary();
			_loadedHotspots[hotspotData as HotspotDataLoad] = managedChild
			
			if (hotspotData.mouse.onClick != null) {
				managedChild.addEventListener(MouseEvent.CLICK, getMouseEventHandler(hotspotData.mouse.onClick));
				arrListeners.push({type:MouseEvent.CLICK, listener:getMouseEventHandler(hotspotData.mouse.onClick)});
			}
			if (hotspotData.mouse.onPress != null) {
				managedChild.addEventListener(MouseEvent.MOUSE_DOWN, getMouseEventHandler(hotspotData.mouse.onPress));
				arrListeners.push({type:MouseEvent.MOUSE_DOWN, listener:getMouseEventHandler(hotspotData.mouse.onPress)});
			}
			if (hotspotData.mouse.onRelease != null) {
				managedChild.addEventListener(MouseEvent.MOUSE_UP, getMouseEventHandler(hotspotData.mouse.onRelease));
				arrListeners.push({type:MouseEvent.MOUSE_UP, listener:getMouseEventHandler(hotspotData.mouse.onRelease)});
			}
			if (hotspotData.mouse.onOver != null) {
				managedChild.addEventListener(MouseEvent.ROLL_OVER, getMouseEventHandler(hotspotData.mouse.onOver));
				arrListeners.push({type:MouseEvent.ROLL_OVER, listener:getMouseEventHandler(hotspotData.mouse.onOver)});
			}
			if (hotspotData.mouse.onOut != null) {
				managedChild.addEventListener(MouseEvent.ROLL_OUT, getMouseEventHandler(hotspotData.mouse.onOut));
				arrListeners.push({type:MouseEvent.ROLL_OUT, listener:getMouseEventHandler(hotspotData.mouse.onOut)});
			}
			
			var piOver180:Number = Math.PI / 180;
			var pr:Number = (-1 * (-hotspotData.location.pan - 90)) * piOver180;
			var tr:Number = -1 * hotspotData.location.tilt * piOver180;
			var xc:Number = hotspotData.location.distance * Math.cos(pr) * Math.cos(tr);
			var yc:Number = hotspotData.location.distance * Math.sin(tr);
			var zc:Number = hotspotData.location.distance * Math.sin(pr) * Math.cos(tr);
			
			managedChild.x = xc;
			managedChild.y = yc;
			managedChild.z = zc;
			managedChild.rotationY = (- hotspotData.location.pan  + hotspotData.transform.rotationY) * piOver180;
			managedChild.rotationX = (hotspotData.location.tilt + hotspotData.transform.rotationX) * piOver180;
			managedChild.rotationZ = hotspotData.transform.rotationZ * piOver180
			
			managedChild.scaleX = hotspotData.transform.scaleX;
			managedChild.scaleY = hotspotData.transform.scaleY;
			managedChild.scaleZ = hotspotData.transform.scaleZ;
			addChild(managedChild);
		}
		
		protected function hotspotsFinished(event:LoadLoadableEvent):void {
			event.target.removeEventListener(LoadLoadableEvent.LOST, hotspotLost);
			event.target.removeEventListener(LoadLoadableEvent.LOADED, hotspotLoaded);
			event.target.removeEventListener(LoadLoadableEvent.FINISHED, hotspotsFinished);
		}
		
		private function getMouseEventHandler(id:String):Function{
			return function(e:MouseEvent):void {
				runAction(id);
			}
		}
		
		private function panoramaLoaded(e:Event):void {
			arrListeners = new Array();
			panoramaLocked = false;
			loadHotspots(currentPanoramaData);
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
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function print(value:String):void {
			Trace.instance.printInfo(value);
		}
		
		public function loadPano(panramaId:String):void {
			loadPanoramaById(panramaId);
		}
		
		public function moveToHotspot(hotspotId:String):void {
			/*
			if (!panoramaLocked && nameToHotspot[hotspotId] != undefined) {
				pendingActionId = null;
				swingToChild(nameToHotspot[hotspotId]);
				panoramaLocked = true;
				addEventListener(PanoSaladoEvent.SWING_TO_CHILD_COMPLETE, swingComplete);
			}
			*/
		}
		
		public function moveToHotspotAnd(childId:String, actionId:String):void {
			/*
			if(!panoramaLocked && nameToHotspot[childId] != undefined){
				swingToChild(nameToHotspot[childId]);
				panoramaLocked = true;
				pendingActionId = actionId; 
				addEventListener(PanoSaladoEvent.SWING_TO_CHILD_COMPLETE, swingComplete);
			}
			*/
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
			/*
			if (!panoramaLocked && nameToHotspot[hotspotId] != undefined){
				pendingActionId = null;
				panoramaLocked = true;
				swingToChild(nameToHotspot[hotspotId], fieldOfView, speed, tween);	
				addEventListener(PanoSaladoEvent.SWING_TO_CHILD_COMPLETE, swingComplete);
			}
			*/
		}
		
		public function advancedMoveToHotspotAnd(hotspotId:String, fieldOfView:Number, speed:Number, tween:Function, actionId:String):void {
			/*
			if(!panoramaLocked && nameToHotspot[hotspotId] != undefined){
				swingToChild(nameToHotspot[hotspotId], fieldOfView, speed, tween);
				panoramaLocked = true;
				pendingActionId = actionId; 
				addEventListener(PanoSaladoEvent.SWING_TO_CHILD_COMPLETE, swingComplete);
			}
			*/
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