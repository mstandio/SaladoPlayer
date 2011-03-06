package suite.configuration{
	
	import test.com.panozona.player.module.utils.DataNodeTranslatorTranslate;
	import test.com.panozona.player.module.utils.DataNodeTranslatorBoolean;
	import test.com.panozona.player.module.utils.DataNodeTranslatorNumber;
	import test.com.panozona.player.module.utils.DataNodeTranslatorString;
	import test.com.panozona.player.module.utils.DataNodeTranslatorFunction;
	import test.com.panozona.player.module.utils.DataNodeTranslatorObject;
	import test.com.panozona.player.module.utils.DataNodeTranslatorSubattributes;
	import test.com.panozona.player.module.utils.DataNodeTranslatorSubBoolean;
	import test.com.panozona.player.module.utils.DataNodeTranslatorSubNumber;
	import test.com.panozona.player.module.utils.DataNodeTranslatorSubString;
	import test.com.panozona.player.module.utils.DataNodeTranslatorSubFunction;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class Translator{
		
		public var dataNodeTranslatorTranslate:DataNodeTranslatorTranslate;
		public var dataNodeTranslatorBoolean:DataNodeTranslatorBoolean;
		public var dataNodeTranslatorNumber:DataNodeTranslatorNumber;
		public var dataNodeTranslatorString:DataNodeTranslatorString;
		public var dataNodeTranslatorFunction:DataNodeTranslatorFunction;
		public var dataNodeTranslatorObject:DataNodeTranslatorObject;
		public var dataNodeTranslatorSubattributes:DataNodeTranslatorSubattributes;
		public var dataNodeTranslatorSubBoolean:DataNodeTranslatorSubBoolean;
		public var dataNodeTranslatorSubNumber:DataNodeTranslatorSubNumber;
		public var dataNodeTranslatorSubString:DataNodeTranslatorSubString;
		public var dataNodeTranslatorSubFunction:DataNodeTranslatorSubFunction;
	}
}