package profiler
{
	import flash.text.*;

	public class ProfilerResources
	{
		// embedded resources
		[ Embed( source = 'assets/fleftex.ttf', fontName = 'fixedFont', mimeType = 'application/x-font-truetype' ) ]
			private static const fixedFont: Class;

		public static function createFixedTextField( aLabel: String, aTextColor: int ): TextField
		{
			var tf: TextField = new TextField();

			tf.visible = true;
			tf.alpha = 1;
			tf.background = false;
			tf.border = false;

			var eFont: Font = new fixedFont();
			var textFormat: TextFormat = new TextFormat();

			textFormat.font = eFont.fontName;
			textFormat.color = aTextColor;
			textFormat.size = 8;
			textFormat.bold = false;

			tf.defaultTextFormat = textFormat;
//			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.type = TextFieldType.DYNAMIC;
			tf.gridFitType = GridFitType.PIXEL;
			tf.embedFonts = true;
			tf.selectable = false;

			tf.text = aLabel;
			tf.autoSize = TextFieldAutoSize.LEFT;

			return tf;
		}

	}
}