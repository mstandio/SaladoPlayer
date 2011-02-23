package test.com.panozona.player.manager.utils.configuration{
	
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	import com.panozona.player.module.utils.*;
	import com.panozona.player.manager.data.*;
	import com.panozona.player.manager.data.panoramas.*;
	import com.panozona.player.manager.events.*;
	import com.panozona.player.manager.utils.configuration.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ManagerDataValidatorFactories extends com.panozona.player.manager.utils.configuration.ManagerDataValidator{
		
		protected var infoCount:int;
		protected var warningCount:int;
		protected var errorCount:int;
		
		protected var managerData:ManagerData;
		
		public function ManagerDataValidatorFactories():void {
			addEventListener(ConfigurationEvent.INFO, function(event:Event):void {infoCount++;});
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void{warningCount++;});
			addEventListener(ConfigurationEvent.ERROR, function(event:Event):void { errorCount++; } );
		}
		
		[Before]
		public function beforeTest():void {
			managerData = new ManagerData();
			
			infoCount = 0;
			warningCount = 0;
			errorCount = 0;
		}
		
		[Test]
		public function smokeTest():void {
			managerData.modulesData.push(new ModuleDataFactory("name_a", "patha_a"));
			managerData.modulesData[0].descriptionReference = new ModuleDescription("name_a", "1.0");
			managerData.modulesData.push(new ModuleDataFactory("name_b", "patha_b"));
			managerData.modulesData[1].descriptionReference = new ModuleDescription("name_b", "1.0");
			
			checkModules(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function checkModulesNoName():void {
			managerData.modulesData.push(new ModuleDataFactory(null, "path_a"));
			managerData.modulesData[0].descriptionReference = new ModuleDescription("name_a", "1.0");
			
			checkModules(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function checkModulesNoPath():void {
			managerData.modulesData.push(new ModuleDataFactory("name_a", null));
			managerData.modulesData[0].descriptionReference = new ModuleDescription("name_a", "1.0");
			
			checkModules(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function checkModulesNoDescription():void {
			managerData.modulesData.push(new ModuleDataFactory("name_a", "path_a"));
			
			checkModules(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function checkModulesRepeatName():void {
			managerData.modulesData.push(new ModuleDataFactory("comp_a", "path_a"));
			managerData.modulesData[0].descriptionReference = new ModuleDescription("comp_a", "1.0");
			managerData.modulesData.push(new ModuleData("comp_a", "path_b"));
			managerData.modulesData[1].descriptionReference = new ModuleDescription("comp_b", "1.0");
			
			checkModules(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function checkModulesFactoryDefinitionSmokeTest():void {
			
			managerData.panoramasData.push(new PanoramaData("pano_a", "path_pa"))
			managerData.panoramasData[0].hotspotsData.push(new HotspotDataFactory("hs_1", "fact_a"));
			managerData.panoramasData[0].hotspotsData.push(new HotspotDataFactory("hs_2", "fact_a"));
			
			managerData.modulesData.push(new ModuleDataFactory("fact_a", "path_a"));
			managerData.modulesData[0].descriptionReference = new ModuleDescription("fact_a", "1.0");
			(managerData.modulesData[0] as ModuleDataFactory).definition["hs_1"] = "product_1";
			(managerData.modulesData[0] as ModuleDataFactory).definition["hs_2"] = "product_2";
			
			checkModules(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function checkModulesFactoryDefinitionUnknownHotspot():void {
			
			managerData.panoramasData.push(new PanoramaData("panp_a", "path_pa"))
			managerData.panoramasData[0].hotspotsData.push(new HotspotDataFactory("hs_1", "fact_a"));
			managerData.panoramasData[0].hotspotsData.push(new HotspotDataFactory("hs_2", "fact_a"));
			
			managerData.modulesData.push(new ModuleDataFactory("fact_a", "path_a"));
			managerData.modulesData[0].descriptionReference = new ModuleDescription("fact_a", "1.0");
			(managerData.modulesData[0] as ModuleDataFactory).definition["hs_1"] = "product_1";
			(managerData.modulesData[0] as ModuleDataFactory).definition["hs_99"] = "product_2";
			
			checkModules(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function checkModulesFactoryDefinitionFactoryMismatch():void {
			
			managerData.panoramasData.push(new PanoramaData("panp_a", "path_pa"))
			managerData.panoramasData[0].hotspotsData.push(new HotspotDataFactory("hs_1", "fact_a"));
			managerData.panoramasData[0].hotspotsData.push(new HotspotDataFactory("hs_2", "fact_99"));
			
			managerData.modulesData.push(new ModuleDataFactory("fact_a", "path_a"));
			managerData.modulesData[0].descriptionReference = new ModuleDescription("fact_a", "1.0");
			(managerData.modulesData[0] as ModuleDataFactory).definition["hs_1"] = "product_1";
			(managerData.modulesData[0] as ModuleDataFactory).definition["hs_2"] = "product_2";
			
			checkModules(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
	}
}