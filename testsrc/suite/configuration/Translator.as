package suite.configuration{
	
	import test.com.panozona.player.module.utils.ModuleDataTranslatorTranslate;
	import test.com.panozona.player.module.utils.ModuleDataTranslatorBoolean;
	import test.com.panozona.player.module.utils.ModuleDataTranslatorNumber;
	import test.com.panozona.player.module.utils.ModuleDataTranslatorString;
	import test.com.panozona.player.module.utils.ModuleDataTranslatorFunction;
	import test.com.panozona.player.module.utils.ModuleDataTranslatorObject;
	import test.com.panozona.player.module.utils.ModuleDataTranslatorSubattributes;
	import test.com.panozona.player.module.utils.ModuleDataTranslatorSubBoolean;
	import test.com.panozona.player.module.utils.ModuleDataTranslatorSubNumber;
	import test.com.panozona.player.module.utils.ModuleDataTranslatorSubString;
	import test.com.panozona.player.module.utils.ModuleDataTranslatorSubFunction;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class Translator{
		
		public var moduleDataTranslatorTranslate:ModuleDataTranslatorTranslate;
		public var moduleDataTranslatorBoolean:ModuleDataTranslatorBoolean;
		public var moduleDataTranslatorNumber:ModuleDataTranslatorNumber;
		public var moduleDataTranslatorString:ModuleDataTranslatorString;
		public var moduleDataTranslatorFunction:ModuleDataTranslatorFunction;
		public var moduleDataTranslatorObject:ModuleDataTranslatorObject;
		public var moduleDataTranslatorSubattributes:ModuleDataTranslatorSubattributes;
		public var moduleDataTranslatorSubBoolean:ModuleDataTranslatorSubBoolean;
		public var moduleDataTranslatorSubNumber:ModuleDataTranslatorSubNumber;
		public var moduleDataTranslatorSubString:ModuleDataTranslatorSubString;
		public var moduleDataTranslatorSubFunction:ModuleDataTranslatorSubFunction;
	}
}