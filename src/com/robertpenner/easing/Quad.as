class com.robertpenner.easing.Quad {
	static function easeIn (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
		return c*(t/=d)*t + b;
	}
	static function easeOut (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
		return -c *(t/=d)*(t-2) + b;
	}
	static function easeInOut (t:Number, b:Number, c:Number, d:Number, p_params:Object = null):Number {
		if ((t/=d/2) < 1) return c/2*t*t + b;
		return -c/2 * ((--t)*(t-2) - 1) + b;
	}
}
