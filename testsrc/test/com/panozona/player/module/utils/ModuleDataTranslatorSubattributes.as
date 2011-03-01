package test.com.panozona.player.module.utils{
	
	import com.panozona.player.module.*;
	import com.panozona.player.module.utils.*;
	import com.panozona.player.manager.data.actions.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ModuleDataTranslatorSubattributes extends com.panozona.player.module.utils.ModuleDataTranslator {
		
		public function ModuleDataTranslatorSubattributes():void {
			super(true);
		}
		
		[Test]
		public function smokeTestStatic():void {
			var source:Object = new Object();
			source["stringNonInit"] = "foo";
			source["stringInit"] = "bar";
			//source["functionNonInit"] = Linear.easeIn;
			source["functionInit"] = Linear.easeOut;
			source["numberNonInit"] = -21.21;
			source["numberInit"] = NaN;
			source["boolean"] = true
			
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
			
			Assert.assertStrictlyEquals("foo", target.stringNonInit);
			Assert.assertStrictlyEquals("bar", target.stringInit);
			
			//Assert.assertStrictlyEquals((Linear.easeIn as Function), target.functionNonInit); // this will not work
			Assert.assertStrictlyEquals((Linear.easeOut as Function), target.functionInit);
			
			Assert.assertStrictlyEquals(-21.21, target.numberNonInit);
			Assert.assertTrue(isNaN(target.numberInit));
			
			Assert.assertStrictlyEquals(true, target.boolean);
		}
		
		[Test]
		public function smokeTestDynamic():void {
			var source:Object = new Object();
			source["str"] = "foo";
			source["fun"] = Linear.easeOut;
			source["num"] = -21.21;
			source["numNaN"] = NaN;
			source["bool"] = true
			
			var target:Object = new Object();
			applySubAttributes(target, source);
			
			Assert.assertStrictlyEquals("foo", target["str"]);
			Assert.assertStrictlyEquals((Linear.easeOut as Function), target["fun"]);
			Assert.assertStrictlyEquals(-21.21, target["num"]);
			Assert.assertTrue(isNaN(target["numNaN"]));
			Assert.assertStrictlyEquals(true, target["bool"]);
		}
	}
}

import com.robertpenner.easing.*;

class DummyObject{
	public var boolean:Boolean;
	public var numberNonInit:Number;
	public var numberInit:Number = -12.12;
	public var stringNonInit:String;
	public var stringInit:String = "default";
	//public var functionNonInit:Function;
	public var functionInit:Function = Linear.easeNone;
}