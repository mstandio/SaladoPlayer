package suite.configuration {
	
	import test.com.panozona.player.manager.utils.configuration.ManagerDataValidatorPanoramas;
	import test.com.panozona.player.manager.utils.configuration.ManagerDataValidatorHotspots;
	import test.com.panozona.player.manager.utils.configuration.ManagerDataValidatorModules;
	import test.com.panozona.player.manager.utils.configuration.ManagerDataValidatorActions;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class Validator{
		
		public var managerDataValidatorPanoramas:ManagerDataValidatorPanoramas;
		public var managerDataValidatorHotspots:ManagerDataValidatorHotspots;
		public var managerDataValidatorModules:ManagerDataValidatorModules;
		public var managerDataValidatorActions:ManagerDataValidatorActions;
	}
}