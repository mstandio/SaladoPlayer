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
package com.panozona.player.manager.data.panoramas {
	
	import com.panosalado.model.Params;
	import com.panozona.player.manager.utils.loading.ILoadable;
	
	public class PanoramaData {
		
		/**
		 * Action called on entering this panorama
		 */
		public var onEnter:String;
		
		/**
		 * Action called on transition effect finished in this panorama
		 */
		public var onTransitionEnd:String;
		
		/**
		 * Action called on leaving this panorama
		 */
		public var onLeave:String;
		
		/**
		 * Object where keys are ids of panoramas and values are ids of actions.
		 * Action is executed when entering from panorama of given id.
		 */
		public const onEnterFrom:Object = new Object();
		
		/**
		 * Object where keys are ids of panoramas and values are ids of actions.
		 * Action is executed when transition effect is finished after entering from panorama of given id.
		 */
		public const onTransitionEndFrom:Object = new Object();
		
		/**
		 * Object where keys are ids of panoramas and values are ids of actions.
		 * Action is executed when leaving to panorama of given id.
		 */
		public const onLeaveTo:Object = new Object();
		
		/**
		 * Object where keys are ids of panoramas and values are ids of actions.
		 * Setting this attribute prevents from loading panorama.
		 * Action is executed when user tries to leave to panorama of given id.
		 */
		public const onLeaveToAttempt:Object = new Object();
		
		public const hotspotsDataImage:Vector.<HotspotDataImage> = new Vector.<HotspotDataImage>();
		public const hotspotsDataSwf:Vector.<HotspotDataSwf> = new Vector.<HotspotDataSwf>();
		public const hotspotsDataProduct:Vector.<HotspotDataProduct> = new Vector.<HotspotDataProduct>();
		
		private var _id:String;
		private var _params:Params;
		
		public function PanoramaData(id:String, path:String) {
			_id = id;
			_params = new Params(path);
		}
		
		public final function get id():String {
			return _id
		}
		
		public final function get params():Params {
			return _params;
		}
		
		public final function hotspotsDataImageById(id:String):HotspotDataImage {
			for (var i:int = 0; i < hotspotsDataImage.length; i++) {
				if (hotspotsDataImage[i].id == id) {
					return hotspotsDataImage[i];
				}
			}
			return null;
		}
		
		public final function hotspotsDataSwfById(id:String):HotspotDataSwf {
			for (var i:int = 0; i < hotspotsDataSwf.length; i++) {
				if (hotspotsDataSwf[i].id == id) {
					return hotspotsDataSwf[i];
				}
			}
			return null;
		}
		
		public final function hotspotsDataProductById(id:String):HotspotDataProduct {
			for (var i:int = 0; i < hotspotsDataProduct.length; i++) {
				if (hotspotsDataProduct[i].id == id) {
					return hotspotsDataProduct[i];
				}
			}
			return null;
		}
		
		public function getHotspotsLoadable():Vector.<ILoadable> {
			var result:Vector.<ILoadable> = new Vector.<ILoadable>();
			for (var i:int = 0; i < hotspotsDataImage.length; i++) {
				result.push(hotspotsDataImage[i] as ILoadable);
			}
			for (i = 0; i < hotspotsDataSwf.length; i++) {
				result.push(hotspotsDataSwf[i] as ILoadable);
			}
			return result;
		}
		
		public function getHotspotsData():Vector.<HotspotData> {
			var result:Vector.<HotspotData> = new Vector.<HotspotData>();
			for (var i:int = 0; i < hotspotsDataImage.length; i++) {
				result.push(hotspotsDataImage[i] as HotspotData);
			}
			for (i = 0; i < hotspotsDataSwf.length; i++) {
				result.push(hotspotsDataSwf[i] as HotspotData);
			}
			for (i = 0; i < hotspotsDataProduct.length; i++) {
				result.push(hotspotsDataProduct[i] as HotspotData);
			}
			return result;
		}
	}
}