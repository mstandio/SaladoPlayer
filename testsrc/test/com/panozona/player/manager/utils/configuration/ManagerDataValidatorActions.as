package test.com.panozona.player.manager.utils.configuration{
	
	import com.panozona.player.module.*;
	import com.panozona.player.module.data.*;
	import com.panozona.player.module.utils.*;
	import com.panozona.player.manager.data.*;
	import com.panozona.player.manager.data.actions.*;
	import com.panozona.player.manager.data.panoramas.*;
	import com.panozona.player.manager.events.*;
	import com.panozona.player.manager.utils.configuration.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ManagerDataValidatorActions extends com.panozona.player.manager.utils.configuration.ManagerDataValidator {
		
		protected var infoCount:int;
		protected var warningCount:int;
		protected var errorCount:int;
		
		protected var managerData:ManagerData;
		
		public function ManagerDataValidatorActions():void {
			addEventListener(ConfigurationEvent.INFO, function(event:Event):void {infoCount++;});
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void{warningCount++;});
			addEventListener(ConfigurationEvent.ERROR, function(event:Event):void{errorCount++;});
		}
		
		[Before]
		public function beforeTest():void {
			infoCount = 0;
			warningCount = 0;
			errorCount = 0;
			
			managerData = new ManagerData();
			managerData.modulesData.push(new ModuleData("module_a", "path_a"));
			managerData.modulesData[0].descriptionReference = new ModuleDescription("module_a", "1.0");
			managerData.modulesData[0].descriptionReference.addFunctionDescription("fun_a_emp");
			managerData.modulesData[0].descriptionReference.addFunctionDescription("fun_a_boo", Boolean);
			managerData.modulesData[0].descriptionReference.addFunctionDescription("fun_a_num", Number);
			managerData.modulesData[0].descriptionReference.addFunctionDescription("fun_a_str", String);
			managerData.modulesData[0].descriptionReference.addFunctionDescription("fun_a_fun", Function);
			managerData.modulesData[0].descriptionReference.addFunctionDescription("fun_a_all", Boolean, Number, String, Function);
			
			managerData.modulesData.push(new ModuleDataFactory("module_b", "path_b"));
			managerData.modulesData[1].descriptionReference = new ModuleDescription("module_b", "1.0");
			managerData.modulesData[1].descriptionReference.addFunctionDescription("fun_b_emp");
			managerData.modulesData[1].descriptionReference.addFunctionDescription("fun_b_boo", Boolean);
			managerData.modulesData[1].descriptionReference.addFunctionDescription("fun_b_num", Number);
			managerData.modulesData[1].descriptionReference.addFunctionDescription("fun_b_str", String);
			managerData.modulesData[1].descriptionReference.addFunctionDescription("fun_b_fun", Function);
			managerData.modulesData[1].descriptionReference.addFunctionDescription("fun_b_all", Boolean, Number, String, Function);
		}
		
		[Test]
		public function actionIdMissing():void {
			managerData.actionsData.push(new ActionData(null));
			
			checkActions(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(1, errorCount);
		}
		
		[Test]
		public function actionIdRepeats():void {
			managerData.actionsData.push(new ActionData("act1"));
			managerData.actionsData.push(new ActionData("act1"));
			
			checkActions(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(1, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function functionSmokeTest():void {
			
			managerData.actionsData.push(new ActionData("act1"));
			
			managerData.actionsData[0].functions.push(new FunctionData("module_a", "fun_a_emp"));
			
			managerData.actionsData[0].functions.push(new FunctionData("module_a", "fun_a_boo"));
			managerData.actionsData[0].functions[1].args.push(false);
			
			managerData.actionsData[0].functions.push(new FunctionData("module_a", "fun_a_num"));
			managerData.actionsData[0].functions[2].args.push( -12.12);
			
			managerData.actionsData[0].functions.push(new FunctionData("module_a", "fun_a_str"));
			managerData.actionsData[0].functions[3].args.push("foo");
			
			managerData.actionsData[0].functions.push(new FunctionData("module_a", "fun_a_fun"));
			managerData.actionsData[0].functions[4].args.push(Linear.easeNone);
			
			managerData.actionsData[0].functions.push(new FunctionData("module_a", "fun_a_all"));
			managerData.actionsData[0].functions[5].args.push(false);
			managerData.actionsData[0].functions[5].args.push(-12.12);
			managerData.actionsData[0].functions[5].args.push("string");
			managerData.actionsData[0].functions[5].args.push(Linear.easeNone);
			
			checkActions(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function functionFactorySmokeTest():void {
			
			managerData.panoramasData.push(new PanoramaData("pano_1", "path_1"));
			managerData.panoramasData[0].hotspotsData.push(new HotspotDataFactory("hs_1", "module_b"));
			managerData.panoramasData[0].hotspotsData.push(new HotspotDataFactory("hs_2", "module_b"));
			
			managerData.actionsData.push(new ActionData("act1"));
			managerData.actionsData[0].functions.push(new FunctionDataFactory("module_b", ["hs_1", "hs_2"], "fun_b_emp"));
			
			managerData.actionsData[0].functions.push(new FunctionDataFactory("module_b", ["hs_1", "hs_2"], "fun_b_boo"));
			managerData.actionsData[0].functions[1].args.push(false);
			
			managerData.actionsData[0].functions.push(new FunctionDataFactory("module_b", ["hs_1", "hs_2"], "fun_b_num"));
			managerData.actionsData[0].functions[2].args.push(-12.12);
			
			managerData.actionsData[0].functions.push(new FunctionDataFactory("module_b", ["hs_1", "hs_2"], "fun_b_str"));
			managerData.actionsData[0].functions[3].args.push("foo");
			
			managerData.actionsData[0].functions.push(new FunctionDataFactory("module_b", ["hs_1", "hs_2"], "fun_b_fun"));
			managerData.actionsData[0].functions[4].args.push(Linear.easeNone);
			
			managerData.actionsData[0].functions.push(new FunctionDataFactory("module_b", ["hs_1", "hs_2"], "fun_b_all"));
			managerData.actionsData[0].functions[5].args.push(false);
			managerData.actionsData[0].functions[5].args.push(-12.12);
			managerData.actionsData[0].functions[5].args.push("string");
			managerData.actionsData[0].functions[5].args.push(Linear.easeNone);
			
			validate(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(0, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		/*
		[Test]
		public function ownerTargetCheck():void {
			managerData.actionsData.push(new ActionData("act1"));
			
			// nonexistant target
			managerData.actionsData[0].functions.push(new FunctionDataFactory("comp_b", ["hs_nonexixtant"], "fun_b_emp"));
			
			// target for module
			managerData.actionsData[0].functions.push(new FunctionDataFactory("comp_a", ["hs_a_a"], "fun_a_emp"));
			
			validate(managerData);
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(2, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		
		[Test]
		public function ownerCheck():void {
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
			
			Assert.assertEquals(0, infoCount);
			Assert.assertEquals(8, warningCount);
			Assert.assertEquals(0, errorCount);
		}
		*/
	}
}