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
package com.panozona.modules.navigationbar.combobox {	
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;	
		
	/**	 
	 * Simple lightweight combobox
 	 * @author mstandio
	 */
	public class Combobox extends Sprite{	
		
		private var panoramasData:Array;
		private var style:ComboboxStyle;				
		
		private var mainElement:ComboboxElement;		
		private var dropDownButton:Sprite;		
		private var elementsBar:Sprite;		
		private var elements:Vector.<ComboboxElement>;						
		
		private var isDropDownOpened:Boolean;		
		private var isDisabled:Boolean;		
		private var mouseOver:Boolean;
		
		
		public function Combobox(panoramasData:Array, style:ComboboxStyle) {			
			this.panoramasData = panoramasData;											
			this.style = style;			
			elements = new Vector.<ComboboxElement>();					
			
			if (stage) stageReady();
			else addEventListener(Event.ADDED_TO_STAGE, stageReady);
		}
		
		private function stageReady(e:Event = null):void {			
			removeEventListener(Event.ADDED_TO_STAGE, stageReady);						
						
			mainElement = new ComboboxElement(panoramasData[0], style, true); // first element in the list						
			addChild(mainElement);			
			
			for each(var panoramaData:Object in panoramasData) {				
				elements.push(new ComboboxElement(panoramaData, style));				
			}							
			
			if(elements.length > 1){
			
				// drop down button
				dropDownButton = new Sprite();								
				dropDownButton.graphics.beginFill(style.backgroundColor);
				dropDownButton.graphics.drawRect(0, 0, mainElement.height, mainElement.height - 1 ) // inside border 
				dropDownButton.graphics.endFill();							
				
				dropDownButton.graphics.moveTo(0, 0);
				dropDownButton.graphics.lineStyle(1, style.borderColor);
				dropDownButton.graphics.lineTo(0, mainElement.height);
					
				dropDownButton.graphics.beginFill(style.borderColor);
				if (style.opensUp) {				
					dropDownButton.graphics.moveTo(mainElement.height/2, mainElement.height/3);  
					dropDownButton.graphics.lineTo(mainElement.height/3*2, mainElement.height/3*2);
					dropDownButton.graphics.lineTo(mainElement.height/3, mainElement.height/3*2);									
				} else {					
					dropDownButton.graphics.moveTo(mainElement.height/3, mainElement.height/3);    
					dropDownButton.graphics.lineTo(mainElement.height/3*2, mainElement.height/3);
					dropDownButton.graphics.lineTo(mainElement.height/2, mainElement.height/3*2);											
				}	
				dropDownButton.graphics.endFill();				
				dropDownButton.buttonMode = true;
				dropDownButton.useHandCursor = true;
				dropDownButton.addEventListener(MouseEvent.MOUSE_DOWN, toggleDropDown, false, 0, true);
				addChild(dropDownButton);	 	
				
				mainElement.addEventListener(MouseEvent.MOUSE_DOWN, toggleDropDown, false, 0, true);
			}			
			
			var elementsMaxWidth:Number = 0;		
			
			for each(var element2:ComboboxElement in elements) {				
				if (element2.getTextWidth() > elementsMaxWidth) {
					elementsMaxWidth = element2.getTextWidth();											
				}					
			}			
			// so that dropDownButton would fit inside mainElement
			elementsMaxWidth  += (panoramasData.length > 1) ? dropDownButton.width : 0;									
			
			mainElement.setWidth(elementsMaxWidth);
			for each(var element:ComboboxElement in elements) {
				element.setWidth(elementsMaxWidth);
				element.addEventListener(ComboboxEvent.LABEL_CHANGED, elementClicked, false, 0 , true);
			}						
			
						
			if(elements.length > 1){
				dropDownButton.x = mainElement.width - dropDownButton.width ;
				dropDownButton.y = 1
			}else {
				this.mainElement.isEnabled = false;
			}
			
			// elements bar			
			elementsBar = new Sprite();					
			addChild(elementsBar);												
			var lastY:Number = 0;			
			for (var i:int = 0; i < elements.length; i++) {								
				element = elements[style.opensUp ? (elements.length-1-i):(i)];
				elementsBar.addChild(element);
				if (element.object.label == mainElement.object.label) {
					element.isActive = true;										
				}else {
					element.isActive = false;									
				}												
				element.y = lastY;
				lastY += (!style.opensUp) ? element.height : - element.height ; 
			}											
			this.elementsBar.y = (style.opensUp) ?  - mainElement.height+1 : mainElement.height;
			
			closeDropDown();
			setEnabled(false);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, cickedOnStage, false, 0, true);
			addEventListener(MouseEvent.ROLL_OVER, mouseRolledOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, mouseRolledOut, false, 0, true);			
		}	
		
		private function elementClicked(e:ComboboxEvent):void {
			closeDropDown();
			for each(var element:ComboboxElement in elements) {
				if (!element.isActive && e.panoramaData === element.object) {
					setSelected(e.panoramaData);					
					dispatchEvent(e.clone());
					return;
				}
			}
		}
		
		private function mouseRolledOver(e:Event):void {
			this.mouseOver = true;
		}
		
		private function mouseRolledOut(e:Event):void {
			this.mouseOver = false;
		}
		
		private function cickedOnStage(e:Event):void {
			if (!this.mouseOver) {
				this.closeDropDown();
			}
		}		
						
		private function openDropDown(e:Event=null):void {
			elementsBar.visible = true;
		}
		
		private function closeDropDown():void{						
			elementsBar.visible = false;
		}
		
		private function toggleDropDown(e:Event = null):void {
			elementsBar.visible = !elementsBar.visible;
		}
		
		private function setActive(object:Object):void{					
			if (mainElement.object === object) {
				if (isDropDownOpened) {					
					closeDropDown();
				}else {
					openDropDown();
				}
			}else{			
				if(!mainElement.isEnabled){					
					setSelected(object);				
					closeDropDown();				
				}else {					
					if (isDropDownOpened) {					
						closeDropDown();
					}else {
						openDropDown();
					}
				}
			}			
		}									
		
		public function setSelected(panoramaData:Object):void {
			for each(var element:ComboboxElement in elements) {
				if (element.object === panoramaData) {
					element.isActive = true;					
				}else {
					element.isActive = false;					
				}															
			}				
			mainElement.setLabel(panoramaData);
		}				
		
		public function setEnabled(value:Boolean):void {												
			for each(var element:ComboboxElement in elements) {				
				element.isEnabled = value;
			}															
			mainElement.isEnabled = value;
		}							
	}	
}