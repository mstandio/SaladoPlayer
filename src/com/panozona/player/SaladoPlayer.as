package com.panozona.player{
	
	import com.panozona.player.utils.Trace;
	import flash.display.Sprite;	
	import flash.events.IOErrorEvent;
	import flash.events.Event;	
	import flash.utils.ByteArray
	import flash.utils.ByteArray;	
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.System;

	import com.panosalado.model.*;
	import com.panosalado.view.*;
	import com.panosalado.controller.*;
	import com.panosalado.core.*;
	import com.panosalado.events.*;
	import com.robertpenner.easing.*;
	
	import com.panozona.player.manager.Manager;
	import com.panozona.player.manager.ManagerData;
	import com.panozona.player.manager.ManagerDataParserXML;		
	
	[SWF(width = "500", height = "375", frameRate = "30", backgroundColor = "#FFFFFF")]
	
	public class SaladoPlayer extends Sprite {		
		
		
		public var manager                  : Manager;
		public var panorama					: Panorama;
		public var stageReference			: StageReference;
		public var resizer 					: IResizer;
		public var inertialMouseCamera 		: ICamera;		
		public var keyboardCamera 			: ICamera;		
		public var autorotationCamera 		: ICamera;		
		public var simpleTransition			: SimpleTransition;		
		public var nanny					: Nanny;					
		public var managerData              : ManagerData;						
		

				
		public function SaladoPlayer() {
			super();
			var xmlLoader:URLLoader = new URLLoader();    		
			xmlLoader.dataFormat = URLLoaderDataFormat.BINARY;
    		xmlLoader.load( new URLRequest(loaderInfo.parameters.xml?loaderInfo.parameters.xml:"settings.xml"));
    		xmlLoader.addEventListener(Event.COMPLETE, onXMLLoaded);	
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
		}
		
		private function onIOError(e:IOErrorEvent):void {
			trace("xml file " + loaderInfo.parameters.xml + " not found");
		}
		
		private function onXMLLoaded(e:Event):void {						
						
			manager                 = new Manager();
			panorama 				= new Panorama(); // this is a Singleton. Don't try this again, you will get an error.
			resizer 				= new Resizer();			
			inertialMouseCamera 	= new InertialMouseCamera();			
			keyboardCamera			= new KeyboardCamera();			
			autorotationCamera 		= new AutorotationCamera();
			simpleTransition		= new SimpleTransition();			
			nanny					= new Nanny();					
			managerData	            = new ManagerData(); 			
			
			var managerDataParserXML:ManagerDataParserXML = new ManagerDataParserXML(); 			
			var input:ByteArray = e.target.data;
			try {
				input.uncompress()
			}catch (errObject:Error) { }															
			
			managerDataParserXML.configureManagerData(XML(input), managerData); 					
			
			manager.setData(managerData);
			
			manager.initialize([
				panorama,  
				DeepZoomTilePyramid,
				resizer,   				
				managerData.inertialMouseCameraData,
				inertialMouseCamera,
				managerData.keyboardCameraData, 
				keyboardCamera,
				managerData.autorotationCameraData, 
				autorotationCamera,
				managerData.simpleTransitionData,
				simpleTransition, 				
				nanny				
			]);						
			
			addChild(manager);	
			
			//FIXME : get this in better place 
			if (managerData.useTrace){
				addChild(Trace.instance);
			}		
			
			manager.loadFirstPanorama();
		}		
	}
}
		//listen for when panorama has loaded
		/*NB: 
		changing properties, adding children, etc AFTER calling loadPanorama, 
		but BEFORE the new panorama has loaded effects the current (outgoing) panorama, 
		NOT the new panorama that is being loaded.
		In other words this operation is asynchronous (because the underlying loading processes are).
		*/
		//panoSalado.addEventListener( Event.COMPLETE, panoramaLoaded, false, 0, true );  
		//listen for transition ends
		//simpleTransition.addEventListener( Event.COMPLETE, transitionComplete, false, 0, true );
		
			// set up buttons
			//ps = new PanoSaladoBitmap();
			//panoSalado.addChild(ps)
		
		/*
		
		var fsBitmap:Bitmap = new FullScreenBitmap();
		fsButton = new Sprite();
		fsButton.useHandCursor = 
			fsButton.buttonMode = true;
		panoSalado.addChild(fsButton);
		fsButton.addChild( fsBitmap );
		fsButton.addEventListener(MouseEvent.CLICK, toggleFullScreen, false, 0, true);
		
		var autorotationBitmap:Bitmap = new AutorotationBitmap();
		aButton = new Sprite()
		aButton.useHandCursor = 
			aButton.buttonMode = true;
		panoSalado.addChild(aButton);
		aButton.addChild(autorotationBitmap);
		aButton.addEventListener(MouseEvent.CLICK, toggleAutorotation, false, 0, true);
		
		var clickBitmap:Bitmap = new ClickBitmap();
		clickButton = new Sprite();
		clickButton.useHandCursor = 
			clickButton.buttonMode = true;
		panoSalado.addChild(clickButton);
		clickButton.addChild( clickBitmap );
		clickButton.addEventListener(MouseEvent.CLICK, newPath, false, 0, true);
		
		moveButtons();
		*/
		//stage.addEventListener(Event.RESIZE, moveButtons, false, 0, true);
		
		// remove me for deployment. add me at the end so I am on top of everything.
		//addChild( new Stats() );
		
		
		//panoSalado.loadPanorama( new Params("images/park2/park2_f.xml") );
		//panoSalado.loadPanorama( new Params("images/park2/park2_f.xml") );
		
		//panoSalado.loadPanorama( new Params("images/park_f.xml") );
	//}
	/*
	
	private function panoramaLoaded(e:Event):void {
		trace("loaded");
		switch (panoSalado.path) {
			case "images/park_f.xml": 
				trace("loaded park");
				// create a vector of IGraphicsData to draw on the hotspot
				var gd:Vector.<flash.display.IGraphicsData> = new Vector.<flash.display.IGraphicsData>();
				gd.push( new flash.display.GraphicsSolidFill(0xFFFFFF,0.6) );
				gd.push( new flash.display.GraphicsStroke(0.001, false, "normal", "none", "round", 3, new flash.display.GraphicsSolidFill(0xFF0000)) );
				var gp:flash.display.GraphicsPath = new flash.display.GraphicsPath();
				var hw:int = 400;
				gp.moveTo(-hw,-hw);
				gp.lineTo(hw,-hw);
				gp.lineTo(hw,hw);
				gp.lineTo(-hw,hw);
				gp.lineTo(-hw,-hw)
				gd.push(gp);
				var hotspot:VectorHotspot = new VectorHotspot( gd ); //pass vector of IGraphics Data to hotspot constructor.
				hotspot.x = -2942; //position hotspot x,y,z = (0,0,0) is where the camera is (bad place for a hotspot)
				hotspot.y = 1800;
				hotspot.z = -2942;
				// give it a name so that it can by fetched by it later
				// alternatively, (and faster performance) make it a global var.
				hotspot.name = "testing"; 
				panoSalado.addChild(hotspot);
				break;
			case "../images/Alyki-quarry_f.xml": 
				// do something here.
				break;
			default: 
				break;
		}
	}
	*/
	/*
	private function transitionComplete(e:Event):void {
				switch (panoSalado.path) {
			case "images/park_f.xml": 
				simpleTransition.removeEventListener( Event.COMPLETE, transitionComplete );
				// fetch by name. args: name:String, managed:Boolean  managed = true returns managed children, false: everybody else
				var targetChild:VectorHotspot = panoSalado._getChildByName("testing", true) as VectorHotspot; 
				panoSalado.swingToChild(targetChild, 45, 6, Linear.easeNone); // args: child, FOV, seconds, tween function with a standard signature
				panoSalado.addEventListener(PanoSaladoEvent.SWING_TO_CHILD_COMPLETE, animationComplete, false, 0, true);
				break;
			case "../images/Alyki-quarry_f.xml": 
				// do something here.
				break;
			default: 
				break;
		}
	}
	*/
	
	//private function animationComplete(e:Event):void {
//		trace( "Swing to child complete!" );
	//}
	//private var toggle:Boolean = true;
	//private function newPath(e:Event):void {
//		if (panoSalado._path == "../images/_f.xml") panoSalado.loadPanorama( new Params("../images/_f.xml", 180, 0, 170) );
		//else panoSalado.loadPanorama( new Params("../images/Alyki-quarry_f.xml", 0, 0, 50) );
		// below can be used for button controls, but I don't have the right buttons in the interface.
// 		if (toggle) {panoSalado.startInertialPan( -12.5, -12.5 ); toggle = !toggle;}
// 		else {panoSalado.stopInertialPan(); toggle = !toggle;}
	//}
	/*
	private function toggleFullScreen(e:Event):void {
		stage.displayState = (stage.displayState == "normal") ? "fullScreen" : "normal";
	}
	private function toggleAutorotation(e:Event):void {
		autorotationCameraData.enabled = !autorotationCameraData.enabled;
	}*/