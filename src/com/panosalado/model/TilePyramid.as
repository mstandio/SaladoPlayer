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

import flash.events.EventDispatcher
import flash.utils.Dictionary

public class TilePyramid extends EventDispatcher
{
	
	public var width:int;
	public var height:int;
	public var numTiles:int;
	public var tileSize:int;
	public var overlap:int;
	public var numTiers:int
	public var widths:Vector.<int>;
	public var heights:Vector.<int>;
	public var accurateWidths:Vector.<Number>;
	public var accurateHeights:Vector.<Number>;
	public var columns:Vector.<int>;
	public var rows:Vector.<int>;
	public var format:String;
	public var path:String;
	
	private static var urlPatternToSubClassConcordance:Dictionary = new Dictionary(true);
	
	public static function processDependency(reference:Object, characteristics:*):void {		
		if (reference.hasOwnProperty("urlPattern") && reference.urlPattern is RegExp && reference is Class){
			urlPatternToSubClassConcordance[reference.urlPattern] = reference					
		}
	}
	
	public static function guessSubClassFromURL(url:String):Class {		
		for (var urlPattern:* in urlPatternToSubClassConcordance) {						
			if ( url.match(urlPattern) )
				return urlPatternToSubClassConcordance[urlPattern];
		}
		// if you have gotten here there is no TilePyramid Class that has been passe into PanoSalado.initialize with a 
		//matching urlPattern for your url.  Bad.  Error.
		throw new Error("Given path: " + url + " can not be resolved to a TilePyramid subclass");
		return null
	}
	
	public function TilePyramid():void {

	}
	
	public function loadDescriptor(path:String):void 
	{
		// to be overriden by subclasses
	}
	
	public function disassembleDescriptorURL(path:String):DisassembledDescriptorURL 
	{
		return new DisassembledDescriptorURL();
	}
	
	public function getTileURL( t : uint, c : uint, r : uint ) : String 
	{
		return "TilePyramid:getTileURL:defaultValue (this should not be returned, EVER)";
		// to be overriden by subclasses
	}
	
	public function clone(into:TilePyramid=null):TilePyramid
	{
		return new TilePyramid();
		// to be overriden
	}
}
}