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
	
	import com.panozona.player.module.data.ModuleData;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageDisplayState;
	import flash.display.Loader;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.ApplicationDomain;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	import com.panozona.modules.navigationbar.combobox.*;
	import com.panozona.modules.navigationbar.button.BitmapButton;
	import com.panozona.modules.navigationbar.data.Button;
	import com.panozona.modules.navigationbar.data.ExtraButton;
	import com.panozona.modules.navigationbar.data.NavigationBarData;
	
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class NavigationBar extends Module{
	
	[Embed(source="assets/saladoplayer.png")]
		private static var Bitmap_saladoplayer:Class;
	[Embed(source="assets/panosalado.png")]
		private static var Bitmap_panosalado:Class;
		
		// basic bitmap buttons 
		private var bitBtnLeft:BitmapButton;
		private var bitBtnRight:BitmapButton;
		private var bitBtnUp:BitmapButton;
		private var bitBtnDown:BitmapButton;
		private var bitBtnIn:BitmapButton;
		private var bitBtnOut:BitmapButton;
		private var bitBtnDrag:BitmapButton;
		private var bitBtnMute:BitmapButton;
		private var bitBtnAutorotate:BitmapButton;
		private var bitBtnFullscreen:BitmapButton;
		
		// extra bitmap buttons
		private var bitmapButtonsExtra:Array;
		
		// buttons image loading delay fix
		private var bitmapButtonsExtraActive:Array;
		
		// loaders
		private var buttonsLoader:Loader;
		private var logoLoader:Loader;
		private var barLoader:Loader;
		
		// visible elemends 
		private var buttonsGroup:Sprite;
		private var combobox:Combobox;
		private var branding:Sprite;
		private var logo:Sprite;
		private var bar:Sprite;
		
		private var logoBMD:BitmapData;
		private var barBMD:BitmapData;
		private var buttonsBMD:BitmapData;
		
		private var navigationBarData:NavigationBarData;
		
		private var CameraKeyBindingsClass:Class;
		private var AutorotationEventClass:Class;
		private var CameraEventClass:Class;
		private var LoadPanoramaEventClass:Class;
		
		public function NavigationBar() {
			
			super("NavigationBar", 0.5, "Marek Standio", "mstandio@o2.pl", "http://panozona.com/wiki/Module:NavigationBar");
			
			aboutThisModule = "This is module for interacting with panoramas and for navigating between them. " +
							  "All its elements can be customized (visibility and position) including: custom buttons bitmaps, "+
							  "bar color / background image, combobox font and colors.<br>" +
							  "Leave branding visible to support this project.";
			
			moduleDescription.addFunctionDescription("setExtraButtonActive", String, Boolean);
		}	
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			navigationBarData = new NavigationBarData(moduleData, debugMode); // allways first
			
			AutorotationEventClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.AutorotationEvent") as Class;
			CameraKeyBindingsClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.model.CameraKeyBindings") as Class;
			CameraEventClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.CameraEvent") as Class;
			LoadPanoramaEventClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.LoadPanoramaEvent") as Class;
			
			saladoPlayer.manager.addEventListener(LoadPanoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0, true);
			saladoPlayer.manager.addEventListener(LoadPanoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			
			saladoPlayer.managerData.arcBallCameraData.addEventListener(CameraEventClass.ENABLED_CHANGE, onDragEnabledChange, false, 0, true);
			saladoPlayer.managerData.autorotationCameraData.addEventListener(AutorotationEventClass.AUTOROTATION_CHANGE, onIsAutorotatingChange, false, 0, true);
			
			if(navigationBarData.bar.visible){
				bar = new Sprite();
				bar.alpha = navigationBarData.bar.alpha;
				bar.mouseEnabled = false;
				if (navigationBarData.bar.path != null){
					barLoader = new Loader();
					barLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, barImageLost, false, 0 , true);
					barLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, barImageLoaded, false, 0 , true);
					barLoader.load(new URLRequest(navigationBarData.bar.path));
				}
				addChild(bar);
			}
			
			if(navigationBarData.branding.visible){
				branding = new Sprite();
				branding.alpha = navigationBarData.branding.alpha;
				var brand1:Sprite = new Sprite();
				brand1.buttonMode = true;
				brand1.addChild(new Bitmap(new Bitmap_saladoplayer().bitmapData, "auto", true));
				brand1.addEventListener(MouseEvent.MOUSE_DOWN, gotoSaladoPlayer, false, 0, true);
				branding.addChild(brand1);
				var brand2:Sprite =  new Sprite();
				brand2.buttonMode = true;
				brand2.addChild(new Bitmap(new Bitmap_panosalado().bitmapData, "auto", true));
				brand2.addEventListener(MouseEvent.MOUSE_DOWN, gotoPanoSalado, false, 0, true);
				branding.addChild(brand2);
				brand2.y = brand1.height;
				addChild(branding);
			}
			
			if (navigationBarData.logo.visible){
				logo = new Sprite();
				logoLoader = new Loader();
				logoLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, logoImageLost, false, 0 , true);
				logoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, logoImageLoaded, false, 0 , true);
				logoLoader.load(new URLRequest(navigationBarData.logo.path));
				if (navigationBarData.logo.text != null) {
					logo.addEventListener(MouseEvent.MOUSE_DOWN, gotoLogoUrl, false, 0 , true);
					logo.buttonMode = true;
				}else {
					logo.mouseEnabled = false;
				}
				addChild(logo);
			}
			
			if(navigationBarData.combobox.visible){
				combobox = new Combobox(saladoPlayer.managerData.panoramasData, navigationBarData.combobox.style);
				combobox.addEventListener(ComboboxEvent.LABEL_CHANGED, comboBoxLabelChanged, false, 0 , true);
				combobox.setEnabled(true);
				addChild(combobox);
			}
			
			if (navigationBarData.buttons.visible) {
				buttonsGroup = new Sprite();
				addChild(buttonsGroup);
				bitmapButtonsExtraActive = new Array(); // buttons image loading delay fix
				buttonsLoader = new Loader();
				buttonsLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, buttonsImageLost, false, 0 , true);
				buttonsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, buttonsImageLoaded, false, 0 , true);
				buttonsLoader.load(new URLRequest(navigationBarData.buttons.path));
			}
			
			stage.addEventListener(Event.RESIZE, handleStageResize, false, 0, true);
			handleStageResize();
		}
		
		private function logoImageLost(error:IOErrorEvent):void {
			printError(error.toString());
			// TODO: wait, AND retry
		}
		
		private function logoImageLoaded(e:Event):void {
			logoBMD = new BitmapData(logoLoader.width, logoLoader.height, true, 0);
			logoBMD.draw(logoLoader);
			logoLoader = null;
			logo.addChild(new Bitmap(logoBMD));
		}
		
		private function barImageLost(error:IOErrorEvent):void {
			printError(error.toString());
			// TODO: wait, AND retry
		}
		
		private function barImageLoaded(e:Event):void {
			barBMD = new BitmapData(barLoader.width, barLoader.height, true, 0);
			barBMD.draw(barLoader);
			barLoader = null;
			placeBar();
		}
		
		private function buttonsImageLost(error:IOErrorEvent):void {
			printError(error.toString());
			// TODO: wait, AND retry <-- THIS IS VERY IMPORTANT
		}
		
		private function buttonsImageLoaded(e:Event):void {
			
			buttonsBMD = new BitmapData(buttonsLoader.width, buttonsLoader.height, true, 0);
 			buttonsBMD.draw(buttonsLoader.content);
			
			buttonsLoader.unload();
			buttonsLoader = null;
			
			var buttonsArray:Array = new Array();
			
			bitBtnLeft = new BitmapButton("left", leftPress, leftRelease);
			bitBtnLeft.setBitmaps(getButtonBitmap(buttonsBMD, 0), getButtonBitmap(buttonsBMD, 10));
			buttonsArray.push(bitBtnLeft);
			
			bitBtnRight = new BitmapButton("right", rightPress, rightRelease);
			bitBtnRight.setBitmaps(getButtonBitmap(buttonsBMD, 1), getButtonBitmap(buttonsBMD, 11));
			buttonsArray.push(bitBtnRight);
			
			bitBtnUp = new BitmapButton("up", upPress, upRelease);
			bitBtnUp.setBitmaps(getButtonBitmap(buttonsBMD, 2), getButtonBitmap(buttonsBMD, 12));
			buttonsArray.push(bitBtnUp);
			
			bitBtnDown = new BitmapButton("down", downPress, downRelease);
			bitBtnDown.setBitmaps(getButtonBitmap(buttonsBMD, 3), getButtonBitmap(buttonsBMD, 13));
			buttonsArray.push(bitBtnDown);
			
			bitBtnIn = new BitmapButton("in", zoominPress, zoominRelease);
			bitBtnIn.setBitmaps(getButtonBitmap(buttonsBMD, 4), getButtonBitmap(buttonsBMD, 14));
			buttonsArray.push(bitBtnIn);
			
			bitBtnOut = new BitmapButton("out", zoomoutPress, zoomoutRelease);
			bitBtnOut.setBitmaps(getButtonBitmap(buttonsBMD, 5), getButtonBitmap(buttonsBMD, 15));
			buttonsArray.push(bitBtnOut);
			
			bitBtnDrag = new BitmapButton("drag", dragToggle);
			bitBtnDrag.setBitmaps(getButtonBitmap(buttonsBMD, 6), getButtonBitmap(buttonsBMD, 16));
			buttonsArray.push(bitBtnDrag);
			
			if (saladoPlayer.managerData.arcBallCameraData.enabled) {
				bitBtnDrag.setActive(true);
			}
			
			//bitBtnMute = new BitmapButton("mute", muteToggle);
			//bitBtnMute.setBitmaps(getButtonBitmap(buttonsBMD, 7), getButtonBitmap(buttonsBMD, 17));
			//buttonsArray.push(bitBtnMute);
			
			bitBtnAutorotate = new BitmapButton("autorotation", autorotateToggle);
			bitBtnAutorotate.setBitmaps(getButtonBitmap(buttonsBMD, 8), getButtonBitmap(buttonsBMD, 18));
			buttonsArray.push(bitBtnAutorotate);
			
			if (saladoPlayer.managerData.autorotationCameraData.isAutorotating){
				bitBtnAutorotate.setActive(true);
			}
						
			bitBtnFullscreen = new BitmapButton("fullscreen", null, fullscreenToggle);// flashplayer bug - fullscreen has to use MouseEvent.MOUSE_UP
			bitBtnFullscreen.setBitmaps(getButtonBitmap(buttonsBMD, 9), getButtonBitmap(buttonsBMD, 19));
			buttonsArray.push(bitBtnFullscreen);
			
			for each (var basicButton:Button in navigationBarData.buttons.getChildrenOfGivenClass(Button)) {
				for (var i:int = 0; i < buttonsArray.length; i++ ) {
					if (buttonsArray[i]!= null && basicButton.name == buttonsArray[i].buttonName) {
						// configure here, for now there is only visibility
						if (basicButton.visible == false) {
							buttonsArray[i] = null;
						}
					}
				}
			}
			
			bitmapButtonsExtra = new Array();
			
			// bonus buttons are named [a][b][c][d][e][f][g][h][i][j]
			for each (var extraButton:ExtraButton in navigationBarData.buttons.getChildrenOfGivenClass(ExtraButton)) { 
				var bitBtnExtra:BitmapButton;
				switch(extraButton.name) { // TODO: write this in smarter way
					case "a": 
						bitBtnExtra = new BitmapButton("a", getExtraButtonFunction(extraButton.action));
						bitBtnExtra.setBitmaps(getButtonBitmap(buttonsBMD,20), getButtonBitmap(buttonsBMD,30));
					break;
					case "b":
						bitBtnExtra = new BitmapButton("b", getExtraButtonFunction(extraButton.action));
						bitBtnExtra.setBitmaps(getButtonBitmap(buttonsBMD,21), getButtonBitmap(buttonsBMD,31));
					break;
					case "c":
						bitBtnExtra = new BitmapButton("c", getExtraButtonFunction(extraButton.action));
						bitBtnExtra.setBitmaps(getButtonBitmap(buttonsBMD,22), getButtonBitmap(buttonsBMD,32));
					break;
					case "d":
						bitBtnExtra = new BitmapButton("d", getExtraButtonFunction(extraButton.action));
						bitBtnExtra.setBitmaps(getButtonBitmap(buttonsBMD,23), getButtonBitmap(buttonsBMD,33));
					break;
					case "e":
						bitBtnExtra = new BitmapButton("e", getExtraButtonFunction(extraButton.action));
						bitBtnExtra.setBitmaps(getButtonBitmap(buttonsBMD,24), getButtonBitmap(buttonsBMD,34));
					break;
					case "f":
						bitBtnExtra = new BitmapButton("f", getExtraButtonFunction(extraButton.action));
						bitBtnExtra.setBitmaps(getButtonBitmap(buttonsBMD,25), getButtonBitmap(buttonsBMD,35));
					break;
					case "g":
						bitBtnExtra = new BitmapButton("g", getExtraButtonFunction(extraButton.action));
						bitBtnExtra.setBitmaps(getButtonBitmap(buttonsBMD,26), getButtonBitmap(buttonsBMD,36));
					break;
					case "h":
						bitBtnExtra = new BitmapButton("h", getExtraButtonFunction(extraButton.action));
						bitBtnExtra.setBitmaps(getButtonBitmap(buttonsBMD,27), getButtonBitmap(buttonsBMD,37));
					break;
					case "i":
						bitBtnExtra = new BitmapButton("i", getExtraButtonFunction(extraButton.action));
						bitBtnExtra.setBitmaps(getButtonBitmap(buttonsBMD,28), getButtonBitmap(buttonsBMD,38));
					break;
					case "j":
						bitBtnExtra = new BitmapButton("j", getExtraButtonFunction(extraButton.action));
						bitBtnExtra.setBitmaps(getButtonBitmap(buttonsBMD,29), getButtonBitmap(buttonsBMD,39));
					break;
				}
				buttonsArray.push(bitBtnExtra);
				bitmapButtonsExtra.push(bitBtnExtra);
			}
			
			// buttons image loading delay fix
			for each (var btn2:BitmapButton in bitmapButtonsExtra) {
				if (bitmapButtonsExtraActive[btn2.buttonName] != undefined) {
					btn2.setActive(bitmapButtonsExtraActive[btn2.buttonName]);
				}
			}			
			bitmapButtonsExtraActive = null;
			
			
			// assebmle all buttons
			var buttonX:int = 0;
			for each (var button:BitmapButton in buttonsArray) {
				if (button != null) {
					button.x = buttonX;
					buttonsGroup.addChild(button);
					buttonX += button.width
				}
			}		
			
			placeButtons();
		}
		
		private function getExtraButtonFunction(actionId:String):Function{
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
			var bmd:BitmapData = new BitmapData(navigationBarData.buttons.buttonSize.width, navigationBarData.buttons.buttonSize.height,true,0);
			bmd.copyPixels(
				sourceBirmaData,
				new Rectangle(
					(buttonId % 10) * navigationBarData.buttons.buttonSize.width + 1 * (buttonId % 10), 
					Math.floor(buttonId / 10) * navigationBarData.buttons.buttonSize.height + 1 * Math.floor(buttonId / 10),
					navigationBarData.buttons.buttonSize.width,
					navigationBarData.buttons.buttonSize.height),
				new Point(0, 0),
				null,
				null,
				true);
			return bmd;
		}
		
		private function handleStageResize(e:Event = null):void {
			if (navigationBarData.bar.visible){
				placeBar();
			}
			if (navigationBarData.buttons.visible) {
				placeButtons();
			}
			if(navigationBarData.combobox.visible){
				placeSprite(combobox, navigationBarData.combobox.align, navigationBarData.combobox.move);
			}
			if (navigationBarData.logo.visible) {
				placeSprite(logo, navigationBarData.logo.align, navigationBarData.logo.move);
			}
			if(navigationBarData.branding.visible){
				placeSprite(branding, navigationBarData.branding.align, navigationBarData.branding.move);
			}
			if (bitBtnFullscreen != null){				
				bitBtnFullscreen.setActive(stage.displayState == StageDisplayState.FULL_SCREEN);				
			}
		}
		
		private function placeButtons():void {
			placeSprite(buttonsGroup, navigationBarData.buttons.align, navigationBarData.buttons.move);
		}
		
		private function placeBar():void {
			bar.graphics.clear();
			if (navigationBarData.bar.path == null ) {
				bar.graphics.beginFill(navigationBarData.bar.color);
			}else if ( barBMD != null){
				bar.graphics.beginBitmapFill(barBMD, null, true);
			}else {
				return;
			}
			bar.graphics.drawRect(
				0, 
				0, 
				(isNaN(navigationBarData.bar.size.width) ? boundsWidth : navigationBarData.bar.size.width), 
				navigationBarData.bar.size.height);
			bar.graphics.endFill();
			placeSprite(bar, navigationBarData.bar.align, navigationBarData.bar.move);
		}
		
		private function placeSprite(sprite:Sprite, align:Align, move:Move):void {
			if (align.horizontal == Align.RIGHT) {
				sprite.x = boundsWidth - sprite.width;
			}else if (align.horizontal == Align.LEFT) {
				sprite.x = 0;
			}else if (align.horizontal == Align.CENTER) {
				sprite.x = (boundsWidth - sprite.width) * 0.5;
			}
			if (align.vertical == Align.BOTTOM) {
				sprite.y = boundsHeight - sprite.height;
			}else if (align.vertical == Align.TOP) {
				sprite.y = 0;
			}else if (align.vertical == Align.MIDDLE) {
				sprite.y = (boundsHeight - sprite.height) * 0.5;
			}
			sprite.x += move.horizontal;
			sprite.y += move.vertical;
		}
		
		private function onPanoramaStartedLoading(loadPanoramaEvent:Object):void {
			if(navigationBarData.combobox.visible && combobox != null){
				combobox.setEnabled(false);
			}
		}
		
		private function onPanoramaLoaded(loadPanoramaEvent:Object):void {
			if(navigationBarData.combobox.visible && combobox != null){
				combobox.setEnabled(true);
				combobox.setSelected(loadPanoramaEvent.panoramaData)
			}
		}
		
		private function onIsAutorotatingChange(autorotationEvent:Object):void {			
			if (bitBtnAutorotate != null) {
				bitBtnAutorotate.setActive(saladoPlayer.managerData.autorotationCameraData.isAutorotating);
			}			
		}		
		
		private function onDragEnabledChange(event:Object):void {
			if (saladoPlayer.managerData.arcBallCameraData.enabled) {
				bitBtnDrag.setActive(true);
			}else {
				bitBtnDrag.setActive(false);
			}
		}
		
		private function comboBoxLabelChanged(e:ComboboxEvent):void{
			saladoPlayer.manager.loadPanoramaById(e.panoramaData.id);
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
			if (saladoPlayer.managerData.inertialMouseCameraData.enabled || ! saladoPlayer.managerData.arcBallCameraData.enabled) {
				saladoPlayer.managerData.inertialMouseCameraData.enabled = false;
				saladoPlayer.managerData.arcBallCameraData.enabled = true;
			}else {
				saladoPlayer.managerData.inertialMouseCameraData.enabled = true;
				saladoPlayer.managerData.arcBallCameraData.enabled = false;
			}
		}
		
		private function autorotateToggle(e:Event):void {
			saladoPlayer.managerData.autorotationCameraData.isAutorotating = !saladoPlayer.managerData.autorotationCameraData.isAutorotating;
		}
		private function fullscreenToggle(e:Event):void {
			stage.displayState = (stage.displayState == StageDisplayState.NORMAL) ? StageDisplayState.FULL_SCREEN : StageDisplayState.NORMAL;
		}
		
		private function gotoSaladoPlayer(e:Event):void {
			var request:URLRequest = new URLRequest("http://panozona.com/");
			try {
				navigateToURL(request, '_BLANK');
			} catch (error:Error) {
				printWarning("Could not open http://panozona.com/");
			}
		}
		
		private function gotoPanoSalado(e:Event):void {
			var request:URLRequest = new URLRequest("http://panosalado.com/");
			try {
				navigateToURL(request, '_BLANK');
			} catch (error:Error) {
				printWarning("Could not open http://panosalado.com/");
			}
		}
		
		private function gotoLogoUrl(e:Event):void {
			var request:URLRequest = new URLRequest(navigationBarData.logo.text);
			try {
				navigateToURL(request, '_BLANK');
			} catch (error:Error) {
				printWarning("Could not open "+navigationBarData.logo.text);
			}
		}
		
///////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function setExtraButtonActive(name:String, active:Boolean):void {
			if (bitmapButtonsExtraActive != null) { // buttons image loading delay fix
				bitmapButtonsExtraActive[name] = active;
			}else {
				for each (var btn1:BitmapButton in bitmapButtonsExtra) {
					if (btn1.buttonName == name) {
						btn1.setActive(active);
						return;
					}
				}
			}
		}
	}
}