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


package performance.profiler
{
	import flash.display.Sprite;
	import flash.text.*;

	/**
	 * Provides a simple mechanism to compute average, minimum and maximum
	 * performance timings of a specific code fragment, by enclosing it in
	 * a begin/end block.
	 * It is also possible to group different fragments that may belongs to
	 * the same logical block by defining the parent node as a group node.
	 */
	public class Profiler extends Sprite
	{
		private var nodes: Array = new Array();
		private var currNode: ProfileNode;
		private var rootNode: ProfileNode;
		private var rootName: String;
		
		private var updateFrequencyFrames: int;
		private var frameCount: int;
		
		private var headerText: TextField = null;
		private var currY: BoxedInt = new BoxedInt();
		private var output: Sprite = new Sprite();
		private var dataReady: Boolean = false;
		
		private static var __instance:Profiler;

		/**
		 * Construction
		 */
		public function Profiler( anUpdateFrequencyFrames: int = 16, groupColorMode: Boolean = true )
		{
			if (__instance != null) throw new Error("Profiler is a Singleton class: use Profiler.instance for the single instance");

			frameCount = 0;
			updateFrequencyFrames = anUpdateFrequencyFrames;

			headerText = ProfilerResources.createFixedTextField( "", 0 );
			output.addChild( headerText );

			// create and add root node			
			rootNode = new ProfileNode( 0, 0 );
			rootNode.setIsGroupColorMode( groupColorMode );
			currNode = rootNode;
			nodes.push( currNode );

			rootName = "root";
			rootNode.setName( rootName );
			output.addChild( rootNode.getGraphics() );

			addChild( output );
		}
		
		public static function get instance():Profiler {
			if (__instance == null) __instance = new Profiler();
			return __instance;
		}

		public function setUpdateFrequencyFrames( aFrameStep: int ): void
		{
			updateFrequencyFrames = aFrameStep;
		}

		private function onTick(): void
		{
/*
			// rootNode will measure the entire
			// tick cycle, measuring non-user code
			// timings, but you have to comment out
			// default behavior in "beginProfiling" and
			// "endProfiling" methods.
			if( rootNode.getOpenProfiles() > 0 )
			{
				rootNode.end()
			}

			rootNode.begin();
*/
			frameCount++;

			dataReady = ( frameCount == updateFrequencyFrames );

			if( dataReady )
			{
				var count: int = nodes.length;
				var i: int;
				var c: ProfileNode;
				
				for( i = 0; i < count; i++ )
				{
					c = nodes[ i ];
					c.computeStats();
				}
				
				for( i = 0; i < count; i++ )
				{
					c = nodes[ i ];
					c.resetLogData();
				}
				
				frameCount = 0;
			}
		}
		
		public function beginProfiling(): void
		{
			onTick();
			rootNode.begin();
		}
		
		public function endProfiling(): void
		{
			rootNode.end();
			render( null );
		}
		
		public function begin( aName: String, groupColorMode: Boolean = false ): void
		{
			if( currNode.getName() != aName )
			{
				var pnode: ProfileNode;

				pnode = currNode.getChild( aName );
				if( pnode )
				{
					// we got it already
				}
				else
				{
					// create new node
					pnode = new ProfileNode( currNode.getDepth() + 1, nodes.length );
					pnode.setIsGroupColorMode( groupColorMode );
					nodes.push( pnode );

					// new node is child of current node
					currNode.addChild( pnode );
					
					// current node is its parent
					pnode.setParent( currNode );
					
					// add node's graphical output to the render queue
					output.addChild( pnode.getGraphics() );
				}
				
				// set name if none yet
				if( pnode.getName().length == 0 )
				{
					pnode.setName( aName );
				}
				
				currNode = pnode;
				pnode.begin();
			}
			else
			{
				// same name, looks like recursion here
				currNode.end();
				currNode.begin();
			}
		}
		
		public function end( aName: String ): void
		{
			currNode.end();
			var p: ProfileNode = currNode.getParent();

			if( p )
			{
				currNode = p;
			}
		}
		
		private function render( node: ProfileNode = null ): void
		{
			// draw just when needed
			if( !dataReady ) return;
			
			if( !node ) node = rootNode;
			var width: int = ProfilerConfig.Width;

			// draw a simple header
			output.graphics.clear();
			output.graphics.beginFill( 0xffffff );
			output.graphics.drawRect( 4, 4, width - 7, 14 - 1 );
			output.graphics.endFill();

			headerText.x = 4;
			headerText.y = 5;
			headerText.text = sprintf( "%-" + ProfilerConfig.TreeColumnWidthChr + "s%-8s%-12s%-12s", "PROFILED TREE", "CALLS", "TIME SPENT", "PERCENTAGE" );

			// reset items y-offset
			currY.value = ProfilerConfig.FirstItemPxFromTop;

			node.render( currY );
			
			var finalH: int = ProfilerConfig.ItemHeight * nodes.length + ProfilerConfig.FirstItemPxFromTop + ProfilerConfig.LastItemPxFromBottom;

			output.graphics.beginFill( 0xffffff, .2 );
			output.graphics.drawRect( 2, 2, width - 4, finalH );
			output.graphics.endFill();
			
			output.graphics.lineStyle( 1, 0xffffff );
			output.graphics.drawRect( 2, 2, width - 4, finalH );
		}
	}
}