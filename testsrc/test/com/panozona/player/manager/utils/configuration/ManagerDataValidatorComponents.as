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
		
		protected var infoCount:int;
		protected var warningCount:int;
		protected var errorCount:int;
		
		protected var componentsData:Vector.<ComponentData>
		
		public function ManagerDataValidatorComponents():void {
			addEventListener(ConfigurationEvent.INFO, function(event:Event):void {infoCount++;});
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void{warningCount++;});
			addEventListener(ConfigurationEvent.ERROR, function(event:Event):void { errorCount++; } );
		}
		
		[Before]
		public function beforeTest():void {
			componentsData = new Vector.<ComponentData>();
			
			infoCount = 0;
			warningCount = 0;
			errorCount = 0;
		}
		
		[Test]
		public function checkComponentsPass():void {
			componentsData.push(new ComponentData("name_a", "patha_a"));
			componentsData[0].descriptionReference = new ComponentDescription("name_a", "1.0");
			componentsData.push(new ComponentData("name_b", "patha_b"));
			componentsData[1].descriptionReference = new ComponentDescription("name_b", "1.0");
			
			checkComponents(componentsData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function checkComponentsNoName():void {
			componentsData.push(new ComponentData(null, "path_a"));
			componentsData[0].descriptionReference = new ComponentDescription("name_a", "1.0");
			
			checkComponents(componentsData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function checkComponentsNoPath():void {
			componentsData.push(new ComponentData("name_a", null));
			componentsData[0].descriptionReference = new ComponentDescription("name_a", "1.0");
			
			checkComponents(componentsData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function checkComponentsNoDescription():void {
			componentsData.push(new ComponentData("name_a", "path_a"));
			
			checkComponents(componentsData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function checkComponentsRepeatName():void {
			componentsData.push(new ComponentData("comp_a", "path_a"));
			componentsData[0].descriptionReference = new ComponentDescription("comp_a", "1.0");
			componentsData.push(new ComponentData("comp_a", "path_b"));
			componentsData[1].descriptionReference = new ComponentDescription("comp_b", "1.0");
			
			checkComponents(componentsData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
	}
}