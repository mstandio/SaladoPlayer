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
	
	import com.panozona.modules.navigationbar.combobox.ComboboxEvent;
	import com.panozona.modules.navigationbar.combobox.Combobox;
	import com.panozona.modules.navigationbar.combobox.ComboboxStyle;
	import com.panozona.modules.navigationbar.button.Button;
		
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import com.panozona.player.module.Module;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class NavigationBar extends Module{
		
		
	[Embed(source="assets/left_plain.png")]
		private static var Bitmap_left_plain:Class;				
	[Embed(source="assets/left_press.png")]		
		private static var Bitmap_left_press:Class;				
		
	[Embed(source="assets/right_plain.png")]
		private static var Bitmap_right_plain:Class;					
	[Embed(source="assets/right_press.png")]
		private static var Bitmap_right_press:Class;						
		
	[Embed(source="assets/up_plain.png")]
		private static var Bitmap_up_plain:Class;					
	[Embed(source="assets/up_press.png")]
		private static var Bitmap_up_press:Class;				
			
	[Embed(source="assets/down_plain.png")]
		private static var Bitmap_down_plain:Class;						
	[Embed(source="assets/down_press.png")]
		private static var Bitmap_down_press:Class;					
							
	[Embed(source="assets/zoomin_plain.png")]
		private static var Bitmap_zoomin_plain:Class;							
	[Embed(source="assets/zoomin_press.png")]
		private static var Bitmap_zoomin_press:Class;	
		
	[Embed(source="assets/zoomout_plain.png")]
		private static var Bitmap_zoomout_plain:Class;						
	[Embed(source="assets/zoomout_press.png")]
		private static var Bitmap_zoomout_press:Class;				
		
	[Embed(source="assets/autorotate_plain.png")]
		private static var Bitmap_autorotate_plain:Class;						
	[Embed(source="assets/autorotate_press.png")]
		private static var Bitmap_autorotate_press:Class;					
	
	[Embed(source="assets/fullscreen_plain.png")]
		private static var Bitmap_fullscreen_plain:Class;						
	[Embed(source="assets/fullscreen_press.png")]
		private static var Bitmap_fullscreen_press:Class;								
	
	[Embed(source="assets/saladoplayer.png")]
		private static var Bitmap_saladoplayer:Class;				
	[Embed(source="assets/panosalado.png")]		
		private static var Bitmap_panosalado:Class;					
				
		private var	btnLeft:Button;
		private var	btnRight:Button;
		private var	btnUp:Button;
		private var	btnDown:Button;		
		private var	btnZoomIn:Button;
		private var	btnZoomOut:Button;
		private var	btnAutorotate:Button;
		private var	btnFullscreen:Button;
			
		private var buttonsBar:Sprite;		
		private var mainBar:Sprite;
		private var combobox:Combobox;		
		private var branding:Sprite;
		
		
			
		public function NavigationBar() {						
			
			super("NavigationBar", 0.1,"http://panozona.com/wiki/NavigationBar");
			
			aboutThisModule = "This is module for simple interaction and navigating between panoramas";
			
			moduleDescription.addFunctionDescription("setVisible",Boolean);
			
		}
		
		override protected function moduleReady():void {			
						
			mainBar = new Sprite();
			addChild(mainBar);
			
			buttonsBar = new Sprite();
			mainBar.addChild(buttonsBar);
			
			btnLeft = new Button(leftPress, leftRelease);		 
			btnLeft.setBitmaps(Bitmap_left_plain, Bitmap_left_plain, Bitmap_left_press);			
			buttonsBar.addChild(btnLeft);
			
			btnRight = new Button(rightPress, rightRelease);
			btnRight.setBitmaps(Bitmap_right_plain,Bitmap_right_plain, Bitmap_right_press);
			buttonsBar.addChild(btnRight);
			
			btnUp = new Button(upPress, upRelease);
			btnUp.setBitmaps(Bitmap_up_plain,Bitmap_up_plain, Bitmap_up_press);
			buttonsBar.addChild(btnUp);
			
			btnDown = new Button(downPress, downRelease);
			btnDown.setBitmaps(Bitmap_down_plain,Bitmap_down_plain, Bitmap_down_press);
			buttonsBar.addChild(btnDown);
			
			btnZoomIn = new Button(zoominPress, zoominRelease);
			btnZoomIn.setBitmaps(Bitmap_zoomin_plain,Bitmap_zoomin_plain, Bitmap_zoomin_press);
			buttonsBar.addChild(btnZoomIn);
			
			btnZoomOut = new Button(zoomoutPress, zoomoutRelease);			
			btnZoomOut.setBitmaps(Bitmap_zoomout_plain, Bitmap_zoomout_plain,Bitmap_zoomout_press);
			buttonsBar.addChild(btnZoomOut);
			/*
			btnAutorotate = new Button(autorotateToggle);
			btnAutorotate.setBitmaps(Bitmap_autorotate_plain, Bitmap_autorotate_plain, Bitmap_autorotate_press);
			btnAutorotate.setActive(getAutorotationState());
			buttonsBar.addChild(btnAutorotate);			
			*/
			btnFullscreen = new Button(fullscreenToggle);
			btnFullscreen.setBitmaps(Bitmap_fullscreen_plain,Bitmap_fullscreen_plain, Bitmap_fullscreen_press);
			buttonsBar.addChild(btnFullscreen);						
			
			var spacing:Number = -3;		
			
			btnLeft.x = 0;			
			btnRight.x = btnLeft.x + btnLeft.width + spacing;			
			btnUp.x = btnRight.x + btnRight.width + spacing;
			btnDown.x = btnUp.x + btnUp.width + spacing;
			btnZoomIn.x = btnDown.x + btnDown.width + spacing;
			btnZoomOut.x = btnZoomIn.x + btnZoomIn.width + spacing;
			//btnAutorotate.x = btnZoomOut.x + btnZoomOut.width + spacing;
			btnFullscreen.x = btnZoomOut.x + btnZoomOut.width + spacing;//btnAutorotate.x + btnAutorotate.width + spacing;
						
			var comboboxStyle:ComboboxStyle = new ComboboxStyle();			
			combobox = new Combobox(saladoPlayer.managerData.panoramasData, comboboxStyle);
			combobox.addEventListener(ComboboxEvent.LABEL_CHANGED, comboBoxLabelChanged, false, 0 , true);			
			mainBar.addChild(combobox);
			combobox.setEnabled(true);
			
			
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
			
			stage.addEventListener(Event.RESIZE, handleStageResize, false, 0, true); 			
			handleStageResize();
		}
		
		
		///////////////////////////////////////////////////////////////////////////////
		// Exposed functions 
		///////////////////////////////////////////////////////////////////////////////
		
		public function setVisible(value:Boolean):void {			
			if(mainBar != null){
				mainBar.visible = value;
			}
		}		
		
		///////////////////////////////////////////////////////////////////////////////
		
		private function comboBoxLabelChanged(e:ComboboxEvent):void{
			loadPanoramaById(e.panoramaData.id);
		}
		
		
		override protected function onPanoramaStartedLoading(loadPanoramaEvent:Object):void {
			combobox.setEnabled(false);
		}		
		
		override protected function onPanoramaLoaded(loadPanoramaEvent:Object):void {						
			combobox.setEnabled(true);
			combobox.setSelected(loadPanoramaEvent.panoramaData)
		}		
		
		private function handleStageResize(e:Event = null):void {					
			mainBar.graphics.clear();
			mainBar.graphics.beginFill(0xffffff);			
			mainBar.graphics.drawRect(0, 0, stage.stageWidth, buttonsBar.height); 			
			mainBar.graphics.endFill();
			mainBar.x = 0;
			mainBar.y = stage.stageHeight - buttonsBar.height - 10;						
			buttonsBar.x = stage.stageWidth - buttonsBar.width - 5; 			
			combobox.x = buttonsBar.x - combobox.width - 30;
			combobox.y = buttonsBar.y +3 ;
			
			branding.x = 5;
			branding.y = (buttonsBar.height - branding.height) * 0.5;			
			
			if (stage.displayState == "fullScreen") {
				btnFullscreen.setActive(true);
			}else {
				btnFullscreen.setActive(false);
			}			
		}		
		
		private function leftPress(e:Event):void {			
			keyLeft(true);
		}				
		private function leftRelease(e:Event):void {			
			keyLeft(false);
		}		
		private function rightPress(e:Event):void {
			keyRight(true);	
		}
		private function rightRelease(e:Event):void {
			keyRight(false);	
		}
		private function upPress(e:Event):void {
			keyUp(true);
		}		
		private function upRelease(e:Event):void {
			keyUp(false);
		}		
		private function downPress(e:Event):void {			
			keyDown(true);
		}
		private function downRelease(e:Event):void {			
			keyDown(false);
		}		
		private function zoominPress(e:Event):void {
			keyIn(true);
		}		
		private function zoominRelease(e:Event):void {
			keyIn(false);
		}		
		private function zoomoutPress(e:Event):void {
			keyOut(true);
		}		
		private function zoomoutRelease(e:Event):void {
			keyOut(false);
		}						
		private function autorotateToggle(e:Event):void {
			toggleAutorotation();
			btnAutorotate.setActive(getAutorotationState());
		}			
		private function fullscreenToggle(e:Event):void {			
			toggleFullscreen();			
		}
		
		private function gotoSaladoPlayer(e:Event):void {						
			var request:URLRequest = new URLRequest("http://github.com/mstandio/SaladoPlayer");
			try {
				navigateToURL(request, '_BLANK');
			} catch (e:Error) {
				printWarning("could not open http://github.com/mstandio/SaladoPlayer");
			}
		}
		
		private function gotoPanoSalado(e:Event = null):void {			
			var request:URLRequest = new URLRequest("http://panosalado.com/");
			try {
				navigateToURL(request, '_BLANK');
			} catch (e:Error) {
				printWarning("could not open http://panosalado.com/");
			}
		}			
	}
}