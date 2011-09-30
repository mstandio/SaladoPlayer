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
package org.diystreetview.modules.directionfixer.view{
	
	import com.diystreetview.modules.directionfixer.data.*;
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	public class InOutView extends Sprite{
		
		[Embed(source="../assets/read.png")]
			public static var BitmapRead:Class;
		[Embed(source="../assets/write.png")]
			public static var BitmapWrite:Class;
			
		[Embed(source="../assets/close.png")]
			public static var BitmapClose:Class;
		
		public var directionFixerData:DirectionFixerData;
		
		public var closeButton:Sprite;
		public var readButton:Sprite;
		public var writeButton:Sprite;
		public var textField:TextField;
		
		public function InOutView(directionFixerData:DirectionFixerData) {
			
			this.directionFixerData = directionFixerData;
			
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = "Courier";
			textField = new TextField();
			textField.type = TextFieldType.INPUT;
			textField.width = 110;
			textField.multiline = true;
			textField.wordWrap = false;
			textField.height = 200;
			textField.textColor = 0x000000;
			textField.background = true;
			textField.backgroundColor = 0xffffff;
			textField.defaultTextFormat = txtFormat;
			textField.alwaysShowSelection = true;
			addChild(textField);
			
			closeButton = new Sprite();
			closeButton.buttonMode = true;
			closeButton.addChild(new Bitmap(new BitmapClose().bitmapData));
			addChild(closeButton);
			
			readButton = new Sprite();
			readButton.buttonMode = true;
			readButton.addChild(new Bitmap(new BitmapRead().bitmapData));
			addChild(readButton);
			
			writeButton = new Sprite();
			writeButton.buttonMode = true;
			writeButton.addChild(new Bitmap(new BitmapWrite().bitmapData));
			addChild(writeButton);
			
			visible = false;
		}
	}
}