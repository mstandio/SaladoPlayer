/*
Copyright 2010 Zephyr Renner.

This file is part of PanoSalado.

PanoSalado is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

PanoSalado is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with PanoSalado.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.panosalado.model
{

import flash.events.EventDispatcher;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;

public class ZoomifyTilePyramid extends TilePyramid
{	
	public var offsets:Vector.<int>;
	
	public function ZoomifyTilePyramid():void {
		offsets = new Vector.<int>();
	}
	/*
	public function loadDescriptor(path:String):void
	{ 
		var l:URLLoader = new URLLoader();
		var r:URLRequest = new URLRequest(path);
		l.addEventListener(Event.COMPLETE, descriptorLoaded, false, 0, true);
		l.load(r);
	}
	*/
	/*
	protected function descriptorLoaded(event:Event):void
	{
		var descriptor:XML = XML( URLLoader(event.target).data );
		
		//<IMAGE_PROPERTIES WIDTH="5885" HEIGHT="5885" NUMTILES="723" NUMIMAGES="1" VERSION="1.8" TILESIZE="256" />
		
		width 		= descriptor.@WIDTH; 
		height 		= descriptor.@HEIGHT;
		numTiles 	= descriptor.@NUMTILES;
		tileSize 	= descriptor.@TILESIZE;
		overlap		= 0;
		format		= "jpg";
		
		deriveProperties();
		
		//dispatchEvent( new ReadyEvent(ReadyEvent.READY, this) );
	}*/
	
	public function resolveURL(t:int, c:int, r:int) : String {
		var group:int = r * columns[t] + c + offsets[t];
		group = int(group / 256);
		
		 return path.substring( 0, path.length - 19 ) 
		 	+ "TileGroup" + group + "/"
			+ String( t) + "-" + String( c ) + "-"
			+ String( r ) + "." + format;
	}
	
	/*public function clone() : TilePyramid {
		var clone:ZoomifyTilePyramid = new ZoomifyTilePyramid();
		clone.width = width;
		clone.height = height;
		clone.numTiles = numTiles;
		clone.tileSize = tileSize;
		clone.overlap = overlap;
		clone.numTiers = numTiers;
		clone.widths = widths;
		clone.heights = heights;
		clone.accurateWidths = accurateWidths;
		clone.accurateHeights = accurateHeights;
		clone.columns = columns;
		clone.rows = rows;
		
		clone.path = path;
		
		return clone;
	}*/
	
	protected function deriveProperties():void
	{
		var widthsArray:Array	=  new Array();
		var heightsArray:Array	=  new Array();
		var accuWidthsArray:Array	=  new Array();
		var accuHeightsArray:Array	=  new Array();
		var columnsArray:Array 	=  new Array();
		var rowsArray:Array 	=  new Array();
		offsets = new Vector.<int>();
		var max:Number = ((width > height) ? width : height) / Number(tileSize);
		for(var i:uint = 0; (1 << i) < max; i++);
		numTiers = i + 1;
		if(max > (1 << i)) { numTiers += 1; }
		var tempWidth:Number = width;
		var tempHeight:Number = height;
		for(var t:int = numTiers - 1; t >= 0; t--) {
			widthsArray[t] = tempWidth;
			heightsArray[t] = tempHeight;	
			columnsArray[t] = (tempWidth % tileSize) ? int(tempWidth / tileSize) + 1 : int(tempWidth / tileSize);
			rowsArray[t] = (tempHeight % tileSize) ? int(tempHeight / tileSize) + 1 : int(tempHeight / tileSize);
			accuWidthsArray[t] = width / (1 << ((numTiers-1)-t));
			accuHeightsArray[t] = height / (1 << ((numTiers-1)-t));
			tempWidth = int(tempWidth * 0.5);
			tempHeight = int(tempHeight * 0.5);
		}
		widths 	=  Vector.<int>(widthsArray);
		heights =  Vector.<int>(heightsArray);
		accurateWidths = Vector.<Number>(accuWidthsArray);
		accurateHeights = Vector.<Number>(accuHeightsArray);
		columns =  Vector.<int>(columnsArray);
		rows 	=  Vector.<int>(rowsArray);
		
		offsets[0] = 0;
		var tally:int = 0;
		for(t = 0; t < numTiers; t++) {
			tally += int(columns[t] * rows[t]);
			offsets[t+1] = tally;
		}
	}
}
}