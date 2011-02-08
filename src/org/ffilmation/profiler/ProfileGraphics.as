/**
 * Copyright (c) 2007 Manuel Bua
 *
 * THIS SOFTWARE IS PROVIDED 'AS-IS', WITHOUT ANY EXPRESS OR IMPLIED
 * WARRANTY. IN NO EVENT WILL THE AUTHORS BE HELD LIABLE FOR ANY DAMAGES
 * ARISING FROM THE USE OF THIS SOFTWARE.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 *     1. The origin of this software must not be misrepresented; you must not
 *     claim that you wrote the original software. If you use this software
 *     in a product, an acknowledgment in the product documentation would be
 *     appreciated but is not required.
 *
 *     2. Altered source versions must be plainly marked as such, and must not be
 *     misrepresented as being the original software.
 *
 *     3. This notice may not be removed or altered from any source
 *     distribution.
 *
 */

package org.ffilmation.profiler
{
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.display.CapsStyle;

	/**
	 * Provides a way to draw graphical output belonging to a single ProfileNode
	 * node and its statistical data.
	 * @private
	 */
	public class ProfileGraphics extends Sprite
	{
		private var tf: TextField = null;
		private var bar: Sprite = null;
		private var node: ProfileNode = null;


		/**
		 * Construction
		 */
		public function ProfileGraphics( nodeOwner: ProfileNode )
		{
			tf = ProfilerResources.createFixedTextField( "", 0 );
			bar = new Sprite();
			node = nodeOwner;
			
			tf.x = tf.y = bar.x = bar.y = 0;
			addChild( bar );
			addChild( tf );
		}
		
		public function getTextField(): TextField
		{
			return tf;
		}
		
		public function getBar(): Sprite
		{
			return bar;
		}
		
		public function updateGraphics( maxGraphWidth: int = -1 ): void
		{
			var count: int = node.getChildCount();
			var stats: ProfileStats = node.getStats();

			var out: String = "";
			var tmp: String;
			var sign: String = new String();

			bar.x = bar.y = tf.x = tf.y = 0;
			tf.x = 4;

			// draw text
			{
				var l: int = node.getDepth();
				for( var i: int = 0; i < l; i++ )
					sign += " ";
		
				if( count ) sign += "+";
				else sign += "-";
		
				// sign and name
				tmp = sign + " " + node.getName();
				out += fProfiler.sprintf( "%-" + ProfilerConfig.TreeColumnWidthChr + "s", tmp );

				// calls
				tmp = fProfiler.sprintf( "%d", stats.calls );
				out += fProfiler.sprintf( "%-8s", tmp );

				// time average (ms)
				if( stats.calls ) tmp = fProfiler.sprintf( "%3.2fms", Number( stats.totalTime ) / Number( stats.calls ) );
				else tmp = "0.00ms";
				out += fProfiler.sprintf( "%-12s", tmp );

				// percentage
				tmp = fProfiler.sprintf( "%3.2f%%", stats.percentage );
				out += fProfiler.sprintf( "%-12s", tmp );

				tf.text = out;
			}

			var left: int = tf.width + tf.x + 4;
			if( maxGraphWidth == -1 )
			{
				// set it to all the available width
				maxGraphWidth = ( ProfilerConfig.Width - 8 ) - left;
			}

			// draw bars
			//if( parent )
			{
				var perc: Number = stats.percentage * .01;
				var thisWidth: int = int( perc * Number( maxGraphWidth ) );

				// compute colors
				var iperc: int = 70 - int( 70. * perc );
				var barInnerColor: int =  HlsToRgb.hlsToRgb( iperc, 120, 240 );
				var barBorderColor: int = HlsToRgb.hlsToRgb( iperc, 80, 240 );

				// bar fill
				bar.graphics.clear();
				bar.graphics.beginFill( barInnerColor );
				bar.graphics.drawRect( 0, 0, thisWidth, ProfilerConfig.GraphBarHeight );
				bar.graphics.endFill();

				// bar outer rect
				bar.graphics.lineStyle( 1, barBorderColor );
				bar.graphics.drawRect( 0, 0, maxGraphWidth, ProfilerConfig.GraphBarHeight );

				// min/max
				if( ProfilerConfig.ShowMinMax )
				{
					var tmpLeft: Number = ( stats.minPerc / 100. ) * maxGraphWidth;
					var tmpRight: Number = ( stats.maxPerc / 100. ) * maxGraphWidth;
					bar.graphics.lineStyle( 1, 0, .8, false, "normal", CapsStyle.NONE );
					bar.graphics.moveTo( tmpLeft, ProfilerConfig.ItemHeightOn2 - .5 /* subpixel nuances */ );
					bar.graphics.lineTo( tmpRight, ProfilerConfig.ItemHeightOn2 - .5 );
				}

				// text-background
				if( node.isGroupColorMode() )
				{
					bar.graphics.lineStyle( 8, 0, .1 );
					bar.graphics.moveTo( -tf.width, ProfilerConfig.ItemHeightOn2 - .5 );
					bar.graphics.lineTo( bar.x - 6, ProfilerConfig.ItemHeightOn2 - .5 );
				}

				// position
				bar.x = left;
				bar.y = ProfilerConfig.GraphBarOffsetY;
				maxGraphWidth = thisWidth;
			}

		}
	}
}