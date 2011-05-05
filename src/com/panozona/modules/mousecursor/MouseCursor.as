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
package com.panozona.modules.mousecursor {
	
	import com.panozona.modules.mousecursor.data.MouseCursorData;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.ui.Mouse;
	
	public class MouseCursor extends Module{
		
		protected var mouseCursorData:MouseCursorData;
		
		protected var handHover:BitmapData;
		protected var handPress:BitmapData;
		protected var handDrag:BitmapData;
		
		protected var arrowHover:BitmapData;
		protected var arrowPress:BitmapData;
		protected var arrowDrag:BitmapData;
		
		protected var cursorWrapper:Sprite;
		protected var cursor:Bitmap;
		protected var cursorWidth:Number = 1;
		protected var cursorHeight:Number = 1;
		
		protected var dragMode:Boolean;
		
		protected var mousePress:Boolean;
		protected var mousePressMove:Boolean;
		
		protected var startX:Number = 0;
		protected var startY:Number = 0;
		
		public function MouseCursor(){
			super("MouseCursor", "1.0", "http://panozona.com/wiki/Module:MouseCursor");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			mouseCursorData = new MouseCursorData(moduleData, saladoPlayer);
			
			cursor = new Bitmap();
			cursor.visible = false;
			cursorWrapper = new Sprite();
			cursorWrapper.mouseEnabled = false;
			addChild(cursorWrapper);
			
			saladoPlayer.manager.canvasInternal.addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
			saladoPlayer.manager.canvasInternal.addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
			
			saladoPlayer.manager.managedChildren.addEventListener(MouseEvent.ROLL_OVER, onMouseOverHotspots, false, 0, true);
			saladoPlayer.manager.managedChildren.addEventListener(MouseEvent.ROLL_OUT, onMouseOutHotspots, false, 0, true);
			
			saladoPlayer.manager.canvasInternal.addEventListener(MouseEvent.MOUSE_DOWN, onMousePress, false, 0, true);
			saladoPlayer.manager.canvasInternal.addEventListener(MouseEvent.MOUSE_UP, onMouseRelease, false, 0, true);
			
			stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
			
			var cameraEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panosalado.events.CameraEvent") as Class;
			saladoPlayer.managerData.controlData.arcBallCameraData.addEventListener(cameraEventClass.ENABLED_CHANGE, onDragEnabledChange, false, 0, true);
			
			var cursorsLoader:Loader = new Loader();
			cursorsLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, cursorsImageLost, false, 0, true);
			cursorsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, cursorsImageLoaded, false, 0, true);
			cursorsLoader.load(new URLRequest(mouseCursorData.settings.path));
		}
		
		protected function cursorsImageLost(error:IOErrorEvent):void {
			printError(error.text);
		}
		
		protected function cursorsImageLoaded(e:Event):void {
			var bitmapData:BitmapData = new BitmapData((e.target as LoaderInfo).width, (e.target as LoaderInfo).height, true, 0);
			bitmapData.draw((e.target as LoaderInfo).content);
			
			cursorWidth = Math.ceil((bitmapData.width - 2) / 3);
			cursorHeight = Math.ceil((bitmapData.height - 1) / 2);
			
			handHover = new BitmapData(cursorWidth, cursorHeight, true, 0);
			handHover.copyPixels(bitmapData, new Rectangle(0, 0, cursorWidth, cursorHeight), new Point(0, 0), null, null, true);
			
			handPress = new BitmapData(cursorWidth, cursorHeight, true, 0);
			handPress.copyPixels(bitmapData, new Rectangle(cursorWidth + 1, 0, cursorWidth, cursorHeight), new Point(0, 0), null, null, true);
			
			handDrag = new BitmapData(cursorWidth, cursorHeight, true, 0);
			handDrag.copyPixels(bitmapData, new Rectangle(cursorWidth * 2 + 2, 0, cursorWidth, cursorHeight), new Point(0, 0), null, null, true);
			
			arrowHover = new BitmapData(cursorWidth, cursorHeight, true, 0);
			arrowHover.copyPixels(bitmapData, new Rectangle(0, cursorHeight + 1, cursorWidth, cursorHeight), new Point(0, 0), null, null, true);
			
			arrowPress = new BitmapData(cursorWidth, cursorHeight, true, 0);
			arrowPress.copyPixels(bitmapData, new Rectangle(cursorWidth + 1, cursorHeight + 1, cursorWidth, cursorHeight), new Point(0, 0), null, null, true);
			
			arrowDrag = new BitmapData(cursorWidth, cursorHeight, true, 0);
			arrowDrag.copyPixels(bitmapData, new Rectangle(cursorWidth *2 + 2, cursorHeight + 1, cursorWidth, cursorHeight), new Point(0, 0), null, null, true);
			
			drawArrowHover();
			cursor.x = -cursorWidth * 0.5;
			cursor.y = -cursorHeight * 0.5;
		}
		
		protected function onMouseOver(e:Event):void {
			cursor.visible = true;
			Mouse.hide();
		}
		
		protected function onMouseOut(e:Event):void {
			mousePress = false;
			if (dragMode) {
				drawHandHover();
			}else {
				drawArrowHover();
			}
			cursor.visible = false;
			Mouse.show();
		}
		
		protected function onMouseOverHotspots(e:Event):void {
			cursor.visible = false;
			Mouse.show();
		}
		
		protected function onMouseOutHotspots(e:Event):void {
			cursor.visible = true;
			Mouse.hide();
		}
		
		protected function onMousePress(e:Event):void {
			mousePress = true;
			mousePressMove = false;
			startX = mouseX;
			startY = mouseY;
			if (dragMode) {
				drawHandPress();
			}else {
				drawArrowPress();
			}
		}
		
		protected function onMouseRelease(e:Event):void {
			mousePress = false;
			if (dragMode) {
				drawHandHover();
			}else {
				drawArrowHover();
			}
		}
		
		protected function onDragEnabledChange(e:Object):void {
			dragMode = saladoPlayer.managerData.controlData.arcBallCameraData.enabled;
			if (mousePress) {
				if (mousePressMove) {
					if (dragMode) {
						drawHandDrag();
					}else {
						drawArrowDrag();
					}
				}else {
					if (dragMode) {
						drawHandPress();
					}else {
						drawArrowPress()
					}
				}
			}else {
				if (dragMode) {
					drawHandHover();
				}else {
					drawArrowHover();
				}
			}
		}
		
		protected function handleEnterFrame(e:Event):void {
			cursorWrapper.x = mouseX;
			cursorWrapper.y = mouseY;
			if (startY != mouseY || startX != mouseX) {
				if (mousePress && !mousePressMove) {
					mousePressMove = true;
					if (dragMode) {
						drawHandDrag();
					}else {
						drawArrowDrag();
					}
				}
				if (!dragMode && mousePress) {
					cursorWrapper.rotationZ = ( -90 + Math.atan2(startY - mouseY, startX - mouseX) * 180 / Math.PI);
				}else {
					cursorWrapper.rotationZ = 0;
				}
			}
		}
		
		protected function drawArrowHover():void {
			cursor.bitmapData = arrowHover;
			cursorWrapper.addChild(cursor);
		}
		
		protected function drawArrowPress():void {
			cursor.bitmapData = arrowPress;
			cursorWrapper.addChild(cursor);
		}
		
		protected function drawArrowDrag():void {
			cursor.bitmapData = arrowDrag;
			cursorWrapper.addChild(cursor);
		}
		
		protected function drawHandHover():void {
			cursor.bitmapData = handHover;
			cursorWrapper.addChild(cursor);
		}
		
		protected function drawHandPress():void {
			cursor.bitmapData = handPress;
			cursorWrapper.addChild(cursor);
		}
		
		protected function drawHandDrag():void {
			cursor.bitmapData = handDrag;
			cursorWrapper.addChild(cursor);
		}
	}
}