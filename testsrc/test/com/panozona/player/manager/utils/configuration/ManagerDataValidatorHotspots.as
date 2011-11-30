package test.com.panozona.player.manager.utils.configuration {
	
	import adobe.utils.CustomActions;
	import com.panosalado.view.Hotspot;
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	import com.panozona.player.module.utils.*;
	import com.panozona.player.manager.data.*;
	import com.panozona.player.manager.data.panoramas.*;
	import com.panozona.player.manager.data.actions.*;
	import com.panozona.player.manager.events.*;
	import com.panozona.player.manager.utils.configuration.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ManagerDataValidatorHotspots extends com.panozona.player.manager.utils.configuration.ManagerDataValidator{
		
		protected var infoCount:int;
		protected var warningCount:int;
		protected var errorCount:int;
		
		protected var managerData:ManagerData;
		
		public function ManagerDataValidatorHotspots():void {
			addEventListener(ConfigurationEvent.INFO, function(event:Event):void {infoCount++;});
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void{warningCount++;});
			addEventListener(ConfigurationEvent.ERROR, function(event:Event):void{errorCount++;});
		}
		
		[Before]
		public function beforeTest():void {
			
			managerData = new ManagerData();
			managerData.panoramasData.push(new PanoramaData("pano_a", "path_a"));
			
			infoCount = 0;
			warningCount = 0;
			errorCount = 0;
		}
		
		[Test]
		public function smokeTest():void {
			
			managerData.panoramasData[0].hotspotsData.push(new HotspotDataImage("hs_1", "path_1"));
			managerData.panoramasData[0].hotspotsData.push(new HotspotDataSwf("hs_2", "path_2"));
			
			checkHotspots(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function missingId():void {
			managerData.panoramasData[0].hotspotsData.push(new HotspotDataImage(null, "path_1"));
			
			checkHotspots(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function repeatingIdSamePanorama():void {
			managerData.panoramasData[0].hotspotsData.push(new HotspotDataImage("hs_1", "path_1"));
			managerData.panoramasData[0].hotspotsData.push(new HotspotDataImage("hs_1", "path_2"));
			
			checkHotspots(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function repeatingIdDifferentPanorama():void {
			managerData.panoramasData[0].hotspotsData.push(new HotspotDataImage("hs_1", "path_1"));
			managerData.panoramasData.push(new PanoramaData("pano_b", "path_b"));
			managerData.panoramasData[1].hotspotsData.push(new HotspotDataSwf("hs_1", "path_2"));
			
			checkHotspots(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function missingPathSwf():void {
			managerData.panoramasData[0].hotspotsData.push(new HotspotDataSwf("hs_1", null));
			
			checkHotspots(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function missingPathImage():void {
			managerData.panoramasData[0].hotspotsData.push(new HotspotDataImage("hs_1", null));
			
			checkHotspots(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function hotspotMousePass():void {
			managerData.panoramasData.push(new PanoramaData("a", "path_a"));
			managerData.panoramasData[0].hotspotsData.push(new HotspotDataImage("spot_1", "path_1"));
			managerData.panoramasData[0].hotspotsData[0].mouse.onClick = "act_1";
			managerData.panoramasData[0].hotspotsData[0].mouse.onOut = "act_2";
			managerData.panoramasData[0].hotspotsData[0].mouse.onOver = "act_3";
			managerData.panoramasData[0].hotspotsData[0].mouse.onPress = "act_4";
			managerData.actionsData.push(new ActionData("act_1"));
			managerData.actionsData.push(new ActionData("act_2"));
			managerData.actionsData.push(new ActionData("act_3"));
			managerData.actionsData.push(new ActionData("act_4"));
			
			checkHotspots(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function hotspotMouseWrongActionId():void {
			managerData.panoramasData.push(new PanoramaData("a", "path_a"));
			managerData.panoramasData[0].hotspotsData.push(new HotspotDataImage("spot_1", "path_1"));
			managerData.panoramasData[0].hotspotsData[0].mouse.onClick = "act_99";
			
			checkHotspots(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
	}
}