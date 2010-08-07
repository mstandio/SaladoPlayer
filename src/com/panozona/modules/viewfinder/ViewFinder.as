package com.panozona.modules.viewfinder{
	
	import com.panozona.player.module.Module;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class ViewFinder extends Module {
		
		private var txtOutput:TextField;		
		private var txtFormat:TextFormat;							
		private var box:Sprite;
		private var pointer:Sprite;	
		
		private var pan:Number;
		private var tilt:Number;
		private var fieldOfView:Number;				
				
		public function ViewFinder() {
			super("ViewFinder", 0.1,"http://panozona.com/wiki/ViewFinder");
			aboutThisModule = 
			"This module shows pan, tilt and field of view of current view, marked as a dot in the middle of the screen." +
			"Module is usefull i.e. for determining position of hotspots during configuration process.";			
		}		
		
		override protected function moduleReady():void {
			
			pointer = new Sprite();
			pointer.graphics.beginFill(0x000000); 			
			pointer.graphics.drawCircle(0, 0, 3);
			pointer.graphics.endFill();
			pointer.graphics.beginFill(0xffffff); 			
			pointer.graphics.drawCircle(0, 0, 2);
			pointer.graphics.endFill();			
			pointer.mouseEnabled = false;
			pointer.mouseChildren = false;
			addChild(pointer);
			
			txtFormat = new TextFormat();
			txtFormat.size = 10;
			txtFormat.color = "0xffffff"
			txtFormat.blockIndent = 0;
			txtFormat.font = "Courier";
			
			box = new Sprite();			
			box.graphics.beginFill(0x000000);
			box.graphics.drawRect(0, 0, 100, 45);
			box.graphics.endFill();
			addChild(box);
			
			txtOutput = new TextField();	
			txtOutput.selectable = false;
			txtOutput.defaultTextFormat = txtFormat;
			txtOutput.height = 45;
			txtOutput.width = 100;									
			box.addChild(txtOutput);
			
			super.cameraMotionTracking(true); // make module listwn to CameraMoveEvents
			
			stage.addEventListener(Event.RESIZE, handleStageResize, false, 0, true); 			
			handleStageResize();
		}			
		
		private var framecount:Number = 0;		
		override protected function onCameraMove(cameraMoveEvent:Object):void {			
			framecount++;
			if(framecount > 2){
				txtOutput.text = "pan  " + validatePan(cameraMoveEvent.pan).toFixed(2) + 
				"\ntilt " + cameraMoveEvent.tilt.toFixed(2) + 
				"\nfov  " + cameraMoveEvent.fieldOfView.toFixed(2);
				framecount = 0;
			}
		}				
	
		private function validatePan(pan:Number):Number {
			return - (pan - Math.round(pan / 360) * 360); 
		}
		
		private function handleStageResize(e:Event = null):void {
			this.box.x = saladoPlayer.managerData.showStatistics ? 70 : 0;
			this.box.y = 0;
			pointer.x = (stage.stageWidth - pointer.width) * 0.5;
			pointer.y = (stage.stageHeight - pointer.height) * 0.5;
		}		
	}
}