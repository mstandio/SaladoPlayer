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
 *     2. Altered source versions must be plainly marked as such, and must not
 *     be misrepresented as being the original software.
 *
 *     3. This notice may not be removed or altered from any source
 *     distribution.
 *
 * @private
*/

package org.ffilmation.profiler
{
	/**
	 * Represents a simple container of overridable, default configuration
	 * values.
	 * 
	 * NOTE: it should be safer to modify these values at runtime too, but this
	 * hasn't been tested.
	 */
	public class ProfilerConfig
	{
		public static var Width: int = 400;
		public static var TreeColumnWidthChr: int = 40;

		/** @private */
		public static var ShowMinMax: Boolean = false;
		/** @private */
		public static var GraphBarHeight: int = 8;
		/** @private */
		public static var ItemHeight: int = 10;
		/** @private */
		public static var ItemHeightOn2: Number = Number( ItemHeight ) / 2.;
		/** @private */
		public static var GraphBarOffsetY: int = 5;
		/** @private */
		/** @private */
		public static var FirstItemPxFromTop: int = 17;
		/** @private */
		public static var LastItemPxFromBottom: int = 5;
	}
}