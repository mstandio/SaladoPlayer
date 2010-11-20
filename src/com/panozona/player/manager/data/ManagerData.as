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
	
	import com.panosalado.model.Params;
	import com.panosalado.model.AutorotationCameraData;
	import com.panosalado.model.SimpleTransitionData;
	import com.panosalado.model.KeyboardCameraData;
	import com.panosalado.model.InertialMouseCameraData;
	import com.panosalado.model.ArcBallCameraData;
	
	import com.panozona.player.manager.data.global.TraceData;
	import com.panozona.player.manager.data.global.BrandingData;
	import com.panozona.player.manager.data.panorama.PanoramaData;
	import com.panozona.player.manager.data.action.ActionData;
	import com.panozona.player.manager.data.module.AbstractModuleData;
	
	/**
	 * Stores all data obtained from i.e. *.xml configuration.
	 * 
	 * @author mstandio
	 */
	public class ManagerData{
		
		/**
		 * Set to true by default. It will show trace window and couse all configuration to be verified and validated. 		 
		 */
		public var debugMode:Boolean; 
		
		/**
		 * Set to false by default. Shows statistics window in upper left corner of panorama.  
		 */
		public var showStats:Boolean;
		
		/**
		 * id of panorama that will be loaded, if not set, SaladoPlayer will load first panorama in line. 
		 */
		public var firstPanorama:String;
		
		private var _params:Params;
		private var _autorotationCameraData:AutorotationCameraData;
		private var _simpleTransitionData:SimpleTransitionData;
		private var _keyboardCameraData:KeyboardCameraData;
		private var _inertialMouseCameraData:InertialMouseCameraData;
		private var _arcBallCameraData:ArcBallCameraData;
		private var _traceData:TraceData;
		private var _brandingData:BrandingData;
		private var _panoramasData:Array;
		private var _actionsData:Array;
		private var _abstractModulesData:Array;
		
		/**
		 * Constructor.
		 */
		public function ManagerData() {
			
			debugMode = true;
			showStats = false;
			
			_params = new Params(null);
			_params.minFov = 30;
			_params.maxFov = 120;
			_autorotationCameraData = new AutorotationCameraData();
			_keyboardCameraData = new KeyboardCameraData();
			_inertialMouseCameraData = new InertialMouseCameraData();
			_arcBallCameraData = new ArcBallCameraData();
			_simpleTransitionData = new SimpleTransitionData();
			_traceData = new TraceData();
			_brandingData = new BrandingData();
			_panoramasData = new Array;
			_actionsData = new Array;
			_abstractModulesData = new Array;
		}
		
		/**
		 * Stores size of panorama window, camera properties limits and initial values.
		 * When some value is set, it will overwrite default values in all panoramas.
		 */
		public function get params():Params {
			return _params;
		}
		
		public function get autorotationCameraData():AutorotationCameraData {
			return _autorotationCameraData;
		}
		
		public function get keyboardCameraData():KeyboardCameraData {
			return _keyboardCameraData;
		}
		
		public function get inertialMouseCameraData():InertialMouseCameraData {
			return _inertialMouseCameraData;
		}
		
		public function get arcBallCameraData():ArcBallCameraData {
			return _arcBallCameraData;
		}
		
		public function get simpleTransitionData():SimpleTransitionData {
			return _simpleTransitionData;
		}
		
		/**
		 * Stores data of trace window.
		 */
		public function get traceData():TraceData{
			return _traceData;
		}
		
		/**
		 * Stores data branding button.
		 */
		public function get brandingData():BrandingData{
			return _brandingData;
		}
		
		/**
		 * Vector of PanoramaData objects.
		 */
		public function get panoramasData():Array{
			return _panoramasData;
		}
		
		/**
		 * Vector of ActionData objects.
		 */
		public function get actionsData():Array{
			return _actionsData;
		}
		
		/**
		 * Array of AbstractModuleData objects.
		 */
		public function get abstractModulesData():Array {
			return _abstractModulesData;
		}
		
		/**
		 * Gets PanoramaData object of panorama of given identifyier.
		 * 
		 * @param	id Identifyier of panorama.
		 * @return  PanoramaData of given id, null if not found.
		 */
		public function getPanoramaDataById(id:String):PanoramaData {
			for each(var panoramaData:PanoramaData in panoramasData) {
				if (panoramaData.id == id) {
					return panoramaData;
				}
			}
			return null;
		}
		
		/**
		 * Gets ActionData object of action of given identifyier.
		 * 		 
		 * @param	id Identifyier of action.
		 * @return  ActionData of given id, null if not found.
		 */
		public function getActionDataById(id:String):ActionData{
			for each(var actionData:ActionData in actionsData) {
				if (actionData.id == id) {
					return actionData;
				}
			}
			return null;
		}	
		
		/**
		 * Gets AbstractModuleData object of module of given name.
		 * 
		 * @param	moduleName Name of module.
		 * @return  ModuleData of given name, null if not found.
		 */
		public function getAbstractModuleDataByName(moduleName:String):AbstractModuleData{
			for each(var abstractModuleData:AbstractModuleData in abstractModulesData) {
				if (abstractModuleData.moduleName == moduleName) {
					return abstractModuleData;
				}
			}
			return null;
		}
		
		/**
		 * Copies set params values over all panorama params values that were left default.
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
				if (isNaN(panoramaData.params.boundsWidth))    panoramaData.params.boundsWidth  = params.boundsWidth;
				if (isNaN(panoramaData.params.boundsHeight))   panoramaData.params.boundsHeight = params.boundsHeight;
				if (isNaN(panoramaData.params.tierThreshold))  panoramaData.params.tierThreshold = params.tierThreshold;
			}
		}
	}
}