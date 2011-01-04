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
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

import com.panosalado.events.ReadyEvent;
import com.panosalado.loading.IOErrorEventHandler;

public class DeepZoomTilePyramid extends TilePyramid
{
	public static var urlPattern:RegExp = /(.*)(_f|front)\.(xml|XML)$/;
	
	public var tierOffset:int;
	
	public function DeepZoomTilePyramid():void {
		super();
	}
	
	override public function loadDescriptor(path:String):void
	{ 
		this.path = path;
		var l:URLLoader = new URLLoader();
		var r:URLRequest = new URLRequest(path);
		//NB: use strong reference, otherwise URLLoader may be gc'ed before complete fires.
		l.addEventListener(Event.COMPLETE, descriptorLoaded);
		l.addEventListener(IOErrorEvent.IO_ERROR, 	IOErrorEventHandler);
		l.load(r);
	}
	
	protected function descriptorLoaded(event:Event):void
	{
		var urlLoader:URLLoader = URLLoader(event.target);
		urlLoader.removeEventListener( Event.COMPLETE, descriptorLoaded )
		urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, 	IOErrorEventHandler);
		
		var descriptor:XML = XML( urlLoader.data );
		/*
<?xml version="1.0" encoding="utf-8"?>
<Image TileSize="256" Overlap="1" Format="jpg" ServerFormat="Default" xmnls="http://schemas.microsoft.com/deepzoom/2009">
<Size Width="5885" Height="5885" />
</Image>
		*/
		width = int(descriptor.Size.@Width); 
		height = int(descriptor.Size.@Height);
		overlap = int(descriptor.@Overlap);
		format = descriptor.@Format;
		tileSize = int(descriptor.@TileSize);
		
		deriveProperties(width, height, tileSize);
		
		dispatchEvent( new ReadyEvent(ReadyEvent.READY, this) );
	}
	
	override public function clone(into:TilePyramid=null) : TilePyramid {
		var clone:DeepZoomTilePyramid = 
			(into != null && into is DeepZoomTilePyramid) ? into as DeepZoomTilePyramid : new DeepZoomTilePyramid();
		clone.width 			= width;
		clone.height 			= height;
		clone.numTiles		 	= numTiles;
		clone.tileSize 			= tileSize;
		clone.overlap 			= overlap;
		clone.numTiers 			= numTiers;
		clone.widths 			= widths;
		clone.heights 			= heights;
		clone.accurateWidths 	= accurateWidths;
		clone.accurateHeights 	= accurateHeights;
		clone.columns 			= columns;
		clone.rows 				= rows;
		clone.path 				= path;
		clone.format 			= format;
		
		clone.tierOffset 		= tierOffset;
		
		return clone;
	}
	
	override public function disassembleDescriptorURL(path:String):DisassembledDescriptorURL {
		//e.g: base/path/name_f.xml
// 		var lastIndexOfSlash:int = path.lastIndexOf('/')+1;
// 		var lastIndexOfDot:int = path.lastIndexOf('.');
// 		
// 		var base:String = path.substring( 0, lastIndexOfSlash );
// 		var id:String = path.substring(lastIndexOfSlash, lastIndexOfDot);
// 		var extension:String = "xml";
		//var regex:RegExp 	= /(.*)(_f|front)\.(xml|XML)$/;
		var o:Object = urlPattern.exec(path);
		var base:String = o[1];
		var id:String = o[2];
		var extension:String = o[3];
		
		return new DisassembledDescriptorURL(base,id,extension);
	}
	
	override public function getTileURL( t : uint, c : uint, r : uint ) : String 
	{
	  t += tierOffset;
	  return path.substring( 0, path.length - 4 ) 
			 + "/" + String( t ) 
			 + "/" + String( c ) + "_" + String( r ) + "." + format;
	}
	
	protected function getMaximumLevel( width : uint, height : uint ) : uint
	{
	  return Math.ceil( Math.log( Math.max( width, height ))/Math.LN2 )
	}
	
	protected function deriveProperties( width  : uint, height : uint, tileSize : uint ) : void
	{
		var originalWidth:int = width // never used 
		var originalHeight:int = height
		
		numTiers = int( getMaximumLevel( width, height ) )
		
		var columns : uint
		var rows : uint
		var widthsArray:Array 		= new Array()
		var heightsArray:Array 		= new Array()
		var columnsArray:Array 		= new Array()
		var rowsArray:Array		 	= new Array()
		var accurateWidthsArray:Array	=  new Array()
		var accurateHeightsArray:Array	=  new Array()
		var accurateWidth:Number = width
		var accurateHeight:Number = height
		
		numTiles = 0;
		 
		for( var t : int = numTiers; t >= 0; t-- )
		{
			// compute number of rows & columns
			columns = Math.ceil( width / tileSize )
			rows = Math.ceil( height / tileSize )
			
			widthsArray[t] 		= width
			heightsArray[t] 	= height
			columnsArray[t]		= columns
			rowsArray[t]		= rows
			accurateWidthsArray[t] = accurateWidth;
			accurateHeightsArray[t] = accurateHeight;
			
			numTiles += columns * rows
			
			if ( width <= tileSize && height <= tileSize ) break;
			
			// compute dimensions of next level
			//width  = Math.ceil( width / 2 )
			//height = Math.ceil( height / 2 )
			 
			width  = ( width + 1 ) >> 1
			height = ( height + 1 ) >> 1
			accurateWidth *= 0.5
			accurateHeight *= 0.5
		}
		tierOffset = t;
		widthsArray.splice(0, tierOffset);
		heightsArray.splice(0, tierOffset);
		accurateWidthsArray.splice(0, tierOffset);
		accurateHeightsArray.splice(0, tierOffset);
		columnsArray.splice(0, tierOffset);
		rowsArray.splice(0, tierOffset);
		
		numTiers -= tierOffset;
		
		widths 	=  Vector.<int>(widthsArray);
		heights =  Vector.<int>(heightsArray);
		accurateWidths = Vector.<Number>(accurateWidthsArray);
		accurateHeights = Vector.<Number>(accurateHeightsArray);
		columns =  Vector.<int>(columnsArray);
		rows 	=  Vector.<int>(rowsArray);
	}
}
}