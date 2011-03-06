package test.com.panozona.player.module.utils{
	
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	import com.panozona.player.module.utils.*;
	import com.panozona.player.manager.data.actions.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class DataNodeTranslatorTranslate extends com.panozona.player.module.utils.DataNodeTranslator {
		
		protected var message:String;
		
		public function DataNodeTranslatorTranslate(){
			super(true);
		}
		
		[Before]
		public function beforeTest():void {
			message = "";
		}
		
		[Test]
		public function smokeTest():void {
			var moduleNode:DataNode = new DataNode("whatever");
			moduleNode.childNodes.push(new DataNode("DummyObjectChild"));
			moduleNode.childNodes.push(new DataNode("DummyObjectChild"));
			
			moduleNode.attributes["boolean"] = false;
			moduleNode.attributes["numberNonInit"] = 123;
			moduleNode.attributes["numberInit"] = 345;
			moduleNode.attributes["stringNonInit"] = "aa";
			moduleNode.attributes["stringInit"] = "bb";
			moduleNode.attributes["functionInit"] = Linear.easeInOut;
			moduleNode.attributes["dummyObject"] = new Object();
			
			moduleNode.attributes["dummyObject"]["boolean"] = true;
			moduleNode.attributes["dummyObject"]["numberNonInit"] = -123;
			moduleNode.attributes["dummyObject"]["numberInit"] = -321;
			moduleNode.attributes["dummyObject"]["stringNonInit"] = "cc";
			moduleNode.attributes["dummyObject"]["stringInit"] = "dd";
			moduleNode.attributes["dummyObject"]["functionInit"] = Linear.easeIn;
			
			moduleNode.childNodes[0].attributes["boolean"] = false;
			moduleNode.childNodes[0].attributes["numberNonInit"] = -234.4;
			moduleNode.childNodes[0].attributes["numberInit"] = 123.12;
			moduleNode.childNodes[0].attributes["stringNonInit"] = "ee";
			moduleNode.childNodes[0].attributes["stringInit"] = "ff";
			moduleNode.childNodes[0].attributes["functionInit"] = Linear.easeOut;
			moduleNode.childNodes[0].attributes["dummyObject"] = new Object();
			
			moduleNode.childNodes[0].attributes["dummyObject"]["boolean"] = true;
			moduleNode.childNodes[0].attributes["dummyObject"]["numberNonInit"] = -2321.21;
			moduleNode.childNodes[0].attributes["dummyObject"]["numberInit"] = 12342;
			moduleNode.childNodes[0].attributes["dummyObject"]["stringNonInit"] = "gg";
			moduleNode.childNodes[0].attributes["dummyObject"]["stringInit"] = "hh";
			moduleNode.childNodes[0].attributes["dummyObject"]["functionInit"] = Expo.easeIn;
			
			moduleNode.childNodes[1].attributes["boolean"] = true;
			moduleNode.childNodes[1].attributes["numberNonInit"] = -21211.21;
			moduleNode.childNodes[1].attributes["numberInit"] = 15452;
			moduleNode.childNodes[1].attributes["stringNonInit"] = "ii";
			moduleNode.childNodes[1].attributes["stringInit"] = "jj";
			moduleNode.childNodes[1].attributes["functionInit"] = Cubic.easeOut;
			moduleNode.childNodes[1].attributes["dummyObject"] = new Object();
			
			moduleNode.childNodes[1].attributes["dummyObject"]["boolean"] = false;
			moduleNode.childNodes[1].attributes["dummyObject"]["numberNonInit"] = -21.22341;
			moduleNode.childNodes[1].attributes["dummyObject"]["numberInit"] = 10032;
			moduleNode.childNodes[1].attributes["dummyObject"]["stringNonInit"] = "kk";
			moduleNode.childNodes[1].attributes["dummyObject"]["stringInit"] = "kk";
			moduleNode.childNodes[1].attributes["dummyObject"]["functionInit"] = Cubic.easeInOut;
			
			var dummyObjectParent:DummyObjectParent = new DummyObjectParent();
			dataNodeToObject(moduleNode, dummyObjectParent);
			
			Assert.assertStrictlyEquals(moduleNode.attributes["boolean"], dummyObjectParent.boolean);
			Assert.assertStrictlyEquals(moduleNode.attributes["numberNonInit"], dummyObjectParent.numberNonInit);
			Assert.assertStrictlyEquals(moduleNode.attributes["numberInit"], dummyObjectParent.numberInit);
			Assert.assertStrictlyEquals(moduleNode.attributes["stringNonInit"], dummyObjectParent.stringNonInit);
			Assert.assertStrictlyEquals(moduleNode.attributes["stringInit"], dummyObjectParent.stringInit);
			Assert.assertStrictlyEquals(moduleNode.attributes["functionInit"], dummyObjectParent.functionInit);
			
			Assert.assertStrictlyEquals(moduleNode.attributes["dummyObject"]["boolean"], dummyObjectParent.dummyObject.boolean);
			Assert.assertStrictlyEquals(moduleNode.attributes["dummyObject"]["numberNonInit"], dummyObjectParent.dummyObject.numberNonInit);
			Assert.assertStrictlyEquals(moduleNode.attributes["dummyObject"]["numberInit"], dummyObjectParent.dummyObject.numberInit);
			Assert.assertStrictlyEquals(moduleNode.attributes["dummyObject"]["stringNonInit"], dummyObjectParent.dummyObject.stringNonInit);
			Assert.assertStrictlyEquals(moduleNode.attributes["dummyObject"]["stringInit"], dummyObjectParent.dummyObject.stringInit);
			Assert.assertStrictlyEquals(moduleNode.attributes["dummyObject"]["functionInit"], dummyObjectParent.dummyObject.functionInit as Function);
			
			Assert.assertStrictlyEquals(moduleNode.childNodes[0].attributes["boolean"], (dummyObjectParent.getAllChildren()[0] as DummyObjectChild).boolean);
			Assert.assertStrictlyEquals(moduleNode.childNodes[0].attributes["numberNonInit"], (dummyObjectParent.getAllChildren()[0] as DummyObjectChild).numberNonInit);
			Assert.assertStrictlyEquals(moduleNode.childNodes[0].attributes["numberInit"], (dummyObjectParent.getAllChildren()[0] as DummyObjectChild).numberInit);
			Assert.assertStrictlyEquals(moduleNode.childNodes[0].attributes["stringNonInit"], (dummyObjectParent.getAllChildren()[0] as DummyObjectChild).stringNonInit);
			Assert.assertStrictlyEquals(moduleNode.childNodes[0].attributes["stringInit"], (dummyObjectParent.getAllChildren()[0] as DummyObjectChild).stringInit);
			Assert.assertStrictlyEquals(moduleNode.childNodes[0].attributes["functionInit"], (dummyObjectParent.getAllChildren()[0] as DummyObjectChild).functionInit as Function);
			
			Assert.assertStrictlyEquals(moduleNode.childNodes[0].attributes["dummyObject"]["boolean"], (dummyObjectParent.getAllChildren()[0] as DummyObjectChild).dummyObject.boolean);
			Assert.assertStrictlyEquals(moduleNode.childNodes[0].attributes["dummyObject"]["numberNonInit"], (dummyObjectParent.getAllChildren()[0] as DummyObjectChild).dummyObject.numberNonInit);
			Assert.assertStrictlyEquals(moduleNode.childNodes[0].attributes["dummyObject"]["numberInit"], (dummyObjectParent.getAllChildren()[0] as DummyObjectChild).dummyObject.numberInit);
			Assert.assertStrictlyEquals(moduleNode.childNodes[0].attributes["dummyObject"]["stringNonInit"], (dummyObjectParent.getAllChildren()[0] as DummyObjectChild).dummyObject.stringNonInit);
			Assert.assertStrictlyEquals(moduleNode.childNodes[0].attributes["dummyObject"]["stringInit"], (dummyObjectParent.getAllChildren()[0] as DummyObjectChild).dummyObject.stringInit);
			Assert.assertStrictlyEquals(moduleNode.childNodes[0].attributes["dummyObject"]["functionInit"], (dummyObjectParent.getAllChildren()[0] as DummyObjectChild).dummyObject.functionInit as Function);
			
			Assert.assertStrictlyEquals(moduleNode.childNodes[1].attributes["boolean"], (dummyObjectParent.getAllChildren()[1] as DummyObjectChild).boolean);
			Assert.assertStrictlyEquals(moduleNode.childNodes[1].attributes["numberNonInit"], (dummyObjectParent.getAllChildren()[1] as DummyObjectChild).numberNonInit);
			Assert.assertStrictlyEquals(moduleNode.childNodes[1].attributes["numberInit"], (dummyObjectParent.getAllChildren()[1] as DummyObjectChild).numberInit);
			Assert.assertStrictlyEquals(moduleNode.childNodes[1].attributes["stringNonInit"], (dummyObjectParent.getAllChildren()[1] as DummyObjectChild).stringNonInit);
			Assert.assertStrictlyEquals(moduleNode.childNodes[1].attributes["stringInit"], (dummyObjectParent.getAllChildren()[1] as DummyObjectChild).stringInit);
			Assert.assertStrictlyEquals(moduleNode.childNodes[1].attributes["functionInit"], (dummyObjectParent.getAllChildren()[1] as DummyObjectChild).functionInit as Function);
			
			Assert.assertStrictlyEquals(moduleNode.childNodes[1].attributes["dummyObject"]["boolean"], (dummyObjectParent.getAllChildren()[1] as DummyObjectChild).dummyObject.boolean);
			Assert.assertStrictlyEquals(moduleNode.childNodes[1].attributes["dummyObject"]["numberNonInit"], (dummyObjectParent.getAllChildren()[1] as DummyObjectChild).dummyObject.numberNonInit);
			Assert.assertStrictlyEquals(moduleNode.childNodes[1].attributes["dummyObject"]["numberInit"], (dummyObjectParent.getAllChildren()[1] as DummyObjectChild).dummyObject.numberInit);
			Assert.assertStrictlyEquals(moduleNode.childNodes[1].attributes["dummyObject"]["stringNonInit"], (dummyObjectParent.getAllChildren()[1] as DummyObjectChild).dummyObject.stringNonInit);
			Assert.assertStrictlyEquals(moduleNode.childNodes[1].attributes["dummyObject"]["stringInit"], (dummyObjectParent.getAllChildren()[1] as DummyObjectChild).dummyObject.stringInit);
			Assert.assertStrictlyEquals(moduleNode.childNodes[1].attributes["dummyObject"]["functionInit"], (dummyObjectParent.getAllChildren()[1] as DummyObjectChild).dummyObject.functionInit as Function);
		}
		
		[Test] 
		public function unrecognizedChild():void {
			var moduleNode:DataNode = new DataNode("whatever");
			moduleNode.childNodes.push(new DataNode("nonexistant"));
			var dummyObjectParent:DummyObjectParent = new DummyObjectParent();
			try{
				dataNodeToObject(moduleNode, dummyObjectParent);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Unrecognized child: nonexistant", message);
		}
		
		[Test]
		public function redundantChild():void {
			var moduleNode:DataNode = new DataNode("whatever");
			moduleNode.childNodes.push(new DataNode("DummyObjectChild"));
			moduleNode.childNodes[0].childNodes.push(new DataNode("Invalid"));
			var dummyObjectParent:DummyObjectParent = new DummyObjectParent();
			try{
				dataNodeToObject(moduleNode, dummyObjectParent);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Redundant children for: DummyObjectChild", message);
		}
		
		[Test]
		public function unrecognizedAttribute():void {
			var moduleNode:DataNode = new DataNode("any");
			moduleNode.attributes["nonexistant"] = "foo";
			var dummyObject:DummyObject = new DummyObject();
			try{
				dataNodeToObject(moduleNode, dummyObject);
			}catch(e:Error){
				message = e.message;
			}
			Assert.assertEquals("Unrecognized attribute: nonexistant", message);
		}
	}
}

import com.robertpenner.easing.*;
import com.panozona.player.module.data.structure.DataParent;

class DummyObjectParent extends DataParent {
	override public function getChildrenTypes():Vector.<Class> {
		var result:Vector.<Class> = new Vector.<Class>();
		result.push(DummyObjectChild);
		return result;
	}
	public var dummyObject:DummyObject = new DummyObject();	
	public var boolean:Boolean;
	public var numberNonInit:Number;
	public var numberInit:Number = -12.12;
	public var stringNonInit:String;
	public var stringInit:String = "default";
	public var functionInit:Function = Linear.easeNone;
}

class DummyObject{
	public var boolean:Boolean;
	public var numberNonInit:Number;
	public var numberInit:Number = -12.12;
	public var stringNonInit:String;
	public var stringInit:String = "default";
	public var functionInit:Function = Linear.easeNone;
}

class DummyObjectChild {
	public var dummyObject:DummyObject = new DummyObject();
	public var boolean:Boolean;
	public var numberNonInit:Number;
	public var numberInit:Number = -12.12;
	public var stringNonInit:String;
	public var stringInit:String = "default";
	public var functionInit:Function = Linear.easeNone;
}