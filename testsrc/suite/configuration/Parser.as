package suite.configuration {
	
	import test.com.panozona.player.manager.utils.configuration.ManagerDataParserXMLRecognize;
	import test.com.panozona.player.manager.utils.configuration.ManagerDataParserXMLGlobal;
	import test.com.panozona.player.manager.utils.configuration.ManagerDataParserXMLPanoramas;
	import test.com.panozona.player.manager.utils.configuration.ManagerDataParserXMLComponents;
	import test.com.panozona.player.manager.utils.configuration.ManagerDataParserXMLActions;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class Parser{
		
		public var mnagerDataParserXMLRecognize:ManagerDataParserXMLRecognize;
		public var mnagerDataParserXMLGlobal:ManagerDataParserXMLGlobal;
		public var mnagerDataParserXMLPanoramas:ManagerDataParserXMLPanoramas;
		public var mnagerDataParserXMLComponents:ManagerDataParserXMLComponents;
		public var mnagerDataParserXMLActions:ManagerDataParserXMLActions;
	}
}