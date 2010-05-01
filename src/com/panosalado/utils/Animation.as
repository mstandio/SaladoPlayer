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
package com.panosalado.utils
{

import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.getTimer;

//(currentTime, startPosition, endPosition, totalTime) standard parameters.

public class Animation extends EventDispatcher
{
	//animation.time, animation.startValue, animation.deltaValue, animation.deltaTime
	public var target:*;
	public var property:Vector.<String>;
	public var startValue:Vector.<Number>;
	public var deltaValue:Vector.<Number>;
	public var time:Number;
	public var deltaTime:int;
	public var tween:Function;
	
	public function Animation(target:*, property:Vector.<String>, end:Vector.<Number>, time:Number, tween:Function){
		if ( target == null) throw new Error("Invalid Animation: target is null");
// 		if ( !target.hasOwnProperty(property) ) throw new Error("Invalid Animation:" + target + " does not have property:" + property);
// 		if ( !target[property] is Number && !target[property] is int ) throw new Error("Invalid Animation: non-numeric property");
// 		if ( isNaN(target[property]) ) throw new Error("Invalid Animation: property values is NaN (Not-A-Number)");
		
		this.target = target;
		this.property = property;
		
		this.deltaValue = new Vector.<Number>();
		this.startValue = new Vector.<Number>();
		var len:int = property.length;
		for (var i:int = 0; i < len; i++) {
			this.startValue[i] = Number(target[property[i]]);
			this.deltaValue[i] = end[i] - this.startValue[i];
		}
		this.time = 0;
		this.deltaTime = int( time * 1000 );
		this.tween = tween;
		
		Animator.instance.add(this);
	}
	
	public function play():void {
		Animator.instance.add(this);
	}
	
	public function pause():void {
	
	}
	
	public function stop():void {
		Animator.instance.remove(this);
	}
	
	override public function toString():String {
		return "[Animation]: " + target + " " + property + " " + startValue + " " + deltaValue + " : " 
		+ time + " " + deltaTime + " " + tween;
	}
	
}
}

import flash.display.Sprite;
import flash.utils.Dictionary;
import flash.events.Event;
import com.panosalado.utils.Animation;
import flash.utils.getTimer;

class Animator extends Sprite
{
	protected static var animations:Dictionary;
	protected var lastTimeStamp:int;
	protected static var _instance:Animator;
	protected var count:int;
	
	public function Animator() {
		_instance = this;
		animations = new Dictionary(true);
		count = 0;
	}
	
	public static function get instance():Animator {
		if (_instance != null) return _instance;
		else return new Animator();
	}
	
	public function add(animation:Animation):void {
		count++;
		if 	(animations[animation.target] == undefined) 
			animations[animation.target] = Vector.<Animation>([animation]);
		else animations[animation.target].push(animation); 
		if (count == 1) {
			lastTimeStamp = getTimer();
			addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		}
	}
	
	public function remove(animation:Animation):void {
		var v:Vector.<Animation> = animations[animation.target];
		var len:int = v.length;
		if (len == 1) { 
			delete animations[animation.target];
			count -= 1; 
			if (count == 0) removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		else {
			var i:int = 0;
			while (i < v.length) {
				if (v[i] === animation) {
					v.splice(i,1);
					continue;
				}
				i++;
			}
		}
	}
	
	final public function enterFrameHandler(e:Event):void {
		var currentTimeStamp:int = getTimer();
		var elapsedTime:int = currentTimeStamp - lastTimeStamp;
		for each (var vectorOfAnimations:Vector.<Animation> in animations) {
			var i:int = 0;
			var len:int = vectorOfAnimations.length;
			while( i < len ) {
				var animation:Animation = vectorOfAnimations[i];
				animation.time += elapsedTime;
				var plen:int = animation.property.length;
				var done:Boolean = (animation.time >= animation.deltaTime) ? true : false;
				for (var j:int = 0; j < plen; j++) {
					if (!done) 
						animation.target[animation.property[j]] = animation.tween.call(null, animation.time, animation.startValue[j], animation.deltaValue[j], animation.deltaTime);
					else 
						animation.target[animation.property[j]] = animation.startValue[j] + animation.deltaValue[j]; 
				}
				if (done) {
					animation.dispatchEvent( new Event(Event.COMPLETE) );
					remove(animation);
					len--
					continue;
					
				}
				i++;
			}
		}
		lastTimeStamp = currentTimeStamp;
	}
}