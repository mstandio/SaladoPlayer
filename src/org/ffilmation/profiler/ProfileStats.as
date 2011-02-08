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
 */

package org.ffilmation.profiler
{
	/**
	 * Represents storage for statistical data harvested at
	 * runtime, describing code fragment performances.
	 * @private
	 */
	public class ProfileStats
	{
		public var calls: int;
		public var totalTime: int;
		public var percentage: Number;
		public var min: Number;
		public var max: Number;
		public var minPerc: Number;
		public var maxPerc: Number;

		/**
		 * Construction
		 */
		public function ProfileStats()
		{
			calls = totalTime = 0;
			percentage = min = max = 0.;
			minPerc = 100.;
			maxPerc = 0.;
		}
	}
}