package com.panosalado.utils {
	
	import com.panosalado.model.ViewData
	import com.panosalado.view.HotspotFlat;
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	
	public class HotspotFlatTransform {
		
		private var _viewData:ViewData;
		
		public function HotspotFlatTransform(viewData: ViewData) {
			this._viewData = viewData
		}
		
		public function setCoords(hotspotFlat:HotspotFlat):void {
			hotspotFlat.x = panToX(hotspotFlat.pan);
			hotspotFlat.y = tiltToY(hotspotFlat.tilt);
		}
		
		private function panToX(pan:Number):int {
			var w:Number = _viewData._boundsWidth;
			var cPan:Number = _viewData._pan;
			var fov:Number = _viewData._fieldOfView;
			pan = validatePanTilt(pan);
			if (inAngleBounds(pan, validatePanTilt(cPan - fov), validatePanTilt(cPan + fov))){
				return Math.round(
					w * 0.5 + 
					(Math.tan((pan - cPan) * __toRadians) * w * 0.5) /
					(Math.tan(fov * 0.5 * __toRadians))
					);
			} else {
				return -99999;
			}
		}
		
		private function tiltToY(tilt:Number):int {
			var w:Number = _viewData._boundsWidth;
			var h:Number = _viewData._boundsHeight;
			var cTilt:Number = _viewData._tilt;
			var fov:Number = _viewData._fieldOfView;
			var vFov:Number = __toDegrees * 2 * Math.atan((h / w) 
			* Math.tan(__toRadians * 0.5 * fov));
			tilt = validatePanTilt(tilt);
			if (inAngleBounds(tilt, validatePanTilt(cTilt - vFov), validatePanTilt(cTilt + vFov))) {
				return Math.round(
					h * 0.5 + 
					(Math.tan((cTilt - tilt) * __toRadians) * h * 0.5) /
					(Math.tan(vFov * 0.5 * __toRadians))
					);
			} else {
				return -99999;
			}
		}
		
		private function inAngleBounds(value:Number, from:Number, to:Number):Boolean {
			var result:Boolean = false;
			if (from > 0 && to < 0) {
				if ((value >= from && value <= 180) || (value >= -180 && value <= to)){
					result = true;
				}
			} else {
				if (value >= from && value <= to) {
					result = true; 
				}
			}
			return result;
		}
		
		private function validatePanTilt(value:Number):Number {
			if (value <= -180) value = (((value + 180) % 360) + 180);
			if (value > 180) value = (((value + 180) % 360) - 180);
			return value;
		}
		
		private var __toDegrees:Number = 180 / Math.PI;
		private var __toRadians:Number = Math.PI / 180;
	}
}