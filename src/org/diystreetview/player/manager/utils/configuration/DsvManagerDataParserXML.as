/*
Copyright 2011 Marek Standio.

This file is part of DIY streetview player.

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
package org.diystreetview.player.manager.utils.configuration{
	
	import com.panozona.player.manager.events.ConfigurationEvent;
	import com.panozona.player.manager.utils.configuration.ManagerDataParserXML;
	import com.panozona.player.manager.data.ManagerData;
	import org.diystreetview.player.manager.data.diystreetview.DiyStreetviewData;
	import org.diystreetview.player.manager.data.diystreetview.LocationData;
	import org.diystreetview.player.manager.data.DsvManagerData;
	
	public class DsvManagerDataParserXML extends ManagerDataParserXML {
		
		override public function configureManagerData(managerData:ManagerData, settings:XML):void {
			if (settings.global != undefined) {
				if (settings.global.@debug != undefined) {
					var debugValue:*;
					debugValue = recognizeContent(settings.global.@debug);
					if (!(debugValue is Boolean)) {
						dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
							"Unrecognized main node: " + mainNodeName));
					}else {
						managerData.debugMode = debugValue;
						debugMode = managerData.debugMode;
					}
				}
			}
			var mainNodeName:String;
			for each(var mainNode:XML in settings.children()) {
				mainNodeName = mainNode.localName().toString();
				if (mainNode.localName().toString() == "global") {
					parseGlobal(managerData, mainNode);
				}else if (mainNode.localName().toString() == "panoramas") {
					parsePanoramas(managerData.panoramasData, mainNode);
				}else if (mainNode.localName().toString() == "modules") {
					parseModules(managerData.modulesData, mainNode);
				}else if (mainNode.localName().toString() == "factories") {
					parseModules(managerData.modulesData, mainNode);
				}else if (mainNode.localName().toString() == "actions") {
					parseActions(managerData.actionsData, mainNode);
				}else if (mainNode.localName().toString() == "diystreetview") {
					parseDiyStreetview((managerData as DsvManagerData).diyStreetviewData, mainNode);
				}else {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Unrecognized main node: " + mainNodeName));
				}
			}
		}
		
		private function parseDiyStreetview(diyStreetviewData:DiyStreetviewData, diyStreetviewNode:XML):void {
			var diyStreetviewChildNodeName:String;
			for each(var diyStreetviewChildNode:XML in diyStreetviewNode.children()) {
				diyStreetviewChildNodeName = diyStreetviewChildNode.localName();
				if (diyStreetviewChildNodeName == "location") {
					parseLocation(diyStreetviewData.locationData, diyStreetviewChildNode);
				}else {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Unrecognized diystreetview node: " + diyStreetviewChildNodeName));
				}
			}
		}
		private function parseLocation(locationData:LocationData, locationNode:XML) :void {
			var locationAttributeName:String;
			for each(var locationAttribute:XML in locationNode.attributes()) {
				locationAttributeName = locationAttribute.localName();
				if (locationAttributeName == "directory") {
					locationData.directory = getAttributeValue(locationAttribute, String);
				}else if (locationAttributeName == "prefix") {
					locationData.prefix = getAttributeValue(locationAttribute, String);
				}else if (locationAttributeName == "hotspot") {
					locationData.hotspot = getAttributeValue(locationAttribute, String);
				}else{
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
					"Unrecognized location attribute: " + locationAttributeName));
				}
			}
		}
	}
}