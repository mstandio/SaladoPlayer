package test.com.panozona.player.module.utils{
	
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	import com.panozona.player.module.utils.*;
	import com.panozona.player.manager.data.actions.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class DataNodeTranslatorBoolean extends com.panozona.player.module.utils.DataNodeTranslator {
		
		protected var message:String;
		
		public function DataNodeTranslatorBoolean(){
			super(true);
		}
		
		[Before]
		public function beforeTest():void {
			message = "";
		}
		
		[Test]
		public function mismatchBooleanNumber():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["boolean"] = -21.21;
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid boolean type (Boolean expected): -21.21", message);
		}
		
		[Test]
		public function mismatchBooleanString():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["boolean"] = "foo";
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid boolean type (Boolean expected): foo", message);
		}
		
		[Test]
		public function mismatchBooleanFunction():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["boolean"] = Linear.easeOut;
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid boolean type (Boolean expected): function Function() {}", message);
		}
		
		[Test]
		public function mismatchBooleanObject():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["boolean"] = new Object();
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Invalid boolean type (Boolean expected): [object Object]", message);
		}
	}
}

class DummyObject{
	public var boolean:Boolean;
}
