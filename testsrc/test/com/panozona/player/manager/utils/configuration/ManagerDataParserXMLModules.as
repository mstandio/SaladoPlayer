package test.com.panozona.player.manager.utils.configuration {
	
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	import com.panozona.player.manager.events.*;
	import com.panozona.player.manager.utils.configuration.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ManagerDataParserXMLModules extends com.panozona.player.manager.utils.configuration.ManagerDataParserXML{
		
		protected var infoCount:int;
		protected var warningCount:int;
		protected var errorCount:int;
		
		public function ManagerDataParserXMLModules():void {
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
		public function parseDataNodeRecursiveStructure():void {
			var dataNode:DataNode = new DataNode("a");
			var nodeXML:XML = new XML(
				"<root>" +
					"<b>" +
						"<f/>" +
						"<c>" +
							"<d/>" +
							"<e/>" +
						"</c>" +
					"</b>" +
				"</root>");
			
			parseDataNodeRecursive(dataNode, nodeXML);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			Assert.assertStrictlyEquals("b", dataNode.childNodes[0].name);
			Assert.assertStrictlyEquals("f", dataNode.childNodes[0].childNodes[0].name);
			Assert.assertStrictlyEquals("c", dataNode.childNodes[0].childNodes[1].name);
			Assert.assertStrictlyEquals("d", dataNode.childNodes[0].childNodes[1].childNodes[0].name);
			Assert.assertStrictlyEquals("e", dataNode.childNodes[0].childNodes[1].childNodes[1].name);
		}
		
		[Test]
		public function parseDataNodeRecursiveStructureFails():void {
			var dataNode:DataNode = new DataNode("a");
			var nodeXML:XML = new XML(
				"<root>" +
					"<b>" +
						"<f/>" +
						"<c>" +
							"<d/>" +
							"<e/>" +
						"</c>" +
					"</b>" +
				"</root>");
			
			parseDataNodeRecursive(dataNode, nodeXML);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			Assert.assertFalse("f" == dataNode.childNodes[0].childNodes[1].childNodes[0].name);
		}
		
		[Test]
		public function parseDataNodeRecursiveStructureBoolean():void {
			var dataNode:DataNode = new DataNode("a");
			var nodeXML:XML = new XML(
				"<root>" +
					"<b bool_t=\"true\" bool_f=\"false\">" +
						"<c bool_t=\"true\" bool_f=\"false\"/>" +
					"</b>" +
				"</root>");
			
			parseDataNodeRecursive(dataNode, nodeXML);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			Assert.assertStrictlyEquals("b", dataNode.childNodes[0].name);
			Assert.assertStrictlyEquals(true, dataNode.childNodes[0].attributes.bool_t);
			Assert.assertStrictlyEquals(false, dataNode.childNodes[0].attributes.bool_f);
			
			Assert.assertStrictlyEquals("c", dataNode.childNodes[0].childNodes[0].name);
			Assert.assertStrictlyEquals(true, dataNode.childNodes[0].childNodes[0].attributes.bool_t);
			Assert.assertStrictlyEquals(false, dataNode.childNodes[0].childNodes[0].attributes.bool_f);
		}
		
		[Test]
		public function parseDataNodeRecursiveStructureNumber():void {
			var dataNode:DataNode = new DataNode("a");
			var nodeXML:XML = new XML(
			"<root>" +
				"<b num_n=\"-12.12\" num_c=\"#FF00FF\" num_nan=\"NaN\">" +
					"<c num_n=\"-12.12\" num_c=\"#FF00FF\" num_nan=\"NaN\"/>" +
				"</b>" +
			"</root>");
			
			parseDataNodeRecursive(dataNode, nodeXML);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			Assert.assertStrictlyEquals("b", dataNode.childNodes[0].name);
			Assert.assertStrictlyEquals(-12.12, dataNode.childNodes[0].attributes.num_n);
			Assert.assertStrictlyEquals(0xff00ff, dataNode.childNodes[0].attributes.num_c);
			Assert.assertTrue(isNaN(dataNode.childNodes[0].attributes.num_nan));
			
			Assert.assertStrictlyEquals("c", dataNode.childNodes[0].childNodes[0].name);
			Assert.assertStrictlyEquals(-12.12, dataNode.childNodes[0].childNodes[0].attributes.num_n);
			Assert.assertStrictlyEquals(0xff00ff, dataNode.childNodes[0].childNodes[0].attributes.num_c);
			Assert.assertTrue(isNaN(dataNode.childNodes[0].childNodes[0].attributes.num_nan));
		}
		
		[Test]
		public function parseDataNodeRecursiveStructureString():void {
			
			var dataNode:DataNode = new DataNode("a");
			var nodeXML:XML = new XML(
				"<root>" +
					"<b str_1=\"\" str_2=\"foo\" str_3=\"[-12.12]\">" +
						"<c str_1=\"\" str_2=\"foo\" str_3=\"[-12.12]\"/>" +
					"</b>" +
				"</root>");
			
			parseDataNodeRecursive(dataNode, nodeXML);
			
			//Assert.assertEquals(0, infoCount);
			//Assert.assertEquals(0, warningCount);
			//Assert.assertEquals(0, errorCount);
			
			Assert.assertStrictlyEquals("b", dataNode.childNodes[0].name);
			Assert.assertNull(dataNode.childNodes[0].attributes.str_1);
			Assert.assertStrictlyEquals("foo", dataNode.childNodes[0].attributes.str_2);
			Assert.assertStrictlyEquals("-12.12", dataNode.childNodes[0].attributes.str_3);
			
			Assert.assertStrictlyEquals("c", dataNode.childNodes[0].childNodes[0].name);
			Assert.assertNull(dataNode.childNodes[0].childNodes[0].attributes.str_1);
			Assert.assertStrictlyEquals("foo", dataNode.childNodes[0].childNodes[0].attributes.str_2);
			Assert.assertStrictlyEquals("-12.12", dataNode.childNodes[0].childNodes[0].attributes.str_3);
		}
		
		[Test]
		public function parseDataNodeRecursiveStructureCdata():void {
			var dataNode:DataNode = new DataNode("a");
			var nodeXML:XML = new XML(
				"<root>" +
					"<b>" +
						"<![CDATA[:;.]]>" +
						"<c text=\"foo\"/>" +
					"</b>" +
				"</root>");
			
			parseDataNodeRecursive(dataNode, nodeXML);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			Assert.assertStrictlyEquals("b", dataNode.childNodes[0].name);
			Assert.assertStrictlyEquals(":;.", dataNode.childNodes[0].attributes.text);
			
			Assert.assertStrictlyEquals("c", dataNode.childNodes[0].childNodes[0].name);
			Assert.assertStrictlyEquals("foo", dataNode.childNodes[0].childNodes[0].attributes.text);
		}
		
		[Test]
		public function parseDataNodeRecursiveStructureFunction():void {
			var dataNode:DataNode = new DataNode("a");
			var nodeXML:XML = new XML(
				"<root>" +
					"<b fun_1=\"Back.easeIn\">" +
						"<c fun_1=\"Bounce.easeIn\"/>" +
					"</b>" +
				"</root>");
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			parseDataNodeRecursive(dataNode, nodeXML);
			
			Assert.assertStrictlyEquals("b", dataNode.childNodes[0].name);
			Assert.assertStrictlyEquals(Back.easeIn, dataNode.childNodes[0].attributes.fun_1);
			
			Assert.assertStrictlyEquals("c", dataNode.childNodes[0].childNodes[0].name);
			Assert.assertStrictlyEquals(Bounce.easeIn, dataNode.childNodes[0].childNodes[0].attributes.fun_1);
		}
		
		[Test]
		public function parseDataNodeRecursiveStructureObject():void {
			var dataNode:DataNode = new DataNode("a");
			var nodeXML:XML = new XML(
				"<root>" +
					"<b obj1=\"str:foo,bool:true,num:-12.12,fun:Back.easeIn\">" +
						"<c obj1=\"str:foo,bool:true,num:-12.12,fun:Back.easeIn\"/>" +
					"</b>" +
				"</root>");
			
			parseDataNodeRecursive(dataNode, nodeXML);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			Assert.assertStrictlyEquals("b", dataNode.childNodes[0].name);
			Assert.assertStrictlyEquals("foo", dataNode.childNodes[0].attributes.obj1.str);
			Assert.assertStrictlyEquals(true, dataNode.childNodes[0].attributes.obj1.bool);
			Assert.assertStrictlyEquals(-12.12, dataNode.childNodes[0].attributes.obj1.num);
			Assert.assertStrictlyEquals(Back.easeIn, dataNode.childNodes[0].attributes.obj1.fun);
			
			Assert.assertStrictlyEquals("c", dataNode.childNodes[0].childNodes[0].name);
			Assert.assertStrictlyEquals("foo", dataNode.childNodes[0].childNodes[0].attributes.obj1.str);
			Assert.assertStrictlyEquals(true, dataNode.childNodes[0].childNodes[0].attributes.obj1.bool);
			Assert.assertStrictlyEquals(-12.12, dataNode.childNodes[0].childNodes[0].attributes.obj1.num);
			Assert.assertStrictlyEquals(Back.easeIn, dataNode.childNodes[0].childNodes[0].attributes.obj1.fun);
		}
		
		[Test]
		public function parseDataNodeRecursiveWarning():void {
			
			var nodeXML_a:XML = new XML(
				"<root>" +
					"<a text=\"foo\">" +
						"<![CDATA[bar]]>" +
					"</a>" +
				"</root>");
				
			var nodeXML_b:XML = new XML(
			"<root>" +
				"<a>" +
					"<![CDATA[foo]]>" +
					"<![CDATA[bar]]>" +
				"</a>" +
			"</root>");
			
			var nodeXML_c:XML = new XML(
			"<root>" +
				"<a>" +
					"<b text=\"foo\">" +
						"<![CDATA[bar]]>" +
					"</b>" +
				"</a>" +
			"</root>");
			
			var nodeXML_d:XML = new XML(
				"<root>" +
					"<a>" +
						"<b>" +
							"<![CDATA[foo]]>" +
							"<![CDATA[bar]]>" +
						"</b>" +
					"</a>" +
				"</root>");
			
			parseDataNodeRecursive(new DataNode("a"), nodeXML_a);
			parseDataNodeRecursive(new DataNode("b"), nodeXML_b);
			parseDataNodeRecursive(new DataNode("c"), nodeXML_c);
			parseDataNodeRecursive(new DataNode("d"), nodeXML_c);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(4, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function parseModulesSmokeTest():void {
			var moduleDatas:Vector.<ModuleData> = new Vector.<ModuleData>();
			var nodeXML:XML = new XML(
				"<modules>" +
					"<name_a path=\"path_a\">" +
						"<a/>" +
						"<b/>" +
					"</name_a>" +
					"<name_b path=\"path_b\">" +
						"<c/>" +
						"<d/>" +
					"</name_b>" +
				"</modules>");
			
			parseModules(moduleDatas, nodeXML);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			Assert.assertEquals(2, moduleDatas.length);
			
			Assert.assertEquals("name_a", moduleDatas[0].name);
			Assert.assertEquals("path_a", moduleDatas[0].path);
			Assert.assertEquals(2, moduleDatas[0].nodes.length);
			
			Assert.assertEquals("name_b", moduleDatas[1].name);
			Assert.assertEquals("path_b", moduleDatas[1].path);
			Assert.assertEquals(2, moduleDatas[1].nodes.length);
		}
		
		[Test]
		public function parseModulesNoPath():void {
			var moduleDatas:Vector.<ModuleData> = new Vector.<ModuleData>();
			
			var nodeXML_a:XML = new XML(
				"<modules>" +
					"<name_a>" +
						"<a/>" +
						"<b/>" +
					"</name_a>" +
					"<name_b path=\"path_b\">" +
						"<c/>" +
						"<d/>" +
					"</name_b>" +
				"</modules>");
			
			parseModules(moduleDatas, nodeXML_a);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
	}
}