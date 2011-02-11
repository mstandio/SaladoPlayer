package test.com.panozona.player.manager.utils.configuration{
	
	import com.panozona.player.component.*;
	import com.panozona.player.manager.data.actions.ActionData;
	import com.panozona.player.manager.data.actions.FunctionDataTarget;
	import com.panozona.player.manager.data.global.BrandingData;
	import com.panozona.player.manager.data.global.ControlData;
	import com.panozona.player.manager.data.global.StatsData;
	import com.panozona.player.manager.data.global.TraceData;
	import com.panozona.player.manager.data.ManagerData;
	import com.panozona.player.manager.utils.configuration.*;
	import com.panozona.player.manager.utils.Stats;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ManagerDataParserXMLGlobal extends com.panozona.player.manager.utils.configuration.ManagerDataParserXML{
		
		[Before]
		public function masterBefore():void {
			debugMode = true;
		}
		
		[Test]
		public function debugTrue():void {
			debugMode = false;
			var nodeXML_a:XML = new XML("<root><global debug=\"true\"/></root>");
			
			configureManagerData(new ManagerData(), nodeXML_a)
			
			Assert.assertTrue(debugMode);
		}
		
		[Test]
		public function debugFalse():void {
			debugMode = true;
			var nodeXML_a:XML = new XML("<root><global debug=\"false\"/></root>");
			
			configureManagerData(new ManagerData(), nodeXML_a)
			
			Assert.assertFalse(debugMode);
		}
		
		[Test]
		public function debugWarning():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; } );
			
			var nodeXML_a:XML = new XML("<root><global debug=\"123\"/></root>");
			configureManagerData(new ManagerData(), nodeXML_a)
			
			Assert.assertEquals(1, callCount);
		}
		
		[Test]
		public function parseGlobalWarning():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; } );
			
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
			
			Assert.assertEquals(2, callCount);
		}
		
		[Test]
		public function parseTraceWarning():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; } );
			
			// unknown trace attribute
			var nodeXML_a:XML = new XML("<trace something=\"false\"/>");
			
			// TODO: invalid align value ect.
			
			
			parseTrace(new TraceData(), nodeXML_a);
			
			Assert.assertEquals(1, callCount);
		}
		
		[Test]
		public function parseStatsWarning():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; } );
			
			// unknown stats attribute
			var nodeXML_a:XML = new XML("<stats something=\"false\"/>");
				
			parseStats(new StatsData(), nodeXML_a);
			
			Assert.assertEquals(1, callCount);
		}
		
		[Test]
		public function parseBrandingWarning():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; } );
			
			// unknown branding attribute
			var nodeXML_a:XML = new XML("<branding something=\"false\"/>");
			
			parseBranding(new BrandingData(), nodeXML_a);
			
			Assert.assertEquals(1, callCount);
		}
		
		[Test]
		public function parseControlWarning():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; } );
			
			// unknown control attribute
			var nodeXML_a:XML = new XML("<control something=\"false\"/>");
			
			parseControl(new ControlData(), nodeXML_a);
			Assert.assertEquals(1, callCount);
		}
	}
}