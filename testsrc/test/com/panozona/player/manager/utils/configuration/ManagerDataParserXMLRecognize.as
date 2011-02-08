package test.com.panozona.player.manager.utils.configuration{
	
	import com.panozona.player.manager.utils.configuration.ManagerDataParserXML;
	import com.panozona.player.manager.utils.configuration.ConfigurationEvent;
	import com.robertpenner.easing.*;
	import flash.events.Event;
	import flexunit.framework.Assert;
	
	public class ManagerDataParserXMLRecognize extends com.panozona.player.manager.utils.configuration.ManagerDataParserXML{
		
		[Test]
		public function recognizeContentBooleanPass():void {
			Assert.assertStrictlyEquals(true, recognizeContent("true"));
			Assert.assertStrictlyEquals(false, recognizeContent("false"));
		}
		
		[Test]
		public function recognizeContentBooleanFail():void {
			Assert.assertFalse(recognizeContent(" true") is Boolean);
			Assert.assertFalse(recognizeContent("true ") is Boolean);
			Assert.assertFalse(recognizeContent(" false ") is Boolean);
			Assert.assertFalse(recognizeContent("True") is Boolean);
			Assert.assertFalse(recognizeContent("False") is Boolean);
		}
		
		[Test]
		public function recognizeContentNumberPass():void {
			Assert.assertStrictlyEquals(12, recognizeContent("12"));
			Assert.assertStrictlyEquals(-12, recognizeContent("-12"));
			Assert.assertStrictlyEquals(12.12, recognizeContent("12.12"));
			Assert.assertStrictlyEquals(-12.12, recognizeContent("-12.12"));
			Assert.assertStrictlyEquals(0, recognizeContent("0"));
			Assert.assertStrictlyEquals(12, recognizeContent("012"));
			Assert.assertStrictlyEquals(0, recognizeContent("0.000"));
			Assert.assertStrictlyEquals(0, recognizeContent("-0.000"));
			Assert.assertStrictlyEquals(0xff00ff, recognizeContent("#ff00ff"));
			Assert.assertStrictlyEquals(0xff00ff, recognizeContent("#FF00FF"));
			Assert.assertTrue(isNaN(recognizeContent("NaN")));
		}
		
		[Test]
		public function recognizeContentNumberFail():void {
			Assert.assertFalse(recognizeContent("1.2.1") is Number);
			Assert.assertFalse(recognizeContent("1.-12") is Number);
			Assert.assertFalse(recognizeContent(".12") is Number);
			Assert.assertFalse(recognizeContent("12.") is Number);
			Assert.assertFalse(recognizeContent("nan") is Number);
			Assert.assertFalse(recognizeContent("NaN ") is Number);
			Assert.assertFalse(recognizeContent("NaN ") is Number);
			Assert.assertFalse(recognizeContent(" NaN ") is Number);
			Assert.assertFalse(recognizeContent(" #ff00ff") is Number);
			Assert.assertFalse(recognizeContent("#ff00ff ") is Number);
			Assert.assertFalse(recognizeContent(" #ff00ff ") is Number);
			Assert.assertFalse(recognizeContent("# ff00ff") is Number);
			Assert.assertFalse(recognizeContent("##ff00ff") is Number);
		}
		
		[Test]
		public function recognizeContentStringPass():void {
			Assert.assertStrictlyEquals("a b c  d f", recognizeContent("a b c  d f"));
			Assert.assertStrictlyEquals("a b c  d f", recognizeContent("[a b c  d f]"));
			Assert.assertStrictlyEquals("  a b c  d f  ", recognizeContent("[  a b c  d f  ]"));
			Assert.assertStrictlyEquals("  a b c  d f  ", recognizeContent("  a b c  d f  ")); // TODO: needs  to be trimmed.
			Assert.assertStrictlyEquals("-12.12", recognizeContent("[-12.12]"));
			Assert.assertStrictlyEquals("#ff00ff", recognizeContent("[#ff00ff]"));
			Assert.assertStrictlyEquals("NaN", recognizeContent("[NaN]"));
			Assert.assertStrictlyEquals("true", recognizeContent("[true]"));
			Assert.assertStrictlyEquals("http://panozona.com", recognizeContent("[http://panozona.com]"));
			Assert.assertStrictlyEquals(" ", recognizeContent("[ ]"));
			Assert.assertStrictlyEquals("", recognizeContent("[]"));
		}
		
		[Test]
		public function recognizeContentStringFail():void {
			Assert.assertFalse(recognizeContent("") is String);
			Assert.assertFalse(recognizeContent(" ") is String)
			//Assert.assertFalse(recognizeContent(null) is String);
			Assert.assertFalse(recognizeContent("a:b") is String);
			Assert.assertFalse(recognizeContent("http://panozona.com") is String);
			Assert.assertFalse(recognizeContent("Linear.easeNone") is String);
		}
		
		[Test]
		public function recognizeContentFunctionPass():void {
			Assert.assertStrictlyEquals(Linear.easeNone, recognizeFunction("Linear.easeNone"));
			Assert.assertStrictlyEquals(Linear.easeIn, recognizeFunction("Linear.easeIn"));
			Assert.assertStrictlyEquals(Linear.easeInOut, recognizeFunction("Linear.easeInOut"));
			Assert.assertStrictlyEquals(Linear.easeOut, recognizeFunction("Linear.easeOut"));
			Assert.assertStrictlyEquals(Expo.easeIn, recognizeFunction("Expo.easeIn"));
			Assert.assertStrictlyEquals(Expo.easeInOut, recognizeFunction("Expo.easeInOut"));
			Assert.assertStrictlyEquals(Expo.easeOut, recognizeFunction("Expo.easeOut"));
			Assert.assertStrictlyEquals(Elastic.easeIn, recognizeFunction("Elastic.easeIn"));
			Assert.assertStrictlyEquals(Elastic.easeInOut, recognizeFunction("Elastic.easeInOut"));
			Assert.assertStrictlyEquals(Elastic.easeOut, recognizeFunction("Elastic.easeOut"));
			Assert.assertStrictlyEquals(Cubic.easeIn, recognizeFunction("Cubic.easeIn"));
			Assert.assertStrictlyEquals(Cubic.easeInOut, recognizeFunction("Cubic.easeInOut"));
			Assert.assertStrictlyEquals(Cubic.easeOut, recognizeFunction("Cubic.easeOut"));
			Assert.assertStrictlyEquals(Bounce.easeIn, recognizeFunction("Bounce.easeIn"));
			Assert.assertStrictlyEquals(Bounce.easeInOut, recognizeFunction("Bounce.easeInOut"));
			Assert.assertStrictlyEquals(Bounce.easeOut, recognizeFunction("Bounce.easeOut"));
			Assert.assertStrictlyEquals(Elastic.easeIn, recognizeFunction("Elastic.easeIn"));
			Assert.assertStrictlyEquals(Elastic.easeInOut, recognizeFunction("Elastic.easeInOut"));
			Assert.assertStrictlyEquals(Elastic.easeOut, recognizeFunction("Elastic.easeOut"));
		}
		
		[Test]
		public function recognizeContentObjectPass():void {
			var obj:Object = recognizeContent("str:foo,bool:true,num:-12.12,fun:Elastic.easeInOut");
			Assert.assertNotNull(obj);
			Assert.assertStrictlyEquals("foo", obj.str);
			Assert.assertStrictlyEquals(true, obj.bool);
			Assert.assertStrictlyEquals(-12.12, obj.num);
			Assert.assertStrictlyEquals(Elastic.easeInOut, obj.fun);
		}
		
		[Test]
		public function recognizeContentWarning():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void{callCount++;});
			recognizeContent("");
			recognizeContent(" ");
			Assert.assertEquals(2, callCount);
		}
		
		[Test]
		public function applySubattributesStringPass():void {
			var dummyObject:DummyObject = new DummyObject();
			applySubAttributes(dummyObject, "stringInit:a,stringNonInit:b");
			Assert.assertStrictlyEquals("a", dummyObject.stringInit);
			Assert.assertStrictlyEquals("b", dummyObject.stringNonInit);
		}
		
		[Test]
		public function applySubattributesNumberPass():void {
			var dummyObject:DummyObject = new DummyObject();
			applySubAttributes(dummyObject, "number:NaN");
			Assert.assertTrue(isNaN(dummyObject.number));
		}
		
		[Test]
		public function applySubattributesBooleanPass():void {
			var dummyObject:DummyObject = new DummyObject();
			dummyObject.boolean = false;
			applySubAttributes(dummyObject, "boolean:true");
			Assert.assertStrictlyEquals(true, dummyObject.boolean);
		}
		
		[Test]
		public function applySubattributesFunctionPass():void {
			var dummyObject:DummyObject = new DummyObject();
			dummyObject.functionInit = Bounce.easeInOut;
			applySubAttributes(dummyObject, "functionInit:Bounce.easeInOut");
			Assert.assertStrictlyEquals(dummyObject.functionInit, Bounce.easeInOut);
		}
		
		[Test]
		public function applySubattributesDynamicPass():void {
			var obj:Object = new Object();
			applySubAttributes(obj, "str:foo,bool:true,num:-12.12,fun:Elastic.easeInOut");
			Assert.assertNotNull(obj);
			Assert.assertStrictlyEquals("foo", obj.str);
			Assert.assertStrictlyEquals(true, obj.bool);
			Assert.assertStrictlyEquals(-12.12, obj.num);
			Assert.assertStrictlyEquals(Elastic.easeInOut, obj.fun);
		}
		
		[Test]
		public function applySubattributesWarning():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; });
			
			// invalid format
			applySubAttributes(new Object(), "abcd:");
			applySubAttributes(new Object(), "12:");
			applySubAttributes(new Object(), ":abcd");
			
			var dummyObject:DummyObject = new DummyObject();
			
			// mismatch Boolean
			applySubAttributes(dummyObject, "boolean:-12.12");
			applySubAttributes(dummyObject, "boolean:foo");
			applySubAttributes(dummyObject, "boolean:Linear.easeNone");
			
			// mismatch Number
			applySubAttributes(dummyObject, "number:true");
			applySubAttributes(dummyObject, "number:foo");
			applySubAttributes(dummyObject, "number:Linear.easeNone");
			
			// mismatch Function
			applySubAttributes(dummyObject, "functionInit:true");
			applySubAttributes(dummyObject, "functionInit:foo");
			applySubAttributes(dummyObject, "functionInit:-12.12");
			
			// mismatch String
			applySubAttributes(dummyObject, "stringInit:true");
			applySubAttributes(dummyObject, "stringInit:Linear.easeNone");
			applySubAttributes(dummyObject, "stringInit:-12.12");
			
			// deny creation of new attribute
			applySubAttributes(dummyObject, "newAttr:foo");
			
			Assert.assertEquals(16, callCount);
		}
	}
}

import com.robertpenner.easing.*;

class DummyObject{
	public var stringNonInit:String;
	public var stringInit:String = "default";
	public var functionNonInit:Function;
	public var functionInit:Function = Linear.easeNone;
	public var number:Number;
	public var boolean:Boolean;
}