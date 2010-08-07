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
package com.panozona.modules.examplemodule.labelledbutton{
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class LabelledButton extends Sprite{
		
		private var textField:TextField;	
		
		public function LabelledButton(label:String) {			
			
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.blockIndent = 0;
			txtFormat.font = "Courier"				
			txtFormat.color = 0xffffff;			
			
			
			textField = new TextField();			
			textField .defaultTextFormat = txtFormat;
			textField.selectable = false;			
			textField.mouseEnabled = false;			
			textField.text = label;		
			textField.autoSize = TextFieldAutoSize.LEFT;
			addChild(textField);
			graphics.beginFill(0x000000);
			graphics.drawRect(0,0,textField.width,textField.height+2);
			graphics.endFill();						
			buttonMode = true;
			useHandCursor = true;						
		}		
	}
}