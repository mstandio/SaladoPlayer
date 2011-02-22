/*
Copyright 2011 Marek Standio.

This file is part of SaladoPlayer.

SaladoPlayer is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published
by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.

SaladoPlayer is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty
of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with SaladoPlayer. If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.player.manager.data {
	
	import com.panosalado.model.*;
	import com.panozona.player.component.data.*;
	import com.panozona.player.manager.data.actions.*;
	import com.panozona.player.manager.data.global.*;
	import com.panozona.player.manager.data.panoramas.*;
	
	public class ManagerData{
		
		public var debugMode:Boolean = true;
		
		public var controlData:ControlData = new ControlData();
		public var allPanoramasData:AllPanoramasData = new AllPanoramasData();
		public var traceData:TraceData = new TraceData();
		public var brandingData:BrandingData = new BrandingData();
		public var statsData:StatsData = new StatsData();
		
		public var panoramasData:Vector.<PanoramaData> = new Vector.<PanoramaData>();
		public var actionsData:Vector.<ActionData> = new Vector.<ActionData>();
		public var componentsData:Vector.<ComponentData> = new Vector.<ComponentData>();
		
		public function getPanoramaDataById(id:String):PanoramaData {
			for each(var panoramaData:PanoramaData in panoramasData) {
				if (panoramaData.id == id) {
					return panoramaData;
				}
			}
			return null;
		}
		
		public function getActionDataById(id:String):ActionData{
			for each(var actionData:ActionData in actionsData) {
				if (actionData.id == id) {
					return actionData;
				}
			}
			return null;
		}
		
		public function getComponentDataByName(name:String):ComponentData{
			for each(var componentData:ComponentData in componentsData) {
				if (componentData.name == name) {
					return componentData;
				}
			}
			return null;
		}
	}
}