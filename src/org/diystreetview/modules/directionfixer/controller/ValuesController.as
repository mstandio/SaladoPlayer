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
	
	import com.diystreetview.modules.directionfixer.data.*;
	import com.diystreetview.modules.directionfixer.events.*;
	import com.diystreetview.modules.directionfixer.view.*;
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.property.*;
	import flash.display.*;
	import flash.events.*;
	import flash.system.*;
	import flash.utils.*;
	
	public class ValuesController {
		
		private var checkTimer:Timer;
		private var currentPanoramaId:String; // NO.
		
		private var currentDirection:Number = 0;
		private var directionCorrection:Number = 0;
		
		private var displayedHotspots:Object = new Object();
		
		private var _valuesView:ValuesView;
		private var _module:Module;
		
		public function ValuesController(valuesView:ValuesView, module:Module){
			_valuesView = valuesView;
			_module = module;
			
			var LoadPanoramaEventClass:Class = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.LoadPanoramaEvent") as Class;
			_module.saladoPlayer.manager.addEventListener(LoadPanoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			
			_valuesView.directionFixerData.labelToDirection.addEventListener(LabelToDirectionEvent.FOR_CURRENT_LABEL_CHANGED, handleDirectionForCurrentChange, false, 0, true);
			_valuesView.directionFixerData.valuesData.addEventListener(ValuesDataEvent.HOTSPOTS_LOADED_CHANGED, handleHotspotsLoadedChange, false, 0, true);
			
			checkTimer = new Timer(100);
			checkTimer.addEventListener(TimerEvent.TIMER, onTick, false, 0, true);
			
			_module.stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
			
			_module.stage.addEventListener(Event.RESIZE, handleStageResize, false, 0, true);
			handleStageResize();
		}
		
		private function onPanoramaLoaded(loadPanoramaEvent:Object):void {
			
			_valuesView.directionFixerData.valuesData.hotspotsLoaded = false;
			var jumpValue:Number = 0;
			
			// if previous panorama has changed direction 
			if (_valuesView.directionFixerData.labelToDirection.currentLabel != null && directionCorrection != 0) {
				jumpValue -= directionCorrection;
			}
			
			// set data for panorama that is just loaded
			currentPanoramaId = loadPanoramaEvent.panoramaData.id; // NO.
			_valuesView.directionFixerData.labelToDirection.currentLabel = _module.saladoPlayer.managerData.getPanoramaDataById(currentPanoramaId).label;
			
			currentDirection = _module.saladoPlayer.manager.currentDirection;
			directionCorrection = 0;
			
			// if correction for direction exists for new panorama 
			if (_valuesView.directionFixerData.labelToDirection.labelExists(_valuesView.directionFixerData.labelToDirection.currentLabel)) {
				directionCorrection = _valuesView.directionFixerData.labelToDirection.getLabel(_valuesView.directionFixerData.labelToDirection.currentLabel) - currentDirection;
				jumpValue += directionCorrection;
			}
			
			_module.saladoPlayer.manager.jumpToView(_module.saladoPlayer.managerData.getPanoramaDataById(currentPanoramaId).params.pan + jumpValue, NaN, NaN);
			
			// load hotspots i new panorama 
			displayedHotspots = new Object();
			checkTimer.start();
		}
		
		private function onTick(e:Event):void {
			for each (var hotspotData:Object in _module.saladoPlayer.managerData.getPanoramaDataById(currentPanoramaId).hotspotsData) {
				if (displayedHotspots [hotspotData.id] == undefined) {
					displayedHotspots[hotspotData.id] = _module.saladoPlayer.manager.nameToHotspot[hotspotData.id];
				}
			}
			var count:int = 0;
			for each (var obj:DisplayObject in displayedHotspots) {
				if (obj != null) {
					count++;
				}
			}
			_valuesView.directionFixerData.valuesData.hotspotsLoaded =
				(count == _module.saladoPlayer.managerData.getPanoramaDataById(currentPanoramaId).hotspotsData.length);
		}
		
		private function handleHotspotsLoadedChange(e:Event):void {
			if (_valuesView.directionFixerData.valuesData.hotspotsLoaded) {
				checkTimer.stop();
				handleDirectionForCurrentChange();
			}
		}
		
		private function handleDirectionForCurrentChange(e:Event = null):void {
			for each (var hotspotData:Object in _module.saladoPlayer.managerData.getPanoramaDataById(currentPanoramaId).hotspotsData) {
				if (displayedHotspots [hotspotData.id] != undefined) {
					var piOver180:Number = Math.PI / 180;
					var pr:Number = (-1*(-hotspotData.position.pan - directionCorrection - 90)) * piOver180; // "-" couse panosalado counts pan counterclockwise
					var tr:Number = -1*  hotspotData.position.tilt * piOver180;
					var xc:Number = hotspotData.position.distance * Math.cos(pr) * Math.cos(tr);
					var yc:Number = hotspotData.position.distance * Math.sin(tr);
					var zc:Number = hotspotData.position.distance * Math.sin(pr) * Math.cos(tr);
					
					displayedHotspots[hotspotData.id].x = xc;
					displayedHotspots[hotspotData.id].y = yc;
					displayedHotspots[hotspotData.id].z = zc;
					displayedHotspots[hotspotData.id].rotationY = (-hotspotData.position.pan - directionCorrection + hotspotData.transformation.rotationY) * piOver180;
					displayedHotspots[hotspotData.id].rotationX = (hotspotData.position.tilt + hotspotData.transformation.rotationX) * piOver180;
					displayedHotspots[hotspotData.id].rotationZ = hotspotData.transformation.rotationZ * piOver180
				}
			}
		}
		
		private function handleEnterFrame(e:Event = null):void {
			if (_valuesView.directionFixerData.valuesData.state == ValuesData.STATE_INCREMENTING){
				directionCorrection --;
			} else if (_valuesView.directionFixerData.valuesData.state == ValuesData.STATE_DECREMENTING){
				directionCorrection ++;
			}
			if (directionCorrection != 0){
				_valuesView.directionFixerData.labelToDirection.setLabel(
					_valuesView.directionFixerData.labelToDirection.currentLabel,
					validateDirection(currentDirection + directionCorrection));
			}
			displayState();
		}
		
		private function displayState():void {
			_valuesView.txtOutput.text =
			"new dir " + validateDirection(-_module.saladoPlayer.manager.pan + currentDirection + directionCorrection).toFixed(2) +
			"\n\nold dir val " + currentDirection +
			"\nnew dir val " + validateDirection(currentDirection + directionCorrection);
		}
		
		private function validateDirection(value:Number):Number {
			if ( value <= 0 || value  > 360 ) return ((value + 360) % 360);
			return value;
		}
		
		public function handleStageResize(e:Event = null):void {
			if (_valuesView.directionFixerData.settings.align.horizontal == Align.LEFT) {
				_valuesView.txtOutput.x = 0;
			}else if (_valuesView.directionFixerData.settings.align.horizontal == Align.RIGHT) {
				_valuesView.txtOutput.x = _module.boundsWidth - _valuesView.txtOutput.width;
			}else if (_valuesView.directionFixerData.settings.align.horizontal == Align.CENTER) {
				_valuesView.txtOutput.x = (_module.boundsWidth - _valuesView.txtOutput.width) * 0.5;
			}
			
			if (_valuesView.directionFixerData.settings.align.vertical == Align.TOP){
				_valuesView.txtOutput.y = 0;
			}else if (_valuesView.directionFixerData.settings.align.vertical == Align.MIDDLE) {
				_valuesView.txtOutput.y = (_module.boundsHeight - _valuesView.txtOutput.height) * 0.5;
			}else if (_valuesView.directionFixerData.settings.align.vertical == Align.BOTTOM) {
				_valuesView.txtOutput.y = _module.boundsHeight - _valuesView.txtOutput.height;
			}
			
			_valuesView.txtOutput.x += _valuesView.directionFixerData.settings.move.horizontal;
			_valuesView.txtOutput.y += _valuesView.directionFixerData.settings.move.vertical;
		}
	}
}