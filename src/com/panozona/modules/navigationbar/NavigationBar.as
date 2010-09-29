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
	
	import com.panozona.modules.navigationbar.combobox.*;
	import com.panozona.modules.navigationbar.button.Button;
	import com.panozona.modules.navigationbar.data.BasicButton;
	import com.panozona.modules.navigationbar.data.BonusButton;
	import com.panozona.modules.navigationbar.data.NavigationBarData;
	
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.PositionAlign;
	import com.panozona.player.module.data.PositionMargin;
	
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
		private var btnLeft:Button;
		private var btnRight:Button;
		private var btnUp:Button;
		private var btnDown:Button;
		private var btnZoomIn:Button;
		private var btnZoomOut:Button;
		private var btnDrag:Button;
		private var btnMute:Button;
		private var btnAutorotate:Button;
		private var btnFullscreen:Button;
		
		private var btnsBonus:Array;
		
		// buttons image loading delay fix
		private var bonusButtonsActive:Array; 
		private var isAutorotating:Boolean;
		private var isFullscreen:Boolean;
		
		private var buttonsLoader:Loader;
		private var logoLoader:Loader;
		private var backgroundBarLoader:Loader;
		
		// visible elemends 
		private var buttonsBar:Sprite;
		private var combobox:Combobox;
		private var branding:Sprite;
		private var logo:Sprite;
		private var backgroundBar:Sprite;
		
		private var logoBMD:BitmapData;
		private var backgroundBarBMD:BitmapData;
		private var buttonsBMD:BitmapData;
		
		private var navigationBarData:NavigationBarData;
		
		private var CameraKeyBindingsClass:Class;
		private var AutorotationEventClass:Class;
		private var CameraEventClass:Class;
		private var LoadPanoramaEventClass:Class;
		
		public function NavigationBar() {
			
			super("NavigationBar", 0.4, "Marek Standio", "mstandio@o2.pl", "http://panozona.com/wiki/Module:NavigationBar");
			
			aboutThisModule = "This is module for interacting with panoramas and for navigating between them.<br>" +
							  "All its elements can be customized (visibility and position) including: custom buttons bitmaps, "+
							  "bar color and alpha / background image, combobox font and colors.<br>" +
							  "Leave branding visible to support this project.";
			
			moduleDescription.addFunctionDescription("changeButton", String, Boolean);
		}	
		
		override protected function moduleReady():void {
			
			navigationBarData = new NavigationBarData(moduleData, debugMode); // allways first
			
			AutorotationEventClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.AutorotationEvent") as Class;
			CameraKeyBindingsClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.model.CameraKeyBindings") as Class;
			CameraEventClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.CameraEvent") as Class;
			LoadPanoramaEventClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.LoadPanoramaEvent") as Class;
			
			saladoPlayer.manager.addEventListener(LoadPanoramaEventClass.PANORAMA_STARTED_LOADING, onPanoramaStartedLoading, false, 0 , true);
			saladoPlayer.manager.addEventListener(LoadPanoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0 , true);
			saladoPlayer.manager.addEventListener(AutorotationEventClass.AUTOROTATION_STARTED, onAutorotationStarted, false, 0 , true);
			saladoPlayer.manager.addEventListener(AutorotationEventClass.AUTOROTATION_STOPPED, onAutorotationStopped, false, 0 , true);
			saladoPlayer.manager.addEventListener(CameraEventClass.ENABLED_CHANGE, onDragEnabledChanged, false, 0 , true);
			
			
			if(navigationBarData.backgroundBar.visible){
				backgroundBar = new Sprite();				
				backgroundBar.alpha = navigationBarData.backgroundBar.alpha;
				backgroundBar.mouseEnabled = false;
				if (navigationBarData.backgroundBar.path != null){
					backgroundBarLoader = new Loader();
					backgroundBarLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, backgroundBarImageLost, false, 0 , true);
					backgroundBarLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, backgroundBarImageLoaded, false, 0 , true);
					backgroundBarLoader.load(new URLRequest(navigationBarData.backgroundBar.path));
				}
				addChild(backgroundBar);
			}
			
			if(navigationBarData.branding.visible){
				branding = new Sprite();
				var brand1:Sprite = new Sprite();
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
				addChild(branding);
			}
			
			if (navigationBarData.logo.visible){
				logo = new Sprite();
				logoLoader = new Loader();
				logoLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, logoImageLost, false, 0 , true);
				logoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, logoImageLoaded, false, 0 , true);
				logoLoader.load(new URLRequest(navigationBarData.logo.path));
				if (navigationBarData.logo.url != null) {
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
				buttonsBar = new Sprite();
				addChild(buttonsBar);
				bonusButtonsActive = new Array(); // buttons image loading delay fix
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
			logoLoader.unload();
			logoLoader = null;
			logo.addChild(new Bitmap(logoBMD));						
		}
		
		private function backgroundBarImageLost(error:IOErrorEvent):void {
			printError(error.toString());
			// TODO: wait, AND retry
		}
		
		private function backgroundBarImageLoaded(e:Event):void {			
			backgroundBarBMD = new BitmapData(backgroundBarLoader.width, backgroundBarLoader.height,true,0);
			backgroundBarBMD.draw(backgroundBarLoader);
			backgroundBarLoader.unload();
			backgroundBarLoader = null;
			placeBackgroundBar();			
		}
		
		private function buttonsImageLost(error:IOErrorEvent):void {
			printError(error.toString());
			// TODO: wait, AND retry <-- THIS IS VERY IMPORTANT
		}
		
		private function buttonsImageLoaded(e:Event):void {
			
			buttonsBMD = new BitmapData(buttonsLoader.width, buttonsLoader.height, true,0);
 			buttonsBMD.draw(buttonsLoader.content);
			
			buttonsLoader.unload();
			buttonsLoader = null;
			
			var buttonsArray:Array = new Array();
			
			btnLeft = new Button("left", leftPress, leftRelease);
			btnLeft.setBitmaps(getButtonBitmap(buttonsBMD, 0), getButtonBitmap(buttonsBMD, 10));
			buttonsArray.push(btnLeft);
			
			btnRight = new Button("right", rightPress, rightRelease);
			btnRight.setBitmaps(getButtonBitmap(buttonsBMD,1), getButtonBitmap(buttonsBMD,11));
			buttonsArray.push(btnRight);
			
			btnUp = new Button("up", upPress, upRelease);
			btnUp.setBitmaps(getButtonBitmap(buttonsBMD,2), getButtonBitmap(buttonsBMD,12));
			buttonsArray.push(btnUp);
			
			btnDown = new Button("down", downPress, downRelease);
			btnDown.setBitmaps(getButtonBitmap(buttonsBMD,3), getButtonBitmap(buttonsBMD,13));
			buttonsArray.push(btnDown);
			
			btnZoomIn = new Button("in", zoominPress, zoominRelease);
			btnZoomIn.setBitmaps(getButtonBitmap(buttonsBMD,4), getButtonBitmap(buttonsBMD,14));
			buttonsArray.push(btnZoomIn);
			
			btnZoomOut = new Button("out", zoomoutPress, zoomoutRelease);
			btnZoomOut.setBitmaps(getButtonBitmap(buttonsBMD,5), getButtonBitmap(buttonsBMD,15));
			buttonsArray.push(btnZoomOut);
			
			btnDrag = new Button("drag", dragToggle);
			btnDrag.setBitmaps(getButtonBitmap(buttonsBMD,6), getButtonBitmap(buttonsBMD,16));
			buttonsArray.push(btnDrag);
			
			//btnMute = new Button("mute",);
			//btnMute.setBitmaps(getButtonBitmap(buttonsBMD,7), getButtonBitmap(buttonsBMD,17));
			//buttonsArray.push(btnMute);
			
			btnAutorotate = new Button("autorotation", autorotateToggle);
			btnAutorotate.setBitmaps(getButtonBitmap(buttonsBMD,8), getButtonBitmap(buttonsBMD,18));
			buttonsArray.push(btnAutorotate);
			
			// flashplayer bug - fullscreen has to use MouseEvent.MOUSE_UP
			btnFullscreen = new Button("fullscreen", null, fullscreenToggle);
			btnFullscreen.setBitmaps(getButtonBitmap(buttonsBMD,9), getButtonBitmap(buttonsBMD,19));
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
						btn.setBitmaps(getButtonBitmap(buttonsBMD,20), getButtonBitmap(buttonsBMD,30));
					break;
					case "b":
						btn = new Button("b", getBonusButtonFunction(bonusButton.action));
						btn.setBitmaps(getButtonBitmap(buttonsBMD,21), getButtonBitmap(buttonsBMD,31));
					break;
					case "c":
						btn = new Button("c", getBonusButtonFunction(bonusButton.action));
						btn.setBitmaps(getButtonBitmap(buttonsBMD,22), getButtonBitmap(buttonsBMD,32));
					break;
					case "d":
						btn = new Button("d", getBonusButtonFunction(bonusButton.action));
						btn.setBitmaps(getButtonBitmap(buttonsBMD,23), getButtonBitmap(buttonsBMD,33));
					break;
					case "e":
						btn = new Button("e", getBonusButtonFunction(bonusButton.action));
						btn.setBitmaps(getButtonBitmap(buttonsBMD,24), getButtonBitmap(buttonsBMD,34));
					break;
					case "f":
						btn = new Button("f", getBonusButtonFunction(bonusButton.action));
						btn.setBitmaps(getButtonBitmap(buttonsBMD,25), getButtonBitmap(buttonsBMD,35));
					break;
					case "g":
						btn = new Button("g", getBonusButtonFunction(bonusButton.action));
						btn.setBitmaps(getButtonBitmap(buttonsBMD,26), getButtonBitmap(buttonsBMD,36));
					break;
					case "h":
						btn = new Button("h", getBonusButtonFunction(bonusButton.action));
						btn.setBitmaps(getButtonBitmap(buttonsBMD,27), getButtonBitmap(buttonsBMD,37));
					break;
					case "i":
						btn = new Button("i", getBonusButtonFunction(bonusButton.action));
						btn.setBitmaps(getButtonBitmap(buttonsBMD,28), getButtonBitmap(buttonsBMD,38));
					break;
					case "j":
						btn = new Button("j", getBonusButtonFunction(bonusButton.action));
						btn.setBitmaps(getButtonBitmap(buttonsBMD,29), getButtonBitmap(buttonsBMD,39));
					break;
				}
				buttonsArray.push(btn);
				btnsBonus.push(btn);
			}
			
			var buttonX:int = 0;
			for each (var button:Button in buttonsArray) {
				if (button != null) {
					button.x = buttonX;
					buttonsBar.addChild(button);
					buttonX += button.width
				}
			}
			
			// buttons image loading delay fix
			for each (var btn2:Button in btnsBonus) {
				if (bonusButtonsActive[btn2.buttonName] != undefined) {
					btn2.setActive(bonusButtonsActive[btn2.buttonName]);
				}
			}						
			btnAutorotate.setActive(isAutorotating);
			btnFullscreen.setActive(isFullscreen);
			
			bonusButtonsActive = null;			
			placeButtons();
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
			if (navigationBarData.backgroundBar.visible){
				placeBackgroundBar();
			}
			if (navigationBarData.buttons.visible) {
				placeButtons();
			}
			if(navigationBarData.combobox.visible){
				placeSprite(combobox, navigationBarData.combobox.align, navigationBarData.combobox.margin);
			}
			if (navigationBarData.logo.visible) {
				placeSprite(logo, navigationBarData.logo.align, navigationBarData.logo.margin);
			}
			if(navigationBarData.branding.visible){
				placeSprite(branding, navigationBarData.branding.align, navigationBarData.branding.margin);
			}
			if (stage.displayState == StageDisplayState.FULL_SCREEN) {
				if (btnFullscreen != null){
					btnFullscreen.setActive(true);				
				}else {
					isAutorotating = true;
				}
			}else {
				if (btnFullscreen != null){
					btnFullscreen.setActive(false);				
				}else {
					isAutorotating = false;
				}
			}
		}
		
		private function placeButtons():void {
			placeSprite(buttonsBar, navigationBarData.buttons.align, navigationBarData.buttons.margin);
		}
		
		private function placeBackgroundBar():void {
			backgroundBar.graphics.clear();
			if (navigationBarData.backgroundBar.path == null ) {
				backgroundBar.graphics.beginFill(navigationBarData.backgroundBar.color);
			}else if ( backgroundBarBMD != null){
				backgroundBar.graphics.beginBitmapFill(backgroundBarBMD, null, true);
			}
			backgroundBar.graphics.drawRect(0, 0, boundsWidth, navigationBarData.backgroundBar.height);
			backgroundBar.graphics.endFill();
			placeSprite(backgroundBar, navigationBarData.backgroundBar.align, navigationBarData.backgroundBar.margin);
		}
		
		private function placeSprite(sprite:Sprite, positionAlign:PositionAlign, positionMargin:PositionMargin):void {
			if (positionAlign.horizontal == PositionAlign.RIGHT) {
				sprite.x = boundsWidth - sprite.width;
			}else if (positionAlign.horizontal == PositionAlign.LEFT) {
				sprite.x = 0;
			}else if (positionAlign.horizontal == PositionAlign.CENTER) {
				sprite.x = (boundsWidth - sprite.width) * 0.5;				
			}
			if (positionAlign.vertical == PositionAlign.BOTTOM) {
				sprite.y = boundsHeight - sprite.height;
			}else if (positionAlign.vertical == PositionAlign.TOP) {
				sprite.y = 0;
			}else if (positionAlign.vertical == PositionAlign.MIDDLE) {
				sprite.y = (boundsHeight - sprite.height) * 0.5;
			}
			sprite.x += positionMargin.left;
			sprite.x -= positionMargin.right;
			sprite.y += positionMargin.top;			
			sprite.y -= positionMargin.bottom;
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
		
		private function onAutorotationStarted(loadPanoramaEvent:Object):void {
			if (btnAutorotate != null) {
				btnAutorotate.setActive(true);
			}else {
				isAutorotating = true;
			}
		}
		
		private function onAutorotationStopped(loadPanoramaEvent:Object):void {
			if (btnAutorotate != null) {
				btnAutorotate.setActive(false);
			}else {
				isAutorotating = false;
			}
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
		
		private function gotoPanoSalado(e:Event):void {
			var request:URLRequest = new URLRequest("http://panosalado.com/");
			try {
				navigateToURL(request, '_BLANK');
			} catch (e:Error) {
				printWarning("Could not open http://panosalado.com/");
			}
		}
		
		private function gotoLogoUrl(e:Event):void {
			var request:URLRequest = new URLRequest("http://"+navigationBarData.logo.url);
			try {
				navigateToURL(request, '_BLANK');
			} catch (e:Error) {
				printWarning("Could not open "+navigationBarData.logo.url);
			}
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function changeButton(name:String, active:Boolean):void {
			if (bonusButtonsActive != null) { // when NavigationBar is not builded yet
				bonusButtonsActive[name] = active;
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