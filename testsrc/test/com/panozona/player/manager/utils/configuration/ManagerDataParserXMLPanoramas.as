package test.com.panozona.player.manager.utils.configuration{
	
	import com.panozona.player.module.*;
	import com.panozona.player.manager.data.panoramas.*;
	import com.panozona.player.manager.events.*;
	import com.panozona.player.manager.utils.configuration.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ManagerDataParserXMLPanoramas extends com.panozona.player.manager.utils.configuration.ManagerDataParserXML {
		
		protected var infoCount:int;
		protected var warningCount:int;
		protected var errorCount:int;
		
		public function ManagerDataParserXMLPanoramas():void {
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
		public function parseHotspotsSmokeTest():void {
			var panoramaData:PanoramaData = new PanoramaData("pano1", "panopath1");
			var nodeXML:XML = new XML(
			"<root>" +
				"<image id=\"hs1\" path=\"hspath1\"/>" + 
				"<swf id=\"hs2\" path=\"hspath2\"/>" +
			"</root>");
			parseHotspots(panoramaData, nodeXML);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			Assert.assertEquals(2, panoramaData.hotspotsData.length);
			
			Assert.assertStrictlyEquals("hs1", panoramaData.hotspotsData[0].id);
			Assert.assertStrictlyEquals("hs2", panoramaData.hotspotsData[1].id);
			
			Assert.assertTrue(panoramaData.hotspotsData[0] is HotspotDataImage);
			Assert.assertTrue(panoramaData.hotspotsData[1] is HotspotDataSwf);
			
			Assert.assertStrictlyEquals("hspath1", (panoramaData.hotspotsData[0] as HotspotDataImage).path);
			Assert.assertStrictlyEquals("hspath2", (panoramaData.hotspotsData[1] as HotspotDataSwf).path);
		}
		
		[Test]
		public function wrongHotspotType():void {
			parseHotspots(new PanoramaData("pano1", "path1"), new XML("<root><immage id=\"img2\"/></root>"));
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function noHotspotId():void {
			parseHotspots(new PanoramaData("pano1", "path1"), new XML("<root><image/></root>"));
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function wrongHotspotId():void {
			parseHotspots(new PanoramaData("pano1", "path1"), new XML("<root><image id=\"1\"/></root>"));
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function parsePanoramasSmokeTest():void {
			var panoramasData:Vector.<PanoramaData> = new Vector.<PanoramaData>();
			var nodeXML:XML = new XML(
				"<root>" +
					"<panorama id=\"pano1\" path=\"path1\">" +
						"<image id=\"hs2\" path=\"pathh2\"/>" +
						"<swf id=\"hs3\" path=\"pathh3\"/>" +
					"</panorama>" +
					"<panorama id=\"pano2\" path=\"path2\"/>" +
				"</root>");
			parsePanoramas(panoramasData, nodeXML);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			Assert.assertEquals(2, panoramasData.length);
			
			Assert.assertStrictlyEquals("pano1", panoramasData[0].id);
			Assert.assertStrictlyEquals("path1", panoramasData[0].params.path);
			Assert.assertEquals(2, panoramasData[0].hotspotsData.length);
			Assert.assertStrictlyEquals("hs2", panoramasData[0].hotspotsData[0].id);
			Assert.assertStrictlyEquals("hs3", panoramasData[0].hotspotsData[1].id);
			
			Assert.assertStrictlyEquals("pano2", panoramasData[1].id);
			Assert.assertStrictlyEquals("path2", panoramasData[1].params.path);
			Assert.assertEquals(0, panoramasData[1].hotspotsData.length);
		}
		
		[Test]
		public function noPanoramaId():void {
			parsePanoramas(new Vector.<PanoramaData>(), new XML("<root><panorama/></root>"));
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function wrongPanoramaId():void {
			parsePanoramas(new Vector.<PanoramaData>(), new XML(
				"<root>" +
					"<panorama id=\"1\"/>" +
				"</root>"));
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function unknownPanoramaAttribute():void {
			parsePanoramas(new Vector.<PanoramaData>(), new XML(
				"<root>" +
					"<panorama id=\"pano1\" path=\"foo\" something=\"bar\"/>" +
				"</root>"));
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function checkDirection():void {
			var panoramaData:PanoramaData = new PanoramaData("p1", "path1");
			
			panoramaData.direction = 90;
			Assert.assertEquals(90, panoramaData.direction);
			
			panoramaData.direction = 0;
			Assert.assertEquals(0, panoramaData.direction);
			
			panoramaData.direction = 360;
			Assert.assertEquals(0, panoramaData.direction);
			
			panoramaData.direction = -10;
			Assert.assertEquals(350, panoramaData.direction);
			
			panoramaData.direction = 370;
			Assert.assertEquals(10, panoramaData.direction);
		}
	}
}