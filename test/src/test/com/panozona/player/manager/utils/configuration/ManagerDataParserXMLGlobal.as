package test.com.panozona.player.manager.utils.configuration{
	
	import com.panozona.player.module.*;
	import com.panozona.player.manager.data.*;
	import com.panozona.player.manager.data.global.*;
	import com.panozona.player.manager.events.*;
	import com.panozona.player.manager.utils.configuration.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ManagerDataParserXMLGlobal extends com.panozona.player.manager.utils.configuration.ManagerDataParserXML{
		
		protected var infoCount:int;
		protected var warningCount:int;
		protected var errorCount:int;
		
		public function ManagerDataParserXMLGlobal():void {
			addEventListener(ConfigurationEvent.INFO, function(event:Event):void {infoCount++;});
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void{warningCount++;});
			addEventListener(ConfigurationEvent.ERROR, function(event:Event):void{errorCount++;});
		}
		
		[Before]
		public function beforeTest():void {
			infoCount = 0;
			warningCount = 0;
			errorCount = 0;
			debugMode = true;
		}
		
		[Test]
		public function debugTrue():void {
			debugMode = false;
			var nodeXML_a:XML = new XML("<root><global debug=\"true\"/></root>");
			
			configureManagerData(new ManagerData(), nodeXML_a)
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			Assert.assertTrue(debugMode);
		}
		
		[Test]
		public function debugFalse():void {
			debugMode = true;
			var nodeXML_a:XML = new XML("<root><global debug=\"false\"/></root>");
			
			configureManagerData(new ManagerData(), nodeXML_a)
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			Assert.assertFalse(debugMode);
		}
		
		[Test]
		public function debugWarning():void {
			
			var nodeXML_a:XML = new XML("<root><global debug=\"123\"/></root>");
			configureManagerData(new ManagerData(), nodeXML_a)
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function parseGlobalWarning():void {
			// unknown global node
			var nodeXML_a:XML = new XML(
				"<root>" +
					"<global>" +
						"<something/>" +
					"</global>" +
				"</root>");
			
			// unknown global attribute
			var nodeXML_b:XML = new XML(
				"<root>" +
					"<global something=\"false\"/>" +
				"</root>");
			
			parseGlobal(new ManagerData(), nodeXML_a);
			parseGlobal(new ManagerData(), nodeXML_b)
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(2, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function parseTraceWarning():void {
			// unknown trace attribute
			var nodeXML_a:XML = new XML("<trace something=\"false\"/>");
			
			// TODO: invalid align value ect.
			parseTrace(new TraceData(), nodeXML_a);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function parseStatsWarning():void {
			// unknown stats attribute
			var nodeXML_a:XML = new XML("<stats something=\"false\"/>");
			
			parseStats(new StatsData(), nodeXML_a);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function parseBrandingWarning():void {
			// unknown branding attribute
			var nodeXML_a:XML = new XML("<branding something=\"false\"/>");
			
			parseBranding(new BrandingData(), nodeXML_a);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function parseControlWarning():void {
			// unknown control attribute
			var nodeXML_a:XML = new XML("<control something=\"false\"/>");
			
			parseControl(new ControlData(), nodeXML_a);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
	}
}