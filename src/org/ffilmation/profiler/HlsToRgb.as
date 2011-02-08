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
	 * Port of C-based helper functions freely available from Microsoft
	 * at "http://support.microsoft.com/?scid=kb%3Ben-us%3B29240&x=14&y=14"
	 * 
	 * Original code is different only for not precomputing constant divisions
	 * results.
	 * @private
	 */
	public class HlsToRgb
	{
		// defined constants
		private static const RANGE: int		= 240;
		private static const HLSMAX: int	= RANGE;
		private static const RGBMAX: int	= 255;

		// computed constants
		private static const HLSMAX_DIV_2: int 			= ( HLSMAX / 2 );
		private static const HLSMAX_DIV_3: int 			= ( HLSMAX / 3 );
		private static const HLSMAX_DIV_6: int 			= ( HLSMAX / 6 );
		private static const HLSMAX_DIV_12: int 		= ( HLSMAX / 12 );
		private static const HLSMAX_MUL_2: int 			= ( HLSMAX * 2 );
		private static const HLSMAX_MUL_2_DIV_3: int 	= ( HLSMAX_MUL_2 / 3 );


		public function HlsToRgb()
		{
			throw new Error( "No need to instance this class." );
		}

		public static function hlsToRgb( hue: int, lum: int, sat: int ): int
		{
			var r: int;
			var g: int;
			var b: int;
			var magic1: int;
			var magic2: int;
		
			if (sat == 0)
			{
				// achromatic case
				r = g = b = ( lum * RGBMAX ) / HLSMAX;
			}
			else
			{
				// chromatic case

				// set up magic numbers
				if( lum <= HLSMAX_DIV_2 )
				{
					magic2 = ( lum * ( HLSMAX + sat ) + HLSMAX_DIV_2 ) / HLSMAX;
				}
				else
				{
					magic2 = lum + sat - ( ( lum * sat ) + HLSMAX_DIV_2 ) / HLSMAX;
				}
				
				magic1 = 2 * lum - magic2;
		
				// get RGB, change units from HLSMAX to RGBMAX
				r = ( hueToRgb( magic1, magic2, hue + HLSMAX_DIV_3 ) * RGBMAX + HLSMAX_DIV_2 ) / HLSMAX; 
				g = ( hueToRgb( magic1, magic2, hue                ) * RGBMAX + HLSMAX_DIV_2 ) / HLSMAX;
				b = ( hueToRgb( magic1, magic2, hue - HLSMAX_DIV_3 ) * RGBMAX + HLSMAX_DIV_2 ) / HLSMAX;
			}

			return( ( r << 16 ) | ( g << 8 ) | b );
		}


		private static function hueToRgb( n1: int, n2: int, hue: int ): int
		{
			if( hue < 0 )
			{
				hue += HLSMAX;
			}
		
			if( hue > HLSMAX )
			{
				hue -= HLSMAX;
			}
		
			if( hue < HLSMAX_DIV_6 )
			{
				return( n1 + ( ( ( n2 - n1 ) * hue + HLSMAX_DIV_12 ) / HLSMAX_DIV_6 ) );
			}
			
			if( hue < HLSMAX_DIV_2 )
			{
				return ( n2 );
			}
			
			if( hue < HLSMAX_MUL_2_DIV_3 )
			{
				return ( n1 + ( ( ( n2 - n1 ) * ( HLSMAX_MUL_2_DIV_3 - hue ) + HLSMAX_DIV_12 ) / HLSMAX_DIV_6 ) );
			} 
			else
			{
				return ( n1 );
			}
		}
	}
}