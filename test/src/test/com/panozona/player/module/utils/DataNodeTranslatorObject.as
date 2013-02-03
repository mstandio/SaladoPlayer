package test.com.panozona.player.module.utils {
	
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	import com.panozona.player.module.utils.*;
	import com.panozona.player.manager.data.actions.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class DataNodeTranslatorObject extends com.panozona.player.module.utils.DataNodeTranslator {
		
		protected var message:String;
		
		public function DataNodeTranslatorObject(){
			super(true);
		}
		
		[Before]
		public function beforeTest():void {
			message = "";
		}
		
		[Test]
		public function mismatchObjectBoolean():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["dummyObject"] = true;
			var dummyObjectParent:DummyObjectParent = new DummyObjectParent();
			try{
				dataNodeToObject(moduleNode, dummyObjectParent);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid dummyObject type (Object expected): true", message);
		}
		
		[Test]
		public function mismatchDynamicObjectBoolean():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["dynamicObject"] = true;
			var dummyObjectParent:DummyObjectParent = new DummyObjectParent();
			try{
				dataNodeToObject(moduleNode, dummyObjectParent);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid dynamicObject type (Object expected): true", message);
		}
		
		[Test]
		public function mismatchObjectNumber():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["dummyObject"] = -21.21;
			var dummyObjectParent:DummyObjectParent = new DummyObjectParent();
			try{
				dataNodeToObject(moduleNode, dummyObjectParent);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid dummyObject type (Object expected): -21.21", message);
		}
		
		[Test]
		public function mismatchDynamicObjectNumber():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["dynamicObject"] = -21.21;
			var dummyObjectParent:DummyObjectParent = new DummyObjectParent();
			try{
				dataNodeToObject(moduleNode, dummyObjectParent);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid dynamicObject type (Object expected): -21.21", message);
		}
		
		[Test]
		public function mismatchObjectString():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["dummyObject"] = "foo";
			var dummyObjectParent:DummyObjectParent = new DummyObjectParent();
			try{
				dataNodeToObject(moduleNode, dummyObjectParent);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid dummyObject type (Object expected): foo", message);
		}
		
		[Test]
		public function mismatchDynamicObjectString():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["dynamicObject"] = "foo";
			var dummyObjectParent:DummyObjectParent = new DummyObjectParent();
			try{
				dataNodeToObject(moduleNode, dummyObjectParent);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid dynamicObject type (Object expected): foo", message);
		}
		
		[Test]
		public function mismatchObjectFunction():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["dummyObject"] = Linear.easeOut;
			var dummyObjectParent:DummyObjectParent = new DummyObjectParent();
			try{
				dataNodeToObject(moduleNode, dummyObjectParent);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid dummyObject type (Object expected): function Function() {}", message);
		}
		
		[Test]
		public function mismatchDynamicObjectFunction():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["dynamicObject"] = Linear.easeOut;
			var dummyObjectParent:DummyObjectParent = new DummyObjectParent();
			try{
				dataNodeToObject(moduleNode, dummyObjectParent);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid dynamicObject type (Object expected): function Function() {}", message);
		}
	}
}

class DummyObjectParent {
	public var dummyObject:DummyObject = new DummyObject();
	public var dynamicObject:Object = new Object();
}

class DummyObject{
}
