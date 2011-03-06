package test.com.panozona.player.module.utils{
	
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	import com.panozona.player.module.utils.*;
	import com.panozona.player.manager.data.actions.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class DataNodeTranslatorSubFunction extends com.panozona.player.module.utils.DataNodeTranslator {
		
		protected var message:String;
		
		public function DataNodeTranslatorSubFunction(){
			super(true);
		}
		
		[Before]
		public function beforeTest():void {
			message = "";
		}
		
		[Test]
		public function mismatchFunctionInitBoolean():void {
			var source:Object = new Object();
			source["functionInit"] = true;
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid functionInit value (Function expected): true", message);
		}
		
		/*[Test]
		public function mismatchFunctionNonInitBoolean():void {
			var source:Object = new Object();
			source["functionNonInit"] = true;
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid functionNonInit value (Function expected): true", message);
		}*/
		
		[Test]
		public function mismatchFunctionInitNumber():void {
			var source:Object = new Object();
			source["functionInit"] = -21.21;
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid functionInit value (Function expected): -21.21", message);
		}
		
		/*[Test]
		public function mismatchFunctionNonInitNumber():void {
			var source:Object = new Object();
			source["functionNonInit"] = -21.21;
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid functionNonInit value (Function expected): -21.21", message);
		}*/
		
		[Test]
		public function mismatchFunctionInitString():void {
			var source:Object = new Object();
			source["functionInit"] = "foo";
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid functionInit value (Function expected): foo", message);
		}
		
		/*[Test]
		public function mismatchFunctionNonInitString():void {
			var source:Object = new Object();
			source["functionNonInit"] = "foo";
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid functionNonInit value (Function expected): foo", message);
		}*/
	}
}

import com.robertpenner.easing.*;

class DummyObject{
	//public var functionNonInit:Function;
	public var functionInit:Function = Linear.easeNone;
}