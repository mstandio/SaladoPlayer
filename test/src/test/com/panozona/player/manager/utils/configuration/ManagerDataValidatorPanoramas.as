package test.com.panozona.player.manager.utils.configuration{
	
	import com.panozona.player.module.*;
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
		
		protected var managerData:ManagerData;
		
		public function ManagerDataValidatorPanoramas():void {
			addEventListener(ConfigurationEvent.INFO, function(event:Event):void {infoCount++;});
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void{warningCount++;});
			addEventListener(ConfigurationEvent.ERROR, function(event:Event):void{errorCount++;});
		}
		
		[Before]
		public function beforeTest():void {
			
			managerData = new ManagerData();
			
			infoCount = 0;
			warningCount = 0;
			errorCount = 0;
		}
		
		[Test]
		public function noPanoramasFound():void {
			
			checkPanoramas(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function repeatingPanoramaId():void {
			
			managerData.panoramasData.push(new PanoramaData("a","path_a"));
			managerData.panoramasData.push(new PanoramaData("a","path_b"));
			
			checkPanoramas(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function panoramaNullPath():void {
			managerData.panoramasData.push(new PanoramaData("a", "path_a"));
			managerData.panoramasData.push(new PanoramaData(null, "path_b"));
			
			checkPanoramas(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function simpleActionTriggerPass():void {
			managerData.panoramasData.push(new PanoramaData("a", "path_a"));
			managerData.actionsData.push(new ActionData("act_1"));
			managerData.actionsData.push(new ActionData("act_2"));
			managerData.actionsData.push(new ActionData("act_3"));
			managerData.panoramasData[0].onEnter = "act_1";
			managerData.panoramasData[0].onLeave = "act_2";
			managerData.panoramasData[0].onTransitionEnd = "act_3";
			
			checkPanoramas(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function simpleActionTriggerWrongActionId():void {
			managerData.panoramasData.push(new PanoramaData("a", "path_a"));
			managerData.panoramasData[0].onTransitionEnd = "act_99";
			
			checkPanoramas(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function complexActionTriggerPass():void {
			managerData.panoramasData.push(new PanoramaData("pano_a", "path_a"));
			managerData.panoramasData.push(new PanoramaData("pano_b", "path_b"));
			managerData.panoramasData.push(new PanoramaData("pano_c", "path_c"));
			managerData.panoramasData.push(new PanoramaData("pano_d", "path_d"));
			
			managerData.actionsData.push(new ActionData("act_1"));
			managerData.actionsData.push(new ActionData("act_2"));
			managerData.actionsData.push(new ActionData("act_3"));
			managerData.actionsData.push(new ActionData("act_4"));
			
			managerData.panoramasData[0].onEnterFrom["pano_b"] = "act_2";
			managerData.panoramasData[0].onEnterFrom["pano_c"] = "act_3";
			managerData.panoramasData[0].onEnterFrom["pano_d"] = "act_4";
			
			checkPanoramas(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function complexActionTriggerSamePanoId():void {
			managerData.panoramasData.push(new PanoramaData("pano_a", "path_a"));
			managerData.actionsData.push(new ActionData("act_1"));
			managerData.panoramasData[0].onEnterFrom["pano_a"] = "act_1";
			
			checkPanoramas(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function complexActionTriggerWrongPanoId():void {
			managerData.panoramasData.push(new PanoramaData("pano_a", "path_a"));
			managerData.actionsData.push(new ActionData("act_1"));
			managerData.panoramasData[0].onEnterFrom["pano_99"] = "act_1";
			
			checkPanoramas(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function complexActionTriggerWrongActionId():void {
			managerData.panoramasData.push(new PanoramaData("pano_a", "path_a"));
			managerData.panoramasData.push(new PanoramaData("pano_b", "path_b"));
			managerData.actionsData.push(new ActionData("act_1"));
			managerData.panoramasData[0].onEnterFrom["pano_b"] = "act_99";
			
			checkPanoramas(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
	}
}