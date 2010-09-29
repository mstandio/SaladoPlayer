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
package com.panosalado.utils {
	
	public class Inertion {
				
		private var _max:Number;
		private var _increment:Number; 
		private var _friction:Number;
		
		private var _value:Number;
	
		public function Inertion( maxValue:Number, incrementValue:Number, friction:Number) {
			_value = 0;
			_max = maxValue;
			_increment = incrementValue;
			_friction  = friction;
		}		
		
		public function increment():Number{			
			if (_value + _increment <=  _max) _value += _increment;
			return _value;
		}
		
		public function decrement():Number {
			if (_value - _increment >= -_max) _value -= _increment;
			return _value;
		}		
	
		public function aimMax():Number {
			if (_value + _increment <=  _max) _value += _increment;
			if (_value - _increment >= -_max) _value -= _increment;			
			return _value;
		}		
	
		public function aimZero():Number {
			if (_value < 0) {
				_value = (_value + _friction > 0) ? 0: _value + _friction ;
			}else if (_value > 0) {
				_value = (_value - _friction < 0) ? 0: _value - _friction;
			}
			return _value;
		}
		
		public function appendMax(value:Number):void {
			_max += value;
		}		
		
		public function setMax(value:Number):void {
			_max = value;
		}		
	}
}