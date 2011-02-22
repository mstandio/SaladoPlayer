package test.com.panozona.player.manager.utils.configuration{
	
	import com.panozona.player.component.*;
	import com.panozona.player.manager.data.*;
	import com.panozona.player.manager.data.actions.*;
	import com.panozona.player.manager.data.panoramas.*;
	import com.panozona.player.manager.events.*;
	import com.panozona.player.manager.utils.configuration.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ManagerDataValidatorPanoramas extends com.panozona.player.manager.utils.configuration.ManagerDataValidator{
		
		protected var infoCount:int;
		protected var warningCount:int;
		protected var errorCount:int;
		
		protected var panoramasData:Vector.<PanoramaData>;
		protected var actionsData:Vector.<ActionData>;
		
		public function ManagerDataValidatorPanoramas():void {
			addEventListener(ConfigurationEvent.INFO, function(event:Event):void {infoCount++;});
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void{warningCount++;});
			addEventListener(ConfigurationEvent.ERROR, function(event:Event):void{errorCount++;});
		}
		
		[Before]
		public function beforeTest():void {
			
			panoramasData = new Vector.<PanoramaData>();
			actionsData = new Vector.<ActionData>();
			
			infoCount = 0;
			warningCount = 0;
			errorCount = 0;
		}
		
		[Test]
		public function noPanoramasFound():void {
			
			checkPanoramas(panoramasData, actionsData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function repeatingPanoramaId():void {
			panoramasData.push(new PanoramaData("a","path_a"));
			panoramasData.push(new PanoramaData("a","path_b"));
			
			checkPanoramas(panoramasData, actionsData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function panoramaNullPath():void {
			panoramasData.push(new PanoramaData("a", "path_a"));
			panoramasData.push(new PanoramaData(null, "path_b"));
			
			checkPanoramas(panoramasData, actionsData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function simpleActionTriggerPass():void {
			panoramasData.push(new PanoramaData("a", "path_a"));
			actionsData.push(new ActionData("act_1"));
			actionsData.push(new ActionData("act_2"));
			actionsData.push(new ActionData("act_3"));
			panoramasData[0].onEnter = "act_1";
			panoramasData[0].onLeave = "act_2";
			panoramasData[0].onTransitionEnd = "act_3";
			
			checkPanoramas(panoramasData, actionsData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function simpleActionTriggerWrongActionId():void {
			panoramasData.push(new PanoramaData("a", "path_a"));
			panoramasData[0].onTransitionEnd = "act_99";
			
			checkPanoramas(panoramasData, actionsData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function complexActionTriggerPass():void {
			panoramasData.push(new PanoramaData("pano_a", "path_a"));
			panoramasData.push(new PanoramaData("pano_b", "path_b"));
			panoramasData.push(new PanoramaData("pano_c", "path_c"));
			panoramasData.push(new PanoramaData("pano_d", "path_d"));
			
			actionsData.push(new ActionData("act_1"));
			actionsData.push(new ActionData("act_2"));
			actionsData.push(new ActionData("act_3"));
			actionsData.push(new ActionData("act_4"));
			
			panoramasData[0].onEnterFrom["pano_b"] = "act_2";
			panoramasData[0].onEnterFrom["pano_c"] = "act_3";
			panoramasData[0].onEnterFrom["pano_d"] = "act_4";
			
			checkPanoramas(panoramasData, actionsData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function complexActionTriggerSamePanoId():void {
			panoramasData.push(new PanoramaData("pano_a", "path_a"));
			actionsData.push(new ActionData("act_1"));
			panoramasData[0].onEnterFrom["pano_a"] = "act_1";
			
			checkPanoramas(panoramasData, actionsData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function complexActionTriggerWrongPanoId():void {
			panoramasData.push(new PanoramaData("pano_a", "path_a"));
			actionsData.push(new ActionData("act_1"));
			panoramasData[0].onEnterFrom["pano_99"] = "act_1";
			
			checkPanoramas(panoramasData, actionsData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function complexActionTriggerWrongActionId():void {
			panoramasData.push(new PanoramaData("pano_a", "path_a"));
			panoramasData.push(new PanoramaData("pano_b", "path_b"));
			actionsData.push(new ActionData("act_1"));
			panoramasData[0].onEnterFrom["pano_b"] = "act_99";
			
			checkPanoramas(panoramasData, actionsData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function noHotspotId():void {
			panoramasData.push(new PanoramaData("a", "path_a"));
			panoramasData[0].hotspotsDataImage.push(new HotspotDataImage(null, "path_2"));
			
			checkPanoramas(panoramasData, actionsData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function repeatingHotspotSamePanoramaId():void {
			panoramasData.push(new PanoramaData("a", "path_a"));
			panoramasData[0].hotspotsDataImage.push(new HotspotDataImage("spot_2","path_2"));
			panoramasData[0].hotspotsDataImage.push(new HotspotDataImage("spot_2","path_3"));
			
			checkPanoramas(panoramasData, actionsData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function repeatingHotspotDifferentPanorama():void {
			panoramasData.push(new PanoramaData("a", "path_a"));
			panoramasData.push(new PanoramaData("b", "path_b"));
			
			panoramasData[0].hotspotsDataImage.push(new HotspotDataImage("spot_1","path_1"));
			panoramasData[0].hotspotsDataImage.push(new HotspotDataImage("spot_2","path_2"));
			
			panoramasData[1].hotspotsDataImage.push(new HotspotDataImage("spot_2","path_3"));
			panoramasData[1].hotspotsDataImage.push(new HotspotDataImage("spot_4","path_4"));
			
			checkPanoramas(panoramasData, actionsData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function hotspotMousePass():void {
			panoramasData.push(new PanoramaData("a", "path_a"));
			panoramasData[0].hotspotsDataImage.push(new HotspotDataImage("spot_1", "path_1"));
			panoramasData[0].hotspotsDataImage[0].mouse.onClick = "act_1";
			panoramasData[0].hotspotsDataImage[0].mouse.onOut = "act_2";
			panoramasData[0].hotspotsDataImage[0].mouse.onOver = "act_3";
			panoramasData[0].hotspotsDataImage[0].mouse.onPress = "act_4";
			actionsData.push(new ActionData("act_1"));
			actionsData.push(new ActionData("act_2"));
			actionsData.push(new ActionData("act_3"));
			actionsData.push(new ActionData("act_4"));
			
			checkPanoramas(panoramasData, actionsData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function hotspotMouseWrongActionId():void {
			panoramasData.push(new PanoramaData("a", "path_a"));
			panoramasData[0].hotspotsDataImage.push(new HotspotDataImage("spot_1", "path_1"));
			panoramasData[0].hotspotsDataImage[0].mouse.onClick = "act_99";
			
			checkPanoramas(panoramasData, actionsData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
	}
}