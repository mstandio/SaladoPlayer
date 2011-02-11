package test.com.panozona.player.manager.utils.configuration{
	
	import com.panozona.player.component.*;
	import com.panozona.player.manager.data.ManagerData;
	import com.panozona.player.manager.data.actions.*;
	import com.panozona.player.manager.data.panoramas.*;
	import com.panozona.player.manager.utils.configuration.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ManagerDataValidatorPanoramas extends com.panozona.player.manager.utils.configuration.ManagerDataValidator{
		
		protected var managerData:ManagerData;
		
		[Before]
		public function masterBefore():void {
			managerData = new ManagerData();
		}
		
		[Test]
		public function repeatingPanoramaId():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void{callCount++;});
			
			managerData.panoramasData.push(new PanoramaData("a","patha"));
			managerData.panoramasData.push(new PanoramaData("a","patha"));
			
			validate(managerData);
			
			Assert.assertEquals(1, callCount);
		}
		
		[Test]
		public function panoramaError():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.ERROR, function(event:Event):void{callCount++;});
			
			managerData.panoramasData.push(new PanoramaData(null, "path"));
			managerData.panoramasData.push(new PanoramaData("a", null));
			
			validate(managerData);
			
			Assert.assertEquals(2, callCount);
		}
		
		[Test]
		public function hotspotError():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.ERROR, function(event:Event):void{callCount++;});
			
			managerData.panoramasData.push(new PanoramaData(null, "path"));
			managerData.panoramasData.push(new PanoramaData("a", null));
			
			validate(managerData);
			
			Assert.assertEquals(2, callCount);
		}
		
		[Test]
		public function panoramaSimpleActionTrigger():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; } );
			
			managerData.panoramasData.push(new PanoramaData("a", "patha"));
			managerData.panoramasData[0].onEnter = "nonexistantActionId";
			
			validate(managerData);
			
			Assert.assertEquals(1, callCount);
		}
		
		[Test]
		public function panoramaComplexActionTrigger():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; } );
			
			managerData.panoramasData.push(new PanoramaData("pano_a", "path_a"));
			managerData.panoramasData.push(new PanoramaData("pano_b", "path_b"));
			managerData.panoramasData.push(new PanoramaData("pano_c", "path_c"));
			managerData.panoramasData.push(new PanoramaData("pano_d", "path_d"));
			
			managerData.actionsData.push(new ActionData("act_1"));
			managerData.actionsData.push(new ActionData("act_2"));
			managerData.actionsData.push(new ActionData("act_3"));
			managerData.actionsData.push(new ActionData("act_4"));
			
			// correct data 
			managerData.panoramasData[0].onEnterFrom.pano_b = "act_2";
			managerData.panoramasData[0].onEnterFrom.pano_c = "act_3";
			managerData.panoramasData[0].onEnterFrom.pano_d = "act_4";
			
			// warning same panorama id
			managerData.panoramasData[1].onEnterFrom.pano_b = "act_4";
			
			// warning nonexistant panorama id
			managerData.panoramasData[2].onEnterFrom.pano_nonexistant = "act_2";
			
			// warning nonexistant action id
			managerData.panoramasData[3].onEnterFrom.pano_a = "act_nonexistant";
			
			validate(managerData);
			
			Assert.assertEquals(3, callCount);
		}
		
		[Test]
		public function repeatingHotspotSamePanorama():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; } );
			
			managerData.panoramasData.push(new PanoramaData("a", "patha"));
			
			managerData.panoramasData[0].hotspotsData.push(new HotspotData("h2"));
			managerData.panoramasData[0].hotspotsData.push(new HotspotData("h2"));
			
			validate(managerData);
			
			Assert.assertEquals(1, callCount);
		}
		
		[Test]
		public function repeatingHotspotDifferentPanorama():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; } );
			
			managerData.panoramasData.push(new PanoramaData("a", "patha"));
			managerData.panoramasData.push(new PanoramaData("b", "pathb"));
			
			managerData.panoramasData[0].hotspotsData.push(new HotspotData("h1"));
			managerData.panoramasData[0].hotspotsData.push(new HotspotData("h2"));
			
			managerData.panoramasData[1].hotspotsData.push(new HotspotData("h2"));
			managerData.panoramasData[1].hotspotsData.push(new HotspotData("h3"));
			
			validate(managerData);
			
			Assert.assertEquals(1, callCount);
		}
		
		[Test]
		public function hotspotMouse():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; } );
			
			managerData.actionsData.push(new ActionData("act_1"));
			managerData.actionsData.push(new ActionData("act_2"));
			managerData.actionsData.push(new ActionData("act_3"));
			managerData.actionsData.push(new ActionData("act_4"));
			
			managerData.panoramasData.push(new PanoramaData("a", "patha"));
			managerData.panoramasData[0].hotspotsData.push(new HotspotData("h1"));
			managerData.panoramasData[0].hotspotsData[0].mouse.onClick = "act_1";
			managerData.panoramasData[0].hotspotsData[0].mouse.onOut = "act_2";
			managerData.panoramasData[0].hotspotsData[0].mouse.onOver = "act_3";
			managerData.panoramasData[0].hotspotsData[0].mouse.onPress = "act_4";
			managerData.panoramasData[0].hotspotsData[0].mouse.onRelease = "act_nonexistant";
			
			validate(managerData);
			
			Assert.assertEquals(1, callCount);
		}
	}
}