package com.panozona.player.manager{

	import com.panosalado.events.ViewEvent;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import com.panosalado.model.Characteristics;
	import com.panosalado.model.Params;
	import com.panosalado.model.ViewData;		
	import com.panosalado.model.ViewData;
	import com.panosalado.core.PanoSalado;	
	
	import com.panozona.player.manager.data.PanoramaData;
	import com.panozona.player.manager.data.ChildData;
	
	/**	 
	 * @author mstandio
	 */
	public class Manager extends PanoSalado{		
			
		protected var _managerData:ManagerData;						
		
		private var interactionEquivalents:Object = { mouseClick:"onClick", mouseOver:"onOver", mouseOut:"onOut", mousePress:"onPress", mouseRelease:"onRelease", mouseMove:"onMouseMove", mouseDown:"onPress", mouseUp:"onRelease", click:"onClick" };
		
		public function Manager() {						
			super();
		}				
				
		public override function initialize(dependencies:Array):void {
			super.initialize(dependencies);
			
		}
		
		public function setData(value:ManagerData):void {
			if (_managerData === value) return;		
			if (value != null) {
				_managerData = value;
			}
		}									
		
		
		public function loadFirstPanorama():void {									
			if (_managerData.firstPanorama != null && _managerData.firstPanorama.length > 0){
				loadPanoramaById(_managerData.firstPanorama);
			}else {
				if (_managerData.panoramas != null && _managerData.panoramas.length > 0) {
					loadPanoramaById(_managerData.panoramas[0].id);
				}
			}
		}		
		
		public function loadPanoramaById(panoramaId:String):void {
			var panoramaData:PanoramaData = _managerData.getPanoramaById(panoramaId);
			if (panoramaData != null) {										
				super.loadPanorama(panoramaData.params, panoramaData.getChildrenDisplayObjectVector());				
			}			
		}	
		
		/*
		public function getPanoramasLabels():Vector.<String> {
			var labels:Vector.<String> = new Vector.<String>();
			for each (var panoramaData:PanoramaData in  _managerData.panoramas) {
				labels.push(panoramaData.label);
			}			
			return labels;
		}
		*/		
		
		/*
		public function getPanoramasIds():Vector.<String> {		
			var ids:Vector.<String> = new Vector.<String>();
			for each (var panoramaData:PanoramaData in  _managerData.panoramas) {
				ids.push(panoramaData.id);
			}			
			return ids;
		}
		*/
	}
}