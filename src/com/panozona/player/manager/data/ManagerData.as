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
package com.panozona.player.manager.data {
	
	import com.panosalado.model.*;
	import com.panozona.player.component.*;
	import com.panozona.player.manager.data.actions.*;
	import com.panozona.player.manager.data.global.*;
	import com.panozona.player.manager.data.panoramas.*;
	
	public class ManagerData{
		
		/**
		 * Set to true by default. It will show trace window 
		 * and couse all configuration to be verified and validated.
		 */
		public var debugMode:Boolean = true;
		
		/**
		 * id of panorama that will be loaded,
		 * if not set, SaladoPlayer will load first panorama in line. 
		 */
		public var firstPanorama:String;
		
		/**
		 * Stores size of panorama window, camera limits and initial values.
		 * When some value is set, it will overwrite default values in all panoramas.
		 */
		public const params:Params = new Params(null); // empty path
		public const keyboardCameraData:KeyboardCameraData = new KeyboardCameraData();
		public const inertialMouseCameraData:InertialMouseCameraData = new InertialMouseCameraData();
		public const arcBallCameraData:ArcBallCameraData = new ArcBallCameraData();
		public const autorotationCameraData:AutorotationCameraData = new AutorotationCameraData();
		public const simpleTransitionData:SimpleTransitionData = new SimpleTransitionData();
		
		public const traceData:TraceData = new TraceData();
		public const statsData:StatsData = new StatsData();
		public const brandingData:BrandingData = new BrandingData();
		
		public const panoramasData:Vector.<PanoramaData> = new Vector.<PanoramaData>();
		public const actionsData:Vector.<ActionData> = new Vector.<ActionData>();
		public const modulesData:Vector.<ComponentData> = new Vector.<ComponentData>();
		public const factoriesData:Vector.<ComponentData> = new Vector.<ComponentData>();
		
		/**
		 * Sets default Field of view limits for global params
		 */
		public function ManagerData() {
			params.minFov = 30;
			params.maxFov = 120;
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
		
		public function getModuleDataByName(name:String):ComponentData{
			for each(var componentData:ComponentData in modulesData) {
				if (componentData.name == name) {
					return componentData;
				}
			}
			return null;
		}
		
		public function getFactoryDataByName(name:String):ComponentData{
			for each(var componentData:ComponentData in factoriesData) {
				if (componentData.name == name) {
					return componentData;
				}
			}
			return null;
		}
		
		/**
		 * Copies param values over all panorama param values that were left default.
		 */
		public function populateGlobalParams():void {
			for each(var panoramaData:PanoramaData in panoramasData) {
				if (isNaN(panoramaData.params.pan))            panoramaData.params.pan = params.pan;
				if (isNaN(panoramaData.params.tilt))           panoramaData.params.tilt = params.tilt;
				if (isNaN(panoramaData.params.fov))            panoramaData.params.fov = params.fov;
				if (isNaN(panoramaData.params.maxPan))         panoramaData.params.maxPan = params.maxPan;
				if (isNaN(panoramaData.params.minPan))         panoramaData.params.minPan = params.minPan;
				if (isNaN(panoramaData.params.maxTilt))        panoramaData.params.maxTilt = params.maxTilt;
				if (isNaN(panoramaData.params.minTilt))        panoramaData.params.minTilt = params.minTilt;
				if (isNaN(panoramaData.params.maxFov))         panoramaData.params.maxFov = params.maxFov;
				if (isNaN(panoramaData.params.minFov))         panoramaData.params.minFov = params.minFov;
				if (isNaN(panoramaData.params.minVerticalFov)) panoramaData.params.minVerticalFov = params.minVerticalFov;
				if (isNaN(panoramaData.params.maxVerticalFov)) panoramaData.params.maxVerticalFov = params.maxVerticalFov;
				if (isNaN(panoramaData.params.boundsWidth))    panoramaData.params.boundsWidth = params.boundsWidth;
				if (isNaN(panoramaData.params.boundsHeight))   panoramaData.params.boundsHeight = params.boundsHeight;
				if (isNaN(panoramaData.params.tierThreshold))  panoramaData.params.tierThreshold = params.tierThreshold;
			}
		}
	}
}