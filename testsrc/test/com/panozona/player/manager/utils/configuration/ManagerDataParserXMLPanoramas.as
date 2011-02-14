package test.com.panozona.player.manager.utils.configuration{
	
	import com.panozona.player.component.*;
	import com.panozona.player.manager.data.panoramas.*;
	import com.panozona.player.manager.events.*;
	import com.panozona.player.manager.utils.configuration.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ManagerDataParserXMLPanoramas extends com.panozona.player.manager.utils.configuration.ManagerDataParserXML {
		
		[Test]
		public function parseHotsptsStructure():void {
			var hotspotsData:Vector.<HotspotData> = new Vector.<HotspotData>();
			var nodeXML:XML = new XML(
			"<root>" +
				"<hotspot id=\"hs1\"/>" + 
				"<hotspot id=\"hs2\"/>" +
				"<hotspot id=\"hs3\"/>" +
			"</root>");
			parseHotspots(hotspotsData, nodeXML);
			
			Assert.assertEquals(3, hotspotsData.length);
			
			Assert.assertStrictlyEquals("hs1", hotspotsData[0].id);
			Assert.assertStrictlyEquals("hs2", hotspotsData[1].id);
			Assert.assertStrictlyEquals("hs3", hotspotsData[2].id);
		}
		
		[Test]
		public function parseHotsptsWarning():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void{callCount++;});
			
			// hotspot id missing
			parseHotspots(new Vector.<HotspotData>(), new XML("<root><hotspot/></root>"));
			
			// hotspot wrong format
			parseHotspots(new Vector.<HotspotData>(), new XML("<root><hotspot id=\"12\"/></root>"));
			
			// unknown hotspot attribute
			parseHotspots(new Vector.<HotspotData>(), new XML("<root><hotspot id=\"12\" something=\"derp\" /></root>"));
			
			Assert.assertEquals(3, callCount);
		}
		
		[Test]
		public function parsePanoramasStructure():void {
			var panoramasData:Vector.<PanoramaData> = new Vector.<PanoramaData>();
			var nodeXML:XML = new XML(
				"<root>" +
					"<panorama id=\"pano1\" path=\"path1\">" +
						"<hotspot id=\"hs1\"/>" +
					"</panorama>" +
					"<panorama id=\"pano2\" path=\"path2\">" +
						"<hotspot id=\"hs2\"/>" +
						"<hotspot id=\"hs3\"/>" +
					"</panorama>" +
					"<panorama id=\"pano3\" path=\"path3\"/>" +
				"</root>");
			parsePanoramas(panoramasData, nodeXML);
			
			Assert.assertEquals(3, panoramasData.length);
			
			Assert.assertStrictlyEquals("pano1", panoramasData[0].id);
			Assert.assertStrictlyEquals("path1", panoramasData[0].params.path);
			Assert.assertEquals(1, panoramasData[0].hotspotsData.length);
			Assert.assertStrictlyEquals("hs1", panoramasData[0].hotspotsData[0].id);
			
			Assert.assertStrictlyEquals("pano2", panoramasData[1].id);
			Assert.assertStrictlyEquals("path2", panoramasData[1].params.path);
			Assert.assertEquals(2, panoramasData[1].hotspotsData.length);
			Assert.assertStrictlyEquals("hs2", panoramasData[1].hotspotsData[0].id);
			Assert.assertStrictlyEquals("hs3", panoramasData[1].hotspotsData[1].id);
			
			Assert.assertStrictlyEquals("pano3", panoramasData[2].id);
			Assert.assertStrictlyEquals("path3", panoramasData[2].params.path);
			Assert.assertEquals(0, panoramasData[2].hotspotsData.length);
		}
		
		[Test]
		public function parsePanoramasWarning():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void{callCount++;});
			
			// panorama id missing
			parsePanoramas(new Vector.<PanoramaData>(), new XML("<root><panorama/></root>"));
			
			// panorama path missing
			parsePanoramas(new Vector.<PanoramaData>(), new XML("<root><panorama id=\"pano1\"/></root>"));
			
			// panorama id wrong format
			parsePanoramas(new Vector.<PanoramaData>(), new XML("<root><panorama id=\"12\" path=\"foo\"/></root>"));
			
			// panorama path wrong format
			parsePanoramas(new Vector.<PanoramaData>(), new XML("<root><panorama id=\"pano1\" path=\"12\"/></root>"));
			
			// unknown panorama attribute
			parsePanoramas(new Vector.<PanoramaData>(), new XML("<root><panorama id=\"pano1\" path=\"foo\" something=\"bar\"/></root>"));
			
			Assert.assertEquals(5, callCount);
		}
	}
}