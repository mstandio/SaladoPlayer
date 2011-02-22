package test.com.panozona.player.manager.utils.configuration{
	
	import com.panozona.player.component.*;
	import com.panozona.player.component.data.*;
	import com.panozona.player.component.utils.*;
	import com.panozona.player.manager.data.*;
	import com.panozona.player.manager.data.panoramas.*;
	import com.panozona.player.manager.events.*;
	import com.panozona.player.manager.utils.configuration.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ManagerDataValidatorComponents extends com.panozona.player.manager.utils.configuration.ManagerDataValidator{
		
		protected var managerData:ManagerData;
		
		[Before]
		public function prepareManagerData():void {
			managerData = new ManagerData();
			managerData.panoramasData.push(new PanoramaData("pano_id", "pano_path"));
		}
		
		[Test]
		public function componentEvents():void {
			var errCount : int = 0;
			var warCount : int = 0;
			addEventListener(ConfigurationEvent.ERROR, function(event:Event):void { errCount++; } );
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { warCount++; } );
			
			//missing component name
			managerData.modulesData.push(new ComponentData(null, "path_a"));
			managerData.factoriesData.push(new ComponentData(null, "path_b"));
			managerData.modulesData[0].descriptionReference = new ComponentDescription("comp_a", "v");
			managerData.factoriesData[0].descriptionReference = new ComponentDescription("comp_b", "v");
			
			// missing component path
			managerData.modulesData.push(new ComponentData("comp_c", null));
			managerData.factoriesData.push(new ComponentData("comp_d", null));
			managerData.modulesData[1].descriptionReference = new ComponentDescription("comp_c", "v");
			managerData.factoriesData[1].descriptionReference = new ComponentDescription("comp_d", "v");
			
			// missing component description
			managerData.modulesData.push(new ComponentData("comp_e", "path_e"));
			managerData.factoriesData.push(new ComponentData("comp_f", "path_f"));
			
			validate(managerData);
			
			Assert.assertEquals(4, errCount);
			Assert.assertEquals(2, warCount);
		}
		
		[Test]
		public function componentRepeatNameSame():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; } );
			
			managerData.modulesData.push(new ComponentData("comp_a", "path_a"));
			managerData.modulesData[0].descriptionReference = new ComponentDescription("comp_a", "v");
			managerData.modulesData.push(new ComponentData("comp_a", "path_b"));
			managerData.modulesData[1].descriptionReference = new ComponentDescription("comp_b", "v");
			managerData.factoriesData.push(new ComponentData("comp_c", "path_c"));
			managerData.factoriesData[0].descriptionReference = new ComponentDescription("comp_c", "v");
			managerData.factoriesData.push(new ComponentData("comp_c", "path_d"));
			managerData.factoriesData[1].descriptionReference = new ComponentDescription("comp_d", "v");
			
			validate(managerData);
			
			Assert.assertEquals(2, callCount);
		}
		
		[Test]
		public function componentRepeatNameAll():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; } );
			
			managerData.modulesData.push(new ComponentData("comp_a", "path_a"));
			managerData.modulesData[0].descriptionReference = new ComponentDescription("comp_a", "v");
			managerData.factoriesData.push(new ComponentData("comp_a", "path_b"));
			managerData.factoriesData[0].descriptionReference = new ComponentDescription("comp_b", "v");
			
			validate(managerData);
			
			Assert.assertEquals(1, callCount);
		}
	}
}