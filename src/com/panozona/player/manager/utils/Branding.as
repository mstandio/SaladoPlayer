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
package com.panozona.player.manager.utils{
	
	import com.panosalado.events.*;
	import com.panozona.player.*;
	import com.panozona.player.manager.data.global.*;
	import com.panozona.player.manager.utils.*;
	import com.panozona.player.module.data.property.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.ui.*;
	
	public class Branding extends Sprite{
		
		[Embed(source="../assets/powered_by_openpano.png")]
		private static var Bitmap_pbsp:Class;
		
		private var saladoPlayer:SaladoPlayer;
		
		private var brandingButton:Sprite;
		
		public function Branding() {
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}
		
		private function stageReady(e:Event = null):void {
			saladoPlayer = (this.parent as SaladoPlayer);
			
			var menu:ContextMenu = new ContextMenu();
			var item:ContextMenuItem = new ContextMenuItem("Powered by OpenPano");
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, gotoPanoZona, false, 0, true);
			menu.customItems.push(item);
			saladoPlayer.contextMenu = menu;
			
			if(saladoPlayer.managerData.brandingData.visible){
				removeEventListener(Event.ADDED_TO_STAGE, stageReady);
				brandingButton = new Sprite();
				brandingButton.alpha = saladoPlayer.managerData.brandingData.alpha;
				brandingButton.buttonMode = true;
				brandingButton.addChild(new Bitmap(new Bitmap_pbsp().bitmapData, "auto", true));
				brandingButton.addEventListener(MouseEvent.CLICK, gotoPanoZona, false, 0, true);
				addChild(brandingButton);
				
				saladoPlayer.manager.addEventListener(ViewEvent.BOUNDS_CHANGED, handleResize ,false, 0, true);
				handleResize();
			}
		}
		
		private function handleResize(e:Event = null):void {
			if (saladoPlayer.managerData.brandingData.align.horizontal == Align.RIGHT) {
				brandingButton.x = saladoPlayer.manager.boundsWidth - brandingButton.width;
			}else if (saladoPlayer.managerData.brandingData.align.horizontal == Align.LEFT) {
				brandingButton.x = 0;
			}else{ // center
				brandingButton.x = (saladoPlayer.manager.boundsWidth - brandingButton.width)*0.5;
			}
			
			if (saladoPlayer.managerData.brandingData.align.vertical == Align.TOP) {
				brandingButton.y = 0;
			}else if (saladoPlayer.managerData.brandingData.align.vertical == Align.BOTTOM) {
				brandingButton.y = saladoPlayer.manager.boundsHeight- brandingButton.height;
			}else { // middle
				brandingButton.y = (saladoPlayer.manager.boundsHeight - brandingButton.height)*0.5;
			}
			brandingButton.x += saladoPlayer.managerData.brandingData.move.horizontal;
			brandingButton.y += saladoPlayer.managerData.brandingData.move.vertical;
		}
		
		private function gotoPanoZona(e:Event):void {
			try {
				navigateToURL(new URLRequest("http://openpano.org/"), '_BLANK');
			} catch (error:Error) {
				saladoPlayer.traceWindow.printWarning("Could not open: http://openpano.org/");
			}
		}
	}
}