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
package com.panozona.modules.imagebutton{
	
	import caurina.transitions.Tweener;
	import com.panozona.modules.imagebutton.data.ImageButtonData;
	import com.panozona.modules.imagebutton.data.structure.Button;
	import com.panozona.modules.imagebutton.data.Wrapper;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Move;
	import com.panozona.player.module.Module;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	public class ImageButton extends Module {
		
		private var imageButtondata:ImageButtonData;
		
		private var loaders:Vector.<Loader>;
		private var wrappers:Vector.<Wrapper>;
		
		public function ImageButton(){
			super("ImageButton", "1.0");
			moduleDescription.addFunctionDescription("open", String);
			moduleDescription.addFunctionDescription("close", String);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			imageButtondata = new ImageButtonData(moduleData, saladoPlayer.managerData.debugMode);
			var button:Button;
			wrappers = new Vector.<Wrapper>();
			loaders = new Vector.<Loader>();
			for (var i:int = 0; i < imageButtondata.buttons.getChildrenOfGivenClass(Button).length; i++) {
				button = imageButtondata.buttons.getChildrenOfGivenClass(Button)[i];
				wrappers.push(new Wrapper(button, new Sprite()));
				loaders[i] = new Loader();
				loaders[i].contentLoaderInfo.addEventListener(Event.COMPLETE, buttonLoaded, false, 0, true);
				loaders[i].contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, buttonLost);
				loaders[i].load(new URLRequest(button.path));
			}
			stage.addEventListener(Event.RESIZE, handleStageResize, false, 0, true);
		}
		
		private function handleStageResize(e:Event = null):void {
			for each (var wrapper:Wrapper in wrappers) {
				placeSprite(wrapper.sprite, wrapper.button.align, wrapper.button.move);
			}
		}
		
		private function buttonLoaded(e:Event):void {
			for(var i:int = 0; i < loaders.length; i++){
				if (loaders[i] != null && loaders[i].contentLoaderInfo === e.target) {
					if (loaders[i].contentLoaderInfo.url.match(/^(.*)\.(png|gif|jpg|jpeg)$/i)) {
						
						wrappers[i].sprite.addChild(loaders[i].content);
						
						wrappers[i].sprite.buttonMode = wrappers[i].button.handCursor;
						
						addChild(wrappers[i].sprite);
						placeSprite(wrappers[i].sprite, wrappers[i].button.align, wrappers[i].button.move);
						
						if (wrappers[i].button.text != null) {
							wrappers[i].sprite.addEventListener(MouseEvent.CLICK, getMouseUrlHandler(wrappers[i].button.text));
						}
						if (wrappers[i].button.mouse.onClick != null) {
							wrappers[i].sprite.addEventListener(MouseEvent.CLICK, getMouseEventHandler(wrappers[i].button.mouse.onClick));
						}
						if (wrappers[i].button.mouse.onPress != null) {
							wrappers[i].sprite.addEventListener(MouseEvent.MOUSE_DOWN, getMouseEventHandler(wrappers[i].button.mouse.onPress));
						}
						if (wrappers[i].button.mouse.onRelease != null) {
							wrappers[i].sprite.addEventListener(MouseEvent.MOUSE_UP, getMouseEventHandler(wrappers[i].button.mouse.onRelease));
						}
						if (wrappers[i].button.mouse.onOver != null) {
							wrappers[i].sprite.addEventListener(MouseEvent.ROLL_OVER, getMouseEventHandler(wrappers[i].button.mouse.onOver));
						}
						if (wrappers[i].button.mouse.onOut != null) {
							wrappers[i].sprite.addEventListener(MouseEvent.ROLL_OUT, getMouseEventHandler(wrappers[i].button.mouse.onOut));
						}
						
					}else {
						printError("Not supported file: " + loaders[i].contentLoaderInfo.url);
					}
					
					loaders[i].contentLoaderInfo.removeEventListener(Event.COMPLETE, buttonLoaded);
					loaders[i].contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, buttonLost);
					loaders[i] = null;
				}
			}
		}
		
		private function getMouseUrlHandler(url:String):Function{
			return function(e:MouseEvent):void {
				gotoUrl(url);
			}
		}
		
		private function getMouseEventHandler(actionId:String):Function{
			return function(e:MouseEvent):void {
				saladoPlayer.manager.runAction(actionId);
			}
		}
		
		private function buttonLost(error:IOErrorEvent):void {
			for(var i:int = 0; i < loaders.length; i++){
				if (loaders[i] != null && loaders[i].contentLoaderInfo == error.target) {
					loaders[i].contentLoaderInfo.removeEventListener(Event.COMPLETE, buttonLoaded);
					loaders[i].contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, buttonLost);
					loaders[i] = null;
				}
			}
			printError("Could not load button images: " + error.toString());
		}
		
		private function placeSprite(sprite:Sprite, align:Align, move:Move):void {
			if (align.horizontal == Align.RIGHT) {
				sprite.x = saladoPlayer.manager.boundsWidth - sprite.width;
			}else if (align.horizontal == Align.LEFT) {
				sprite.x = 0;
			}else if (align.horizontal == Align.CENTER) {
				sprite.x = (saladoPlayer.manager.boundsWidth - sprite.width) * 0.5;
			}
			if (align.vertical == Align.BOTTOM) {
				sprite.y = saladoPlayer.manager.boundsHeight - sprite.height;
			}else if (align.vertical == Align.TOP) {
				sprite.y = 0;
			}else if (align.vertical == Align.MIDDLE) {
				sprite.y = (saladoPlayer.manager.boundsHeight - sprite.height) * 0.5;
			}
			sprite.x += move.horizontal;
			sprite.y += move.vertical;
		}
		
		private function gotoUrl(url:String):void {
			var request:URLRequest = new URLRequest(url);
			try {
				navigateToURL(request, '_BLANK');
			} catch (error:Error) {
				printWarning("Could not open " + url);
			}
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function open(buttonId:String):void {
			for each (var wrapper:Wrapper in wrappers) {
				if (wrapper.button.id == buttonId) {
					wrapper.sprite.visible = true;
					Tweener.addTween(wrapper.sprite,{
						alpha:1, 
						transition:wrapper.button.openTween.transition, 
						time:wrapper.button.openTween.time});
					return;
				}
			}
		}
		
		public function close(buttonId:String):void {
			for each (var wrapper:Wrapper in wrappers) {
				if (wrapper.button.id == buttonId) {
					Tweener.addTween(wrapper.sprite, {
						alpha:0,
						transition:wrapper.button.closeTween.transition,
						time:wrapper.button.closeTween.time,
						onComplete:function():void{ wrapper.sprite.visible = false; }});
					return;
				}
			}
		}
	}
}