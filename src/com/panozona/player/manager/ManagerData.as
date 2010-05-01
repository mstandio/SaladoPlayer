package com.panozona.player.manager {
	
	import com.panozona.player.manager.data.*	
	import com.panosalado.model.ArcBallCameraData;
	import com.panosalado.model.AutorotationCameraData;
	import com.panosalado.model.InertialMouseCameraData;
	import com.panosalado.model.KeyboardCameraData;
	import com.panosalado.model.SimpleTransitionData;
	import com.panosalado.model.Params;
	
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
		
		public var panoramas :Vector.<PanoramaData>;      
		public var actions   :Vector.<ActionData>;      
				
		public var params:Params;         // global params 
		
		public var firstPanorama:String; // id of first panorama				
		
		public var useTrace:Boolean;		
		
		public function ManagerData() {						
			
			autorotationCameraData = new AutorotationCameraData();
			arcBallCameraData = new ArcBallCameraData();
			keyboardCameraData = new KeyboardCameraData();
			inertialMouseCameraData = new InertialMouseCameraData();
			simpleTransitionData = new SimpleTransitionData();		
			
			panoramas = new Vector.<PanoramaData>();
			actions   = new Vector.<ActionData>();			
			
			params = new Params(null);												
		}				
		
		public function getPanoramaById(id:String):PanoramaData {
			for each(var panoramaData:PanoramaData in panoramas) {
				if (panoramaData.id == id) {
					return panoramaData;
				}
			}
			return null;
		}
		
		public function getActionById(id:String):ActionData{
			for each(var actionData:ActionData in actions) {
				if (actionData.id == id) {
					return actionData;
				}
			}
			return null;
		}
		
		public function populateGlobalDataParams():void {
			for each(var panoramaData:PanoramaData in panoramas) {				
				if (isNaN(panoramaData.params.pan))                panoramaData.params.pan = params.pan;	
				if (isNaN(panoramaData.params.tilt))               panoramaData.params.tilt = params.tilt;	
				if (isNaN(panoramaData.params.fieldOfView))        panoramaData.params.fieldOfView = params.fieldOfView;					
				
				if (isNaN(panoramaData.params.maximumPan))         panoramaData.params.maximumPan = params.maximumPan;	
				if (isNaN(panoramaData.params.maximumTilt))        panoramaData.params.maximumTilt = params.maximumTilt;	
				if (isNaN(panoramaData.params.maximumFieldOfView)) panoramaData.params.maximumFieldOfView = params.maximumFieldOfView;					
				
				if (isNaN(panoramaData.params.minimumPan))         panoramaData.params.minimumPan = params.minimumPan;	
				if (isNaN(panoramaData.params.minimumTilt))        panoramaData.params.minimumTilt = params.minimumTilt;	
				if (isNaN(panoramaData.params.minimumFieldOfView)) panoramaData.params.minimumFieldOfView = params.minimumFieldOfView;					
				
				if (isNaN(panoramaData.params.boundsWidth))        panoramaData.params.boundsWidth  = params.boundsWidth;
				if (isNaN(panoramaData.params.boundsHeight))       panoramaData.params.boundsHeight = params.boundsWidth;				
				
				if (isNaN(panoramaData.params.tierThreshold))      panoramaData.params.tierThreshold = params.tierThreshold;
			}			
		}	
	}	
}