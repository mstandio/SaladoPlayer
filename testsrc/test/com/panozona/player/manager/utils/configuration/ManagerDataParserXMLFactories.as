package test.com.panozona.player.manager.utils.configuration {
	
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	import com.panozona.player.manager.events.*;
	import com.panozona.player.manager.utils.configuration.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ManagerDataParserXMLFactories extends com.panozona.player.manager.utils.configuration.ManagerDataParserXML{
		
		protected var infoCount:int;
		protected var warningCount:int;
		protected var errorCount:int;
		
		public function ManagerDataParserXMLFactories():void {
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
		public function parseModulesSmokeTest():void {
			var moduleDatas:Vector.<ModuleData> = new Vector.<ModuleData>();
			var nodeXML:XML = new XML(
				"<factories>" +
					"<Factorya path=\"path_a\">" +
						"<a/>" +
						"<b/>" +
					"</Factorya>" +
					"<Factoryb path=\"path_b\" definition=\"hs1:product1,hs2:product2\">" +
						"<c/>" +
						"<d/>" +
					"</Factoryb>" +
				"</factories>");
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			parseModules(moduleDatas, nodeXML);
			
			Assert.assertEquals(2, moduleDatas.length);
			
			Assert.assertTrue(moduleDatas[0] is ModuleDataFactory);
			Assert.assertTrue(moduleDatas[1] is ModuleDataFactory);
			
			Assert.assertEquals("Factorya", moduleDatas[0].name);
			Assert.assertEquals("path_a", moduleDatas[0].path);
			Assert.assertEquals(2, moduleDatas[0].nodes.length);
			
			Assert.assertEquals("Factoryb", moduleDatas[1].name);
			Assert.assertEquals("path_b", moduleDatas[1].path);
			Assert.assertEquals(2, moduleDatas[1].nodes.length);
			
			Assert.assertTrue((moduleDatas[1] as ModuleDataFactory).definition["hs1"] == "product1");
			Assert.assertTrue((moduleDatas[1] as ModuleDataFactory).definition["hs2"] == "product2");
		}
	}
}