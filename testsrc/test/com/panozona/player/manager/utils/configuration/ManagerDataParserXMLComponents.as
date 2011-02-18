package test.com.panozona.player.manager.utils.configuration {
	
	import com.panozona.player.component.*;
	import com.panozona.player.manager.events.*;
	import com.panozona.player.manager.utils.configuration.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ManagerDataParserXMLComponents extends com.panozona.player.manager.utils.configuration.ManagerDataParserXML{
		
		protected var infoCount:int;
		protected var warningCount:int;
		protected var errorCount:int;
		
		public function ManagerDataParserXMLComponents():void {
			addEventListener(ConfigurationEvent.INFO, function(event:Event):void {infoCount++;});
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void{warningCount++;});
			addEventListener(ConfigurationEvent.ERROR, function(event:Event):void{errorCount++;});
		}
		
		[Before]
		public function beforeTest():void {
			infoCount = 0;
			warningCount = 0;
			errorCount = 0;
		}
		
		[Test]
		public function parseComponentNodeRecursiveStructure():void {
			var componentNode:ComponentNode = new ComponentNode("a");
			var nodeXML:XML = new XML("<root><b><f/><c><d/><e/></c></b></root>");
			
			parseComponentNodeRecursive(componentNode, nodeXML);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			Assert.assertStrictlyEquals("b", componentNode.childNodes[0].name);
			Assert.assertStrictlyEquals("f", componentNode.childNodes[0].childNodes[0].name);
			Assert.assertStrictlyEquals("c", componentNode.childNodes[0].childNodes[1].name);
			Assert.assertStrictlyEquals("d", componentNode.childNodes[0].childNodes[1].childNodes[0].name);
			Assert.assertStrictlyEquals("e", componentNode.childNodes[0].childNodes[1].childNodes[1].name);
		}
		
		[Test]
		public function parseComponentNodeRecursiveStructureFails():void {
			var componentNode:ComponentNode = new ComponentNode("a");
			var nodeXML:XML = new XML("<root><b><f/><c><d/><e/></c></b></root>");
			
			parseComponentNodeRecursive(componentNode, nodeXML);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			Assert.assertFalse("f" == componentNode.childNodes[0].childNodes[1].childNodes[0].name);
		}
		
		[Test]
		public function parseComponentNodeRecursiveStructureBoolean():void {
			var componentNode:ComponentNode = new ComponentNode("a");
			var nodeXML:XML = new XML("<root><b bool_t=\"true\" bool_f=\"false\"><c bool_t=\"true\" bool_f=\"false\"/></b></root>");
			
			parseComponentNodeRecursive(componentNode, nodeXML);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			Assert.assertStrictlyEquals("b", componentNode.childNodes[0].name);
			Assert.assertStrictlyEquals(true, componentNode.childNodes[0].attributes.bool_t);
			Assert.assertStrictlyEquals(false, componentNode.childNodes[0].attributes.bool_f);
			
			Assert.assertStrictlyEquals("c", componentNode.childNodes[0].childNodes[0].name);
			Assert.assertStrictlyEquals(true, componentNode.childNodes[0].childNodes[0].attributes.bool_t);
			Assert.assertStrictlyEquals(false, componentNode.childNodes[0].childNodes[0].attributes.bool_f);
		}
		
		[Test]
		public function parseComponentNodeRecursiveStructureNumber():void {
			var componentNode:ComponentNode = new ComponentNode("a");
			var nodeXML:XML = new XML("<root><b num_n=\"-12.12\" num_c=\"#FF00FF\" num_nan=\"NaN\"><c num_n=\"-12.12\" num_c=\"#FF00FF\" num_nan=\"NaN\"/></b></root>");
			
			parseComponentNodeRecursive(componentNode, nodeXML);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			Assert.assertStrictlyEquals("b", componentNode.childNodes[0].name);
			Assert.assertStrictlyEquals(-12.12, componentNode.childNodes[0].attributes.num_n);
			Assert.assertStrictlyEquals(0xff00ff, componentNode.childNodes[0].attributes.num_c);
			Assert.assertTrue(isNaN(componentNode.childNodes[0].attributes.num_nan));
			
			Assert.assertStrictlyEquals("c", componentNode.childNodes[0].childNodes[0].name);
			Assert.assertStrictlyEquals(-12.12, componentNode.childNodes[0].childNodes[0].attributes.num_n);
			Assert.assertStrictlyEquals(0xff00ff, componentNode.childNodes[0].childNodes[0].attributes.num_c);
			Assert.assertTrue(isNaN(componentNode.childNodes[0].childNodes[0].attributes.num_nan));
		}
		
		[Test]
		public function parseComponentNodeRecursiveStructureString():void {
			
			var componentNode:ComponentNode = new ComponentNode("a");
			var nodeXML:XML = new XML("<root><b str_1=\"\" str_2=\"foo\" str_3=\"[-12.12]\"><c str_1=\"\" str_2=\"foo\" str_3=\"[-12.12]\"/></b></root>");
			
			parseComponentNodeRecursive(componentNode, nodeXML);
			
			//Assert.assertEquals(0, infoCount);
			//Assert.assertEquals(0, warningCount);
			//Assert.assertEquals(0, errorCount);
			
			Assert.assertStrictlyEquals("b", componentNode.childNodes[0].name);
			Assert.assertNull(componentNode.childNodes[0].attributes.str_1);
			Assert.assertStrictlyEquals("foo", componentNode.childNodes[0].attributes.str_2);
			Assert.assertStrictlyEquals("-12.12", componentNode.childNodes[0].attributes.str_3);
			
			Assert.assertStrictlyEquals("c", componentNode.childNodes[0].childNodes[0].name);
			Assert.assertNull(componentNode.childNodes[0].childNodes[0].attributes.str_1);
			Assert.assertStrictlyEquals("foo", componentNode.childNodes[0].childNodes[0].attributes.str_2);
			Assert.assertStrictlyEquals("-12.12", componentNode.childNodes[0].childNodes[0].attributes.str_3);
		}
		
		[Test]
		public function parseComponentNodeRecursiveStructureCdata():void {
			var componentNode:ComponentNode = new ComponentNode("a");
			var nodeXML:XML = new XML("<root><b><![CDATA[:;.]]><c text=\"foo\"/></b></root>");
			
			parseComponentNodeRecursive(componentNode, nodeXML);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			Assert.assertStrictlyEquals("b", componentNode.childNodes[0].name);
			Assert.assertEquals(":;.", componentNode.childNodes[0].attributes.text); // TODO: why fails on strictlyEquals?
			
			Assert.assertStrictlyEquals("c", componentNode.childNodes[0].childNodes[0].name);
			Assert.assertStrictlyEquals("foo", componentNode.childNodes[0].childNodes[0].attributes.text);
		}
		
		[Test]
		public function parseComponentNodeRecursiveStructureFunction():void {
			var componentNode:ComponentNode = new ComponentNode("a");
			var nodeXML:XML = new XML("<root><b fun_1=\"Back.easeIn\"><c fun_1=\"Bounce.easeIn\"/></b></root>");
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			parseComponentNodeRecursive(componentNode, nodeXML);
			
			Assert.assertStrictlyEquals("b", componentNode.childNodes[0].name);
			Assert.assertStrictlyEquals(Back.easeIn, componentNode.childNodes[0].attributes.fun_1);
			
			Assert.assertStrictlyEquals("c", componentNode.childNodes[0].childNodes[0].name);
			Assert.assertStrictlyEquals(Bounce.easeIn, componentNode.childNodes[0].childNodes[0].attributes.fun_1);
		}
		
		[Test]
		public function parseComponentNodeRecursiveStructureObject():void {
			var componentNode:ComponentNode = new ComponentNode("a");
			var nodeXML:XML = new XML("<root><b obj1=\"str:foo,bool:true,num:-12.12,fun:Back.easeIn\"><c obj1=\"str:foo,bool:true,num:-12.12,fun:Back.easeIn\"/></b></root>");
			
			parseComponentNodeRecursive(componentNode, nodeXML);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			Assert.assertStrictlyEquals("b", componentNode.childNodes[0].name);
			Assert.assertStrictlyEquals("foo", componentNode.childNodes[0].attributes.obj1.str);
			Assert.assertStrictlyEquals(true, componentNode.childNodes[0].attributes.obj1.bool);
			Assert.assertStrictlyEquals(-12.12, componentNode.childNodes[0].attributes.obj1.num);
			Assert.assertStrictlyEquals(Back.easeIn, componentNode.childNodes[0].attributes.obj1.fun);
			
			Assert.assertStrictlyEquals("c", componentNode.childNodes[0].childNodes[0].name);
			Assert.assertStrictlyEquals("foo", componentNode.childNodes[0].childNodes[0].attributes.obj1.str);
			Assert.assertStrictlyEquals(true, componentNode.childNodes[0].childNodes[0].attributes.obj1.bool);
			Assert.assertStrictlyEquals(-12.12, componentNode.childNodes[0].childNodes[0].attributes.obj1.num);
			Assert.assertStrictlyEquals(Back.easeIn, componentNode.childNodes[0].childNodes[0].attributes.obj1.fun);
		}
		
		[Test]
		public function parseComponentNodeRecursiveWarning():void {
			
			var nodeXML_a:XML = new XML("<root><a text=\"foo\"><![CDATA[bar]]></a></root>");
			var nodeXML_b:XML = new XML("<root><a><![CDATA[foo]]><![CDATA[bar]]></a></root>");
			var nodeXML_c:XML = new XML("<root><a><b text=\"foo\"><![CDATA[bar]]></b></a></root>");
			var nodeXML_d:XML = new XML("<root><a><b><![CDATA[foo]]><![CDATA[bar]]></b></a></root>");
			
			parseComponentNodeRecursive(new ComponentNode("a"), nodeXML_a);
			parseComponentNodeRecursive(new ComponentNode("b"), nodeXML_b);
			parseComponentNodeRecursive(new ComponentNode("c"), nodeXML_c);
			parseComponentNodeRecursive(new ComponentNode("d"), nodeXML_c);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(4, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function parseComponentsStructure():void {
			var componentDatas:Vector.<ComponentData> = new Vector.<ComponentData>();
			var nodeXML:XML = new XML("<root><ca path=\"path_a\"><a/><b/></ca><cb path=\"path_b\"><c/><d/></cb></root>");
			
			parseComponents(componentDatas, nodeXML);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			Assert.assertEquals(2, componentDatas.length);
			
			Assert.assertEquals("ca", componentDatas[0].name);
			Assert.assertEquals("path_a", componentDatas[0].path);
			Assert.assertEquals(2, componentDatas[0].nodes.length);
			
			Assert.assertEquals("cb", componentDatas[1].name);
			Assert.assertEquals("path_b", componentDatas[1].path);
			Assert.assertEquals(2, componentDatas[1].nodes.length);
		}
		
		[Test]
		public function parseComponentsWarning():void {
			var componentDatas:Vector.<ComponentData> = new Vector.<ComponentData>();
			
			// path not found
			var nodeXML_a:XML = new XML("<root><ca><a/><b/></ca><cb path=\"path_b\"><c/><d/></cb></root>");
			
			parseComponents(componentDatas, nodeXML_a);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
	}
}