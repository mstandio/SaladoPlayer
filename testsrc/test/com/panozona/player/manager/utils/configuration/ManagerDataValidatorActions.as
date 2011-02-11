package test.com.panozona.player.manager.utils.configuration{
	
	import com.panozona.player.component.*;
	import com.panozona.player.manager.data.actions.ActionData;
	import com.panozona.player.manager.data.actions.FunctionData;
	import com.panozona.player.manager.data.actions.FunctionDataTarget;
	import com.panozona.player.manager.data.ManagerData;
	import com.panozona.player.manager.data.panoramas.HotspotData;
	import com.panozona.player.manager.data.panoramas.PanoramaData;
	import com.panozona.player.manager.utils.configuration.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ManagerDataValidatorActions extends com.panozona.player.manager.utils.configuration.ManagerDataValidator {
		
		protected var managerData:ManagerData;
		
		[Before]
		public function prepareManagerData():void {
			managerData = new ManagerData();
			
			managerData.panoramasData.push(new PanoramaData("pano_a", "path_a"));
			managerData.panoramasData[0].hotspotsData.push(new HotspotData("hs_a_a"));
			managerData.panoramasData[0].hotspotsData.push(new HotspotData("hs_a_b"));
			
			var componentDataModule:ComponentData = new ComponentData("comp_a","path_a");
			componentDataModule.descriptionReference = new ComponentDescription("comp_a", "1.0.1 beta");
			componentDataModule.descriptionReference.addFunctionDescription("fun_a_emp");
			componentDataModule.descriptionReference.addFunctionDescription("fun_a_str", String);
			componentDataModule.descriptionReference.addFunctionDescription("fun_a_num", Number);
			componentDataModule.descriptionReference.addFunctionDescription("fun_a_boo", Boolean);
			componentDataModule.descriptionReference.addFunctionDescription("fun_a_fun", Function);
			componentDataModule.descriptionReference.addFunctionDescription("fun_a_all", String, Number, Boolean, Function);
			managerData.modulesData.push(componentDataModule);
			
			var componentDataFactory:ComponentData = new ComponentData("comp_b","path_b");
			componentDataFactory.descriptionReference = new ComponentDescription("comp_b", "1.0.2 beta");
			componentDataFactory.descriptionReference.addFunctionDescription("fun_b_emp");
			componentDataFactory.descriptionReference.addFunctionDescription("fun_b_str", String);
			componentDataFactory.descriptionReference.addFunctionDescription("fun_b_num", Number);
			componentDataFactory.descriptionReference.addFunctionDescription("fun_b_boo", Boolean);
			componentDataFactory.descriptionReference.addFunctionDescription("fun_b_fun", Function);
			componentDataFactory.descriptionReference.addFunctionDescription("fun_b_all", String, Number, Boolean, Function);
			managerData.factoriesData.push(componentDataFactory);
		}
		
		[Test]
		public function actionIdRepeats():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; });
			
			managerData.actionsData.push(new ActionData("act1"));
			managerData.actionsData.push(new ActionData("act1"));
			
			validate(managerData);
			
			Assert.assertEquals(1, callCount);
		}
		
		[Test]
		public function actionIdMissing():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.ERROR, function(event:Event):void { callCount++; });
			
			managerData.actionsData.push(new ActionData(null));
			
			validate(managerData);
			
			Assert.assertEquals(1, callCount);
		}
		
		[Test]
		public function ownerCheckPass():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; } );
			
			managerData.actionsData.push(new ActionData("act1"));
			
			managerData.actionsData[0].functions.push(new FunctionData("comp_a", "fun_a_emp"));
			
			managerData.actionsData[0].functions.push(new FunctionData("comp_a", "fun_a_num"));
			managerData.actionsData[0].functions[1].args.push(-12.12);
			
			managerData.actionsData[0].functions.push(new FunctionData("comp_a", "fun_a_boo"));
			managerData.actionsData[0].functions[2].args.push(false);
			
			managerData.actionsData[0].functions.push(new FunctionData("comp_a", "fun_a_all"));
			managerData.actionsData[0].functions[3].args.push("string");
			managerData.actionsData[0].functions[3].args.push(-12.12);
			managerData.actionsData[0].functions[3].args.push(false);
			managerData.actionsData[0].functions[3].args.push(Linear.easeNone);
			
			validate(managerData);
			
			Assert.assertEquals(0, callCount);
		}
		
		[Test]
		public function ownerTargetCheckPass():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; } );
			
			managerData.actionsData.push(new ActionData("act1"));
			
			managerData.actionsData[0].functions.push(new FunctionDataTarget("comp_b", "hs_a_a", "fun_b_emp"));
			
			managerData.actionsData[0].functions.push(new FunctionDataTarget("comp_b", "hs_a_a", "fun_b_num"));
			managerData.actionsData[0].functions[1].args.push(-12.12);
			
			managerData.actionsData[0].functions.push(new FunctionDataTarget("comp_b", "hs_a_b", "fun_b_boo"));
			managerData.actionsData[0].functions[2].args.push(false);
			
			managerData.actionsData[0].functions.push(new FunctionDataTarget("comp_b", "hs_a_b", "fun_b_all"));
			managerData.actionsData[0].functions[3].args.push("string");
			managerData.actionsData[0].functions[3].args.push(-12.12);
			managerData.actionsData[0].functions[3].args.push(false);
			managerData.actionsData[0].functions[3].args.push(Linear.easeNone);
			
			validate(managerData);
			
			Assert.assertEquals(0, callCount);
		}
		
		[Test]
		public function ownerTargetCheck():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; } );
			
			managerData.actionsData.push(new ActionData("act1"));
			
			// nonexistant target
			managerData.actionsData[0].functions.push(new FunctionDataTarget("comp_b", "hs_nonexixtant", "fun_b_emp"));
			
			// target for module
			managerData.actionsData[0].functions.push(new FunctionDataTarget("comp_a", "hs_a_a", "fun_a_emp"));
			
			validate(managerData);
			
			Assert.assertEquals(2, callCount);
		}
		
		[Test]
		public function ownerCheck():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void { callCount++; } );
			
			managerData.actionsData.push(new ActionData("act1"));
			managerData.actionsData.push(new ActionData("act2"));
			managerData.actionsData.push(new ActionData("act3"));
			managerData.actionsData.push(new ActionData("act4"));
			managerData.actionsData.push(new ActionData("act5"));
			managerData.actionsData.push(new ActionData("act6"));
			managerData.actionsData.push(new ActionData("act7"));
			managerData.actionsData.push(new ActionData("act8"));
			
			// nonexistant owner
			managerData.actionsData[0].functions.push(new FunctionData("comp_nonexistant", "fun_a_all"));
			managerData.actionsData[0].functions[0].args.push("string");
			managerData.actionsData[0].functions[0].args.push(-12.12);
			managerData.actionsData[0].functions[0].args.push(true);
			managerData.actionsData[0].functions[0].args.push(Linear.easeNone);
			
			// nonexistant function name
			managerData.actionsData[1].functions.push(new FunctionData("comp_a", "fun_a_nonexistant"));
			managerData.actionsData[1].functions[0].args.push("string");
			
			// function args quantity mismatch #1
			managerData.actionsData[2].functions.push(new FunctionData("comp_a", "fun_a_emp"));
			managerData.actionsData[2].functions[0].args.push("string");
			
			// function args quantity mismatch #2
			managerData.actionsData[3].functions.push(new FunctionData("comp_a", "fun_a_all"));
			managerData.actionsData[3].functions[0].args.push("String");
			managerData.actionsData[3].functions[0].args.push(-12.12);
			managerData.actionsData[3].functions[0].args.push(false);
			
			// function args types mismatch String
			managerData.actionsData[4].functions.push(new FunctionData("comp_a", "fun_a_str"));
			managerData.actionsData[4].functions[0].args.push(-12.12);
			
			// function args types mismatch Number
			managerData.actionsData[5].functions.push(new FunctionData("comp_a", "fun_a_num"));
			managerData.actionsData[5].functions[0].args.push(false);
			
			// function args types mismatch Boolean
			managerData.actionsData[6].functions.push(new FunctionData("comp_a", "fun_a_boo"));
			managerData.actionsData[6].functions[0].args.push(Linear.easeNone);
			
			// function args types mismatch Function
			managerData.actionsData[7].functions.push(new FunctionData("comp_a", "fun_a_fun"));
			managerData.actionsData[7].functions[0].args.push("string");
			
			validate(managerData);
			
			Assert.assertEquals(8, callCount);
		}
	}
}