package test.com.panozona.player.module.utils {
	
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	import com.panozona.player.module.utils.*;
	import com.panozona.player.manager.data.actions.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ModuleDataTranslatorFunction extends com.panozona.player.module.utils.ModuleDataTranslator {
		
		protected var message:String;
		
		public function ModuleDataTranslatorFunction(){
			super(true);
		}
		
		[Before]
		public function beforeTest():void {
			message = "";
		}
		
		[Test]
		public function mismatchFunctionInitBoolean():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["functionInit"] = true;
			var dummyObject:DummyObject = new DummyObject();
			try{
				moduleNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid functionInit value (Function expected): true", message);
		}
		
		/*[Test]
		public function mismatchFunctionNonInitBoolean():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["functionNonInit"] = true;
			var dummyObject:DummyObject = new DummyObject();
			try{
				moduleNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid attribute value (Function expected): true", message);
		}*/
		
		[Test]
		public function mismatchFunctionInitNumber():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["functionInit"] = -21.21
			var dummyObject:DummyObject = new DummyObject();
			try{
				moduleNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid functionInit value (Function expected): -21.21", message);
		}
		
		/*[Test]
		public function mismatchFunctionNonInitNumber():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["functionNonInit"] = -21.21;
			var dummyObject:DummyObject = new DummyObject();
			try{
				moduleNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid attribute value (Function expected): -21.21", message);
		}*/
		
		[Test]
		public function mismatchFunctionInitString():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["functionInit"] = "foo"
			var dummyObject:DummyObject = new DummyObject();
			try{
				moduleNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid functionInit value (Function expected): foo", message);
		}
		
		/*[Test]
		public function mismatchFunctionNonInitSring():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["functionNonInit"] = "foo";
			var dummyObject:DummyObject = new DummyObject();
			try{
				moduleNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid attribute value (Function expected): foo", message);
		}*/
		
		[Test]
		public function mismatchFunctionInitObject():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["functionInit"] = new Object();
			var dummyObject:DummyObject = new DummyObject();
			try{
				moduleNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid functionInit value (Function expected): [object Object]", message);
		}
		
		/*[Test]
		public function mismatchFunctionNonInitObject():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["functionNonInit"] = new Object();
			var dummyObject:DummyObject = new DummyObject();
			try{
				moduleNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid attribute value (Function expected): [object Object]", message);
		}*/
	}
}

import com.robertpenner.easing.*;

class DummyObject{
	//public var functionNonInit:Function; 
	public var functionInit:Function = Linear.easeNone;
}