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
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Rectangle;
import flash.geom.Vector3D;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import com.panosalado.events.ReadyEvent;
// import com.panosalado.model.AssetDescriptor

public class QuadTreeCube extends Tile 
{
	//public var panoramaImageType:String;
	public var tilePyramids:Vector.<TilePyramid>;
	public var paths:Vector.<String>;
	public var displayingTile:Tile;
	
	protected var bitmapsLoaded:int;
		
	public function QuadTreeCube(path:String)
	{
		super();
		
		bitmapsLoaded = 0;
		
		//this.panoramaImageType = panoramaImageType;
		//var tilePyramidClass:Class = PanoramaImageType.concordance[panoramaImageType] as Class;
		//var tilePyramid:TilePyramid = new tilePyramidClass();
		var tilePyramidClass:Class = TilePyramid.guessSubClassFromURL(path);
		var tilePyramid:TilePyramid = new tilePyramidClass();
		tilePyramid.path = path;
		this.paths = predictPaths(tilePyramid.disassembleDescriptorURL(path));
		this.tilePyramids = Vector.<TilePyramid>([tilePyramid]);
		//add listener first in case event is dispatched synchronously.
		tilePyramid.addEventListener( ReadyEvent.READY, tilePyramidReady, false, 0, false ); //NB: use strong references.
		tilePyramid.loadDescriptor(path);
	}
	
	protected function tilePyramidReady(event:ReadyEvent):void {
		(event.target as TilePyramid).removeEventListener(ReadyEvent.READY,tilePyramidReady); //NB: strong referenced, must remove.
		
		var tilePyramid:TilePyramid = tilePyramids[0];
		for (var i:int = 1; i< 6; i++) {
			var into:TilePyramid = (i < tilePyramids.length) ? tilePyramids[i] as TilePyramid : null;
			tilePyramids[i] = tilePyramid.clone(into);
			tilePyramids[i].path = paths[i]; 
		}
	
		var ct:Tile;
		var nt:Tile; // not used ? 
		var v:Vector.<Vector3D>;
		var across:Number;
		var at:Number;
		var w:int = tilePyramids[0].width;
		
		//across = w * 0.501;
		across = w * 0.5;
		at = w * 0.5;
		
		ct = this;
		//front
		v = new Vector.<Vector3D>(4,true);
		v[0] = new Vector3D(-across,-across,at); // tl
		v[1] = new Vector3D(across,-across,at);  //tr
		v[2] = new Vector3D(-across,across,at); //bl
		v[3] = new Vector3D(across,across,at);  //br
		addEventListener(ReadyEvent.READY, waitForBitmaps, false, 0, true);
		Tile.init(super,tilePyramids[0],v,"x","y","z");
		//right
		ct.n = new Tile();
		ct = ct.n;
 		v = new Vector.<Vector3D>(4,true);
 		v[0] = new Vector3D(at,-across,across);
 		v[1] = new Vector3D(at,-across,-across);
 		v[2] = new Vector3D(at,across,across);
 		v[3] = new Vector3D(at,across,-across);
 		ct.addEventListener(ReadyEvent.READY, waitForBitmaps, false, 0, true);
 		Tile.init(ct,tilePyramids[1],v,"z","y","x");
 		//back
 		ct.n = new Tile();
		ct = ct.n;
 		v = new Vector.<Vector3D>(4,true);
 		v[0] = new Vector3D(across,-across,-at);
 		v[1] = new Vector3D(-across,-across,-at);
 		v[2] = new Vector3D(across,across,-at);
 		v[3] = new Vector3D(-across,across,-at);
 		ct.addEventListener(ReadyEvent.READY, waitForBitmaps, false, 0, true);
 		Tile.init(ct,tilePyramids[2],v,"x","y","z");
 		//left
 		ct.n = new Tile();
 		ct = ct.n;
 		v = new Vector.<Vector3D>(4,true);
 		v[0] = new Vector3D(-at,-across,-across);
 		v[1] = new Vector3D(-at,-across,across);
 		v[2] = new Vector3D(-at,across,-across);
 		v[3] = new Vector3D(-at,across,across);
 		ct.addEventListener(ReadyEvent.READY, waitForBitmaps, false, 0, true);
 		Tile.init(ct,tilePyramids[3],v,"z","y","x");
 		//up
 		ct.n = new Tile();
 		ct = ct.n;
 		v = new Vector.<Vector3D>(4,true);
 		v[0] = new Vector3D(-across,-at,-across);
 		v[1] = new Vector3D(across,-at,-across);
 		v[2] = new Vector3D(-across,-at,across);
 		v[3] = new Vector3D(across,-at,across);
 		ct.addEventListener(ReadyEvent.READY, waitForBitmaps, false, 0, true);
 		Tile.init(ct,tilePyramids[4],v,"x","z","y");
		//down
		ct.n = new Tile();
 		ct = ct.n;
 		v = new Vector.<Vector3D>(4,true);
 		v[0] = new Vector3D(-across,at,across);
 		v[1] = new Vector3D(across,at,across);
 		v[2] = new Vector3D(-across,at,-across);
 		v[3] = new Vector3D(across,at,-across);
 		ct.addEventListener(ReadyEvent.READY, waitForBitmaps, false, 0, true);
 		Tile.init(ct,tilePyramids[5],v,"x","z","y");
 		ct.n = null;
 		
 		//TODO: create all root parent tiles files, dispatch ready event, then create children tiles with green-threading.
//  		ready = true;
// 		dispatchEvent( event ); //re-dispatch event.
	}
	// get compilation error 
	protected function waitForBitmaps(event:ReadyEvent):void {
		bitmapsLoaded++;
		(event.target as EventDispatcher).removeEventListener(ReadyEvent.READY, this.waitForBitmaps); //NB: must remove or infinite loop with this and super
		if (bitmapsLoaded < 6) return; 
		
		ready = true;
		dispatchEvent( new ReadyEvent(ReadyEvent.READY, tilePyramid) );
	}
	
	protected function predictPaths(input:DisassembledDescriptorURL):Vector.<String>
	{
		var ret:Vector.<String> = new Vector.<String>(6,true);
		switch (input.id) {
		case "_f":
			ret[0] = input.base + "_f" + "." + input.extension;
			ret[1] = input.base + "_r" + "." + input.extension;
			ret[2] = input.base + "_b" + "." + input.extension;
			ret[3] = input.base + "_l" + "." + input.extension;
			ret[4] = input.base + "_u" + "." + input.extension;
			ret[5] = input.base + "_d" + "." + input.extension;
			break;
		case "front":
			ret[0] = input.base + "front" + "." + input.extension;
			ret[1] = input.base + "right" + "." + input.extension;
			ret[2] = input.base + "back" + "." + input.extension;
			ret[3] = input.base + "left" + "." + input.extension;
			ret[4] = input.base + "top" + "." + input.extension;
			ret[5] = input.base + "bottom" + "." + input.extension;
			break;
		default: 
			throw new Error(getQualifiedClassName(this) + 
				": Can't predict face paths from given path" +
				" base:" + input.base + 
				" face id:" + input.id + 
				" extension:" + input.extension);
		}
		// trace("ret 0 " + ret[0]);
		// trace("ret 1 " + ret[1]);
		// trace("ret 2 " + ret[2]);
		
		return ret;
	}
	
	override public function toString():String {
		return "[QuadTreeCube] " + url;
	}
}
}