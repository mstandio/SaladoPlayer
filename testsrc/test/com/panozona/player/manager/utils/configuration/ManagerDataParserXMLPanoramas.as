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
				"<product id=\"hs3\" factory=\"hspath3\"/>" +
			"</root>");
			parseHotspots(panoramaData, nodeXML);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			Assert.assertEquals(3, panoramaData.getHotspotsData().length);
			
			Assert.assertStrictlyEquals("hs1", panoramaData.hotspotsDataImage[0].id);
			Assert.assertStrictlyEquals("hs2", panoramaData.hotspotsDataSwf[0].id);
			Assert.assertStrictlyEquals("hs3", panoramaData.hotspotsDataProduct[0].id);
			
			Assert.assertStrictlyEquals("hspath1", panoramaData.hotspotsDataImage[0].path);
			Assert.assertStrictlyEquals("hspath2", panoramaData.hotspotsDataSwf[0].path);
			Assert.assertStrictlyEquals("hspath3", panoramaData.hotspotsDataProduct[0].factory);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function wrongHotspotType():void {
			parseHotspots(new PanoramaData("pano1", "path1"), new XML("<root><something/></root>"));
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function noHotspotId():void {
			parseHotspots(new PanoramaData("pano1", "path1"), new XML("<root><image/></root>"));
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function wrongHotspotId():void {
			parseHotspots(new PanoramaData("pano1", "path1"), new XML("<root><image id=\"1\"/></root>"));
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function noHotspotImagePath():void {
			parseHotspots(new PanoramaData("pano1", "path1"), new XML("<root><image id=\"hs1\"/></root>"));
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function noHotspotSwfPath():void {
			parseHotspots(new PanoramaData("pano1", "path1"), new XML("<root><swf id=\"hs1\"/></root>"));
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function parsePanoramasSmokeTest():void {
			var panoramasData:Vector.<PanoramaData> = new Vector.<PanoramaData>();
			var nodeXML:XML = new XML(
				"<root>" +
					"<panorama id=\"pano1\" path=\"path1\">" +
						"<product id=\"hs1\" factory=\"factoryId\"/>" +
					"</panorama>" +
					"<panorama id=\"pano2\" path=\"path2\">" +
						"<image id=\"hs2\" path=\"pathh2\"/>" +
						"<swf id=\"hs3\" path=\"pathh3\"/>" +
					"</panorama>" +
					"<panorama id=\"pano3\" path=\"path3\"/>" +
				"</root>");
			parsePanoramas(panoramasData, nodeXML);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
			
			Assert.assertEquals(3, panoramasData.length);
			
			Assert.assertStrictlyEquals("pano1", panoramasData[0].id);
			Assert.assertStrictlyEquals("path1", panoramasData[0].params.path);
			Assert.assertEquals(1, panoramasData[0].hotspotsDataProduct.length);
			Assert.assertStrictlyEquals("hs1", panoramasData[0].hotspotsDataProduct[0].id);
			
			Assert.assertStrictlyEquals("pano2", panoramasData[1].id);
			Assert.assertStrictlyEquals("path2", panoramasData[1].params.path);
			Assert.assertEquals(2, panoramasData[1].getHotspotsData().length);
			Assert.assertStrictlyEquals("hs2", panoramasData[1].hotspotsDataImage[0].id);
			Assert.assertStrictlyEquals("hs3", panoramasData[1].hotspotsDataSwf[0].id);
			
			Assert.assertStrictlyEquals("pano3", panoramasData[2].id);
			Assert.assertStrictlyEquals("path3", panoramasData[2].params.path);
			Assert.assertEquals(0, panoramasData[2].getHotspotsData().length);
		}
		
		[Test]
		public function noPanoramaId():void {
			parsePanoramas(new Vector.<PanoramaData>(), new XML("<root><panorama/></root>"));
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function wrongPanoramaId():void {
			parsePanoramas(new Vector.<PanoramaData>(), new XML("<root><panorama id=\"1\"/></root>"));
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function noPanoramaPath():void {
			parsePanoramas(new Vector.<PanoramaData>(), new XML("<root><panorama id=\"pano1\"/></root>"));
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function unknownPanoramaAttribute():void {
			parsePanoramas(new Vector.<PanoramaData>(), new XML("<root><panorama id=\"pano1\" path=\"foo\" something=\"bar\"/></root>"));
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
	}
}