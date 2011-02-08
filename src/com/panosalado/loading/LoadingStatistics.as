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
package com.panosalado.loading
{

public class LoadingStatistics
{
	private static var __instance:LoadingStatistics;
	
	private var __latency:Number;
	private var __latencies:Vector.<int>;
	
	public function LoadingStatistics() {
		if (__instance != null) throw new Error("LoadingStatistics is a Singleton class: use LoadingStatistics.instance for the single instance");
		__latency = 0;
		__latencies = new Vector.<int>();
	}
	
	public static function get instance():LoadingStatistics {
		if (__instance == null) __instance = new LoadingStatistics();
		return __instance;
	}
	
	public function get averageLatency():Number {
		return __latency;
	}
	
	public function reportLatency(value:int):Number {
		// calculate latency as an average of the last ten loads
		if (__latencies.length == 10) __latencies.shift();
		__latencies[__latencies.length] = ( value );
		var latenciesLength:int = __latencies.length;
		var i:int = 0;
		var totalLatency:int;
		while( i < latenciesLength ){
			totalLatency += __latencies[i];
			i++;
		}
		__latency = totalLatency/latenciesLength;
		return __latency;
	}
	
	
	
	
}
}