package test.com.panozona.player.module.utils {
	
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	import com.panozona.player.module.utils.*;
	import com.panozona.player.manager.data.actions.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ModuleDataTranslatorSubBoolean extends com.panozona.player.module.utils.ModuleDataTranslator {
		
		protected var message:String;
		
		public function ModuleDataTranslatorSubBoolean(){
			super(true);
		}
		
		[Before]
		public function beforeTest():void {
			message = "";
		}
		
		[Test]
		public function mismatchBooleanNumber():void {
			var source:Object = new Object();
			source["boolean"] = -12.12;
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid boolean value (Boolean expected): -12.12", message);
		}
		
		[Test]
		public function mismatchBooleanNan():void {
			var source:Object = new Object();
			source["boolean"] = NaN;
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid boolean value (Boolean expected): NaN", message);
		}
		
		[Test]
		public function mismatchBooleanString():void {
			var source:Object = new Object();
			source["boolean"] = "foo";
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid boolean value (Boolean expected): foo", message);
		}
		
		[Test]
		public function mismatchBooleanFunction():void {
			var source:Object = new Object();
			source["boolean"] = Linear.easeInOut;
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid boolean value (Boolean expected): function Function() {}", message);
		}
	}
}

class DummyObject{
	public var boolean:Boolean;
}