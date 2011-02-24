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
	
	import com.panozona.player.*;
	import com.panozona.player.manager.data.*;
	import flash.display.*;
	import flash.events.*;
	import net.hires.debug.*;
	
	public class Stats extends Sprite{
		
		private var stats:net.hires.debug.Stats;
		private var startsData:StatsData
		
		public function Stats() {
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}
		
		private function stageReady(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			startsData = (this.parent as SaladoPlayer).managerData.statsData;
			stats = new net.hires.debug.Stats();
			addChild(stats);
			stage.addEventListener(Event.RESIZE, handleStageResize);
			handleStageResize();
		}
		
		private function handleStageResize(e:Event = null):void {
			var boundsWidth:Number = (this.parent as SaladoPlayer).manager.boundsWidth;
			var boundsHeight:Number = (this.parent as SaladoPlayer).manager.boundsHeight;
			if (statsData.align.horizontal == Align.RIGHT) {
				stats.x = boundsWidth - stats.width;
			}else if (statsData.align.horizontal == Align.LEFT) {
				stats.x = 0;
			}else{ // center
				stats.x = (boundsWidth - stats.width)*0.5;
			}
			if (statsData.align.vertical == Align.TOP) {
				stats.y = 0;
			}else if (statsData.align.vertical == Align.BOTTOM) {
				btnOpen.y = boundsHeight- stats.height;
			}else { // middle
				stats.y = (boundsHeight - stats.height) * 0.5;
				
			}
			stats.x += statsData.move.horizontal;
			stats.y += statsData.move.vertical;
		}
	}
}