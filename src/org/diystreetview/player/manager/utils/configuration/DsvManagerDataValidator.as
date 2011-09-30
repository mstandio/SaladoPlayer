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
	
	import com.panozona.player.manager.data.panoramas.PanoramaData;
	import com.panozona.player.manager.events.ConfigurationEvent;
	import com.panozona.player.manager.utils.configuration.ManagerDataValidator;
	
	public class DsvManagerDataValidator extends ManagerDataValidator{
		
		override protected function checkPanoramas(managerData:ManagerData):void {
			
			var panoramasId:Object = new Object();
			
			for each(var panoramaData:PanoramaData in managerData.panoramasData) {
				if (panoramaData.id == null || panoramaData.id.length == 0) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
						"Missig panorama id."));
					continue;
				}
				if (panoramaData.params.path == null || panoramaData.params.path.length == 0) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.ERROR,
						"Missig panorama path in: " + panoramaData.id));
					continue;
				}
				if (panoramasId[panoramaData.id] != undefined) {
					dispatchEvent(new ConfigurationEvent(ConfigurationEvent.WARNING,
						"Repeating panorama id: " + panoramaData.id));
					continue;
				}
				panoramasId[panoramaData.id] = ""; // not undefined
				
				actionExists(panoramaData.onEnter, managerData);
				actionExists(panoramaData.onLeave, managerData);
				actionExists(panoramaData.onTransitionEnd, managerData);
				checkActionTrigger(panoramaData.id, panoramaData.onEnterFrom, managerData);
				checkActionTrigger(panoramaData.id, panoramaData.onTransitionEndFrom, managerData);
				checkActionTrigger(panoramaData.id, panoramaData.onLeaveTo, managerData);
				checkActionTrigger(panoramaData.id, panoramaData.onLeaveToAttempt, managerData);
			}
		}
	}
}