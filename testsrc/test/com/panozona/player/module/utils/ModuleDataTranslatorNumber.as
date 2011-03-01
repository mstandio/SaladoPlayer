package test.com.panozona.player.module.utils{
	
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	import com.panozona.player.module.utils.*;
	import com.panozona.player.manager.data.actions.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ModuleDataTranslatorNumber extends com.panozona.player.module.utils.ModuleDataTranslator {
		
		protected var message:String;
		
		public function ModuleDataTranslatorNumber(){
			super(true);
		}
		
		[Before]
		public function beforeTest():void {
			message = "";
		}
		
		[Test]
		public function mismatchNumberInitBoolean():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["numberInit"] = true;
			var dummyObject:DummyObject = new DummyObject();
			try{
				moduleNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid numberInit value (Number expected): true", message);
		}
		
		[Test]
		public function mismatchNumberNonInitBoolean():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["numberNonInit"] = true
			var dummyObject:DummyObject = new DummyObject();
			try{
				moduleNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid numberNonInit value (Number expected): true", message);
		}
		
		[Test]
		public function mismatchNumberInitString():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["numberInit"] = "foo";
			var dummyObject:DummyObject = new DummyObject();
			try{
				moduleNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid numberInit value (Number expected): foo", message);
		}
		
		[Test]
		public function mismatchNumberNonInitString():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["numberNonInit"] = "foo";
			var dummyObject:DummyObject = new DummyObject();
			try{
				moduleNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid numberNonInit value (Number expected): foo", message);
		}
		
		[Test]
		public function mismatchNumberInitFunction():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["numberInit"] = Linear.easeOut;
			var dummyObject:DummyObject = new DummyObject();
			try{
				moduleNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid numberInit value (Number expected): function Function() {}", message);
		}
		
		[Test]
		public function mismatchNumberNonInitFunction():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["numberNonInit"] = Linear.easeOut;
			var dummyObject:DummyObject = new DummyObject();
			try{
				moduleNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid numberNonInit value (Number expected): function Function() {}", message);
		}
		
		[Test]
		public function mismatchNumberInitObject():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["numberInit"] = new Object();
			var dummyObject:DummyObject = new DummyObject();
			try{
				moduleNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid numberInit value (Number expected): [object Object]", message);
		}
		
		[Test]
		public function mismatchNumberNonInitObject():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["numberNonInit"] = new Object();
			var dummyObject:DummyObject = new DummyObject();
			try{
				moduleNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid numberNonInit value (Number expected): [object Object]", message);
		}
	}
}

class DummyObject{
	public var numberNonInit:Number; // NaN
	public var numberInit:Number = -12.12;
}