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
			//source["functionNonInit"] = Linear.easeIn; // this will not work
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
		
		[Test(expects="Error")]
		public function mismatchBooleanNumber():void {
			var source:Object = new Object();
			source["boolean"] = -12.12;
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchBooleanNan():void {
			var source:Object = new Object();
			source["boolean"] = NaN;
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchBooleanString():void {
			var source:Object = new Object();
			source["boolean"] = "foo";
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchBooleanFunction():void {
			var source:Object = new Object();
			source["boolean"] = Linear.easeInOut;
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchNumberInitBoolean():void {
			var source:Object = new Object();
			source["numberInit"] = false;
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchNumberNonInitBoolean():void {
			var source:Object = new Object();
			source["numberNonInit"] = false;
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchNumberInitString():void {
			var source:Object = new Object();
			source["numberInit"] = "foo";
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchNumberNonInitString():void {
			var source:Object = new Object();
			source["numberNonInit"] = "foo";
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchNumberInitFunction():void {
			var source:Object = new Object();
			source["numberInit"] = Linear.easeInOut;
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchNumberNonInitFunction():void {
			var source:Object = new Object();
			source["numberNonInit"] = Linear.easeInOut;
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchStringInitBoolean():void {
			var source:Object = new Object();
			source["stringInit"] = false;
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchStringNonInitBoolean():void {
			var source:Object = new Object();
			source["stringNonInit"] = false;
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchStringInitNumber():void {
			var source:Object = new Object();
			source["stringInit"] = -21.21;
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchStringNonInitNumber():void {
			var source:Object = new Object();
			source["stringNonInit"] = -21.21;
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchStringInitFunction():void {
			var source:Object = new Object();
			source["stringInit"] = Linear.easeInOut;
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchStringNonInitFunction():void {
			var source:Object = new Object();
			source["stringNonInit"] = Linear.easeInOut;
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchFunctionInitBoolean():void {
			var source:Object = new Object();
			source["functionInit"] = true;
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchFunctionNonInitBoolean():void {
			var source:Object = new Object();
			source["functionNonInit"] = true;
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchFunctionInitNumber():void {
			var source:Object = new Object();
			source["functionInit"] = -21.21;
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchFunctionNonInitNumber():void {
			var source:Object = new Object();
			source["functionNonInit"] = -21.21;
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchFunctionInitString():void {
			var source:Object = new Object();
			source["functionInit"] = "foo";
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
		}
		
		[Test(expects="Error")]
		public function mismatchFunctionNonInitString():void {
			var source:Object = new Object();
			source["functionNonInit"] = "foo";
			var target:DummyObject = new DummyObject();
			applySubAttributes(target, source);
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
	public var functionNonInit:Function;
	public var functionInit:Function = Linear.easeNone;
}