/*
Copyright 2011 Marek Standio.

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
along with SaladoPlayer. If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.modules.buttonbar.controller{
	
	import com.panozona.modules.buttonbar.model.ButtonData;
	import com.panozona.modules.buttonbar.model.structure.Button;
	import com.panozona.modules.buttonbar.model.structure.ExtraButton;
	import com.panozona.modules.buttonbar.view.BarView;
	import com.panozona.modules.buttonbar.view.ButtonView;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Size;
	import com.panozona.player.module.Module;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	public class BarController {
		
		private var _barView:BarView;
		private var _module:Module;
		
		private var cameraKeyBindingsClass:Class;
		private var autorotationEventClass:Class;
		private var cameraEventClass:Class;
		
		private var barBitmapData:BitmapData;
		private var buttonsBitmapData:BitmapData;
		private var buttonSize:Size;
		
		private var buttonsController:Vector.<ButtonController>;
		
		public function BarController(barView:BarView, module:Module){
			_barView = barView;
			_module = module;
			
			buttonsController = new Vector.<ButtonController>();
			buttonSize = new Size(30,30);
			buildButtonsBar();
			
			var ViewEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.ViewEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(ViewEventClass.BOUNDS_CHANGED, handleResize, false, 0, true);
			
			autorotationEventClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.AutorotationEvent") as Class;
			cameraKeyBindingsClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.model.CameraKeyBindings") as Class;
			cameraEventClass = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.CameraEvent") as Class;
			
			_module.saladoPlayer.managerData.controlData.arcBallCameraData.addEventListener(cameraEventClass.ENABLED_CHANGE, onDragEnabledChange, false, 0, true);
			_module.saladoPlayer.managerData.controlData.autorotationCameraData.addEventListener(autorotationEventClass.AUTOROTATION_CHANGE, onIsAutorotatingChange, false, 0, true);
			
			if (_barView.buttonBarData.barData.buttons.listenKeys) {
				_module.saladoPlayer.stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownEvent, false, 0, true);
				_module.saladoPlayer.stage..addEventListener( KeyboardEvent.KEY_UP, keyUpEvent, false, 0, true);
			}
			
			if (_barView.buttonBarData.bar.visible && _barView.buttonBarData.bar.path != null){
				var barLoader:Loader = new Loader();
				barLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, barImageLost, false, 0, true);
				barLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, barImageLoaded, false, 0, true);
				barLoader.load(new URLRequest(_barView.buttonBarData.bar.path));
			}
			
			var buttonsLoader:Loader = new Loader();
			buttonsLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, buttonsImageLost, false, 0, true);
			buttonsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, buttonsImageLoaded, false, 0, true);
			buttonsLoader.load(new URLRequest(_barView.buttonBarData.barData.buttons.path));
		}
		
		public function handleResize(e:Event = null):void {
			
			if (_barView.buttonBarData.barData.buttons.align.horizontal == Align.LEFT) {
				_barView.buttonsContainer.x = 0;
			}else if (_barView.buttonBarData.barData.buttons.align.horizontal == Align.RIGHT) {
				_barView.buttonsContainer.x = _module.saladoPlayer.manager.boundsWidth
					- (buttonSize.width + _barView.buttonBarData.barData.buttons.spacing)
					* (_barView.buttonBarData.barData.buttons.getAllChildren().length);
			}else { // CENTER
				_barView.buttonsContainer.x = (_module.saladoPlayer.manager.boundsWidth
					- (buttonSize.width + _barView.buttonBarData.barData.buttons.spacing)
					* _barView.buttonBarData.barData.buttons.getAllChildren().length) * 0.5;
			}
			if (_barView.buttonBarData.barData.buttons.align.vertical == Align.TOP){
				_barView.buttonsContainer.y = 0;
			}else if (_barView.buttonBarData.barData.buttons.align.vertical == Align.BOTTOM) {
				_barView.buttonsContainer.y = _module.saladoPlayer.manager.boundsHeight - buttonSize.height;
			}else { // MIDDLE
				_barView.buttonsContainer.y = (_module.saladoPlayer.manager.boundsHeight - buttonSize.height) * 0.5;
			}
			_barView.buttonsContainer.x += _barView.buttonBarData.barData.buttons.move.horizontal;
			_barView.buttonsContainer.y += _barView.buttonBarData.barData.buttons.move.vertical;
			
			if (_barView.buttonBarData.bar.visible){
				buildBackgroundBar();
			}
			setButtonActive("fullscreen", _module.saladoPlayer.stage.displayState == StageDisplayState.FULL_SCREEN);
		}
		
		public function setButtonActive(name:String, active:Boolean):void {
			var buttonView:ButtonView;
			for (var i:int = 0; i < _barView.buttonsContainer.numChildren; i++) {
				buttonView = _barView.buttonsContainer.getChildAt(i) as ButtonView;
				if (buttonView.buttonData.button.name == name) {
					buttonView.buttonData.state = active ? ButtonData.STATE_ACTIVE : ButtonData.STATE_PLAIN;
					return;
				}
			}
		}
		
		private function barImageLost(error:IOErrorEvent):void {
			_module.printError(error.toString());
		}
		
		private function barImageLoaded(e:Event):void {
			barBitmapData = new BitmapData((e.target as LoaderInfo).width, (e.target as LoaderInfo).height, true, 0);
			barBitmapData.draw((e.target as LoaderInfo).content);
			buildBackgroundBar();
		}
		
		private function buttonsImageLost(error:IOErrorEvent):void {
			_module.printError(error.toString());
		}
		
		private function buttonsImageLoaded(e:Event):void {
			buttonsBitmapData = new BitmapData((e.target as LoaderInfo).width, (e.target as LoaderInfo).height, true, 0);
			buttonsBitmapData.draw((e.target as LoaderInfo).content);
			buttonSize.width = Math.ceil((buttonsBitmapData.width - 9) / 10);
			buttonSize.height = Math.ceil((buttonsBitmapData.height - 3) / 4);
			updateButtonsBar();
			handleResize();
			displayQuality();
		}
		
		private function buildButtonsBar():void {
			while (_barView.buttonsContainer.numChildren) {
				_barView.buttonsContainer.removeChildAt(0);
			}
			while (buttonsController.length){
				buttonsController.pop();
			}
			var buttonView:ButtonView;
			for each(var button:Button in _barView.buttonBarData.barData.buttons.getAllChildren()) {
				buttonView = new ButtonView(new ButtonData(button), _barView.buttonBarData);
				if (button.name == "left") {
					buttonView.buttonData.onPress = leftPress;
					buttonView.buttonData.onRelease = leftRelease;
				}else if (button.name == "right") {
					buttonView.buttonData.onPress = rightPress;
					buttonView.buttonData.onRelease = rightRelease;
				}else if (button.name == "up") {
					buttonView.buttonData.onPress = upPress;
					buttonView.buttonData.onRelease = upRelease;
				}else if (button.name == "down") {
					buttonView.buttonData.onPress = downPress;
					buttonView.buttonData.onRelease = downRelease;
				}else if (button.name == "in") {
					buttonView.buttonData.onPress = inPress;
					buttonView.buttonData.onRelease = inRelease;
				}else if (button.name == "out") {
					buttonView.buttonData.onPress = outPress;
					buttonView.buttonData.onRelease = outRelease;
				}else if (button.name == "drag") {
					buttonView.buttonData.onPress = dragToggle;
				}else if (button.name == "quality") {
					buttonView.buttonData.onPress = qualityToggle;
				}else if (button.name == "autorotation") {
					buttonView.buttonData.onPress = autorotateToggle;
				}else if (button.name == "fullscreen") {
					buttonView.buttonData.onRelease = fullscreenToggle;
				}else if (
					button.name == "a" ||
					button.name == "b" ||
					button.name == "c" ||
					button.name == "d" ||
					button.name == "e" ||
					button.name == "f" ||
					button.name == "g" ||
					button.name == "h" ||
					button.name == "i" ||
					button.name == "j") {
					if (button is ExtraButton) {
						buttonView.buttonData.onPress = extraButtonFunction(button as ExtraButton);
					}else {
						_module.printError("Not extraButton:" + button.name);
						continue;
					}
				}else {
					_module.printError("Unrecognized button name:" + button.name);
					continue;
				}
				
				buttonsController.push(new ButtonController(buttonView, _module));
				_barView.buttonsContainer.addChild(buttonView);
			}
		}
		
		private function extraButtonFunction(extraButton:ExtraButton):Function {
			return function():void {
				_module.saladoPlayer.manager.runAction(extraButton.action);
			}
		}
		
		private function updateButtonsBar():void {
			var buttonView:ButtonView;
			var lastX:Number = 0;
			for ( var i:int = 0; i < _barView.buttonsContainer.numChildren; i++) {
				buttonView = _barView.buttonsContainer.getChildAt(i) as ButtonView;
				if (buttonView.buttonData.button.name == "left") {
					buttonView.buttonData.bitmapPlain = getButtonBitmap(0);
					buttonView.buttonData.bitmapActive = getButtonBitmap(10);
				}else if (buttonView.buttonData.button.name == "right") {
					buttonView.buttonData.bitmapPlain = getButtonBitmap(1);
					buttonView.buttonData.bitmapActive = getButtonBitmap(11);
				}else if (buttonView.buttonData.button.name == "up") {
					buttonView.buttonData.bitmapPlain = getButtonBitmap(2);
					buttonView.buttonData.bitmapActive = getButtonBitmap(12);
				}else if (buttonView.buttonData.button.name == "down") {
					buttonView.buttonData.bitmapPlain = getButtonBitmap(3);
					buttonView.buttonData.bitmapActive = getButtonBitmap(13);
				}else if (buttonView.buttonData.button.name == "in") {
					buttonView.buttonData.bitmapPlain = getButtonBitmap(4);
					buttonView.buttonData.bitmapActive = getButtonBitmap(14);
				}else if (buttonView.buttonData.button.name == "out") {
					buttonView.buttonData.bitmapPlain = getButtonBitmap(5);
					buttonView.buttonData.bitmapActive = getButtonBitmap(15);
				}else if (buttonView.buttonData.button.name == "drag") {
					buttonView.buttonData.bitmapPlain = getButtonBitmap(6);
					buttonView.buttonData.bitmapActive = getButtonBitmap(16);
				}else if (buttonView.buttonData.button.name == "quality") {
					buttonView.buttonData.bitmapPlain = getButtonBitmap(7);
					buttonView.buttonData.bitmapActive = getButtonBitmap(17);
				}else if (buttonView.buttonData.button.name == "autorotation") {
					buttonView.buttonData.bitmapPlain = getButtonBitmap(8);
					buttonView.buttonData.bitmapActive = getButtonBitmap(18);
				}else if (buttonView.buttonData.button.name == "fullscreen") {
					buttonView.buttonData.bitmapPlain = getButtonBitmap(9);
					buttonView.buttonData.bitmapActive = getButtonBitmap(19);
				}else if (buttonView.buttonData.button.name == "a") {
					buttonView.buttonData.bitmapPlain = getButtonBitmap(20);
					buttonView.buttonData.bitmapActive = getButtonBitmap(30);
				}else if (buttonView.buttonData.button.name == "b") {
					buttonView.buttonData.bitmapPlain = getButtonBitmap(21);
					buttonView.buttonData.bitmapActive = getButtonBitmap(31);
				}else if (buttonView.buttonData.button.name == "c") {
					buttonView.buttonData.bitmapPlain = getButtonBitmap(22);
					buttonView.buttonData.bitmapActive = getButtonBitmap(32);
				}else if (buttonView.buttonData.button.name == "d") {
					buttonView.buttonData.bitmapPlain = getButtonBitmap(23);
					buttonView.buttonData.bitmapActive = getButtonBitmap(33);
				}else if (buttonView.buttonData.button.name == "e") {
					buttonView.buttonData.bitmapPlain = getButtonBitmap(24);
					buttonView.buttonData.bitmapActive = getButtonBitmap(34);
				}else if (buttonView.buttonData.button.name == "f") {
					buttonView.buttonData.bitmapPlain = getButtonBitmap(25);
					buttonView.buttonData.bitmapActive = getButtonBitmap(35);
				}else if (buttonView.buttonData.button.name == "g") {
					buttonView.buttonData.bitmapPlain = getButtonBitmap(26);
					buttonView.buttonData.bitmapActive = getButtonBitmap(36);
				}else if (buttonView.buttonData.button.name == "h") {
					buttonView.buttonData.bitmapPlain = getButtonBitmap(27);
					buttonView.buttonData.bitmapActive = getButtonBitmap(37);
				}else if (buttonView.buttonData.button.name == "i") {
					buttonView.buttonData.bitmapPlain = getButtonBitmap(28);
					buttonView.buttonData.bitmapActive = getButtonBitmap(38);
				}else if (buttonView.buttonData.button.name == "j") {
					buttonView.buttonData.bitmapPlain = getButtonBitmap(29);
					buttonView.buttonData.bitmapActive = getButtonBitmap(39);
				}
				buttonView.x = lastX;
				buttonView.x += buttonView.buttonData.button.move.horizontal;
				buttonView.y += buttonView.buttonData.button.move.vertical;
				lastX += buttonView.width + _barView.buttonBarData.barData.buttons.spacing;
			}
		}
		
		private function buildBackgroundBar():void {
			_barView.backgroundBar.graphics.clear();
			if (_barView.buttonBarData.bar.path == null ) {
				_barView.backgroundBar.graphics.beginFill(_barView.buttonBarData.bar.color);
			}else if ( barBitmapData != null){
				_barView.backgroundBar.graphics.beginBitmapFill(barBitmapData, null, true);
			}else {
				return;
			}
			_barView.backgroundBar.graphics.drawRect(
				0,
				0,
				(isNaN(_barView.buttonBarData.bar.size.width) ? _module.saladoPlayer.manager.boundsWidth : _barView.buttonBarData.bar.size.width),
				_barView.buttonBarData.bar.size.height);
			_barView.backgroundBar.graphics.endFill();
			
			if (_barView.buttonBarData.bar.align.horizontal == Align.LEFT) {
				_barView.backgroundBar.x = 0;
			}else if (_barView.buttonBarData.bar.align.horizontal == Align.RIGHT) {
				_barView.backgroundBar.x = _module.saladoPlayer.manager.boundsWidth - _barView.backgroundBar.width;
			}else { // CENTER
				_barView.backgroundBar.x = (_module.saladoPlayer.manager.boundsWidth - _barView.backgroundBar.width) * 0.5;
			}
			if (_barView.buttonBarData.bar.align.vertical == Align.TOP){
				_barView.backgroundBar.y = 0;
			}else if (_barView.buttonBarData.bar.align.vertical == Align.BOTTOM) {
				_barView.backgroundBar.y = _module.saladoPlayer.manager.boundsHeight - _barView.backgroundBar.height;
			}else { // MIDDLE
				_barView.backgroundBar.y = (_module.saladoPlayer.manager.boundsHeight - _barView.backgroundBar.height) * 0.5;
			}
			_barView.backgroundBar.x += _barView.buttonBarData.bar.move.horizontal;
			_barView.backgroundBar.y += _barView.buttonBarData.bar.move.vertical;
		}
		
		// ids hardcoded 
		// button id as in:
		// [0 ][1 ][2 ][3 ][4 ][5 ][6 ][7 ][8 ][ 9]
		// [10][11][12][13][14][15][16][17][18][19]
		// [20][21][22][23][24][25][26][27][28][29]
		// [30][31][32][33][34][35][36][37][38][39]
		private function getButtonBitmap(buttonId:int):BitmapData {
			var bmd:BitmapData = new BitmapData(buttonSize.width, buttonSize.height, true, 0);
			bmd.copyPixels(
				buttonsBitmapData,
				new Rectangle(
					(buttonId % 10) * buttonSize.width + 1 * (buttonId % 10),
					Math.floor(buttonId / 10) * buttonSize.height + 1 * Math.floor(buttonId / 10),
					buttonSize.width,
					buttonSize.height),
				new Point(0, 0),
				null,
				null,
				true);
			return bmd;
		}
		
		private function onIsAutorotatingChange(autorotationEvent:Object):void {
			setButtonActive("autorotation", _module.saladoPlayer.managerData.controlData.autorotationCameraData.isAutorotating);
		}
		
		private function onDragEnabledChange(event:Object):void {
			setButtonActive("drag", _module.saladoPlayer.managerData.controlData.arcBallCameraData.enabled);
		}
		
		private function leftPress(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, cameraKeyBindingsClass.LEFT));
		}
		private function leftRelease(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, cameraKeyBindingsClass.LEFT));
		}
		private function rightPress(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, cameraKeyBindingsClass.RIGHT));
		}
		private function rightRelease(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, cameraKeyBindingsClass.RIGHT));
		}
		private function upPress(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, cameraKeyBindingsClass.UP));
		}
		private function upRelease(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, cameraKeyBindingsClass.UP));
		}
		private function downPress(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, cameraKeyBindingsClass.DOWN));
		}
		private function downRelease(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, cameraKeyBindingsClass.DOWN));
		}
		private function inPress(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, cameraKeyBindingsClass.IN));
		}
		private function inRelease(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, cameraKeyBindingsClass.IN));
		}
		private function outPress(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, true, 0, cameraKeyBindingsClass.OUT));
		}
		private function outRelease(e:Event):void {
			_module.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, true, 0, cameraKeyBindingsClass.OUT));
		}
		
		private function dragToggle(e:Event = null):void {
			if (_module.saladoPlayer.managerData.controlData.inertialMouseCameraData.enabled ||
				!_module.saladoPlayer.managerData.controlData.arcBallCameraData.enabled) {
				_module.saladoPlayer.managerData.controlData.inertialMouseCameraData.enabled = false;
				_module.saladoPlayer.managerData.controlData.arcBallCameraData.enabled = true;
			}else {
				_module.saladoPlayer.managerData.controlData.inertialMouseCameraData.enabled = true;
				_module.saladoPlayer.managerData.controlData.arcBallCameraData.enabled = false;
			}
		}
		
		private function qualityToggle(e:Event = null):void {
			if (_barView.root.stage.quality.toLowerCase() == StageQuality.HIGH || _barView.root.stage.quality.toLowerCase() == StageQuality.BEST) {
				_barView.root.stage.quality = StageQuality.MEDIUM;
			}else {
				_barView.root.stage.quality = StageQuality.BEST
			}
			displayQuality();
		}
		
		private function displayQuality():void {
			setButtonActive("quality",
			_barView.root.stage.quality.toLowerCase() == StageQuality.HIGH || _barView.root.stage.quality.toLowerCase() == StageQuality.BEST);
		}
		
		private function autorotateToggle(e:Event = null):void {
			_module.saladoPlayer.managerData.controlData.autorotationCameraData.isAutorotating = 
			!_module.saladoPlayer.managerData.controlData.autorotationCameraData.isAutorotating;
		}
		
		private function fullscreenToggle(e:Event = null):void {
			_module.saladoPlayer.stage.displayState = (_module.saladoPlayer.stage.displayState == StageDisplayState.NORMAL) ?
				StageDisplayState.FULL_SCREEN :
				StageDisplayState.NORMAL;
		}
		
		
		private function keyDownEvent(e:KeyboardEvent):void {
			switch( e.keyCode ){
				case cameraKeyBindingsClass.UP:
					setButtonActive("up", true);
				break;
				case cameraKeyBindingsClass.DOWN:
					setButtonActive("down", true);
				break;
				case cameraKeyBindingsClass.LEFT:
					setButtonActive("left", true);
				break;
				case cameraKeyBindingsClass.RIGHT:
					setButtonActive("right", true);
				break;
				case cameraKeyBindingsClass.IN:
					setButtonActive("in", true);
				break;
				case cameraKeyBindingsClass.OUT:
					setButtonActive("out", true);
				break;
			}
		}
		
		private function keyUpEvent(e:KeyboardEvent):void {
			switch( e.keyCode ){
				case cameraKeyBindingsClass.UP:
					setButtonActive("up", false);
				break;
				case cameraKeyBindingsClass.DOWN:
					setButtonActive("down", false);
				break;
				case cameraKeyBindingsClass.LEFT:
					setButtonActive("left", false);
				break;
				case cameraKeyBindingsClass.RIGHT:
					setButtonActive("right", false);
				break;
				case cameraKeyBindingsClass.IN:
					setButtonActive("in", false);
				break;
				case cameraKeyBindingsClass.OUT:
					setButtonActive("out", false);
				break;
			}
		}
	}
}