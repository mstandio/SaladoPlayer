/*
Copyright 2010 Zephyr Renner.

This file is part of PanoSalado.

PanoSalado is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

PanoSalado is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with PanoSalado. If not, see <http://www.gnu.org/licenses/>.
*/
package com.panosalado.view {

import flash.display.Sprite
import flash.events.Event;
import flash.geom.Vector3D;
import flash.geom.Matrix3D;

	public class ManagedChild extends Sprite implements IManagedChild {
		
		public var _decomposition:Vector.<Vector3D>;
		public var _invalid:Boolean;
		public var _matrix3D:Matrix3D;
		
		public function ManagedChild() {
			transform.matrix3D = new Matrix3D();
			_decomposition = new Vector.<Vector3D>();
			_decomposition[0] = new Vector3D(0,0,0);
			_decomposition[1] = new Vector3D(0,0,0);
			_decomposition[2] = new Vector3D(1,1,1);
			_invalid = true;
			_matrix3D = new Matrix3D();
		}
		
		public function get decomposition():Vector.<Vector3D> { return _decomposition }
		public function set decomposition(value:Vector.<Vector3D>):void {
			if (value === _decomposition) return
			_decomposition = value
			_invalid = true;
		}
		
		public function get invalid():Boolean { return _invalid }
		public function set invalid(value:Boolean):void {
			if (value == _invalid) return
			_invalid = value
		}
		
		public function get matrix3D():Matrix3D { return _matrix3D }
		public function set matrix3D(value:Matrix3D):void {
			if (value === _matrix3D) return
			_matrix3D = value
			_invalid = true;
		}
		
		override public function get x():Number { return _decomposition[0].x; }
		override public function set x(value:Number):void { _decomposition[0].x = value; _invalid = true; if(stage) stage.invalidate(); }
		
		override public function get y():Number { return _decomposition[0].y; }
		override public function set y(value:Number):void { _decomposition[0].y = value; _invalid = true; if(stage) stage.invalidate(); }
		
		override public function get z():Number { return _decomposition[0].z; }
		override public function set z(value:Number):void { _decomposition[0].z = value; _invalid = true; if(stage) stage.invalidate(); }
		
		override public function get rotationX():Number { return _decomposition[1].x; }
		override public function set rotationX(value:Number):void { _decomposition[1].x = value; _invalid = true; if (stage) stage.invalidate(); }
		
		override public function get rotationY():Number { return _decomposition[1].y; }
		override public function set rotationY(value:Number):void { _decomposition[1].y = value; _invalid = true; if(stage) stage.invalidate(); }
		
		override public function get rotationZ():Number { return _decomposition[1].z; }
		override public function set rotationZ(value:Number):void { _decomposition[1].z = value; _invalid = true; if(stage) stage.invalidate(); }
		
		override public function get scaleX():Number { return _decomposition[2].x; }
		override public function set scaleX(value:Number):void { _decomposition[2].x = value; _invalid = true; if(stage) stage.invalidate(); }
		
		override public function get scaleY():Number { return _decomposition[2].y; }
		override public function set scaleY(value:Number):void { _decomposition[2].y = value; _invalid = true; if(stage) stage.invalidate(); }
		
		override public function get scaleZ():Number { return _decomposition[2].z; }
		override public function set scaleZ(value:Number):void { _decomposition[2].z = value; _invalid = true; if (stage) stage.invalidate(); }
		
		public var flat:Boolean;
		
		public function set flatX(value:Number):void {
			super.x = value
		}
		
		public function set flatY(value:Number):void {
			super.y = value
		}
	}
}