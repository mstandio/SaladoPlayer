package com.panozona.player.manager.data {
	
	
	
	import flash.display.GraphicsPath;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsBitmapFill;
	import flash.display.GraphicsStroke;
	
	import flash.events.m
		
	import com.panosalado.view.VectorHotspot;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class ChildData {
		
		public var id:String;				
		public var positionData:ChildPositionData;				
		
		protected var _managedChild:VectorHotspot;
		/*
		public var graphicsPath:GraphicsPath;
		public var graphicsSolidFill:GraphicsSolidFill;
		public var graphicsBitmapFill:GraphicsBitmapFill;
		public var graphicsStroke:GraphicsStroke;
		*/
		public function ChildData() {			
			
			positionData = new ChildPositionData();
			
			//var graphicsPath:GraphicsPath;
			//var graphicsSolidFill:GraphicsSolidFill;
			//var graphicsBitmapFill:GraphicsBitmapFill;
			//var graphicsStroke:GraphicsStroke;
						
			//TODO: parse display data, determine type of managed child  
			
			//temporaty default values 			 						
			
				var gd:Vector.<flash.display.IGraphicsData> = new Vector.<flash.display.IGraphicsData>();
				gd.push( new flash.display.GraphicsSolidFill(0x00FF00, 0.6) );				
				gd.push( new GraphicsStroke(0.001, false, "normal", "none", "round", 3, new flash.display.GraphicsSolidFill(0xFF0000)) );
				var gp:flash.display.GraphicsPath = new flash.display.GraphicsPath();
				var hw:int = 400;
				gp.moveTo(-hw,-hw);
				gp.lineTo(hw,-hw);
				gp.lineTo(hw,hw);
				gp.lineTo(-hw,hw);
				
				gd.push(gp);
				_managedChild = new VectorHotspot( gd ); //pass vector of IGraphics Data to hotspot constructor.
				
				_managedChild.addEventListener(Mou)
		}		

		
		public final function get managedChild():VectorHotspot {
			if (_managedChild != null && !isNaN(positionData.pan) && !isNaN(positionData.tilt) && !isNaN(positionData.distance)) {				
				
				var piOver180:Number = Math.PI / 180;				
				var pr:Number = (-1*(positionData.pan - 90)) * piOver180; 
				var tr:Number = positionData.tilt * piOver180;
				var xc:Number = positionData.distance * Math.cos(pr) * Math.cos(tr);
				var yc:Number = positionData.distance * Math.sin(tr);
				var zc:Number = positionData.distance * Math.sin(pr) * Math.cos(tr);				
				
				_managedChild.x = xc;
				_managedChild.y = yc;
				_managedChild.z = zc;				
				
				if (id != null ) (_managedChild).name = id;
			}			
			return _managedChild;
		}
	}	
}