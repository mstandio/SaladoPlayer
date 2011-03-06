package test.com.panozona.player.module.utils{
	
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	import com.panozona.player.module.utils.*;
	import com.panozona.player.manager.data.actions.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class DataNodeTranslatorString extends com.panozona.player.module.utils.DataNodeTranslator {
		
		protected var message:String;
		
		public function DataNodeTranslatorString(){
			super(true);
		}
		
		[Before]
		public function beforeTest():void {
			message = "";
		}
		
		[Test]
		public function mismatchStringInitBoolean():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["stringInit"] = true;
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid stringInit value (String expected): true", message);
		}
		
		[Test]
		public function mismatchStringNonInitBoolean():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["stringNonInit"] = true;
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid stringNonInit value (String expected): true", message);
		}
		
		[Test]
		public function mismatchStringInitNumber():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["stringInit"] = -21.21;
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid stringInit value (String expected): -21.21", message);
		}
		
		[Test]
		public function mismatchStringNonInitNumber():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["stringNonInit"] = -21.21;
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid stringNonInit value (String expected): -21.21", message);
		}
		
		[Test]
		public function mismatchStringInitFunction():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["stringInit"] = Linear.easeOut;
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid stringInit value (String expected): function Function() {}", message);
		}
		
		[Test]
		public function mismatchStringNonInitFunction():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["stringNonInit"] = Linear.easeOut;
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid stringNonInit value (String expected): function Function() {}", message);
		}
		
		[Test]
		public function mismatchStringInitObject():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["stringInit"] = new Object();
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid stringInit value (String expected): [object Object]", message);
		}
		
		[Test]
		public function mismatchStringNonInitObject():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["stringNonInit"] = new Object();
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid stringNonInit value (String expected): [object Object]", message);
		}
	}
}

class DummyObject{
	public var stringNonInit:String;
	public var stringInit:String = "default";
}