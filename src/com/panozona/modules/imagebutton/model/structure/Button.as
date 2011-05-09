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
package com.panozona.modules.imagebutton.model.structure {
	
	import caurina.transitions.Equations;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Mouse;
	import com.panozona.player.module.data.property.Move;
	import com.panozona.player.module.data.property.Transition;
	import com.panozona.player.module.data.property.Tween;
	
	public class Button {
		
		public var id:String;
		public var path:String;
		public var text:String; // indended to be passed as CDATA
		public var alpha:Number = 1;
		public var align:Align = new Align(Align.LEFT, Align.TOP);
		public var move:Move = new Move(20, 20);
		public var transition:Transition = new Transition(Transition.FADE);
		public var mouse:Mouse = new Mouse();
		public var open:Boolean = true;
		public var onOpen:String; // id of action
		public var onClose:String; // id of action
		public var openTween:Tween = new Tween(Equations.easeNone, 0.5);
		public var closeTween:Tween = new Tween(Equations.easeNone, 0.5);
	}
}