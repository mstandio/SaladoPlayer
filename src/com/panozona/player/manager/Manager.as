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
	
	import com.panosalado.view.ImageHotspot;
	import com.panosalado.view.ManagedChild;
	import com.panozona.player.SaladoPlayer;
	import com.panosalado.controller.SimpleTransition;
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
	
	import com.panosalado.core.PanoSalado;
	import com.panosalado.model.Characteristics;
	import com.panosalado.model.CameraKeyBindings;
	import com.panosalado.model.Params;
	import com.panosalado.model.ViewData;
	import com.panosalado.model.ViewData;	
	
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
		private var loadingPanoramaLocked:Boolean;
		
		public function Manager(managerData:ManagerData) {
			_managerData = managerData;
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}
		
		private function stageReady(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			saladoPlayer = SaladoPlayer(this.parent.root);
			childrenLoader = new ChildrenLoader();			
			childrenLoader.addEventListener(LoadChildEvent.BITMAPDATA_CONTENT, insertChild, false, 0, true);
			childrenLoader.addEventListener(LoadChildEvent.SWFDATA_CONTENT, insertChild, false, 0, true);
		}		
		
		public override function initialize(dependencies:Array):void {
			super.initialize(dependencies);
			addEventListener(Event.COMPLETE, panoramaLoaded, false, 0, true);
			for (var i:int=0; i < dependencies.length; i++ ) {
				if (dependencies[i] is SimpleTransition) {
					dependencies[i].addEventListener( Event.COMPLETE, transitionComplete, false, 0, true);
					return;
				}
			}
		}
		
		private function panoramaLoaded(e:Event):void { 			
			childrenLoader.loadChildren(currentPanoramaData.childrenData);
			dispatchEvent(new LoadPanoramaEvent(LoadPanoramaEvent.PANORAMA_LOADED, currentPanoramaData));
			loadingPanoramaLocked = false;			
			runAction(currentPanoramaData.onEnter);
			if (previousPanoramaData != null ){
				runAction(currentPanoramaData.onEnterSource[previousPanoramaData.id]);
			}
		}		
		
		private function transitionComplete(e:Event):void {
			runAction(currentPanoramaData.onTransitionEnd);
			if(previousPanoramaData != null){
				runAction(currentPanoramaData.onTransitionEndSource[previousPanoramaData.id]);
			}
			dispatchEvent(new LoadPanoramaEvent(LoadPanoramaEvent.TRANSITION_ENDED, currentPanoramaData));
		}
		
		private function insertChild(e:LoadChildEvent):void {
			
			var childData:ChildData = e.childData;
			var managedChild:ManagedChild;			
			
			if (e.type == LoadChildEvent.BITMAPDATA_CONTENT){
				managedChild = new ImageHotspot(childData.bitmapFile.bitmapData);
				managedChild.buttonMode = childData.childMouse.useHandCursor;
				managedChild.name = childData.id;
				
			}else if (e.type == LoadChildEvent.SWFDATA_CONTENT) {				
				Object(childData.swfFile).setButtonMode(childData.childMouse.useHandCursor);				
				managedChild = ManagedChild(childData.swfFile); // TODO: cant change Timeline-placed object - need to craeate map id to name
			}			
			
			if (childData.childMouse.onClick != null) {
				managedChild.addEventListener(MouseEvent.CLICK, getMouseEventHandler(e.childData.childMouse.onClick), false, 0, true);				
			}
			if (childData.childMouse.onPress != null) {
				managedChild.addEventListener(MouseEvent.MOUSE_DOWN, getMouseEventHandler(childData.childMouse.onPress), false, 0, true);
			}
			if (childData.childMouse.onRelease != null) {
				managedChild.addEventListener(MouseEvent.MOUSE_UP, getMouseEventHandler(childData.childMouse.onRelease), false, 0, true);
			}
			if (childData.childMouse.onMove != null) {
				managedChild.addEventListener(MouseEvent.MOUSE_MOVE, getMouseEventHandler(childData.childMouse.onMove), false, 0, true);
			}
			if (childData.childMouse.onOver != null) {
				managedChild.addEventListener(MouseEvent.MOUSE_OVER, getMouseEventHandler(childData.childMouse.onOver), false, 0, true);
			}
			if (childData.childMouse.onOut != null) {
				managedChild.addEventListener(MouseEvent.MOUSE_OUT, getMouseEventHandler(childData.childMouse.onOut), false, 0, true);
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
			managedChild.rotationY = (childData.childPosition.pan  + childData.childTransform.rotationY) * piOver180;
			managedChild.rotationX = (childData.childPosition.tilt + childData.childTransform.rotationX) * piOver180;
			managedChild.rotationZ = childData.childTransform.rotationZ * piOver180
				
			managedChild.scaleX = childData.childTransform.scaleX;
			managedChild.scaleY = childData.childTransform.scaleY;
			managedChild.scaleZ = childData.childTransform.scaleZ;																
			
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
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Funtions intended to be used only by by modules
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function loadFirstPanorama():void {
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
			if (panoramaData != null && !loadingPanoramaLocked && panoramaData !== currentPanoramaData) {
				
				previousPanoramaData = currentPanoramaData;
				currentPanoramaData = panoramaData;								
				loadingPanoramaLocked = true;				
				
				if(previousPanoramaData != null) {
					runAction(previousPanoramaData.onLeave);
					runAction(previousPanoramaData.onLeaveTarget[currentPanoramaData.id]);
				}
				
				Trace.instance.printInfo("loading panorama: " + panoramaData.id + " " + panoramaData.params.path);				
				dispatchEvent(new LoadPanoramaEvent(LoadPanoramaEvent.PANORAMA_STARTED_LOADING, panoramaData));
				while (_managedChildren.numChildren) {
					_managedChildren.removeChildAt(0); 
				}				
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
							}else if(functionData.owner == "SaladoPlayer") {
																			
									if (functionData.name == "print" ||
										functionData.name == "loadPano" ||
										functionData.name == "moveToChild" ||
										functionData.name == "moveToView" ||
										functionData.name == "jumpToView" ||
										functionData.name == "startMoving" ||
										functionData.name == "stopMoving" ||
										functionData.name == "advancedStartMoving" ||
										functionData.name == "advancedMoveToChild" ||
										functionData.name == "advancedMoveTo" ||
										functionData.name == "runAction") { // this should not be used
											
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
				
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Exposed functions intended to be used via actions in XML settings as following:
		// <action id="act1" content="SaladoPlayer.print(hello), SaladoPlayer.moveToView(10,10,50)"/> 
		// Functions as public are also avaible for modules.
		// Those functions are descrivbed in com.panozona.player.manager.utils.ManagerDescription
		// Only using those functions via actions won't trigger validator warning
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function print(message:String):void {
			Trace.instance.printInfo(message);
		}		
		
		public function loadPano(panramaId:String):void {
			loadPanoramaById(panramaId);
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