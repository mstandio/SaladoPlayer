package test.com.panozona.player.module.utils {
	
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	import com.panozona.player.module.utils.*;
	import com.panozona.player.manager.data.actions.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class DataNodeTranslatorFunction extends com.panozona.player.module.utils.DataNodeTranslator {
		
		protected var message:String;
		
		public function DataNodeTranslatorFunction(){
			super(true);
		}
		
		[Before]
		public function beforeTest():void {
			message = "";
		}
		
		[Test]
		public function mismatchFunctionInitBoolean():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["functionInit"] = true;
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid functionInit type (Function expected): true", message);
		}
		
		/*[Test]
		public function mismatchFunctionNonInitBoolean():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["functionNonInit"] = true;
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid attribute type (Function expected): true", message);
		}*/
		
		[Test]
		public function mismatchFunctionInitNumber():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["functionInit"] = -21.21
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid functionInit type (Function expected): -21.21", message);
		}
		
		/*[Test]
		public function mismatchFunctionNonInitNumber():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["functionNonInit"] = -21.21;
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid attribute type (Function expected): -21.21", message);
		}*/
		
		[Test]
		public function mismatchFunctionInitString():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["functionInit"] = "foo"
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid functionInit type (Function expected): foo", message);
		}
		
		/*[Test]
		public function mismatchFunctionNonInitSring():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["functionNonInit"] = "foo";
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid attribute type (Function expected): foo", message);
		}*/
		
		[Test]
		public function mismatchFunctionInitObject():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["functionInit"] = new Object();
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid functionInit type (Function expected): [object Object]", message);
		}
		
		/*[Test]
		public function mismatchFunctionNonInitObject():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["functionNonInit"] = new Object();
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid attribute type (Function expected): [object Object]", message);
		}*/
	}
}

import com.robertpenner.easing.*;

class DummyObject{
	//public var functionNonInit:Function; 
	public var functionInit:Function = Linear.easeNone;
}