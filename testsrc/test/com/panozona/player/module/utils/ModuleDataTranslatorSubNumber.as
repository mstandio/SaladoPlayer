package test.com.panozona.player.module.utils{
	
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	import com.panozona.player.module.utils.*;
	import com.panozona.player.manager.data.actions.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ModuleDataTranslatorSubNumber extends com.panozona.player.module.utils.ModuleDataTranslator {
		
		protected var message:String;
		
		public function ModuleDataTranslatorSubNumber(){
			super(true);
		}
		
		[Before]
		public function beforeTest():void {
			message = "";
		}
		
		[Test]
		public function mismatchNumberInitBoolean():void {
			var source:Object = new Object();
			source["numberInit"] = true;
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid numberInit value (Number expected): true", message);
		}
		
		[Test]
		public function mismatchNumberNonInitBoolean():void {
			var source:Object = new Object();
			source["numberNonInit"] = true;
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid numberNonInit value (Number expected): true", message);
		}
		
		[Test]
		public function mismatchNumberInitString():void {
			var source:Object = new Object();
			source["numberInit"] = "foo";
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid numberInit value (Number expected): foo", message);
		}
		
		[Test]
		public function mismatchNumberNonInitString():void {
			var source:Object = new Object();
			source["numberNonInit"] = "foo";
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid numberNonInit value (Number expected): foo", message);
		}
		
		[Test]
		public function mismatchNumberInitFunction():void {
			var source:Object = new Object();
			source["numberInit"] = Linear.easeInOut;
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid numberInit value (Number expected): function Function() {}", message);
		}
		
		[Test]
		public function mismatchNumberNonInitFunction():void {
			var source:Object = new Object();
			source["numberNonInit"] = Linear.easeInOut;
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid numberNonInit value (Number expected): function Function() {}", message);
		}
	}
}

class DummyObject{
	public var numberNonInit:Number;
	public var numberInit:Number = -12.12;
}