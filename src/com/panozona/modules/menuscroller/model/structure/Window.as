/*
Copyright 2012 Marek Standio.

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
package com.panozona.modules.menuscroller.model.structure {
	
	import caurina.transitions.Equations;
	import com.panozona.player.module.data.property.Align;
	import com.panozona.player.module.data.property.Margin;
	import com.panozona.player.module.data.property.Size;
	import com.panozona.player.module.data.property.Transition;
	import com.panozona.player.module.data.property.Tween;
	
	public class Window {
		
		public const align:Align = new Align(Align.LEFT, Align.MIDDLE);
		public const margin:Margin = new Margin(0, 0, 0, 0);
		public const minSize:Size = new Size(100, 100);
		public const maxSize:Size = new Size(250, 2000);
		
		public var alpha:Number = 1.0;
		
		public var open:Boolean = true;
		public var onOpen:String = null;
		public var onClose:String = null;
		
		public const openTween:Tween = new Tween(Equations.easeNone, 0.5);
		public const closeTween:Tween = new Tween(Equations.easeNone, 0.5);
		public const transition:Transition = new Transition(Transition.SLIDE_LEFT);
	}
}