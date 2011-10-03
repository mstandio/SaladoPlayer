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
package org.diystreetview.modules.directionfixer.controller{
	
	import org.diystreetview.modules.directionfixer.data.*;
	import org.diystreetview.modules.directionfixer.events.*;
	import org.diystreetview.modules.directionfixer.view.*;
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.property.*;
	import flash.display.*;
	import flash.events.*;
	import flash.system.*;
	import flash.utils.*;
	
	public class InOutController {
		
		private var _inOutView:InOutView
		private var _module:Module;
		
		public function InOutController(inOutView:InOutView, module:Module){
			_inOutView = inOutView;
			_module = module;
			
			_inOutView.directionFixerData.inOutData.addEventListener(InOutEvent.OPEN_CHANGED, handleOpenChange, false, 0, true);
			
			_inOutView.closeButton.addEventListener(MouseEvent.CLICK, handleCloseClick, false, 0, true);
			_inOutView.readButton.addEventListener(MouseEvent.CLICK, handleReadClick, false, 0, true);
			_inOutView.writeButton.addEventListener(MouseEvent.CLICK, handleWriteClick, false, 0, true);
			
			_module.stage.addEventListener(Event.RESIZE, handleStageResize, false, 0, true);
			handleStageResize();
		}
		
		public function handleStageResize(e:Event = null):void {
			_inOutView.textField.x = _module.saladoPlayer.manager.boundsWidth - _inOutView.textField.width - 10;
			_inOutView.textField.y = (_module.saladoPlayer.manager.boundsHeight - _inOutView.textField.height) * 0.5;
			_inOutView.closeButton.x = _inOutView.textField.x + _inOutView.textField.width - _inOutView.closeButton.width;
			_inOutView.closeButton.y = _inOutView.textField.y;
			_inOutView.readButton.x = _inOutView.textField.x;
			_inOutView.readButton.y = _inOutView.textField.y + _inOutView.textField.height + 3;
			_inOutView.writeButton.x = _inOutView.textField.x + _inOutView.readButton.width + 3;
			_inOutView.writeButton.y = _inOutView.textField.y + _inOutView.textField.height + 3;
		}
		
		private function handleCloseClick(e:Event):void {
			_inOutView.directionFixerData.inOutData.open = false;
		}
		
		private function handleReadClick(e:Event):void {
			_inOutView.textField.text = readData();
			_inOutView.textField.setSelection(0, _inOutView.textField.text.length);
			System.setClipboard(_inOutView.textField.text);
		}
		
		private function handleWriteClick(e:Event):void {
			writeData(_inOutView.textField.text);
			_inOutView.textField.text = "";
		}
		
		private function handleOpenChange(e:Event):void {
			if (_inOutView.directionFixerData.inOutData.open) {
				_inOutView.visible = true; // herp derp
			}else {
				_inOutView.visible = false;
			}
		}
		
		private function readData():String {
			var result:String = "";
			for (var label:String in _inOutView.directionFixerData.labelToDirection.object) {
				result += label + " " + _inOutView.directionFixerData.labelToDirection.object[label] +"\n";
			}
			return result;
		}
		
		private function writeData(data:String):void {
			_inOutView.directionFixerData.labelToDirection.reset();
			var lines:Array = data.match(/^.+$/gm);
			var fields:Array;
			for each (var line:String in lines) {
				fields = line.match(/\d+/g);
				if (fields.length == 2) {
					_inOutView.directionFixerData.labelToDirection.setLabel(fields[0], fields[1]);
				}else {
					_module.printWarning("Wrong format: " + line);
				}
			}
		}
	}
}