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
	import org.diystreetview.player.manager.data.diystreetview.Settings;
	import org.diystreetview.player.manager.data.diystreetview.DiyStreetviewData;
	import org.diystreetview.player.manager.data.diystreetview.Resources;
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
				if (diyStreetviewChildNodeName == "resources") {
					parseResources(diyStreetviewData.resources, diyStreetviewChildNode);
				}else if (diyStreetviewChildNodeName == "settings") {
					parseSettings(diyStreetviewData.settings, diyStreetviewChildNode);
				}else {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Unrecognized diystreetview node: " + diyStreetviewChildNodeName));
				}
			}
		}
		private function parseResources(resources:Resources, resourcesNode:XML) :void {
			var resourcesAttributeName:String;
			for each(var resourcesAttribute:XML in resourcesNode.attributes()) {
				resourcesAttributeName = resourcesAttribute.localName();
				if (resourcesAttributeName == "directory") {
					resources.directory = getAttributeValue(resourcesAttribute, String);
				}else if (resourcesAttributeName == "prefix") {
					resources.prefix = getAttributeValue(resourcesAttribute, String);
				}else if (resourcesAttributeName == "start") {
					resources.start = getAttributeValue(resourcesAttribute, String);
				}else if (resourcesAttributeName == "url") {
					resources.url = getAttributeValue(resourcesAttribute, String);
				}else{
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
					"Unrecognized resources attribute: " + resourcesAttributeName));
				}
			}
		}
		
		private function parseSettings(settings:Settings, settingsNode:XML) :void {
			var settingsAttributeName:String;
			for each(var settingsAttribute:XML in settingsNode.attributes()) {
				settingsAttributeName = settingsAttribute.localName();
				if (settingsAttributeName == "camera") {
					applySubAttributes(settings.params, settingsAttribute);
				}else if (settingsAttributeName == "hotspots") {
					settings.hotspots = getAttributeValue(settingsAttribute, String);
				}else{
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
					"Unrecognized settings attribute: " + settingsAttributeName));
				}
			}
		}
	}
}