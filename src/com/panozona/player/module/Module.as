package com.panozona.module {
	
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class Module extends Sprite{
					
		
		public function Module() {
			
			// make contact with singleton from player assighn to it 
			// add all required listeners and make rightt things happen			
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
		
		protected final function  initialize(dependencies:Array):void {
			
		}
		
		protected final function  loadPanorama(params:Params):void {
			
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