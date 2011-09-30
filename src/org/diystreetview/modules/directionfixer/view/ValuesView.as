/*
Copyright 2011 Marek Standio.

This file is part of DIY streetview player.

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
package org.diystreetview.modules.directionfixer.view {
	
	import com.diystreetview.modules.directionfixer.data.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	public class ValuesView extends Sprite {
		
		public var directionFixerData:DirectionFixerData;
		public var txtOutput:TextField;
		
		private var txtFormat:TextFormat;
		
		public function ValuesView(directionFixerData:DirectionFixerData) {
			
			this.directionFixerData = directionFixerData;
			
			txtFormat = new TextFormat();
			txtFormat.font = "Courier";
			
			txtOutput = new TextField();
			txtOutput.mouseEnabled = false;
			txtOutput.textColor = 0xffffff;
			txtOutput.background = true;
			txtOutput.backgroundColor = 0x000000;
			txtOutput.defaultTextFormat = txtFormat;
			txtOutput.autoSize = TextFieldAutoSize.LEFT
			addChild(txtOutput);
			addEventListener(Event.ADDED_TO_STAGE, stageReady, false, 0, true);
		}
		
		private function stageReady(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp, false, 0, true);
		}
		
		private function keyDown(event:KeyboardEvent):void {
			if (event.keyCode == 88){
				directionFixerData.valuesData.state = ValuesData.STATE_INCREMENTING;
			}else if (event.keyCode == 90) {
				directionFixerData.valuesData.state = ValuesData.STATE_DECREMENTING;
			}else {
				directionFixerData.valuesData.state = ValuesData.STATE_IDLE;
			}
		}
		private function keyUp(event:KeyboardEvent):void {
			directionFixerData.valuesData.state = ValuesData.STATE_IDLE;
		}
	}
}