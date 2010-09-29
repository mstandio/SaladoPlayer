/*
Copyright 2010 Marek Standio.

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
along with SaladoPlayer.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.modules.navigationbar.data {
	
	import com.panozona.player.module.data.ModuleNode;
	import com.panozona.player.module.data.ModuleData;
	
	import com.panozona.player.module.data.StructureMaster;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class NavigationBarData extends StructureMaster{
		
		public var buttons:Buttons = new Buttons();
		public var backgroundBar:BackgroundBar = new BackgroundBar();
		public var combobox:Combobox = new Combobox();
		public var branding:Branding = new Branding();
		public var logo:Logo = new Logo();
		public var basicButtons:BasicButtons = new BasicButtons();
		public var bonusButtons:BonusButtons = new BonusButtons();
		
		public function NavigationBarData(moduleData:ModuleData, debugMode:Boolean) {
			super(debugMode);
			for each(var moduleNode:ModuleNode in moduleData.moduleNodes) {
				switch (moduleNode.nodeName) {
					case "buttons": 
						readRecursive(buttons, moduleNode);
					break;
					case "backgroundBar": 
						readRecursive(backgroundBar, moduleNode);
					break;
					case "combobox": 
						readRecursive(combobox, moduleNode);
					break;
					case "branding": 
						readRecursive(branding, moduleNode);
					break;
					case "logo": 
						readRecursive(logo, moduleNode);
					break;
					case "basicButtons": 
						readRecursive(basicButtons, moduleNode);
					break;
					case "bonusButtons": 
						readRecursive(bonusButtons, moduleNode);
					break;
					default:
						throw new Error("Could not recognize: "+moduleNode.nodeName);
				}
			}
			
			if (debugMode) {
				// check for mandatory data
				if (buttons.visible && buttons.path == null) {
					throw new Error("No path specified for buttons.");
				}
				
				if (logo.visible && logo.path == null) {
					throw new Error("No path specified for logo.");
				}
			}			
		}
	}
}