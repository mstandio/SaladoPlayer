package test.com.panozona.player.module.utils{
	
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	import com.panozona.player.module.utils.*;
	import com.panozona.player.manager.data.actions.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ModuleDataTranslatorTranslate extends com.panozona.player.module.utils.ModuleDataTranslator {
		
		public function ModuleDataTranslatorTranslate(){
			super(true);
		}
		
		[Test]
		public function smokeTest():void {/*
			var moduleNode:ModuleNode = new ModuleNode("whatever");
			moduleNode.childNodes.push(new ModuleNode("DummyObjectChild"));
			moduleNode.childNodes.push(new ModuleNode("DummyObjectChild"));
			
			moduleNode.attributes["boolean"] = true;
			moduleNode.attributes["numberNonInit"] = -21.21;
			moduleNode.attributes["numberInit"] = NaN;
			moduleNode.attributes["stringNonInit"] = "foo";
			moduleNode.attributes["stringInit"] = "bar";
			moduleNode.attributes["functionNonInit"] = Linear.easeIn;
			moduleNode.attributes["functionInit"] = Linear.easeOut;
			moduleNode.attributes["dummyObject"] = new Object();
			
			moduleNode.attributes["dummyObject"]["boolean"] = true;
			moduleNode.attributes["dummyObject"]["numberNonInit"] = -21.21;
			moduleNode.attributes["dummyObject"]["numberInit"] = NaN;
			moduleNode.attributes["dummyObject"]["stringNonInit"] = "foo";
			moduleNode.attributes["dummyObject"]["stringInit"] = "bar";
			moduleNode.attributes["dummyObject"]["functionNonInit"] = Linear.easeIn;
			moduleNode.attributes["dummyObject"]["functionInit"] = Linear.easeOut;
			
			moduleNode.childNodes[0].attributes["boolean"] = ;
			moduleNode.childNodes[0].attributes["numberNonInit"] = ;
			moduleNode.childNodes[0].attributes["numberInit"] = ;
			moduleNode.childNodes[0].attributes["stringNonInit"] = ;
			moduleNode.childNodes[0].attributes["stringInit"] = ;
			moduleNode.childNodes[0].attributes["functionNonInit"] = ;
			moduleNode.childNodes[0].attributes["functionInit"] = ;
			moduleNode.childNodes[0].attributes["dummyObject"] = new Object();
			
			moduleNode.childNodes[0].attributes["dummyObject"]["boolean"] = ;
			moduleNode.childNodes[0].attributes["dummyObject"]["numberNonInit"] = ;
			moduleNode.childNodes[0].attributes["dummyObject"]["numberInit"] = ;
			moduleNode.childNodes[0].attributes["dummyObject"]["stringNonInit"] = ;
			moduleNode.childNodes[0].attributes["dummyObject"]["stringInit"] = ;
			moduleNode.childNodes[0].attributes["dummyObject"]["functionNonInit"] = ;
			moduleNode.childNodes[0].attributes["dummyObject"]["functionInit"] = ;
			
			moduleNode.childNodes[1].attributes["boolean"] = ;
			moduleNode.childNodes[1].attributes["numberNonInit"] = ;
			moduleNode.childNodes[1].attributes["numberInit"] = ;
			moduleNode.childNodes[1].attributes["stringNonInit"] = ;
			moduleNode.childNodes[1].attributes["stringInit"] = ;
			moduleNode.childNodes[1].attributes["functionNonInit"] = ;
			moduleNode.childNodes[1].attributes["functionInit"] = ;
			moduleNode.childNodes[1].attributes["dummyObject"] = new Object();
			
			moduleNode.childNodes[1].attributes["dummyObject"]["boolean"] = ;
			moduleNode.childNodes[1].attributes["dummyObject"]["numberNonInit"] = ;
			moduleNode.childNodes[1].attributes["dummyObject"]["numberInit"] = ;
			moduleNode.childNodes[1].attributes["dummyObject"]["stringNonInit"] = ;
			moduleNode.childNodes[1].attributes["dummyObject"]["stringInit"] = ;
			moduleNode.childNodes[1].attributes["dummyObject"]["functionNonInit"] = ;
			moduleNode.childNodes[1].attributes["dummyObject"]["functionInit"] = ;
			
			var dummyObjectParent:DummyObjectParent = new DummyObjectParent();
			translateModuleNodeToObject(moduleNode, dummyObjectParent);*/
		}
		
		[Test(expects = "Error")] 
		public function unrecognizedChild():void {
			var moduleNode:ModuleNode = new ModuleNode("whatever");
			moduleNode.childNodes.push(new ModuleNode("nonexistant"));
			var dummyObjectParent:DummyObjectParent = new DummyObjectParent();
			translateModuleNodeToObject(moduleNode, dummyObjectParent);
		}
		
		[Test(expects = "Error")] 
		public function redundantChild():void {
			var moduleNode:ModuleNode = new ModuleNode("whatever");
			moduleNode.childNodes.push(new ModuleNode("DummyObjectChild"));
			moduleNode.childNodes[0].childNodes.push(new ModuleNode("Invalid"));
			var dummyObjectParent:DummyObjectParent = new DummyObjectParent();
			translateModuleNodeToObject(moduleNode, dummyObjectParent);
		}
		
		[Test(expects="Error")]
		public function unrecognizedAttribute():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["nonexistant"] = "foo";
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchBooleanNumber():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["boolean"] = -21.21;
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchBooleanString():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["boolean"] = "foo";
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchBooleanFunction():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["boolean"] = Linear.easeOut;
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchBooleanObject():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["boolean"] = new Object();
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchNumberInitBoolean():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["numberInit"] = false
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchNumberNonInitBoolean():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["numberNonInit"] = false
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchNumberInitString():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["numberInit"] = "foo";
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchNumberNonInitString():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["numberNonInit"] = "foo";
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchNumberInitFunction():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["numberInit"] = Linear.easeOut;
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchNumberNonInitFunction():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["numberNonInit"] = new Object();
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchNumberInitObject():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["numberInit"] = Linear.easeOut;
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchNumberNonInitObject():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["numberNonInit"] = new Object();
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchStringInitBoolean():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["numberInit"] = true;
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchStringNonInitString():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["numberNonInit"] = true;
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchStringInitNumber():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["stringInit"] = -21.21;
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchStringNonInitNumber():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["stringNonInit"] = -21.21;
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchStringInitFunction():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["stringInit"] = Linear.easeOut;
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchStringNonInitFunction():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["stringNonInit"] = Linear.easeOut;
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchStringInitObject():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["stringInit"] = new Object();
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchStringNonInitObject():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["stringNonInit"] = new Object();
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchFunctionInitBoolean():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["functionInit"] = true;
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchFunctionNonInitBoolean():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["functionNonInit"] = true;
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchFunctionInitNumber():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["functionInit"] = -21.21
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchFunctionNonInitNumber():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["functionNonInit"] = -21.21;
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchFunctionInitString():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["functionInit"] = "foo"
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchFunctionNonInitSring():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["functionNonInit"] = "foo";
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchFunctionInitObject():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["functionInit"] = new Object();
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchFunctionNonInitObject():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["functionNonInit"] = new Object();
			var dummyObject:DummyObject = new DummyObject();
			translateModuleNodeToObject(moduleNode, dummyObject);
		}
		
		[Test(expects="Error")]
		public function mismatchObjectBoolean():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["dummyObject"] = true;
			var dummyObjectParent:DummyObjectParent = new DummyObjectParent();
			translateModuleNodeToObject(moduleNode, dummyObjectParent);
		}
		
		[Test(expects="Error")]
		public function mismatchObjectNumber():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["dummyObject"] = -21.21;
			var dummyObjectParent:DummyObjectParent = new DummyObjectParent();
			translateModuleNodeToObject(moduleNode, dummyObjectParent);
		}
		
		[Test(expects="Error")]
		public function mismatchObjectString():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["dummyObject"] = "foo";
			var dummyObjectParent:DummyObjectParent = new DummyObjectParent();
			translateModuleNodeToObject(moduleNode, dummyObjectParent);
		}
		
		[Test(expects="Error")]
		public function mismatchObjectFunction():void {
			var moduleNode:ModuleNode = new ModuleNode("any");
			moduleNode.attributes["dummyObject"] = Linear.easeOut;
			var dummyObjectParent:DummyObjectParent = new DummyObjectParent();
			translateModuleNodeToObject(moduleNode, dummyObjectParent);
		}
	}
}

import com.robertpenner.easing.*;
import com.panozona.player.module.data.structure.DataParent;

class DummyObjectParent extends DataParent {
	
	override public function getChildrenTypes():Vector.<Class> {
		return new Vector.<DummyObjectChild>;
	}

	public var dummyObject:DummyObject = new DummyObject();
	
	public var boolean:Boolean;
	public var numberNonInit:Number;
	public var numberInit:Number = -12.12;
	public var stringNonInit:String;
	public var stringInit:String = "default";
	public var functionNonInit:Function;
	public var functionInit:Function = Linear.easeNone;
}

class DummyObject{
	public var boolean:Boolean;
	public var numberNonInit:Number;
	public var numberInit:Number = -12.12;
	public var stringNonInit:String;
	public var stringInit:String = "default";
	public var functionNonInit:Function;
	public var functionInit:Function = Linear.easeNone;
}

class DummyObjectChild {

	public var dummyObject:DummyObject = new DummyObject();
	
	public var boolean:Boolean;
	public var numberNonInit:Number;
	public var numberInit:Number = -12.12;
	public var stringNonInit:String;
	public var stringInit:String = "default";
	public var functionNonInit:Function;
	public var functionInit:Function = Linear.easeNone;
}