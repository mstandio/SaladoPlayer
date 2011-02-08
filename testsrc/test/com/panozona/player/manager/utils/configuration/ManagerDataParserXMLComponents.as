package test.com.panozona.player.manager.utils.configuration {
	
	import com.panozona.player.component.*;
	import com.panozona.player.manager.utils.configuration.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ManagerDataParserXMLComponents extends com.panozona.player.manager.utils.configuration.ManagerDataParserXML{
		
		[Test]
		public function parseComponentNodeRecursiveStructure():void {
			var componentNode_a2:ComponentNode = new ComponentNode("a");
			var nodeXML:XML = new XML("<root><b><f/><c><d/><e/></c></b></root>");
			
			parseComponentNodeRecursive(componentNode_a2, nodeXML);
			Assert.assertStrictlyEquals("b", componentNode_a2.childNodes[0].name);
			Assert.assertStrictlyEquals("f", componentNode_a2.childNodes[0].childNodes[0].name);
			Assert.assertStrictlyEquals("c", componentNode_a2.childNodes[0].childNodes[1].name);
			Assert.assertStrictlyEquals("d", componentNode_a2.childNodes[0].childNodes[1].childNodes[0].name);
			Assert.assertStrictlyEquals("e", componentNode_a2.childNodes[0].childNodes[1].childNodes[1].name);
		}
		
		[Test]
		public function parseComponentNodeRecursiveStructureFails():void {
			var componentNode_a2:ComponentNode = new ComponentNode("a");
			var nodeXML:XML = new XML("<root><b><f/><c><d/><e/></c></b></root>");
			
			parseComponentNodeRecursive(componentNode_a2, nodeXML);
			Assert.assertFalse("f" == componentNode_a2.childNodes[0].childNodes[1].childNodes[0].name);
		}
		
		[Test]
		public function parseComponentNodeRecursiveStructureBoolean():void {
			var componentNode_a2:ComponentNode = new ComponentNode("a");
			var nodeXML:XML = new XML("<root><b bool_t=\"true\" bool_f=\"false\"><c bool_t=\"true\" bool_f=\"false\"/></b></root>");
			
			parseComponentNodeRecursive(componentNode_a2, nodeXML);
			
			Assert.assertStrictlyEquals("b", componentNode_a2.childNodes[0].name);
			Assert.assertStrictlyEquals(true, componentNode_a2.childNodes[0].attributes.bool_t);
			Assert.assertStrictlyEquals(false, componentNode_a2.childNodes[0].attributes.bool_f);
			
			Assert.assertStrictlyEquals("c", componentNode_a2.childNodes[0].childNodes[0].name);
			Assert.assertStrictlyEquals(true, componentNode_a2.childNodes[0].childNodes[0].attributes.bool_t);
			Assert.assertStrictlyEquals(false, componentNode_a2.childNodes[0].childNodes[0].attributes.bool_f);
		}
		
		[Test]
		public function parseComponentNodeRecursiveStructureNumber():void {
			var componentNode_a2:ComponentNode = new ComponentNode("a");
			var nodeXML:XML = new XML("<root><b num_n=\"-12.12\" num_c=\"#FF00FF\" num_nan=\"NaN\"><c num_n=\"-12.12\" num_c=\"#FF00FF\" num_nan=\"NaN\"/></b></root>");
			
			parseComponentNodeRecursive(componentNode_a2, nodeXML);
			
			Assert.assertStrictlyEquals("b", componentNode_a2.childNodes[0].name);
			Assert.assertStrictlyEquals(-12.12, componentNode_a2.childNodes[0].attributes.num_n);
			Assert.assertStrictlyEquals(0xff00ff, componentNode_a2.childNodes[0].attributes.num_c);
			Assert.assertTrue(isNaN(componentNode_a2.childNodes[0].attributes.num_nan));
			
			Assert.assertStrictlyEquals("c", componentNode_a2.childNodes[0].childNodes[0].name);
			Assert.assertStrictlyEquals(-12.12, componentNode_a2.childNodes[0].childNodes[0].attributes.num_n);
			Assert.assertStrictlyEquals(0xff00ff, componentNode_a2.childNodes[0].childNodes[0].attributes.num_c);
			Assert.assertTrue(isNaN(componentNode_a2.childNodes[0].childNodes[0].attributes.num_nan));
		}
		
		[Test]
		public function parseComponentNodeRecursiveStructureString():void {
			
			var componentNode_a2:ComponentNode = new ComponentNode("a");
			var nodeXML:XML = new XML("<root><b str_1=\"\" str_2=\"foo\" str_3=\"[-12.12]\"><c str_1=\"\" str_2=\"foo\" str_3=\"[-12.12]\"/></b></root>");
			
			parseComponentNodeRecursive(componentNode_a2, nodeXML);
			
			Assert.assertStrictlyEquals("b", componentNode_a2.childNodes[0].name);
			Assert.assertNull(componentNode_a2.childNodes[0].attributes.str_1);
			Assert.assertStrictlyEquals("foo", componentNode_a2.childNodes[0].attributes.str_2);
			Assert.assertStrictlyEquals("-12.12", componentNode_a2.childNodes[0].attributes.str_3);
			
			Assert.assertStrictlyEquals("c", componentNode_a2.childNodes[0].childNodes[0].name);
			Assert.assertNull(componentNode_a2.childNodes[0].childNodes[0].attributes.str_1);
			Assert.assertStrictlyEquals("foo", componentNode_a2.childNodes[0].childNodes[0].attributes.str_2);
			Assert.assertStrictlyEquals("-12.12", componentNode_a2.childNodes[0].childNodes[0].attributes.str_3);
		}
		
		[Test]
		public function parseComponentNodeRecursiveStructureCdata():void {
			var componentNode_a2:ComponentNode = new ComponentNode("a");
			var nodeXML:XML = new XML("<root><b><![CDATA[:;.]]><c text=\"foo\"/></b></root>");
			
			parseComponentNodeRecursive(componentNode_a2, nodeXML);
			
			Assert.assertStrictlyEquals("b", componentNode_a2.childNodes[0].name);
			Assert.assertEquals(":;.", componentNode_a2.childNodes[0].attributes.text); // TODO: why fails on strictlyEquals?
			
			Assert.assertStrictlyEquals("c", componentNode_a2.childNodes[0].childNodes[0].name);
			Assert.assertStrictlyEquals("foo", componentNode_a2.childNodes[0].childNodes[0].attributes.text);
		}
		
		[Test]
		public function parseComponentNodeRecursiveStructureFunction():void {
			var componentNode_a2:ComponentNode = new ComponentNode("a");
			var nodeXML:XML = new XML("<root><b fun_1=\"Back.easeIn\"><c fun_1=\"Bounce.easeIn\"/></b></root>");
			
			parseComponentNodeRecursive(componentNode_a2, nodeXML);
			
			Assert.assertStrictlyEquals("b", componentNode_a2.childNodes[0].name);
			Assert.assertStrictlyEquals(Back.easeIn, componentNode_a2.childNodes[0].attributes.fun_1);
			
			Assert.assertStrictlyEquals("c", componentNode_a2.childNodes[0].childNodes[0].name);
			Assert.assertStrictlyEquals(Bounce.easeIn, componentNode_a2.childNodes[0].childNodes[0].attributes.fun_1);
		}
		
		[Test]
		public function parseComponentNodeRecursiveStructureObject():void {
			var componentNode_a2:ComponentNode = new ComponentNode("a");
			var nodeXML:XML = new XML("<root><b obj1=\"str:foo,bool:true,num:-12.12,fun:Back.easeIn\"><c obj1=\"str:foo,bool:true,num:-12.12,fun:Back.easeIn\"/></b></root>");
			
			parseComponentNodeRecursive(componentNode_a2, nodeXML);
			
			Assert.assertStrictlyEquals("b", componentNode_a2.childNodes[0].name);
			Assert.assertStrictlyEquals("foo", componentNode_a2.childNodes[0].attributes.obj1.str);
			Assert.assertStrictlyEquals(true, componentNode_a2.childNodes[0].attributes.obj1.bool);
			Assert.assertStrictlyEquals(-12.12, componentNode_a2.childNodes[0].attributes.obj1.num);
			Assert.assertStrictlyEquals(Back.easeIn, componentNode_a2.childNodes[0].attributes.obj1.fun);
			
			Assert.assertStrictlyEquals("c", componentNode_a2.childNodes[0].childNodes[0].name);
			Assert.assertStrictlyEquals("foo", componentNode_a2.childNodes[0].childNodes[0].attributes.obj1.str);
			Assert.assertStrictlyEquals(true, componentNode_a2.childNodes[0].childNodes[0].attributes.obj1.bool);
			Assert.assertStrictlyEquals(-12.12, componentNode_a2.childNodes[0].childNodes[0].attributes.obj1.num);
			Assert.assertStrictlyEquals(Back.easeIn, componentNode_a2.childNodes[0].childNodes[0].attributes.obj1.fun);
		}
		
		[Test]
		public function parseComponentNodeRecursiveWarning():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; } );
			
			var nodeXML_a:XML = new XML("<root><a text=\"foo\"><![CDATA[bar]]></a></root>");
			var nodeXML_b:XML = new XML("<root><a><![CDATA[foo]]><![CDATA[bar]]></a></root>");
			var nodeXML_c:XML = new XML("<root><a><b text=\"foo\"><![CDATA[bar]]></b></a></root>");
			var nodeXML_d:XML = new XML("<root><a><b><![CDATA[foo]]><![CDATA[bar]]></b></a></root>");
			
			parseComponentNodeRecursive(new ComponentNode("a"), nodeXML_a);
			parseComponentNodeRecursive(new ComponentNode("b"), nodeXML_b);
			parseComponentNodeRecursive(new ComponentNode("c"), nodeXML_c);
			parseComponentNodeRecursive(new ComponentNode("d"), nodeXML_c);
			
			Assert.assertEquals(4, callCount);
		}
		
		[Test]
		public function parseComponentsStructure():void {
			var componentDatas_2:Vector.<ComponentData> = new Vector.<ComponentData>();
			var nodeXML:XML = new XML("<root><ca path=\"path_a\"><a/><b/></ca><cb path=\"path_b\"><c/><d/></cb></root>");
			
			parseComponents(componentDatas_2, nodeXML);
			
			Assert.assertEquals(2, componentDatas_2.length);
			
			Assert.assertEquals("ca", componentDatas_2[0].name);
			Assert.assertEquals("path_a", componentDatas_2[0].path);
			Assert.assertEquals(2, componentDatas_2[0].nodes.length);
			
			Assert.assertEquals("cb", componentDatas_2[1].name);
			Assert.assertEquals("path_b", componentDatas_2[1].path);
			Assert.assertEquals(2, componentDatas_2[1].nodes.length);
		}
		
		[Test]
		public function parseComponentsWarning():void {
			var componentDatas_2:Vector.<ComponentData> = new Vector.<ComponentData>();
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; } );
			
			var nodeXML_a:XML = new XML("<root><ca><a/><b/></ca><cb path=\"path_b\"><c/><d/></cb></root>");
			var nodeXML_b:XML = new XML("<root><ca path=\"true\"><a/><b/></ca><cb path=\"path_b\"><c/><d/></cb></root>");
			
			parseComponents(componentDatas_2, nodeXML_a);
			parseComponents(componentDatas_2, nodeXML_b);
			
			Assert.assertEquals(2, callCount);
		}
	}
}