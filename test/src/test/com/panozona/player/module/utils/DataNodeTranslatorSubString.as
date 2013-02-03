package test.com.panozona.player.module.utils {
	
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	import com.panozona.player.module.utils.*;
	import com.panozona.player.manager.data.actions.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class DataNodeTranslatorSubString extends com.panozona.player.module.utils.DataNodeTranslator {
		
		protected var message:String;
		
		public function DataNodeTranslatorSubString(){
			super(true);
		}
		
		[Before]
		public function beforeTest():void {
			message = "";
		}
		
		[Test]
		public function mismatchStringInitBoolean():void {
			var source:Object = new Object();
			source["stringInit"] = true;
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid stringInit type (String expected): true", message);
		}
		
		[Test]
		public function mismatchStringNonInitBoolean():void {
			var source:Object = new Object();
			source["stringNonInit"] = true;
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid stringNonInit type (String expected): true", message);
		}
		
		[Test]
		public function mismatchStringInitNumber():void {
			var source:Object = new Object();
			source["stringInit"] = -21.21;
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid stringInit type (String expected): -21.21", message);
		}
		
		[Test]
		public function mismatchStringNonInitNumber():void {
			var source:Object = new Object();
			source["stringNonInit"] = -21.21;
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid stringNonInit type (String expected): -21.21", message);
		}
		
		[Test]
		public function mismatchStringInitFunction():void {
			var source:Object = new Object();
			source["stringInit"] = Linear.easeInOut;
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid stringInit type (String expected): function Function() {}", message);
		}
		
		[Test]
		public function mismatchStringNonInitFunction():void {
			var source:Object = new Object();
			source["stringNonInit"] = Linear.easeInOut;
			var target:DummyObject = new DummyObject();
			try{
				applySubAttributes(target, source);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid stringNonInit type (String expected): function Function() {}", message);
		}
	}
}

class DummyObject{
	public var stringNonInit:String;
	public var stringInit:String = "default";
}