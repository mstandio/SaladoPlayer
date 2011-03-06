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
package com.panozona.player.manager.utils {
	
	import com.panosalado.events.*;
	import com.panozona.player.*;
	import com.panozona.player.manager.data.*;
	import com.panozona.player.module.data.property.*;
	import flash.display.*;
	import flash.events.*;
	import net.hires.debug.*;
	
	public class Stats extends Sprite{
		
		private var stats:net.hires.debug.Stats;
		private var saladoPlayer:SaladoPlayer;
		
		public function Stats() {
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}
		
		private function stageReady(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			saladoPlayer = (this.parent as SaladoPlayer);
			stats = new net.hires.debug.Stats();
			addChild(stats);
			
			saladoPlayer.manager.addEventListener(ViewEvent.BOUNDS_CHANGED, handleResize ,false, 0, true);
			handleResize();
		}
		
		private function handleResize(e:Event = null):void {
			if (saladoPlayer.managerData.statsData.align.horizontal == Align.RIGHT) {
				stats.x = saladoPlayer.manager.boundsWidth - stats.width;
			}else if (saladoPlayer.managerData.statsData.align.horizontal == Align.LEFT) {
				stats.x = 0;
			}else{ // center
				stats.x = (saladoPlayer.manager.boundsWidth - stats.width)*0.5;
			}
			if (saladoPlayer.managerData.statsData.align.vertical == Align.TOP) {
				stats.y = 0;
			}else if (saladoPlayer.managerData.statsData.align.vertical == Align.BOTTOM) {
				stats.y = saladoPlayer.manager.boundsHeight- stats.height;
			}else { // middle
				stats.y = (saladoPlayer.manager.boundsHeight - stats.height) * 0.5;
			}
			stats.x += saladoPlayer.managerData.statsData.move.horizontal;
			stats.y += saladoPlayer.managerData.statsData.move.vertical;
		}
	}
}