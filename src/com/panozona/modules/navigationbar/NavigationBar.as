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
package com.panozona.modules.navigationbar {
	
	import com.panozona.modules.navigationbar.data.BasicButton;	
	import com.panozona.modules.navigationbar.data.BonusButton;
	import com.panozona.player.module.Module;	
	import com.panozona.modules.navigationbar.combobox.*;	
	import com.panozona.modules.navigationbar.button.Button;
	import com.panozona.modules.navigationbar.data.NavigationBarData;	
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;	
	import flash.display.StageDisplayState;	
	import flash.display.Loader;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;	
	import flash.system.ApplicationDomain;	
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class NavigationBar extends Module{
	
	[Embed(source="assets/saladoplayer.png")]
		private static var Bitmap_saladoplayer:Class;
	[Embed(source="assets/panosalado.png")]
		private static var Bitmap_panosalado:Class;
		
		// basic buttons 
		private var	btnLeft:Button;
		private var	btnRight:Button;
		private var	btnUp:Button;
		private var	btnDown:Button;
		private var	btnZoomIn:Button;
		private var	btnZoomOut:Button;
		private var	btnDrag:Button;
		private var	btnMute:Button;
		private var	btnAutorotate:Button;
		private var	btnFullscreen:Button;
		
		private var btnsBonus:Array;
		private var bonusButtonsAvtive:Array; // cutout loading delay fix
		
		private var buttonsBar:Sprite;
		private var mainBar:Sprite;
		private var combobox:Combobox;
		private var branding:Sprite;
		
		private var navigationBarData:NavigationBarData;
		
		private var loader:Loader;		
		
		private var CameraKeyBindingsClass:Class;
		private var AutorotationEventClass:Class;
		private var CameraEventClass:Class;
		private var LoadPanoramaEventClass:Class;
		
			
		public function NavigationBar() {
			
			super("NavigationBar", 0.3, "Marek Standio", "http://panozona.com/wiki/Module:NavigationBar");
			
			aboutThisModule = "This is module for interaction and navigating between panoramas.<br>" +
							  "It can be extended to with additional buttons";
						
			moduleDescription.addFunctionDescription("changeButton", String, Boolean);	
			
		}	
		
		override protected function moduleReady():void {
						
			navigationBarData = new NavigationBarData(moduleData, debugging); // allways first
			
			AutorotationEventClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.AutorotationEvent") as Class;
			CameraKeyBindingsClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.model.CameraKeyBindings") as Class;
			CameraEventClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.CameraEvent") as Class;
			LoadPanoramaEventClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.LoadPanoramaEvent") as Class;			
						
			saladoPlayer.manager.addEventListener(LoadPanoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0 , true);
			saladoPlayer.manager.addEventListener(LoadPanoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0 , true);
			saladoPlayer.manager.addEventListener(AutorotationEventClass.AUTOROTATION_STARTED, onAutorotationStarted, false, 0 , true);
			saladoPlayer.manager.addEventListener(AutorotationEventClass.AUTOROTATION_STOPPED, onAutorotationStopped, false, 0 , true);
			saladoPlayer.manager.addEventListener(CameraEventClass.ENABLED_CHANGE, onDragEnabledChanged, false, 0 , true);
			
			bonusButtonsAvtive = new Array(); // cutout loading delay fix
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, cutoutLost, false, 0 , true);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, cutoutLoaded, false, 0 , true);
			loader.load(new URLRequest(navigationBarData.cutout.path));
		}
		
		private function cutoutLost(error:IOErrorEvent):void {
			printError(error.toString());
		}
		
		private function cutoutLoaded(e:Event):void {
			
			var cutoutBMD:BitmapData = new BitmapData(loader.width, loader.height,true,0);
 			cutoutBMD.draw(loader.content);
			
			var buttonsArray:Array = new Array();
			
			btnLeft = new Button("left", leftPress, leftRelease);
			btnLeft.setBitmaps(getButtonBitmap(cutoutBMD, 0), getButtonBitmap(cutoutBMD, 10));
			buttonsArray.push(btnLeft);
			
			btnRight = new Button("right", rightPress, rightRelease);
			btnRight.setBitmaps(getButtonBitmap(cutoutBMD,1), getButtonBitmap(cutoutBMD,11));
			buttonsArray.push(btnRight);
			
			btnUp = new Button("up", upPress, upRelease);
			btnUp.setBitmaps(getButtonBitmap(cutoutBMD,2), getButtonBitmap(cutoutBMD,12));
			buttonsArray.push(btnUp);
			
			btnDown = new Button("down", downPress, downRelease);
			btnDown.setBitmaps(getButtonBitmap(cutoutBMD,3), getButtonBitmap(cutoutBMD,13));
			buttonsArray.push(btnDown);
			
			btnZoomIn = new Button("in", zoominPress, zoominRelease);
			btnZoomIn.setBitmaps(getButtonBitmap(cutoutBMD,4), getButtonBitmap(cutoutBMD,14));
			buttonsArray.push(btnZoomIn);
			
			btnZoomOut = new Button("out", zoomoutPress, zoomoutRelease);
			btnZoomOut.setBitmaps(getButtonBitmap(cutoutBMD,5), getButtonBitmap(cutoutBMD,15));
			buttonsArray.push(btnZoomOut);
			
			btnDrag = new Button("drag", dragToggle);
			btnDrag.setBitmaps(getButtonBitmap(cutoutBMD,6), getButtonBitmap(cutoutBMD,16));
			buttonsArray.push(btnDrag);
			
			//btnMute = new Button("mute",);
			//btnMute.setBitmaps(getButtonBitmap(cutoutBMD,7), getButtonBitmap(cutoutBMD,17));
			//buttonsArray.push(btnMute);
			
			btnAutorotate = new Button("autorotation", autorotateToggle);
			btnAutorotate.setBitmaps(getButtonBitmap(cutoutBMD,8), getButtonBitmap(cutoutBMD,18));
			buttonsArray.push(btnAutorotate);			
			
			// flashplayer bug - fullscreen has to use MouseEvent.MOUSE_UP
			btnFullscreen = new Button("fullscreen", null, fullscreenToggle);
			btnFullscreen.setBitmaps(getButtonBitmap(cutoutBMD,9), getButtonBitmap(cutoutBMD,19));
			buttonsArray.push(btnFullscreen);
			
			for each (var basicButton:BasicButton in navigationBarData.basicButtons.getChildren()) {
				for (var i:int = 0; i < buttonsArray.length; i++ ) {
					if (buttonsArray[i]!= null && basicButton.name == buttonsArray[i].buttonName) {
						// configure here, for now there is only visibility
						if (basicButton.visible == false) {
							buttonsArray[i] = null;
						}
					}
				}
			}
			
			btnsBonus = new Array();
			
			// bonus buttons are named [a][b][c][d][e][f][g][h][i][j]
			for each (var bonusButton:BonusButton in navigationBarData.bonusButtons.getChildren()) {
				var btn:Button;
				switch(bonusButton.name) {
					case "a": 
						btn = new Button("a", getBonusButtonFunction(bonusButton.action));
						btn.setBitmaps(getButtonBitmap(cutoutBMD,20), getButtonBitmap(cutoutBMD,30));
					break;
					case "b":
						btn = new Button("b", getBonusButtonFunction(bonusButton.action));
						btn.setBitmaps(getButtonBitmap(cutoutBMD,21), getButtonBitmap(cutoutBMD,31));
					break;
					case "c":
						btn = new Button("c", getBonusButtonFunction(bonusButton.action));
						btn.setBitmaps(getButtonBitmap(cutoutBMD,22), getButtonBitmap(cutoutBMD,32));
					break;
					case "d":
						btn = new Button("d", getBonusButtonFunction(bonusButton.action));
						btn.setBitmaps(getButtonBitmap(cutoutBMD,23), getButtonBitmap(cutoutBMD,33));
					break;
					case "e":
						btn = new Button("e", getBonusButtonFunction(bonusButton.action));
						btn.setBitmaps(getButtonBitmap(cutoutBMD,24), getButtonBitmap(cutoutBMD,34));
					break;
					case "f":
						btn = new Button("f", getBonusButtonFunction(bonusButton.action));
						btn.setBitmaps(getButtonBitmap(cutoutBMD,25), getButtonBitmap(cutoutBMD,35));
					break;
					case "g":
						btn = new Button("g", getBonusButtonFunction(bonusButton.action));
						btn.setBitmaps(getButtonBitmap(cutoutBMD,26), getButtonBitmap(cutoutBMD,36));
					break;
					case "h":
						btn = new Button("h", getBonusButtonFunction(bonusButton.action));
						btn.setBitmaps(getButtonBitmap(cutoutBMD,27), getButtonBitmap(cutoutBMD,37));
					break;
					case "i":
						btn = new Button("i", getBonusButtonFunction(bonusButton.action));
						btn.setBitmaps(getButtonBitmap(cutoutBMD,28), getButtonBitmap(cutoutBMD,38));
					break;
					case "j":
						btn = new Button("j", getBonusButtonFunction(bonusButton.action));
						btn.setBitmaps(getButtonBitmap(cutoutBMD,29), getButtonBitmap(cutoutBMD,39));
					break;
				}
				buttonsArray.push(btn);
				btnsBonus.push(btn);
			}
			
			loader = null;
			
			mainBar = new Sprite();
			addChild(mainBar);
			
			buttonsBar = new Sprite();
			buttonsBar.alpha = (navigationBarData.bar.alpha > 0) ?  1/navigationBarData.bar.alpha : 1;
			mainBar.addChild(buttonsBar);
			
			var buttonX:int = 0;
			for each (var button:Button in buttonsArray) {
				if (button != null) {
					button.x = buttonX;
					buttonsBar.addChild(button);
					buttonX += button.width
				}
			}
			
			if(navigationBarData.combobox.visible){				
				combobox = new Combobox(saladoPlayer.managerData.panoramasData, navigationBarData.combobox.style);
				combobox.addEventListener(ComboboxEvent.LABEL_CHANGED, comboBoxLabelChanged, false, 0 , true);
				mainBar.addChild(combobox);
				combobox.setEnabled(true);
			}
			
			
			if(navigationBarData.branding.visible){
				branding = new Sprite();
				mainBar.addChild(branding);
				var brand1:Sprite =  new Sprite();
				brand1.useHandCursor = true;
				brand1.buttonMode = true;
				brand1.addChild(new Bitmap(new Bitmap_saladoplayer().bitmapData, "auto", true));
				brand1.addEventListener(MouseEvent.MOUSE_DOWN, gotoSaladoPlayer, false, 0, true);
				branding.addChild(brand1);
				var brand2:Sprite =  new Sprite();
				brand2.useHandCursor = true;
				brand2.buttonMode = true;
				brand2.addChild(new Bitmap(new Bitmap_panosalado().bitmapData, "auto", true));
				brand2.addEventListener(MouseEvent.MOUSE_DOWN, gotoPanoSalado, false, 0, true);
				branding.addChild(brand2);
				brand2.y = brand1.height;
			}			
			
			// cutout loading delay fix
			for each (var btn2:Button in btnsBonus) {					
				if (bonusButtonsAvtive[btn2.buttonName] != undefined) {
					btn2.setActive(bonusButtonsAvtive[btn2.buttonName]);					
				}
			}
			bonusButtonsAvtive = null;		
			
			stage.addEventListener(Event.RESIZE, handleStageResize, false, 0, true);
			handleStageResize();
		}
		
		private function getBonusButtonFunction(actionId:String):Function{
			return function(e:MouseEvent):void {
				saladoPlayer.manager.runAction(actionId);
			}
		}
		
		// ids hardcoded 
		// button id as in:
		// [0 ][1 ][2 ][3 ][4 ][5 ][6 ][7 ][8 ][ 9]
		// [10][11][12][13][14][15][16][17][18][19]
		// [20][21][22][23][24][25][26][27][28][29]
		// [30][31][32][33][34][35][36][37][38][39]
		private function getButtonBitmap(sourceBirmaData:BitmapData, buttonId:int):BitmapData {
			try{
				var bmd:BitmapData = new BitmapData(navigationBarData.cutout.buttonSide, navigationBarData.cutout.buttonSide,true,0);
				bmd.copyPixels(
					sourceBirmaData, 	
					new Rectangle(
						(buttonId % 10) * navigationBarData.cutout.buttonSide + 1*(buttonId % 10), 
						Math.floor(buttonId / 10) * navigationBarData.cutout.buttonSide + 1*Math.floor(buttonId / 10), 
						navigationBarData.cutout.buttonSide, 
						navigationBarData.cutout.buttonSide), 
					new Point(0, 0),
					null,
					null,
					true);
				return bmd;
			}catch (error:Error){
				printError("Wrong cutout size");
			}
			return null;
		}		
		
		private function onPanoramaStartedLoading(loadPanoramaEvent:Object):void {
			if(navigationBarData.combobox.visible && combobox != null){
				combobox.setEnabled(false);
			}
		}
		
		private function onPanoramaLoaded(loadPanoramaEvent:Object):void {
			if(navigationBarData.combobox.visible){
				combobox.setEnabled(true);
				combobox.setSelected(loadPanoramaEvent.panoramaData)
			}
		}
		
		private function onAutorotationStarted(loadPanoramaEvent:Object):void {
			btnAutorotate.setActive(true);
		}
		
		private function onAutorotationStopped(loadPanoramaEvent:Object):void {
			btnAutorotate.setActive(false);
		}
		
		private function onDragEnabledChanged(event:Object):void {
			if (saladoPlayer.managerData.arcBallCameraData.enabled) {
				btnDrag.setActive(true);
			}else {
				btnDrag.setActive(false);
			}
		}
		
		private function comboBoxLabelChanged(e:ComboboxEvent):void{			
			saladoPlayer.manager.loadPanoramaById(e.panoramaData.id);
		}		
		
		private function handleStageResize(e:Event = null):void {
			
			if(navigationBarData.bar.visible){
				mainBar.graphics.clear();
				mainBar.graphics.beginFill(navigationBarData.bar.color,navigationBarData.bar.alpha);
				mainBar.graphics.drawRect(0, 0, saladoPlayer.manager._boundsWidth, buttonsBar.height); 
				mainBar.graphics.endFill();
				mainBar.x = 0;
			}
			
			mainBar.y = saladoPlayer.manager._boundsHeight - buttonsBar.height - 10; // ist better to use than stage.stageHeight
			buttonsBar.x = saladoPlayer.manager._boundsWidth - buttonsBar.width - 5;
			
			if(navigationBarData.combobox.visible){
				combobox.x = buttonsBar.x - combobox.width - 30;
				combobox.y = buttonsBar.y +3 ;
			}
			
			if(navigationBarData.branding.visible){
				branding.x = 5;
				branding.y = (buttonsBar.height - branding.height) * 0.5;
			}
			
			if (stage.displayState == StageDisplayState.FULL_SCREEN) {
				btnFullscreen.setActive(true);
			}else {
				btnFullscreen.setActive(false);
			}
		}
		
		private function leftPress(e:Event):void {
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, CameraKeyBindingsClass.LEFT)); 
		}
		private function leftRelease(e:Event):void {
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, CameraKeyBindingsClass.LEFT)); 
		}
		private function rightPress(e:Event):void {
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, CameraKeyBindingsClass.RIGHT)); 
		}
		private function rightRelease(e:Event):void {
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, CameraKeyBindingsClass.RIGHT)); 
		}
		private function upPress(e:Event):void {
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, CameraKeyBindingsClass.UP)); 
		}
		private function upRelease(e:Event):void {
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, CameraKeyBindingsClass.UP)); 
		}
		private function downPress(e:Event):void {
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, CameraKeyBindingsClass.DOWN)); 
		}
		private function downRelease(e:Event):void {
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, CameraKeyBindingsClass.DOWN)); 
		}
		private function zoominPress(e:Event):void {
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, CameraKeyBindingsClass.IN)); 
		}
		private function zoominRelease(e:Event):void {
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, CameraKeyBindingsClass.IN)); 
		}
		private function zoomoutPress(e:Event):void {
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, CameraKeyBindingsClass.OUT)); 
		}
		private function zoomoutRelease(e:Event):void {
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, CameraKeyBindingsClass.OUT)); 
		}
		
		private function dragToggle(e:Event):void {
			saladoPlayer.manager.toggleMouseCamera();
		}
		
		private function autorotateToggle(e:Event):void {
			saladoPlayer.manager.toggleAutorotation();
		}
		private function fullscreenToggle(e:Event):void {
			stage.displayState = (stage.displayState == StageDisplayState.NORMAL) ? StageDisplayState.FULL_SCREEN : StageDisplayState.NORMAL;
		}
		
		private function gotoSaladoPlayer(e:Event):void {
			var request:URLRequest = new URLRequest("http://panozona.com/");
			try {
				navigateToURL(request, '_BLANK');
			} catch (e:Error) {
				printWarning("Could not open http://panozona.com/");
			}
		}
		
		private function gotoPanoSalado(e:Event = null):void {
			var request:URLRequest = new URLRequest("http://panosalado.com/");
			try {
				navigateToURL(request, '_BLANK');
			} catch (e:Error) {
				printWarning("Could not open http://panosalado.com/");
			}
		}
				
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////

		public function changeButton(name:String, active:Boolean):void {						
			if (bonusButtonsAvtive != null) { // when NavigationBar is not builded yet
				bonusButtonsAvtive[name] = active;				
			}else {				
				for each (var btn1:Button in btnsBonus) {										
					if (btn1.buttonName == name) {
						btn1.setActive(active);
						return;
					}									
				}
			}
		}		
	}
}