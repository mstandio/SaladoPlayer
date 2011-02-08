package org.ffilmation.profiler
{
	import flash.text.*;

	/** @private */
	public class ProfilerResources
	{

		public static function createFixedTextField( aLabel: String, aTextColor: int ): TextField
		{
			
			var tf: TextField = new TextField();

			tf.visible = true;
			tf.alpha = 1;
			tf.background = false;
			tf.border = false;

			var textFormat: TextFormat = new TextFormat();
			textFormat.font = "Courier New"
			textFormat.color = aTextColor;
			textFormat.size = 11;
			textFormat.bold = false;

			tf.defaultTextFormat = textFormat;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.type = TextFieldType.DYNAMIC;
			tf.gridFitType = GridFitType.PIXEL;
			//tf.embedFonts = true;
			tf.selectable = false;

			tf.text = aLabel;
			tf.autoSize = TextFieldAutoSize.LEFT;

			return tf;
		}

	}
}