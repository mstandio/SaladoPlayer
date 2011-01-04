package com.robertpenner.easing {
	public class Sine {
		public static function easeIn (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
			return -c * Math.cos(t/d * (Math.PI/2)) + c + b;
		}
		public static function easeOut (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
			return c * Math.sin(t/d * (Math.PI/2)) + b;
		}
		public static function easeInOut (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
			return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
		}
	}
}