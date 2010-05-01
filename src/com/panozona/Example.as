package com.panozona
{

import flash.display.GraphicsBitmapFill;
import flash.display.GraphicsStroke;
import flash.display.Sprite;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.display.Bitmap;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.getQualifiedClassName;

import com.panosalado.model.*;
import com.panosalado.view.*;
import com.panosalado.controller.*;
import com.panosalado.core.*;
import com.panosalado.events.*;
import com.robertpenner.easing.*;

import com.panozona.player.manager.data.ChildData;

import profiler.*;

[SWF(width="500", height="375", frameRate="60", backgroundColor="#FFFFFF")]
public class Example extends Sprite
{
	public var panoSalado				: PanoSalado;
	
	
	public var panorama					: Panorama;
	public var stageReference			: StageReference;
	public var resizer 					: IResizer;
	public var inertialMouseCamera 		: ICamera;
	public var inertialMouseCameraData  : InertialMouseCameraData;
	public var keyboardCamera 			: ICamera;
	public var keyboardCameraData 		: KeyboardCameraData;
	public var autorotationCamera 		: ICamera;
	public var autorotationCameraData 	: AutorotationCameraData;
	public var simpleTransition			: SimpleTransition;
	public var simpleTransitionData		: SimpleTransitionData;
	public var nanny					: Nanny;
	
	// embedded bitmaps for the buttons.  Don't have to use bitmaps, can be Button class or basically anything.
	[Embed(source = "player/assets/full2.png")]
	private var FullScreenBitmap2:Class;
	[Embed(source = "player/assets/aut2.png")]
	private var AutorotationBitmap2:Class;
	[Embed(source = "player/assets/click2.png")]
	private var ClickBitmap2:Class;
	[Embed(source = "player/assets/ps.png")]
	private var PanoSaladoBitmap2:Class;
	private var fsButton:Sprite; //fullscreen button
	private var aButton:Sprite; //autorotation button
	private var ps:Bitmap; //Logo image
	private var clickButton:Sprite; //click button
	
	public var prof:Profiler;
	
	public function Example() {
		super();
		initialize();
		prof = Profiler.instance;
		addChild(prof);
		prof.x = 100;
	}
	
	private function initialize():void {		
		panoSalado = new PanoSalado();
		
		panorama 				= new Panorama(); // this is a Singleton. Don't try this again, you will get an error.
		resizer 				= new Resizer();
		inertialMouseCameraData	= new InertialMouseCameraData();
		inertialMouseCamera 	= new InertialMouseCamera();
		keyboardCameraData		= new KeyboardCameraData();
		keyboardCamera			= new KeyboardCamera();
		autorotationCameraData	= new AutorotationCameraData();
		autorotationCamera 		= new AutorotationCamera();
		simpleTransition		= new SimpleTransition();
		simpleTransitionData	= new SimpleTransitionData();
		nanny					= new Nanny();
		
		autorotationCameraData.mode = AutorotationCameraData.FRAME_INCREMENT; // or AutorotationCameraData.SPEED
		
		//pass to panoSalado all the various components that it will affect it
		/*
		All items in this list are more or less optional, e.g. remove inertialMouseCamera and the panorama will 
		not respond to mouse clicks.  Each class and its associated data object should be added or removed together.
		i.e. inertialMouseCamera will not work without its data object and its data object is superfluous without it.
		The one quasi-exception is panorama, and some object fulfilling its _function_ needs to be passed in, 
		if not it itself (i.e. some other kind of renderer).
		*/
		panoSalado.initialize([
			panorama,  // rendering engine
			DeepZoomTilePyramid,
			resizer,   // keeps render bounds sized to the stage
			inertialMouseCameraData, 
			inertialMouseCamera,
			keyboardCameraData, 
			keyboardCamera,
			autorotationCameraData, 
			autorotationCamera,
			simpleTransition, // inter-panorama transition controller
			simpleTransitionData,
			nanny // child manager (any child of PanoSalado implementing and extending IManagedChild and ManagedChild will have their position update to match the panorama and will be remove when the panorama to which they belong is no longer extant.
		]);
		
		addChild( panoSalado );
		
		
		var initialChildren:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		var childData1:ChildData = new ChildData();
				childData1.id = "1";
				childData1.positionData.pan  = 0;
				childData1.positionData.tilt = 0;
				childData1.positionData.distance = 5000;			
				
		var childData2:ChildData = new ChildData();
				childData2.id = "2";
				childData2.positionData.pan  = 30;
				childData2.positionData.tilt = 30;
				childData2.positionData.distance = 5000;					
				
		//initialChildren.push(childData1.managedChild);
		//initialChildren.push(childData2.managedChild);
		
		
		panoSalado.loadPanorama( new Params("images/park1/park_f.xml"));
		//panoSalado.loadPanorama( new Params("images/park1/park_f.xml"));
		
		//listen for when panorama has loaded
		/*NB: 
		changing properties, adding children, etc AFTER calling loadPanorama, 
		but BEFORE the new panorama has loaded effects the current (outgoing) panorama, 
		NOT the new panorama that is being loaded.
		In other words this operation is asynchronous (because the underlying loading processes are).
		*/
		panoSalado.addEventListener( Event.COMPLETE, panoramaLoaded, false, 0, true );  
		//listen for transition ends
		//simpleTransition.addEventListener( Event.COMPLETE, transitionComplete, false, 0, true );
		
		// set up buttons
		ps = new PanoSaladoBitmap2();
		panoSalado.addChild(ps)
		
		var fsBitmap:Bitmap = new FullScreenBitmap2();
		fsButton = new Sprite();
		fsButton.useHandCursor = 
			fsButton.buttonMode = true;
		panoSalado.addChild(fsButton);
		fsButton.addChild( fsBitmap );
		fsButton.addEventListener(MouseEvent.CLICK, toggleFullScreen, false, 0, true);
		
		var autorotationBitmap:Bitmap = new AutorotationBitmap2();
		aButton = new Sprite()
		aButton.useHandCursor = 
			aButton.buttonMode = true;
		panoSalado.addChild(aButton);
		aButton.addChild(autorotationBitmap);
		aButton.addEventListener(MouseEvent.CLICK, toggleAutorotation, false, 0, true);
		
		var clickBitmap:Bitmap = new ClickBitmap2();
		clickButton = new Sprite();
		clickButton.useHandCursor = 
			clickButton.buttonMode = true;
		panoSalado.addChild(clickButton);
		clickButton.addChild( clickBitmap );
		clickButton.addEventListener(MouseEvent.CLICK, newPath, false, 0, true);
		
		moveButtons();
		stage.addEventListener(Event.RESIZE, moveButtons, false, 0, true);
		
		// remove me for deployment. add me at the end so I am on top of everything.
		addChild( new Stats() );
	}
	
	private function panoramaLoaded(e:Event):void {
		switch (panoSalado.path) {
			case "images/park1/park_f.xml": 
			
			/*
				// create a vector of IGraphicsData to draw on the hotspot
				var gd:Vector.<flash.display.IGraphicsData> = new Vector.<flash.display.IGraphicsData>();
				gd.push( new flash.display.GraphicsSolidFill(0x00FF00, 0.6) );				
				gd.push( new GraphicsStroke(0.001, false, "normal", "none", "round", 3, new flash.display.GraphicsSolidFill(0xFF0000)) );
				var gp:flash.display.GraphicsPath = new flash.display.GraphicsPath();
				var hw:int = 400;
				gp.moveTo(-hw,-hw);
				gp.lineTo(hw,-hw);
				gp.lineTo(hw,hw);
				gp.lineTo(-hw,hw);
				//gp.lineTo(-hw,-hw)
				gd.push(gp);
				var hotspot:VectorHotspot = new VectorHotspot( gd ); //pass vector of IGraphics Data to hotspot constructor.
				hotspot.x = -2942; //position hotspot x,y,z = (0,0,0) is where the camera is (bad place for a hotspot)
				hotspot.y = 1800;
				hotspot.z = -2942;
				
				// give it a name so that it can by fetched by it later
				// alternatively, (and faster performance) make it a global var.
				hotspot.name = "testing"; 
			*/
			/*	
				var childData:ChildData = new ChildData();
				childData.id = "1";
				childData.positionData.pan  = 0;
				childData.positionData.tilt = 0;
				childData.positionData.distance = 5000;
			
				panoSalado.addChild(childData.managedChild);
			*/	
				
				break;
			case "../images/Alyki-quarry_f.xml": 
				// do something here.
				break;
			default: 
				break;
		}
	}
	
	private function transitionComplete(e:Event):void {
				switch (panoSalado.path) {
			case "images/park1/park_f.xml": 
				simpleTransition.removeEventListener( Event.COMPLETE, transitionComplete );
				// fetch by name. args: name:String, managed:Boolean  managed = true returns managed children, false: everybody else
				//var targetChild:VectorHotspot = panoSalado._getChildByName("testing", true) as VectorHotspot; 
				//panoSalado.swingToChild(targetChild, 45, 6, Linear.easeNone); // args: child, FOV, seconds, tween function with a standard signature
				//panoSalado.addEventListener(PanoSaladoEvent.SWING_TO_CHILD_COMPLETE, animationComplete, false, 0, true);
				break;
			case "../images/Alyki-quarry_f.xml": 
				// do something here.
				break;
			default: 
				break;
		}
	}
	
	private function animationComplete(e:Event):void {
		trace( "Swing to child complete!" );
	}
	private var toggle:Boolean = true;
	private function newPath(e:Event):void {
		if (panoSalado._path == "../images/Alyki-quarry_f.xml") panoSalado.loadPanorama( new Params("images/park1/park_f.xml", 180, 0, 170) );
		else panoSalado.loadPanorama( new Params("../images/Alyki-quarry_f.xml", 0, 0, 50) );
		// below can be used for button controls, but I don't have the right buttons in the interface.
// 		if (toggle) {panoSalado.startInertialPan( -12.5, -12.5 ); toggle = !toggle;}
// 		else {panoSalado.stopInertialPan(); toggle = !toggle;}
	}
	private function toggleFullScreen(e:Event):void {
		stage.displayState = (stage.displayState == "normal") ? "fullScreen" : "normal";
	}
	private function toggleAutorotation(e:Event):void {
		autorotationCameraData.enabled = !autorotationCameraData.enabled;
	}
	private function moveButtons(e:Event = null):void {
		ps.x = 2;
		ps.y = stage.stageHeight - 
			(ps.height + 2);
		var bl:Number = stage.stageWidth;
		bl -= 2;

		bl -= fsButton.width;
		fsButton.x = bl ;
		fsButton.y = stage.stageHeight - 
			(fsButton.height + 2);
		bl -= 2;

		bl -= aButton.width;
		aButton.x = bl;
		aButton.y = stage.stageHeight - 
			(aButton.height + 2);
		bl -= 2;

		bl -= clickButton.width;
		clickButton.x = bl;
		clickButton.y = stage.stageHeight - 
			(clickButton.height + 2);
		bl -= 2;

	}
}
}