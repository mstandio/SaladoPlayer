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
	import flash.display.Sprite
	import flash.text.*
	import flash.events.*

	/**
	 * Provides a simple mechanism to compute average, minimum and maximum
	 * performance timings of a specific code fragment, by enclosing it in
	 * a begin/end block.
	 * It is also possible to group different fragments that may belongs to
	 * the same logical block by defining the parent node as a group node.
	 * <p>I took it from <a href="http://manuel.bit-fire.com/2007/10/17/an-as3-profiler/" target="_blank">here</a>. Credit goes to Manuel Bua. Check the link for instructions on how to use it.</p>
	 */
	public class fProfiler extends Sprite
	{
		private var nodes: Array = new Array();
		private var currNode: ProfileNode;
		private var rootNode: ProfileNode;
		private var rootName: String;
		
		private var frameCount: int;
		
		private var headerText: TextField = null;
		private var currY: BoxedInt = new BoxedInt();
		private var output: Sprite = new Sprite();
		private var dataReady: Boolean = false;
		private var gcm:Boolean
		private var active:Boolean = false
		private var button:Sprite
		private var buttonText: TextField = null

		/**
		* Constructor
		*/
		public function fProfiler( groupColorMode: Boolean = true ) {
			gcm = groupColorMode
			frameCount = 0;

			headerText = ProfilerResources.createFixedTextField( "", 0 );
			output.addChild( headerText )
			output.y = 15

			// create and add root node			
			rootNode = new ProfileNode( 0, 0 );
			rootNode.setIsGroupColorMode( groupColorMode );
			currNode = rootNode;
			nodes.push( currNode );

			rootName = "root";
			rootNode.setName( rootName );
			output.addChild( rootNode.getGraphics() );

			this.button = new Sprite()
			this.button.graphics.beginFill(0xffffff,80)
			this.button.graphics.drawRect(0,0,120,12)
			this.buttonText = ProfilerResources.createFixedTextField( "", 0 )
			this.buttonText.y = -3
			this.button.addChild(this.buttonText)
			this.buttonText.text = "START PROFILING"
			addChild(this.button)
			this.button.addEventListener(MouseEvent.CLICK,this.clickListener)
			this.button.buttonMode = true
			this.buttonText.mouseEnabled = false
			
		}
		
		private function clickListener(e:Event):void {
			if(!this.active) {
				this.beginProfiling()
				this.buttonText.text = "STOP PROFILING"
			} else {
				this.endProfiling()
				this.buttonText.text = "START PROFILING"
			}
			
		}
		

		/**
		* This method clears the list.
		*/
		private function clear():void {
			
			for(var i:Number=0;i<nodes.length;i++) {
				var n:ProfileNode = nodes[i]
				if(n.gfx.parent && n!=rootNode) n.gfx.parent.removeChild(n.gfx)
			}
			rootNode.childs = new Array()
			nodes = new Array()
			currNode = rootNode
			nodes.push( currNode )
			this.render(null)
		}

		private function beginProfiling(): void	{
			this.clear()
			this.active = true
			rootNode.begin()
			try {
				removeChild( output )
			} catch(e:Error){}
		}
		
		private function endProfiling(): void	{

			rootNode.end()

			var count: int = nodes.length;
			var i: int;
			var c: ProfileNode;
			
			for( i = 0; i < count; i++ )
			{
				c = nodes[ i ];
				c.computeStats();
			}
			addChild( output )
			render( null )

			for( i = 0; i < count; i++ )
			{
				c = nodes[ i ];
				c.resetLogData();
			}
			
			this.active = false
			
		}
		
		public function begin( aName: String, groupColorMode: Boolean = false ): void	{
			
			if(!this.active) return
			
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
		
		public function end( aName: String ): void {
			
			if(!this.active) return

			currNode.end();
			var p: ProfileNode = currNode.getParent();

			if( p )
			{
				currNode = p;
			}


		}
		
		private function render( node: ProfileNode = null ): void	{
			
			if( !node ) node = rootNode;
			var width: int = ProfilerConfig.Width;

			// draw a simple header
			output.graphics.clear();
			output.graphics.beginFill( 0xffffff );
			output.graphics.drawRect( 4, 4, width - 7, 14 - 1 );
			output.graphics.endFill();

			headerText.x = 4;
			headerText.y = 2;
			headerText.text = fProfiler.sprintf( "%-" + ProfilerConfig.TreeColumnWidthChr + "s%-8s%-12s%-12s", "PROFILED TREE", "CALLS", "TIME SPENT", "PERCENTAGE" );

			// reset items y-offset
			currY.value = ProfilerConfig.FirstItemPxFromTop;

			node.render( currY );
			
			var finalH: int = ProfilerConfig.ItemHeight * nodes.length + ProfilerConfig.FirstItemPxFromTop + ProfilerConfig.LastItemPxFromBottom;

			output.graphics.beginFill( 0xffffff, .6 );
			output.graphics.drawRect( 2, 2, width - 4, finalH );
			output.graphics.endFill();
			
			output.graphics.lineStyle( 1, 0xffffff );
			output.graphics.drawRect( 2, 2, width - 4, finalH );
		}
		
		/**  sprintf(3) implementation in ActionScript 3.0.
		*
		*  http://www.die.net/doc/linux/man/man3/sprintf.3.html
		*
		*  The following flags are supported: '#', '0', '-', '+'
		*
		*  Field widths are fully supported.  '*' is not supported.
		*
		*  Precision is supported except one difference from the standard: for an
		*  explicit precision of 0 and a result string of "0", the output is "0"
		*  instead of an empty string.
		*
		*  Length modifiers are not supported.
		*
		*  The following conversion specifiers are supported: 'd', 'i', 'o', 'u', 'x',
		*  'X', 'f', 'F', 'c', 's', '%'
		*
		*  Report bugs to manish.jethani@gmail.com
		* @private
		*/
		public static function sprintf(format:String, ... args):String
		{
			var result:String = "";
		
			var length:int = format.length;
			for (var i:int = 0; i < length; i++)
			{
				var c:String = format.charAt(i);
		
				if (c == "%")
				{
					var next: *;
					var str: String;
					var pastFieldWidth:Boolean = false;
					var pastFlags:Boolean = false;
		
					var flagAlternateForm:Boolean = false;
					var flagZeroPad:Boolean = false;
					var flagLeftJustify:Boolean = false;
					var flagSpace:Boolean = false;
					var flagSign:Boolean = false;
		
					var fieldWidth:String = "";
					var precision:String = "";
		
					c = format.charAt(++i);
		
					while (c != "d"
						&& c != "i"
						&& c != "o"
						&& c != "u"
						&& c != "x"
						&& c != "X"
						&& c != "f"
						&& c != "F"
						&& c != "c"
						&& c != "s"
						&& c != "%")
					{
						if (!pastFlags)
						{
							if (!flagAlternateForm && c == "#")
								flagAlternateForm = true;
							else if (!flagZeroPad && c == "0")
								flagZeroPad = true;
							else if (!flagLeftJustify && c == "-")
								flagLeftJustify = true;
							else if (!flagSpace && c == " ")
								flagSpace = true;
							else if (!flagSign && c == "+")
								flagSign = true;
							else
								pastFlags = true;
						}
		
						if (!pastFieldWidth && c == ".")
						{
							pastFlags = true;
							pastFieldWidth = true;
		
							c = format.charAt(++i);
							continue;
						}
		
						if (pastFlags)
						{
							if (!pastFieldWidth)
								fieldWidth += c;
							else
								precision += c;
						}
		
						c = format.charAt(++i);
					}
		
					switch (c)
					{
					case "d":
					case "i":
						next = args.shift();
						str = String(Math.abs(int(next)));
		
						if (precision != "")
							str = fProfiler.leftPad(str, int(precision), "0");
		
						if (int(next) < 0)
							str = "-" + str;
						else if (flagSign && int(next) >= 0)
							str = "+" + str;
		
						if (fieldWidth != "")
						{
							if (flagLeftJustify)
								str = fProfiler.rightPad(str, int(fieldWidth));
							else if (flagZeroPad && precision == "")
								str = fProfiler.leftPad(str, int(fieldWidth), "0");
							else
								str = fProfiler.leftPad(str, int(fieldWidth));
						}
		
						result += str;
						break;
		
					case "o":
						next = args.shift();
						str = uint(next).toString(8);
		
						if (flagAlternateForm && str != "0")
							str = "0" + str;
		
						if (precision != "")
							str = fProfiler.leftPad(str, int(precision), "0");
		
						if (fieldWidth != "")
						{
							if (flagLeftJustify)
								str = fProfiler.rightPad(str, int(fieldWidth));
							else if (flagZeroPad && precision == "")
								str = fProfiler.leftPad(str, int(fieldWidth), "0");
							else
								str = fProfiler.leftPad(str, int(fieldWidth));
						}
		
						result += str;
						break;
		
					case "u":
						next = args.shift();
						str = uint(next).toString(10);
		
						if (precision != "")
							str = fProfiler.leftPad(str, int(precision), "0");
		
						if (fieldWidth != "")
						{
							if (flagLeftJustify)
								str = fProfiler.rightPad(str, int(fieldWidth));
							else if (flagZeroPad && precision == "")
								str = fProfiler.leftPad(str, int(fieldWidth), "0");
							else
								str = fProfiler.leftPad(str, int(fieldWidth));
						}
		
						result += str;
						break;
		
					case "X":
						var capitalise:Boolean = true;
					case "x":
						next = args.shift();
						str = uint(next).toString(16);
		
						if (precision != "")
							str = fProfiler.leftPad(str, int(precision), "0");
		
						var prepend:Boolean = flagAlternateForm && uint(next) != 0;
		
						if (fieldWidth != "" && !flagLeftJustify
								&& flagZeroPad && precision == "")
							str = fProfiler.leftPad(str, prepend
									? int(fieldWidth) - 2 : int(fieldWidth), "0");
		
						if (prepend)
							str = "0x" + str;
		
						if (fieldWidth != "")
						{
							if (flagLeftJustify)
								str = fProfiler.rightPad(str, int(fieldWidth));
							else
								str = fProfiler.leftPad(str, int(fieldWidth));
						}
		
						if (capitalise)
							str = str.toUpperCase();
		
						result += str;
						break;
		
					case "f":
					case "F":
						next = args.shift();
						str = Math.abs(Number(next)).toFixed( precision != "" ?  int(precision) : 6 );
		
						if (int(next) < 0)
							str = "-" + str;
						else if (flagSign && int(next) >= 0)
							str = "+" + str;
		
						if (flagAlternateForm && str.indexOf(".") == -1)
							str += ".";
		
						if (fieldWidth != "")
						{
							if (flagLeftJustify)
								str = fProfiler.rightPad(str, int(fieldWidth));
							else if (flagZeroPad && precision == "")
								str = fProfiler.leftPad(str, int(fieldWidth), "0");
							else
								str = fProfiler.leftPad(str, int(fieldWidth));
						}
		
						result += str;
						break;
		
					case "c":
						next = args.shift();
						str = String.fromCharCode(int(next));
		
						if (fieldWidth != "")
						{
							if (flagLeftJustify)
								str = fProfiler.rightPad(str, int(fieldWidth));
							else
								str = fProfiler.leftPad(str, int(fieldWidth));
						}
		
						result += str;
						break;
		
					case "s":
						next = args.shift();
						str = String(next);
		
						if (precision != "")
							str = str.substring(0, int(precision));
		
						if (fieldWidth != "")
						{
							if (flagLeftJustify)
								str = fProfiler.rightPad(str, int(fieldWidth));
							else
								str = fProfiler.leftPad(str, int(fieldWidth));
						}
		
						result += str;
						break;
		
					case "%":
						result += "%";
					}
				}
				else
				{
					result += c;
				}
			}
			return result;
		}
		
		// Private functions
		/** @private */
		public static function leftPad(source:String, targetLength:int, padChar:String = " "):String
		{
			if (source.length < targetLength)
			{
				var padding:String = "";
		
				while (padding.length + source.length < targetLength)
					padding += padChar;
		
				return padding + source;
			}
		
			return source;
		}
		
		/** @private */
		public static function rightPad(source:String, targetLength:int, padChar:String = " "):String
		{
			while (source.length < targetLength)
				source += padChar;
		
			return source;
		}		
				
		
		
	}
}