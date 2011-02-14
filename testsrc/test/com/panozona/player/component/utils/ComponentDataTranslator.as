package test.com.panozona.player.component.utils{
	
	import com.panozona.player.component.*;
	import com.panozona.player.component.events.ConfigurationEvent;
	import com.panozona.player.manager.data.actions.*;
	import com.panozona.player.component.utils.ComponentDataTranslator;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ComponentDataTranslator extends com.panozona.player.component.utils.ComponentDataTranslator {
		
		public function ComponentDataTranslator():void {
			super(true);
		}
		
		[Test]
		public function applySubAttributesStaticPass():void {
			var errorCount : int = 0;
			var warningCount : int = 0;
			var infoCount : int = 0;
			
			addEventListener(ConfigurationEvent.ERROR, function(event:Event):void { errorCount ++; } );
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { warningCount ++; } );
			addEventListener(ConfigurationEvent.INFO, function(event:Event):void { infoCount ++; } );
			
			var dummyObject:DummyObject = new DummyObject();
			dummyObject.stringNonInit;
			dummyObject.stringInit = "default";
			dummyObject.functionNonInit;
			dummyObject.functionInit = Linear.easeNone;
			dummyObject.numberNonInit;
			dummyObject.numberInit = -12.12;
			dummyObject.boolean;
			
			var source:Object = new Object();
			
			source.stringInit = "foo";
			source.functionInit = Linear.easeInOut;
			source.numberInit = -12.12;
			source.boolean = true;
			
			applySubAttributes(dummyObject, source);
			
			
			Assert.assertEquals(0, errorCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, infoCount);
			
			Assert.assertStrictlyEquals("foo", dummyObject.stringInit);
			Assert.assertStrictlyEquals(Linear.easeInOut, dummyObject.functionInit);
			Assert.assertStrictlyEquals(-12.12, dummyObject.numberInit);
			Assert.assertStrictlyEquals(true, dummyObject.boolean);
		}
		
		[Test]
		public function applySubAttributesStaticFail():void {
			var dummyObject:DummyObject = new DummyObject();
		}
		
		[Test]
		public function applySubAttributesDynamicPass():void {
			
			
		}
		
		[Test]
		public function applySubAttributesDynamicFail():void {
			
		}
	}
}

import com.robertpenner.easing.*;

class DummyObject{
	public var stringNonInit:String;
	public var stringInit:String = "default";
	public var functionNonInit:Function;
	public var functionInit:Function = Linear.easeNone;
	public var numberNonInit:Number;
	public var numberInit:Number = -12.12;
	public var boolean:Boolean;
}