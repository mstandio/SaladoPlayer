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
package com.panozona.player.manager.data {	
	
	import com.panosalado.model.ArcBallCameraData;
	import com.panosalado.model.AutorotationCameraData;
	import com.panosalado.model.InertialMouseCameraData;
	import com.panosalado.model.KeyboardCameraData;
	import com.panosalado.model.SimpleTransitionData;
	import com.panosalado.model.Params;
	
	import com.panozona.player.manager.data.*;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class ManagerData{
		
		public var autorotationCameraData:AutorotationCameraData;
		public var arcBallCameraData:ArcBallCameraData;
		public var keyboardCameraData:KeyboardCameraData;
		public var inertialMouseCameraData:InertialMouseCameraData;
		public var simpleTransitionData:SimpleTransitionData;
		
		public var params:Params;         // global params
		public var firstPanorama:String;  // id of first panorama
		public var debugMode:Boolean;     // if show trace and validate configuration and modules
		public var traceData:TraceData;
		public var showStatistics:Boolean;
		
		public var panoramasData:Array;
		public var actionsData:Array;
		public var abstractModulesData:Array;
		
		public function ManagerData() {
			
			autorotationCameraData = new AutorotationCameraData();
			arcBallCameraData = new ArcBallCameraData();
			keyboardCameraData = new KeyboardCameraData();
			inertialMouseCameraData = new InertialMouseCameraData();
			simpleTransitionData = new SimpleTransitionData();
			
			params = new Params(null);
			debugMode = true; // true by default in case of crash on startup
			traceData = new TraceData();			
			panoramasData = new Array;
			actionsData = new Array;
			abstractModulesData = new Array;
		}
		
		public function getPanoramaDataById(id:String):PanoramaData {
			for each(var panoramaData:PanoramaData in panoramasData) {
				if (panoramaData.id == id) {
					return panoramaData;
				}
			}
			return null;
		}
		
		public function getActionDataById(id:String):ActionData{
			for each(var actionData:ActionData in actionsData) {
				if (actionData.id == id) {
					return actionData;
				}
			}
			return null;
		}
		
		public function getAbstractModuleDataByName(moduleName:String):AbstractModuleData{
			for each(var abstractModuleData:AbstractModuleData in abstractModulesData) {
				if (abstractModuleData.moduleName == moduleName) {
					return abstractModuleData;
				}
			}
			return null;
		}
		
		public function populateGlobalDataParams():void {
						
			for each(var panoramaData:PanoramaData in panoramasData) {
				if (isNaN(panoramaData.params.pan))            panoramaData.params.pan = params.pan;
				if (isNaN(panoramaData.params.tilt))           panoramaData.params.tilt = params.tilt;
				if (isNaN(panoramaData.params.fieldOfView))    panoramaData.params.fieldOfView = params.fieldOfView;
				
				if (isNaN(panoramaData.params.maxPan))         panoramaData.params.maxPan = params.maxPan;
				if (isNaN(panoramaData.params.maxTilt))        panoramaData.params.maxTilt = params.maxTilt;
				if (isNaN(panoramaData.params.maxFieldOfView)) panoramaData.params.maxFieldOfView = params.maxFieldOfView;
				
				if (isNaN(panoramaData.params.minPan))         panoramaData.params.minPan = params.minPan;
				if (isNaN(panoramaData.params.minTilt))        panoramaData.params.minTilt = params.minTilt;
				if (isNaN(panoramaData.params.minFieldOfView)) panoramaData.params.minFieldOfView = params.minFieldOfView;
				
				if (isNaN(panoramaData.params.boundsWidth))    panoramaData.params.boundsWidth  = params.boundsWidth;
				if (isNaN(panoramaData.params.boundsHeight))   panoramaData.params.boundsHeight = params.boundsHeight;
				
				if (isNaN(panoramaData.params.tierThreshold))  panoramaData.params.tierThreshold = params.tierThreshold;
			}			
		}
	}
}