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
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * Represents the Profiler's view of a user-defined code fragment.
	 * @private
	 */
	public class ProfileNode
	{
		private var profileInstances: uint;
		private var openProfiles: int;
		private var startTime: int;
		private var accumulator: int;
		private var maxTime: int;
		private var minTime: int;

		private var parent: ProfileNode;
		public var childs: Array = new Array();
		private var depth: int = 0;
		private var ordinal: int = 0;
		
		private var groupColorMode: Boolean = false;
		private var name: String = new String();
		private var nameCrc: uint;
		
		private var stats: ProfileStats = new ProfileStats();
		public var gfx: ProfileGraphics = null;


		/**
		 * Construction
		 */
		public function ProfileNode( aDepth: int, anOrdinal: int )
		{
			accumulator = startTime = openProfiles = profileInstances = nameCrc = 0;
			parent = null;
			depth = aDepth;
			ordinal = anOrdinal;
			gfx = new ProfileGraphics( this );
		}
		
		public function getParent(): ProfileNode
		{
			return parent;
		}
		
		public function getGraphics(): ProfileGraphics
		{
			return gfx;
		}
		
		public function getOpenProfiles(): int
		{
			return openProfiles;
		}

		public function setParent( node: ProfileNode ): void
		{
			parent = node;
		}
		
		public function getStats(): ProfileStats
		{
			return stats;
		}
		
		public function getDepth(): int
		{
			return depth;
		}
		
		public function getOrdinal(): int
		{
			return ordinal;
		}
		
		public function getChild( aName: String ): ProfileNode
		{
			var len: int = childs.length;
			var c: ProfileNode;
			var i: int;
			for( i = 0; i < len; i++ )
			{
				c = childs[ i ];
				if( c.getName() == aName )
				{
					return c;
				}
			}
			
			return null;
		}
		
		public function getChildCount(): int
		{
			return childs.length;
		}
		
		public function isGroupColorMode(): Boolean
		{
			return groupColorMode;
		}
		
		public function setIsGroupColorMode( isGroupColorMode: Boolean ): void
		{
			groupColorMode = isGroupColorMode;
		}
		
		public function addChild( node: ProfileNode ): void
		{
			childs.push( node );
		}

		public function begin(): void
		{
			// increment at each call
			++openProfiles;
			
			// count how many times "begin()" has been called
			++profileInstances;
			
			// remember start time
			startTime = getTimer();
		}
		
		public function end(): void
		{
			var diff: int = getTimer() - startTime;
			accumulator += diff;
			
			// stores min and max
			maxTime = ( maxTime < diff ) ? diff : maxTime;
			minTime = ( minTime > diff ) ? diff : minTime;

			// decrease count on leave
			--openProfiles;
		}

		public function render( yOffset: BoxedInt, maxGraphWidth: int = -1 ): void
		{
			gfx.updateGraphics( maxGraphWidth );

			gfx.y = yOffset.value;
			
			// update shared data
			yOffset.value += ProfilerConfig.ItemHeight;

			var count: int = childs.length;
			var c: ProfileNode;
			for( var k: int = 0; k < count; k++ )
			{
				c = childs[ k ];
				c.render( yOffset, maxGraphWidth );
			}
		}
		
		public function setName( aName: String ): void
		{
			var len: int = aName.length;
			var i: int = 0;
			name = aName;
			
			nameCrc = 0;
			for( ; i < len; i++ )
			{
				nameCrc += int( name.charCodeAt( i ) );
			}
		}

		public function getName(): String
		{
			return name;
		}

		public function getChecksum(): uint
		{
			if( parent )
			{
				return nameCrc + parent.getChecksum();
			}

			return nameCrc;
		}

		public function computeStats(): void
		{
			stats.calls = profileInstances;
			stats.totalTime = accumulator;

			if( parent )
			{
				if( parent.accumulator > 0 )
				{
					stats.percentage = Number( accumulator * 100 ) / Number( parent.accumulator );
				}
				else
				{
					stats.percentage = 0.;
				}
			}
			else
			{
				stats.percentage = 100.
			}

			// clamp percentage
			stats.percentage = ( stats.percentage > 100. ) ? 100. : stats.percentage;
			stats.percentage = ( stats.percentage < 0. ) ? 0. : stats.percentage;

			// compute min/max percentage
			stats.minPerc = ( stats.minPerc > stats.percentage ) ? stats.percentage : stats.minPerc;
			stats.maxPerc = ( stats.maxPerc < stats.percentage ) ? stats.percentage : stats.maxPerc;

			var av: Number;
			if( profileInstances == 0 )
			{
				av = Number( accumulator );
			}
			else
			{
				av = Number( accumulator ) / Number( profileInstances );
			}
			
			if( minTime == 0 )
			{
				stats.min = 1.;
			}
			else
			{
				stats.min = av / Number( minTime );
			}
			
			if( av == 0 )
			{
				stats.max = 1.;
			}
			else
			{
				stats.max = Number( maxTime ) / av;
			}
		}

		public function resetLogData(): void
		{
			profileInstances = accumulator = 0;
			maxTime = 0;
			minTime = 1;
		}
	}
}