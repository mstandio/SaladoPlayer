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
	
	import flash.display.DisplayObject;	
	import flash.display.BitmapData;
	import flash.events.Event;	
				
	import com.panosalado.view.ManagedChild;
	import com.panosalado.view.ImageHotspot; //import com.panosalado.view.VectorHotspot;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class ChildData {  				
		
		private var _id:String;									
		private var _path:String;
		private var _weight:int;
		
		private var _childMouse:ChildMouse;
		private var _childTransform:ChildTransform;
		private var _childPosition:ChildPosition;		
		
		protected var _managedChild:ManagedChild;		
		
		public function ChildData(id:String, path:String, weight:int) {
			if (id == null || id == "" ) {
				throw new Error("No id for child");
			}
			
			if (path == null || path == "") {
				throw new Error("No path specified for child: "+id);							
			}									
			
			_id = id;			
			_path = path;
			_weight = weight;
			
			_childMouse = new ChildMouse();
			_childTransform = new ChildTransform();
			_childPosition = new ChildPosition();
		}	
		
		public final function setBitmapData(bitmapData:BitmapData):void {			
			_managedChild = new ImageHotspot(bitmapData);
		}
					
		public final function get managedChild():ManagedChild {			
			if (_managedChild != null && !isNaN(_childPosition.pan) && !isNaN(_childPosition.tilt) && !isNaN(_childPosition.distance)) {								
				var piOver180:Number = Math.PI / 180;				
				var pr:Number = (-1*(_childPosition.pan - 90)) * piOver180; 
				var tr:Number = -1*  _childPosition.tilt * piOver180;
				var xc:Number = _childPosition.distance * Math.cos(pr) * Math.cos(tr);
				var yc:Number = _childPosition.distance * Math.sin(tr);
				var zc:Number = _childPosition.distance * Math.sin(pr) * Math.cos(tr);				
				
				_managedChild.x = xc;
				_managedChild.y = yc;
				_managedChild.z = zc;								
				_managedChild.rotationY = (_childPosition.pan  + _childTransform.rotationY) * piOver180;
				_managedChild.rotationX = (_childPosition.tilt + _childTransform.rotationX) * piOver180;
				_managedChild.rotationZ = _childTransform.rotationZ * piOver180
				
				_managedChild.scaleX = _childTransform.scaleX;
				_managedChild.scaleY = _childTransform.scaleY;
				_managedChild.scaleZ = _childTransform.scaleZ;												
				
				if (id != null ) {
					(_managedChild).name = id;								
				}			
			}			
			
			/*
			
			var gd:Vector.<flash.display.IGraphicsData> = new Vector.<flash.display.IGraphicsData>();
				gd.push( new flash.display.GraphicsSolidFill(0x000000,0.6) );
				gd.push( new flash.display.GraphicsStroke(0.001, false, "normal", "none", "round", 3, new flash.display.GraphicsSolidFill(0xFF0000)) );
				var gp:flash.display.GraphicsPath = new flash.display.GraphicsPath();
				var hw:int = 50;
				gp.moveTo(-hw,-hw);
				gp.lineTo(hw,-hw);
				gp.lineTo(hw,hw);
				gp.lineTo(-hw,hw);
				gp.lineTo(-hw,-hw)
				gd.push(gp);
				_managedChild = new VectorHotspot( gd ); //pass vector of IGraphics Data to hotspot constructor.
				_managedChild.x = 0; //position hotspot x,y,z = (0,0,0) is where the camera is (bad place for a hotspot)
				_managedChild.y = 0;
				_managedChild.z = 600;		
			*/
			
			return _managedChild;
		}
		
		
		
		public function get id():String {
			return _id;
		}
		
		public function get path():String {
			return _path;
		}
		
		public function get weight():int {
			return _weight;
		}
		
		public function get childMouse():ChildMouse{
			return _childMouse;
		}		
		
		public function get childTransform():ChildTransform{
			return _childTransform;
		}		
		
		public function get childPosition():ChildPosition{
			return _childPosition;
		}		
		
		public function get managedChildReference():ManagedChild {
			return _managedChild;
		}
	}	
}