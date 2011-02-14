/*
Copyright 2010 Zephyr Renner.

This file is part of PanoSalado.

PanoSalado is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

PanoSalado is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with PanoSalado.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.panosalado.view
{
//import performance.profiler.*;

import com.panosalado.model.QuadTreeCube;
//import com.panosalado.controller.ICamera;
//import com.panosalado.controller.IResizer;
import com.panosalado.model.Characteristics;
import com.panosalado.model.Tile;
import com.panosalado.model.TilePyramid;
import com.panosalado.model.Capicua;
import com.panosalado.model.ViewData;
//import com.panosalado.events.ReadyEvent;
//import com.panosalado.events.ViewEvent;
import com.panosalado.loading.LoadingStatistics;
import com.panosalado.loading.TileLoader;
import com.panosalado.loading.IOErrorEventHandler;
import com.panosalado.core.PanoSalado;

import flash.display.BlendMode;
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.GraphicsBitmapFill;
import flash.display.IGraphicsData;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.TimerEvent;
import flash.geom.Matrix3D;
import flash.geom.PerspectiveProjection;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Utils3D;
import flash.geom.Vector3D;
import flash.net.URLRequest;
import flash.text.TextSnapshot;
import flash.utils.Dictionary;
import flash.utils.getTimer;
import flash.utils.Timer;
import flash.display.BitmapData;

import flash.display.GraphicsStroke;
import flash.display.GraphicsSolidFill;

//import performance.profiler.*;

final public class Panorama
{
	protected var _graphicsData:Vector.<IGraphicsData>;
	protected var _tiltAroundAxis:Vector3D;
	protected var _displayingTile:Tile;
	protected var _panRawData:Vector.<Number>;
	protected var _tiltRawData:Vector.<Number>;
	protected var _transformRawData:Vector.<Number>;
	protected var _tempClippedVertices:Vector.<Number>;
	protected var _tempClippedUvtData:Vector.<Number>;
	protected var _tempPoint:Vector3D;
	protected var _referenceTransformedVertices:Vector.<Number>;
	protected var _capicua:Capicua;
	protected var _loadingStatistics:LoadingStatistics;
	
	public var dispatchEvents:Boolean;
	
	private var __loaders:Vector.<TileLoader> 		= new Vector.<TileLoader>();
	private var __urlRequest:URLRequest 			= new URLRequest();
	private var __toRadians:Number 					= Math.PI / 180;
	private var __toDegrees:Number					= 180 / Math.PI;
	private var __pi1_2:Number 						= Math.PI / 2;	
	
	private static const INSIDE:uint = 0;
	private static const OUTSIDE:uint = 1;
	private static const OUT_IN:uint = 2;
	private static const IN_OUT:uint = 3;
	
	private static var __instance:Panorama;

	
	public function Panorama() { 
		if (__instance != null) throw new Error("Panorama is a singleton class; please access the single instance with Panorama.instance.");
		
		_graphicsData = new Vector.<IGraphicsData>();
		_tiltAroundAxis = new Vector3D(0,0,0);
		_panRawData = new Vector.<Number>(16,true);
		_tiltRawData = new Vector.<Number>(16,true);
		_transformRawData = new Vector.<Number>(16,true);
		_tempClippedVertices = new Vector.<Number>();
		_tempClippedUvtData = new Vector.<Number>();
		_tempPoint = new Vector3D();
		_referenceTransformedVertices = new Vector.<Number>();
		_capicua = new Capicua();
		_loadingStatistics = LoadingStatistics.instance;
		
		dispatchEvents = true;
	}
	
	public static function get instance():Panorama {
		if (__instance == null) __instance = new Panorama();
		return __instance;
	}
	
	public function processDependency(reference:Object,characteristics:*):void {
		if (characteristics == Characteristics.VIEW_DATA) { 
			if (reference.hasOwnProperty("renderFunction"))
				(reference as PanoSalado).renderFunction = render;
		}
	}
	
	final public function render( viewData:ViewData, targetGraphics:Graphics = null):Boolean
	{ 
//if (targetGraphics) Profiler.instance.beginProfiling();
//if (targetGraphics) Profiler.instance.begin("render");
		//viewData vars. fetch them once since they are getter functions
		var pan:Number 				= viewData._pan;
		var tilt:Number 			= viewData._tilt;
		var fieldOfView:Number 		= viewData._fieldOfView;
		var boundsWidth:Number		= viewData._boundsWidth;
		var boundsHeight:Number		= viewData._boundsHeight;
		var tierThreshold:Number 	= viewData._tierThreshold;		

		var perspective:Matrix3D 		= viewData.perspectiveMatrix3D;
		var transform:Matrix3D 			= viewData.transformMatrix3D;
		var perspectiveProjection:PerspectiveProjection	= viewData.perspectiveProjection;
		var frustumLeft:Vector3D		= viewData.frustumLeft;
		var frustumRight:Vector3D		= viewData.frustumRight;
		var frustumTop:Vector3D			= viewData.frustumTop;
		var frustumBottom:Vector3D		= viewData.frustumBottom;
		var pixelsPerDegree:Number		= viewData.pixelsPerDegree;
		var tile:Tile					= viewData._tile as Tile;
		var rootTile:QuadTreeCube		= viewData._tile as QuadTreeCube;
		var displayingTile:Tile 		= rootTile.displayingTile;
		
		//variables used across blocks. no need to have multiple vars for the same functions in different blocks.
		var referenceUvtData:Vector.<Number>;
		var workingUvtData:Vector.<Number>;
		var workingIndices:Vector.<int>;
		var i:int;
		var len:int;
		var transformedVertices:Vector.<Number>;
		var referenceTransformedVertices:Vector.<Number>;
		
		
/* clear list of displaying tiles, IF being called with a render event (result of Stage.invalidate() */		
		if (targetGraphics)
		{ //function is being called as a result of Stage.invalidate();
			// loop linked list of displaying tiles setting displaying to false.
			while (displayingTile != null){ 
				var nextDisplayingTile:Tile = displayingTile.nextDisplayingTile;
				displayingTile.displaying = false;
				displayingTile.nextDisplayingTile = null;
				displayingTile = nextDisplayingTile;
			}
			_graphicsData.length = 0;
			var graphicsDataIndex:int = 0;
		}
		
/* update transform matrix because pan or tilt is invalid. API standard functions have been inlined */
		if (viewData.invalidTransform){
			var panRadians:Number = pan * __toRadians;
			var panPlus90Radians:Number = panRadians + __pi1_2;
			_tiltAroundAxis.x = Math.sin( -panPlus90Radians );
			_tiltAroundAxis.z = Math.cos( -panPlus90Radians );
			var vTilt:Vector.<Number>,
			 vPan:Vector.<Number>,
			 vTransform:Vector.<Number>,
			 sinW2:Number,
			 x:Number,
			 y:Number,
			 z:Number,
			 w:Number,
			 tiltRadians:Number;
			 tiltRadians = tilt * __toRadians;
			
			/* inlined: tilt.rawData = prependRotation( _tiltAroundAxis, viewData._tilt * __toRadians ); 
			nota bene: Matrix3D.prependRotation is relative, while prependRotation is ABSOLUTE, which is important
			because we know that this function can be called multiple times in a frame to predict and load future needed tiles.
			*/
			vTilt=_tiltRawData;
			 sinW2 = Math.sin(tiltRadians*0.5);
			 x = _tiltAroundAxis.x * sinW2;
			 y = _tiltAroundAxis.y * sinW2;
			 z = _tiltAroundAxis.z * sinW2;
			 w = Math.cos(tiltRadians*0.5);
			vTilt[0] = (1-2*y*y-2*z*z);
			vTilt[1] = (2*x*y+2*w*z);
			vTilt[2] = (2*x*z-2*w*y);
			vTilt[3]=0;
			vTilt[4] = (2*x*y-2*w*z);
			vTilt[5] = (1-2*x*x-2*z*z);
			vTilt[6] = (2*y*z+2*w*x);
			vTilt[7]=0;
			vTilt[8] = (2*x*z+2*w*y);
			vTilt[9] = (2*y*z-2*w*x);
			vTilt[10] = (1-2*x*x-2*y*y);
			vTilt[11]=0;
			vTilt[12]=0; //translation X
			vTilt[13]=0; //translation Y
			vTilt[14]=0; //translation Z
			vTilt[15]=1;
			
			//inlined pan.rawData = prependRotation( Vector3D.Y_AXIS, viewData._pan * __toRadians ); see above note
			vPan=_panRawData;
			 sinW2 = Math.sin(panRadians*0.5);
			 x = 0;
			 y = sinW2;
			 z = 0;
			 w = Math.cos(panRadians*0.5);
			vPan[0] = (1-2*y*y-2*z*z);
			vPan[1] = (2*x*y+2*w*z);
			vPan[2] = (2*x*z-2*w*y);
			vPan[3]=0;
			vPan[4] = (2*x*y-2*w*z);
			vPan[5] = (1-2*x*x-2*z*z);
			vPan[6] = (2*y*z+2*w*x);
			vPan[7]=0;
			vPan[8] = (2*x*z+2*w*y);
			vPan[9] = (2*y*z-2*w*x);
			vPan[10] = (1-2*x*x-2*y*y);
			vPan[11]=0;
			vPan[12]=0; //translation X
			vPan[13]=0; //translation Y
			vPan[14]=0; //translation Z
			vPan[15]=1;
			
			//pan = matrix3DMultiply(tilt, pan);
			vTransform = _transformRawData;
			vTransform[0] = vTilt[0] * vPan[0] + vTilt[1] * vPan[4] + vTilt[2] * vPan[8];
			vTransform[1] = vTilt[0] * vPan[1] + vTilt[1] * vPan[5] + vTilt[2] * vPan[9];
			vTransform[2] = vTilt[0] * vPan[2] + vTilt[1] * vPan[6] + vTilt[2] * vPan[10];
			vTransform[3] = vTilt[0] * vPan[3] + vTilt[1] * vPan[7] + vTilt[2] * vPan[11] + vTilt[3];
	
			vTransform[4] = vTilt[4] * vPan[0] + vTilt[5] * vPan[4] + vTilt[6] * vPan[8];
			vTransform[5] = vTilt[4] * vPan[1] + vTilt[5] * vPan[5] + vTilt[6] * vPan[9];
			vTransform[6] = vTilt[4] * vPan[2] + vTilt[5] * vPan[6] + vTilt[6] * vPan[10];
			vTransform[7] = vTilt[4] * vPan[3] + vTilt[5] * vPan[7] + vTilt[6] * vPan[11] + vTilt[7];
	
			vTransform[8] = vTilt[8] * vPan[0] + vTilt[9] * vPan[4] + vTilt[10] * vPan[8];
			vTransform[9] = vTilt[8] * vPan[1] + vTilt[9] * vPan[5] + vTilt[10] * vPan[9];
			vTransform[10] = vTilt[8] * vPan[2] + vTilt[9] * vPan[6] + vTilt[10] * vPan[10];
			vTransform[11] = vTilt[8] * vPan[3] + vTilt[9] * vPan[7] + vTilt[10] * vPan[11] + vTilt[11];
			
			vTransform[12] = 0
			vTransform[13] = 0
			vTransform[14] = 0
			vTransform[15] = 1
			
			transform.rawData = vTransform;
		}
/* field of view or view bounds have changed and need to update frustum, as well as pixels per degree of the view area. */
		if (viewData.invalidPerspective
		){
			//TODO: modify this to use the projectionCenter.
			var hFOV1_2:Number = fieldOfView * 0.5 * __toRadians;
			var boundsDiagonal:Number = Math.sqrt(boundsWidth * boundsWidth + boundsHeight * boundsHeight);
			var adjacent:Number = (boundsWidth * 0.5) / Math.tan( hFOV1_2 );
			var vFOV1_2:Number = Math.atan( (boundsHeight * 0.5) / adjacent );
			var dFOV:Number = Math.atan( (boundsDiagonal * 0.5) / adjacent ) * 2 * __toDegrees;
			pixelsPerDegree = viewData.pixelsPerDegree = (boundsDiagonal / dFOV) / tierThreshold;
			//init frustum
			var sinH:Number					= Math.sin( hFOV1_2 );
			var cosH:Number					= Math.cos( hFOV1_2 );
			var sinV:Number					= Math.sin( vFOV1_2 );
			var cosV:Number					= Math.cos( vFOV1_2 );
			//frustum planes are stored as normal (x,y,z) and distance from origin (w)
		//	x							y							z							w
			frustumLeft.x 	= cosH; 	/*0*/						frustumLeft.z = sinH; 		/*0*/				//left plane
			frustumRight.x = -cosH;		/*0*/						frustumRight.z = sinH; 		/*0*/				//right plane
			/*0*/						frustumTop.y = cosV; 		frustumTop.z = sinV; 		/*0*/				//top plane
			/*0*/						frustumBottom.y = -cosV; 	frustumBottom.z = sinV; 	/*0*/				//bottom plane
			
			perspectiveProjection.focalLength = isNaN(adjacent) ? 0.001 : adjacent; // COREMOD
			perspective = viewData.perspectiveMatrix3D = perspectiveProjection.toMatrix3D();  // NB: toMatrix3D returns a NEW object so must copy it back to _perspective too.
			/* Flash bug: with stage.scaleMode = StageScaleMode.NO_RESIZE setting 
			perspectiveProjection.fieldOfView does not update focalLength, BUT setting focalLength
			does update fieldOfView.  One workaround is to scale the resulting matrix from 
			perspectiveProjection.toMatrix3D(), but the projection then will not correctly project
			native DisplayObjects.  Setting perspectiveProjection.focalLength solves the problem.
			_projection.fieldOfView = fieldOfView;
			perspective = _perspective = _projection.toMatrix3D(); 
			// scale / 1 = boundsWidth / 500   NB: 500 is the default stage width
			var scale:Number = boundsWidth/500;
			perspective.appendScale( scale, scale, scale );
			*/
		}
		
		// determine which tiles to render (loop through quadtree)
		var capicua:Capicua = _capicua;
		// re-initialize capicua
		capicua.cap = tile;
		capicua.cua = null;
		
		selectTiles: while(tile = capicua.cap) 
		{ 
			capicua.cap = capicua.cap.next; 
//Profiler.instance.begin("clip");			
			clipVerticesBlock: { 
				transformedVertices = tile.transformedVertices;
				transformedVertices.length = 0;
				transform.transformVectors(tile.vertices, // in
									transformedVertices); // out
				//unclipped vertices will be needed for generating preview uvtData, so store them here.
				if (!tile.graphicsBitmapFill.bitmapData) {
					referenceTransformedVertices = _referenceTransformedVertices
					len = transformedVertices.length;
					referenceTransformedVertices.length = 0;
					for (i = 0; i < len; i++){ referenceTransformedVertices[i] = transformedVertices[i]; }
				}
				var tileInView:Boolean = true;
				referenceUvtData = (tile.previewUvtData.length == 0) ? tile.uvtData : tile.previewUvtData;
				workingUvtData = tile.clippedUvtData;
				workingIndices = tile.clippedIndices;
				// copy referenceUvtData
				len = referenceUvtData.length;
				workingUvtData.length = 0;
				for (i = 0; i < len; i++){ workingUvtData[i] = referenceUvtData[i] }
				//clip to each of the "side" planes, if there are no output transformedVertices, tile is out
				
				
				var dist1:Number;
				var vertexIndex:int;
				var uvtIndex:int;
				var pt0X:Number;
				var pt0Y:Number;
				var pt0Z:Number;
				var uv0U:Number; 
				var uv0V:Number; 
				var ii:int;
				var pt1X:Number;
				var pt1Y:Number;
				var pt1Z:Number;
				var uv1U:Number; 
				var uv1V:Number; 
				var dist2:Number; 
				var d:Number;
				var status:uint;
				//clipToFrustumPlane( transformedVertices, workingUvtData, frustumTop );
				clipToFrustumTop: {
					dist1 = transformedVertices[0] * frustumTop.x + transformedVertices[1] * frustumTop.y + transformedVertices[2] * frustumTop.z;
					vertexIndex = 0;
					uvtIndex = 0;
					_tempClippedVertices.length = 0;
					_tempClippedUvtData.length = 0;
					len = int(transformedVertices.length / 3);
					i = 0;
					clipLoopTop: while(i < len)
					{ 
						pt0X = transformedVertices[int(i*3)];
						pt0Y = transformedVertices[int(i*3+1)];
						pt0Z = transformedVertices[int(i*3+2)];
						uv0U = workingUvtData[int(i*3)]; 
						uv0V = workingUvtData[int(i*3+1)]; 
						
						ii = (i+1 < len) ? i+1 : 0;
						pt1X = transformedVertices[int((ii)*3)];
						pt1Y = transformedVertices[int((ii)*3+1)];
						pt1Z = transformedVertices[int((ii)*3+2)];
			
						uv1U = workingUvtData[int(ii*3)]; 
						uv1V = workingUvtData[int(ii*3+1)]; 
						
						dist2 = pt1X * frustumTop.x + pt1Y * frustumTop.y + pt1Z * frustumTop.z; 
						
						d = dist1 / (dist1-dist2);
						if (isNaN(d)) d = 1; // !important, above can give divide by 0 errors.
						
						if( dist1 < 0 && dist2 < 0 ) status = OUTSIDE;
						else if( dist1 > 0 && dist2 > 0 ) status =  INSIDE;
						else if( dist1 > 0 && dist2 < 0 ) status =  IN_OUT;	
						else status =  OUT_IN;
						
						switch( status )
						{
							case INSIDE:
								_tempClippedVertices[vertexIndex++] = pt1X;
								_tempClippedVertices[vertexIndex++] = pt1Y;
								_tempClippedVertices[vertexIndex++] = pt1Z;
								_tempClippedUvtData[uvtIndex++] = uv1U; 
								_tempClippedUvtData[uvtIndex++] = uv1V;
								_tempClippedUvtData[uvtIndex++] = 1;
								break;
						
							case IN_OUT:
								_tempClippedVertices[vertexIndex++] = pt0X + (pt1X - pt0X) * d;
								_tempClippedVertices[vertexIndex++] = pt0Y + (pt1Y - pt0Y) * d;
								_tempClippedVertices[vertexIndex++] = pt0Z + (pt1Z - pt0Z) * d;
								_tempClippedUvtData[uvtIndex++] = uv0U + (uv1U - uv0U) * d; 
								_tempClippedUvtData[uvtIndex++] = uv0V + (uv1V - uv0V) * d; 
								_tempClippedUvtData[uvtIndex++] = 1;
								break;
							
							case OUT_IN:
								_tempClippedVertices[vertexIndex++] = pt0X + (pt1X - pt0X) * d;
								_tempClippedVertices[vertexIndex++] = pt0Y + (pt1Y - pt0Y) * d;
								_tempClippedVertices[vertexIndex++] = pt0Z + (pt1Z - pt0Z) * d;
								_tempClippedVertices[vertexIndex++] = pt1X;
								_tempClippedVertices[vertexIndex++] = pt1Y;
								_tempClippedVertices[vertexIndex++] = pt1Z;
								_tempClippedUvtData[uvtIndex++] = uv0U + (uv1U - uv0U) * d; 
								_tempClippedUvtData[uvtIndex++] = uv0V + (uv1V - uv0V) * d; 
								_tempClippedUvtData[uvtIndex++] = 1;
								_tempClippedUvtData[uvtIndex++] = uv1U;
								_tempClippedUvtData[uvtIndex++] = uv1V;
								_tempClippedUvtData[uvtIndex++] = 1;
								break;
									
							default:
								break;
						}
						dist1 = dist2;
						i++;
					}
					transformedVertices.length = workingUvtData.length = 0;
					len = _tempClippedVertices.length; 
					for (i=0; i<len; i++) transformedVertices[i] = _tempClippedVertices[i];
					for (i=0; i<len; i++) workingUvtData[i]  = _tempClippedUvtData[i];
				}
					if (transformedVertices.length == 0) {
						tileInView = false; break clipVerticesBlock;
					}
				//clipToFrustumPlane( transformedVertices, workingUvtData, frustumRight );
				clipToFrustumRight: {
					dist1 = transformedVertices[0] * frustumRight.x + transformedVertices[1] * frustumRight.y + transformedVertices[2] * frustumRight.z;
					vertexIndex = 0;
					uvtIndex = 0;
					_tempClippedVertices.length = 0;
					_tempClippedUvtData.length = 0;
					len = int(transformedVertices.length / 3);
					i = 0;
					clipLoopRight: while(i < len)
					{ 
						pt0X = transformedVertices[int(i*3)];
						pt0Y = transformedVertices[int(i*3+1)];
						pt0Z = transformedVertices[int(i*3+2)];
						uv0U = workingUvtData[int(i*3)]; 
						uv0V = workingUvtData[int(i*3+1)]; 
						
						ii = (i+1 < len) ? i+1 : 0;
						pt1X = transformedVertices[int((ii)*3)];
						pt1Y = transformedVertices[int((ii)*3+1)];
						pt1Z = transformedVertices[int((ii)*3+2)];
			
						uv1U = workingUvtData[int(ii*3)]; 
						uv1V = workingUvtData[int(ii*3+1)]; 
						
						dist2 = pt1X * frustumRight.x + pt1Y * frustumRight.y + pt1Z * frustumRight.z; 
						
						d = dist1 / (dist1-dist2);
						if (isNaN(d)) d = 1; // !important, above can give divide by 0 errors.
						
						if( dist1 < 0 && dist2 < 0 ) status = OUTSIDE;
						else if( dist1 > 0 && dist2 > 0 ) status =  INSIDE;
						else if( dist1 > 0 && dist2 < 0 ) status =  IN_OUT;	
						else status =  OUT_IN;
						
						switch( status )
						{
							case INSIDE:
								_tempClippedVertices[vertexIndex++] = pt1X;
								_tempClippedVertices[vertexIndex++] = pt1Y;
								_tempClippedVertices[vertexIndex++] = pt1Z;
								_tempClippedUvtData[uvtIndex++] = uv1U; 
								_tempClippedUvtData[uvtIndex++] = uv1V;
								_tempClippedUvtData[uvtIndex++] = 1;
								break;
						
							case IN_OUT:
								_tempClippedVertices[vertexIndex++] = pt0X + (pt1X - pt0X) * d;
								_tempClippedVertices[vertexIndex++] = pt0Y + (pt1Y - pt0Y) * d;
								_tempClippedVertices[vertexIndex++] = pt0Z + (pt1Z - pt0Z) * d;
								_tempClippedUvtData[uvtIndex++] = uv0U + (uv1U - uv0U) * d; 
								_tempClippedUvtData[uvtIndex++] = uv0V + (uv1V - uv0V) * d; 
								_tempClippedUvtData[uvtIndex++] = 1;
								break;
							
							case OUT_IN:
								_tempClippedVertices[vertexIndex++] = pt0X + (pt1X - pt0X) * d;
								_tempClippedVertices[vertexIndex++] = pt0Y + (pt1Y - pt0Y) * d;
								_tempClippedVertices[vertexIndex++] = pt0Z + (pt1Z - pt0Z) * d;
								_tempClippedVertices[vertexIndex++] = pt1X;
								_tempClippedVertices[vertexIndex++] = pt1Y;
								_tempClippedVertices[vertexIndex++] = pt1Z;
								_tempClippedUvtData[uvtIndex++] = uv0U + (uv1U - uv0U) * d; 
								_tempClippedUvtData[uvtIndex++] = uv0V + (uv1V - uv0V) * d; 
								_tempClippedUvtData[uvtIndex++] = 1;
								_tempClippedUvtData[uvtIndex++] = uv1U;
								_tempClippedUvtData[uvtIndex++] = uv1V;
								_tempClippedUvtData[uvtIndex++] = 1;
								break;
									
							default:
								break;
						}
						dist1 = dist2;
						i++;
					}
					transformedVertices.length = workingUvtData.length = 0;
					len = _tempClippedVertices.length; 
					for (i=0; i<len; i++) transformedVertices[i] = _tempClippedVertices[i];
					for (i=0; i<len; i++) workingUvtData[i]  = _tempClippedUvtData[i];
				}
					if (transformedVertices.length == 0) {
						tileInView = false; break clipVerticesBlock;
					}
				//clipToFrustumPlane( transformedVertices, workingUvtData, frustumBottom);
				clipToFrustumBottom: {
					dist1 = transformedVertices[0] * frustumBottom.x + transformedVertices[1] * frustumBottom.y + transformedVertices[2] * frustumBottom.z;
					vertexIndex = 0;
					uvtIndex = 0;
					_tempClippedVertices.length = 0;
					_tempClippedUvtData.length = 0;
					len = int(transformedVertices.length / 3);
					i = 0;
					clipLoopBottom: while(i < len)
					{ 
						pt0X = transformedVertices[int(i*3)];
						pt0Y = transformedVertices[int(i*3+1)];
						pt0Z = transformedVertices[int(i*3+2)];
						uv0U = workingUvtData[int(i*3)]; 
						uv0V = workingUvtData[int(i*3+1)]; 
						
						ii = (i+1 < len) ? i+1 : 0;
						pt1X = transformedVertices[int((ii)*3)];
						pt1Y = transformedVertices[int((ii)*3+1)];
						pt1Z = transformedVertices[int((ii)*3+2)];
			
						uv1U = workingUvtData[int(ii*3)]; 
						uv1V = workingUvtData[int(ii*3+1)]; 
						
						dist2 = pt1X * frustumBottom.x + pt1Y * frustumBottom.y + pt1Z * frustumBottom.z; 
						
						d = dist1 / (dist1-dist2);
						if (isNaN(d)) d = 1; // !important, above can give divide by 0 errors.
						
						if( dist1 < 0 && dist2 < 0 ) status = OUTSIDE;
						else if( dist1 > 0 && dist2 > 0 ) status =  INSIDE;
						else if( dist1 > 0 && dist2 < 0 ) status =  IN_OUT;	
						else status =  OUT_IN;
						
						switch( status )
						{
							case INSIDE:
								_tempClippedVertices[vertexIndex++] = pt1X;
								_tempClippedVertices[vertexIndex++] = pt1Y;
								_tempClippedVertices[vertexIndex++] = pt1Z;
								_tempClippedUvtData[uvtIndex++] = uv1U; 
								_tempClippedUvtData[uvtIndex++] = uv1V;
								_tempClippedUvtData[uvtIndex++] = 1;
								break;
						
							case IN_OUT:
								_tempClippedVertices[vertexIndex++] = pt0X + (pt1X - pt0X) * d;
								_tempClippedVertices[vertexIndex++] = pt0Y + (pt1Y - pt0Y) * d;
								_tempClippedVertices[vertexIndex++] = pt0Z + (pt1Z - pt0Z) * d;
								_tempClippedUvtData[uvtIndex++] = uv0U + (uv1U - uv0U) * d; 
								_tempClippedUvtData[uvtIndex++] = uv0V + (uv1V - uv0V) * d; 
								_tempClippedUvtData[uvtIndex++] = 1;
								break;
							
							case OUT_IN:
								_tempClippedVertices[vertexIndex++] = pt0X + (pt1X - pt0X) * d;
								_tempClippedVertices[vertexIndex++] = pt0Y + (pt1Y - pt0Y) * d;
								_tempClippedVertices[vertexIndex++] = pt0Z + (pt1Z - pt0Z) * d;
								_tempClippedVertices[vertexIndex++] = pt1X;
								_tempClippedVertices[vertexIndex++] = pt1Y;
								_tempClippedVertices[vertexIndex++] = pt1Z;
								_tempClippedUvtData[uvtIndex++] = uv0U + (uv1U - uv0U) * d; 
								_tempClippedUvtData[uvtIndex++] = uv0V + (uv1V - uv0V) * d; 
								_tempClippedUvtData[uvtIndex++] = 1;
								_tempClippedUvtData[uvtIndex++] = uv1U;
								_tempClippedUvtData[uvtIndex++] = uv1V;
								_tempClippedUvtData[uvtIndex++] = 1;
								break;
									
							default:
								break;
						}
						dist1 = dist2;
						i++;
					}
					transformedVertices.length = workingUvtData.length = 0;
					len = _tempClippedVertices.length; 
					for (i=0; i<len; i++) transformedVertices[i] = _tempClippedVertices[i];
					for (i=0; i<len; i++) workingUvtData[i]  = _tempClippedUvtData[i];
				}
					if (transformedVertices.length == 0) {
						tileInView = false; break clipVerticesBlock;
					}
				//clipToFrustumPlane( transformedVertices, workingUvtData, frustumLeft);
				clipToFrustumLeft: {
					dist1 = transformedVertices[0] * frustumLeft.x + transformedVertices[1] * frustumLeft.y + transformedVertices[2] * frustumLeft.z;
					vertexIndex = 0;
					uvtIndex = 0;
					_tempClippedVertices.length = 0;
					_tempClippedUvtData.length = 0;
					len = int(transformedVertices.length / 3);
					i = 0;
					clipLoopLeft: while(i < len)
					{ 
						pt0X = transformedVertices[int(i*3)];
						pt0Y = transformedVertices[int(i*3+1)];
						pt0Z = transformedVertices[int(i*3+2)];
						uv0U = workingUvtData[int(i*3)]; 
						uv0V = workingUvtData[int(i*3+1)]; 
						
						ii = (i+1 < len) ? i+1 : 0;
						pt1X = transformedVertices[int((ii)*3)];
						pt1Y = transformedVertices[int((ii)*3+1)];
						pt1Z = transformedVertices[int((ii)*3+2)];
			
						uv1U = workingUvtData[int(ii*3)]; 
						uv1V = workingUvtData[int(ii*3+1)]; 
						
						dist2 = pt1X * frustumLeft.x + pt1Y * frustumLeft.y + pt1Z * frustumLeft.z; 
						
						d = dist1 / (dist1-dist2);
						if (isNaN(d)) d = 1; // !important, above can give divide by 0 errors.
						
						if( dist1 < 0 && dist2 < 0 ) status = OUTSIDE;
						else if( dist1 > 0 && dist2 > 0 ) status =  INSIDE;
						else if( dist1 > 0 && dist2 < 0 ) status =  IN_OUT;	
						else status =  OUT_IN;
						
						switch( status )
						{
							case INSIDE:
								_tempClippedVertices[vertexIndex++] = pt1X;
								_tempClippedVertices[vertexIndex++] = pt1Y;
								_tempClippedVertices[vertexIndex++] = pt1Z;
								_tempClippedUvtData[uvtIndex++] = uv1U; 
								_tempClippedUvtData[uvtIndex++] = uv1V;
								_tempClippedUvtData[uvtIndex++] = 1;
								break;
						
							case IN_OUT:
								_tempClippedVertices[vertexIndex++] = pt0X + (pt1X - pt0X) * d;
								_tempClippedVertices[vertexIndex++] = pt0Y + (pt1Y - pt0Y) * d;
								_tempClippedVertices[vertexIndex++] = pt0Z + (pt1Z - pt0Z) * d;
								_tempClippedUvtData[uvtIndex++] = uv0U + (uv1U - uv0U) * d; 
								_tempClippedUvtData[uvtIndex++] = uv0V + (uv1V - uv0V) * d; 
								_tempClippedUvtData[uvtIndex++] = 1;
								break;
							
							case OUT_IN:
								_tempClippedVertices[vertexIndex++] = pt0X + (pt1X - pt0X) * d;
								_tempClippedVertices[vertexIndex++] = pt0Y + (pt1Y - pt0Y) * d;
								_tempClippedVertices[vertexIndex++] = pt0Z + (pt1Z - pt0Z) * d;
								_tempClippedVertices[vertexIndex++] = pt1X;
								_tempClippedVertices[vertexIndex++] = pt1Y;
								_tempClippedVertices[vertexIndex++] = pt1Z;
								_tempClippedUvtData[uvtIndex++] = uv0U + (uv1U - uv0U) * d; 
								_tempClippedUvtData[uvtIndex++] = uv0V + (uv1V - uv0V) * d; 
								_tempClippedUvtData[uvtIndex++] = 1;
								_tempClippedUvtData[uvtIndex++] = uv1U;
								_tempClippedUvtData[uvtIndex++] = uv1V;
								_tempClippedUvtData[uvtIndex++] = 1;
								break;
									
							default:
								break;
						}
						dist1 = dist2;
						i++;
					}
					transformedVertices.length = workingUvtData.length = 0;
					len = _tempClippedVertices.length; 
					for (i=0; i<len; i++) transformedVertices[i] = _tempClippedVertices[i];
					for (i=0; i<len; i++) workingUvtData[i]  = _tempClippedUvtData[i];
				}
					if (transformedVertices.length == 0) {
						tileInView = false; break clipVerticesBlock;
					}
				/* write new indices: e.g. triangle FAB, FBC, FCD, FDE where BC and DE have been clipped to frustum.
			   A _______ B
				|       \
				|        \  C
				|         | 
				|________/  D
			   F         E
				*/
				tile.clippedIndices.length = 0;
				var currIndex_cvb:int = 1;
				len = int((transformedVertices.length / 3 - 2) * 3);
				for (i = 0; i < len; i+=3) { 
					workingIndices[i] = 0;
					workingIndices[int(i+1)] = currIndex_cvb++;
					workingIndices[int(i+2)] = currIndex_cvb;
				}
				tile.graphicsTrianglePath.indices = workingIndices;
				tile.graphicsTrianglePath.uvtData = workingUvtData;
				break clipVerticesBlock;
			}
//Profiler.instance.end("clip");
			if (!tileInView)
			{	// put tl child tile at head of capicua -> continue with NEXT tile.
				if (tile.n != null) {tile.n.next = capicua.cap; if (capicua.cap) capicua.cap.prev = tile.n; capicua.cap = tile.n;} 
				else {if (capicua.cua != null) capicua.cua.next = null;}
				continue selectTiles; 
			}
			if(tile.ppd < pixelsPerDegree && tile.tl != null){ 
				//put tl child tile at head of capicua -> go down quadTree looking for higher res tiles
				if (tile.tl != null) {tile.tl.next = capicua.cap; if (capicua.cap) capicua.cap.prev = tile.tl; capicua.cap = tile.tl;} 
				else {if (capicua.cua != null) capicua.cua.next = null;}
				// put tl child tile at head of capicua -> go to next tile as well
				if (tile.n != null) {tile.n.next = capicua.cap; if (capicua.cap) capicua.cap.prev = tile.n; capicua.cap = tile.n;} 
				else {if (capicua.cua != null) capicua.cua.next = null;}
				continue selectTiles;
			}
			// put next tile at head of capicua.
			if (tile.n != null) {tile.n.next = capicua.cap; if (capicua.cap) capicua.cap.prev = tile.n; capicua.cap = tile.n;} 
			else {if (capicua.cua != null) capicua.cua.next = null;}
			/* tile has been selected. ***************************/
			
			// check if tile needs loading and temporary uvtData and bitmapData
			// check tile.graphicsBitmapFill.bitmapData instead of bitmapData so that this won't execute next frame.
			if ( !tile.bitmapLoading && !tile.bitmapLoaded )
			{ 
				var tileLoader:TileLoader;
				if (__loaders.length > 0) { tileLoader = __loaders[__loaders.length-1]; __loaders.length--; }
				else 
					tileLoader = new TileLoader(); 
				__urlRequest.url = tile.url;  //trace("tilw "+tile.url);
				//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, 	tile.bitmapLoadedHandler, 	false, 1, true);
				tileLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, 	bitmapLoadedHandler,		false, 0, true); 
				tileLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, 	IOErrorEventHandler, 	false, 0, true);
				tileLoader.tile = tile;
				tileLoader.timeStamp = flash.utils.getTimer();
				tileLoader.viewData = viewData;
				tileLoader.load(__urlRequest);
				tile.bitmapLoading = true;
			}

			if (!tile.graphicsBitmapFill.bitmapData){ 	
				// walk UP the quadtree looking for the first tile with bitmapData and use that as a preview tile.
				var parentTile:Tile = tile.p;
				findValidParentTile: while(parentTile != null)
				{ 
					if (parentTile.bitmapData != null){ 	
						/* found valid parent tile, adjust uvtData so that it will be appropriate for the parent tile */
						var tp:TilePyramid = tile.tilePyramid;
						var mult:int = 1 << (tile.t - parentTile.t);
						var upt1:Number = (parentTile.c+1) * mult * tp.tileSize;
						var vpt1:Number = (parentTile.r+1) * mult * tp.tileSize;
						if ( upt1 > tp.widths[tile.t]) upt1 = tp.widths[tile.t];
						if ( vpt1 > tp.heights[tile.t]) vpt1 = tp.heights[tile.t];
						var uBegin:Number = (tile.c - (parentTile.c * mult)) * tp.tileSize / (upt1 - parentTile.c * mult * tp.tileSize);
						var vBegin:Number = (tile.r - (parentTile.r * mult)) * tp.tileSize / (vpt1 - parentTile.r * mult * tp.tileSize);
						var uEnd:Number = ((tile.c+1) - (parentTile.c * mult)) * tp.tileSize / (upt1 - parentTile.c * mult * tp.tileSize);
						var vEnd:Number = ((tile.r+1) - (parentTile.r * mult)) * tp.tileSize / (vpt1 - parentTile.r * mult * tp.tileSize);
						if ( uEnd > 1 ) uEnd = 1;
						if ( vEnd > 1 ) vEnd = 1;
						var uRange:Number = uEnd - uBegin;
						var vRange:Number = vEnd - vBegin;
						workingUvtData = tile.previewUvtData;
						referenceUvtData = tile.uvtData;
						i = 0; len = referenceUvtData.length;
						// calculate uvtData for preview tile. 
						while (i<len) {	
							workingUvtData[i] 	= uBegin + referenceUvtData[i] * uRange; i++;
							workingUvtData[i] 	= vBegin + referenceUvtData[i] * vRange; i++;
							workingUvtData[i] 	= -1; i++;
						}
						// copy uvtData and bitmapData over to graphicsData
						tile.graphicsTrianglePath.uvtData = tile.previewUvtData = workingUvtData;
						tile.graphicsBitmapFill.bitmapData = parentTile.bitmapData;
						
						// add tile to displaying tile list and set displaying
						if (displayingTile) { displayingTile.nextDisplayingTile = tile; displayingTile = tile; }
						else { _displayingTile = displayingTile = tile; }
						displayingTile.displaying = true;						
						
						clipReferenceVerticesBlock: { 
							//transformedVertices.length = 0;
							//transform.transformVectors(tile.vertices, // in
							//					transformedVertices); // out
							transformedVertices = referenceTransformedVertices;
							referenceUvtData = tile.previewUvtData;
							workingUvtData = tile.clippedUvtData;
							len = referenceUvtData.length;
							workingUvtData.length = 0;
							for (i = 0; i < len; i++){ workingUvtData[i] = referenceUvtData[i] }
							clipToFrustumPlane( transformedVertices, workingUvtData, frustumTop );
							clipToFrustumPlane( transformedVertices, workingUvtData, frustumRight );
							clipToFrustumPlane( transformedVertices, workingUvtData, frustumBottom);
							clipToFrustumPlane( transformedVertices, workingUvtData, frustumLeft);
							tile.graphicsTrianglePath.uvtData = workingUvtData;
							break clipReferenceVerticesBlock;
						}
						
						break findValidParentTile; // done creating adjusted uvtData.
					}
					parentTile = parentTile.p; // continue with next parent tile up the list.
				}
			}
			
			// final check to make sure fill has bitmapData and to check that function was called by Stage.invalidate(): (if (event) );
			if (tile.graphicsBitmapFill.bitmapData && (targetGraphics))
			{					
				// update displaying tile list and mark current tile.
				if (displayingTile) { // the displayingTile list already contains at least one tile.
					displayingTile.nextDisplayingTile = tile; //write link from displayingTile to this tile.
					displayingTile = tile; //switch displayingTile reference to this tile.
				}
				else { 
					rootTile.displayingTile = displayingTile = tile; //start off the displayingTile list and save reference to first tile in QuadTreeCube.
				}
				displayingTile.displaying = true; // set displaying.

				tile.graphicsTrianglePath.vertices.length = 0;
				Utils3D.projectVectors(perspective, transformedVertices, // in
								   tile.graphicsTrianglePath.vertices, tile.graphicsTrianglePath.uvtData); // out	
				_graphicsData[graphicsDataIndex++] = tile.graphicsBitmapFill;
				_graphicsData[graphicsDataIndex++] = tile.graphicsTrianglePath;
			}
		}
		// end quadtree loop
		// check that stage was checked by Stage.invalidate() and render scene.
		if ( targetGraphics && _graphicsData.length > 0) { 
			targetGraphics.clear();
			targetGraphics.drawGraphicsData(_graphicsData);
//if (targetGraphics) Profiler.instance.end("render");
//if (targetGraphics) Profiler.instance.endProfiling();
			return (_graphicsData.length > 0);
		}
//if (targetGraphics) Profiler.instance.end("render");
//if (targetGraphics) Profiler.instance.endProfiling();
		return false;
	}
	
	//private var stroke : GraphicsStroke = new GraphicsStroke(0.001, false, "normal", "none", "round", 3, new GraphicsSolidFill(0xFF0000));
	
	protected function clipToFrustumPlane( vertices:Vector.<Number>, uvtData:Vector.<Number>, plane:Vector3D):void
	{ 
		var dist1:Number = vertices[0] * plane.x + vertices[1] * plane.y + vertices[2] * plane.z;
		var vertexIndex:int = 0;
		var uvtIndex:int = 0;
		_tempClippedVertices.length = 0;
		_tempClippedUvtData.length = 0;
		var len:int, i:int;
		len = int(vertices.length / 3);
		i = 0;
		clipLoop: while(i < len)
		{ 
			var pt0X:Number = vertices[int(i*3)];
			var pt0Y:Number = vertices[int(i*3+1)];
			var pt0Z:Number = vertices[int(i*3+2)];
			var uv0U:Number = uvtData[int(i*3)]; 
			var uv0V:Number = uvtData[int(i*3+1)]; 
			
			var ii:int = (i+1 < len) ? i+1 : 0;
			var pt1X:Number = vertices[int((ii)*3)];
			var pt1Y:Number = vertices[int((ii)*3+1)];
			var pt1Z:Number = vertices[int((ii)*3+2)];

			var uv1U:Number = uvtData[int(ii*3)]; 

			var uv1V:Number = uvtData[int(ii*3+1)]; 
			//_tempPoint.x = pt1X; _tempPoint.y = pt1Y; _tempPoint.z = pt1Z;
			//var dist2:Number = plane.dotProduct(_tempPoint);
			var dist2:Number = pt1X * plane.x + pt1Y * plane.y + pt1Z * plane.z; 
			
			var d:Number = dist1 / (dist1-dist2);
			if (isNaN(d)) d = 1; // !important, above can give divide by 0 errors.
			
			var status:uint;
			if( dist1 < 0 && dist2 < 0 )
				status = OUTSIDE;
			else if( dist1 > 0 && dist2 > 0 )
				status =  INSIDE;
			else if( dist1 > 0 && dist2 < 0 )
				status =  IN_OUT;	
			else
				status =  OUT_IN;
			
			switch( status )
			{
				case INSIDE:
					_tempClippedVertices[vertexIndex++] = pt1X;
					_tempClippedVertices[vertexIndex++] = pt1Y;
					_tempClippedVertices[vertexIndex++] = pt1Z;
					_tempClippedUvtData[uvtIndex++] = uv1U; 
					_tempClippedUvtData[uvtIndex++] = uv1V;
					_tempClippedUvtData[uvtIndex++] = 1;
					break;
			
				case IN_OUT:
					_tempClippedVertices[vertexIndex++] = pt0X + (pt1X - pt0X) * d;
					_tempClippedVertices[vertexIndex++] = pt0Y + (pt1Y - pt0Y) * d;
					_tempClippedVertices[vertexIndex++] = pt0Z + (pt1Z - pt0Z) * d;
 					_tempClippedUvtData[uvtIndex++] = uv0U + (uv1U - uv0U) * d; 
					_tempClippedUvtData[uvtIndex++] = uv0V + (uv1V - uv0V) * d; 
					_tempClippedUvtData[uvtIndex++] = 1;
					break;
				
				case OUT_IN:
					_tempClippedVertices[vertexIndex++] = pt0X + (pt1X - pt0X) * d;
					_tempClippedVertices[vertexIndex++] = pt0Y + (pt1Y - pt0Y) * d;
					_tempClippedVertices[vertexIndex++] = pt0Z + (pt1Z - pt0Z) * d;
					_tempClippedVertices[vertexIndex++] = pt1X;
					_tempClippedVertices[vertexIndex++] = pt1Y;
					_tempClippedVertices[vertexIndex++] = pt1Z;
					_tempClippedUvtData[uvtIndex++] = uv0U + (uv1U - uv0U) * d; 
					_tempClippedUvtData[uvtIndex++] = uv0V + (uv1V - uv0V) * d; 
					_tempClippedUvtData[uvtIndex++] = 1;
					_tempClippedUvtData[uvtIndex++] = uv1U;
					_tempClippedUvtData[uvtIndex++] = uv1V;
					_tempClippedUvtData[uvtIndex++] = 1;
					break;
						
				default:
					break;
			}
			dist1 = dist2;
			i++;
		}
		vertices.length = uvtData.length = 0;
		len = _tempClippedVertices.length; 
		for (i=0; i<len; i++) vertices[i] = _tempClippedVertices[i];
		for (i=0; i<len; i++) uvtData[i]  = _tempClippedUvtData[i];
	}
	
	//TODO: make this static? function so that Tile.rootParentLoadComplete handler is the same...
	final public function bitmapLoadedHandler(event:Event):void
	{
		var loaderInfo:LoaderInfo = LoaderInfo(event.target);
		var tileLoader:TileLoader = loaderInfo.loader as TileLoader;
		var tile:Tile = tileLoader.tile
		tile.bitmapLoading = false;
		tile.bitmapLoaded = true;
		tile.previewUvtData.length = 0;
		tile.bitmapData = tile.graphicsBitmapFill.bitmapData = (loaderInfo.content as Bitmap).bitmapData;
		tile.graphicsTrianglePath.uvtData = tile.uvtData;
		if ( tile.t > 0 ){
			var expirationTimer:Timer;
			if (tile.expirationTimer != null) expirationTimer = tile.expirationTimer;
			//else expirationTimer = tile.expirationTimer = new Timer( 180000/(1<<tile.t) );
			else expirationTimer = tile.expirationTimer = new Timer( 90000 );
			expirationTimer.addEventListener( TimerEvent.TIMER, tile.expirationHandler, false, 0, true);
			expirationTimer.start();
		}
		var viewData:ViewData = tileLoader.viewData;
		viewData.invalid = viewData.invalidPerspective = true;
		if (viewData.stage != null) viewData.stage.invalidate();
		
		_loadingStatistics.reportLatency( getTimer() - tileLoader.timeStamp)
		
		loaderInfo.removeEventListener( Event.COMPLETE, bitmapLoadedHandler );
		loaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, IOErrorEventHandler );
		tileLoader.tile = null;
		tileLoader.timeStamp = NaN;
		tileLoader.viewData = null; 
		__loaders[ __loaders.length ] = tileLoader;
	}
	
// 	public function get canvas():Sprite { return _canvas; }
// 	public function get secondaryCanvas():Sprite { return _secondaryCanvas; }
// 	public function get canvasInternal():Sprite { return canvasInternal; }
// 	public function get secondaryCanvasInternal():Sprite { return _secondaryCanvasInternal; }
// 	public function get managedChildren():Sprite { return _managedChildren; }
// 	public function get secondaryManagedChildren():Sprite { return _secondaryManagedChildren; }
// 	public function get children():Sprite { return _children; };
	
// 	protected function clearGraphics(e:Event):void { 
// 		if (_viewData._path == null) 					_canvasInternal.graphics.clear(); 
// 		if (_viewData.secondaryViewData._path == null) 	_secondaryCanvasInternal.graphics.clear(); 
// 	}
	
}
}



// 	protected function prependRotation(axis:Vector3D, angle:Number):Vector.<Number> {
// 		var v:Vector.<Number>=new Vector.<Number>(16,true);
// 		var sinW2:Number = Math.sin(angle*0.5);
// 		var x:Number = axis.x * sinW2;
// 		var y:Number = axis.y * sinW2;
// 		var z:Number = axis.z * sinW2;
// 		var w:Number = Math.cos(angle*0.5);
// 		v[0] = (1-2*y*y-2*z*z);
// 		v[1] = (2*x*y+2*w*z);
// 		v[2] = (2*x*z-2*w*y);
// 		v[3]=0;
// 		v[4] = (2*x*y-2*w*z);
// 		v[5] = (1-2*x*x-2*z*z);
// 		v[6] = (2*y*z+2*w*x);
// 		v[7]=0;
// 		v[8] = (2*x*z+2*w*y);
// 		v[9] = (2*y*z-2*w*x);
// 		v[10] = (1-2*x*x-2*y*y);
// 		v[11]=0;
// 		v[12]=0; //translation X
// 		v[13]=0; //translation Y
// 		v[14]=0; //translation Z
// 		v[15]=1;
// 		return v;
// 	}
// 	
// 	protected function matrix3DMultiply(lhs:Matrix3D, rhs:Matrix3D):Matrix3D
// 	{
// 		var v:Vector.<Number> = new Vector.<Number>();
// 		var l:Vector.<Number> = lhs.rawData;
// 		var r:Vector.<Number> = rhs.rawData;
// 		
// 		v[0] = l[0] * r[0] + l[1] * r[4] + l[2] * r[8];
// 		v[1] = l[0] * r[1] + l[1] * r[5] + l[2] * r[9];
// 		v[2] = l[0] * r[2] + l[1] * r[6] + l[2] * r[10];
// 		v[3] = l[0] * r[3] + l[1] * r[7] + l[2] * r[11] + l[3];
// 
// 		v[4] = l[4] * r[0] + l[5] * r[4] + l[6] * r[8];
// 		v[5] = l[4] * r[1] + l[5] * r[5] + l[6] * r[9];
// 		v[6] = l[4] * r[2] + l[5] * r[6] + l[6] * r[10];
// 		v[7] = l[4] * r[3] + l[5] * r[7] + l[6] * r[11] + l[7];
// 
// 		v[8] = l[8] * r[0] + l[9] * r[4] + l[10] * r[8];
// 		v[9] = l[8] * r[1] + l[9] * r[5] + l[10] * r[9];
// 		v[10] = l[8] * r[2] + l[9] * r[6] + l[10] * r[10];
// 		v[11] = l[8] * r[3] + l[9] * r[7] + l[10] * r[11] + l[11];
// 		
// 		v[12] = 0
// 		v[13] = 0
// 		v[14] = 0
// 		v[15] = 1
// 		lhs.rawData = v;
// 		return lhs;
// 	}



// 		var rotationX:Number = -gimbal.rotationX * Math.PI/180;
// 		var rotationY:Number = -pano.rotationY * Math.PI/180;
// 		var facing:Vector3D = new Vector3D(
// 			Math.sin( rotationY ) * Math.cos( rotationX ), 
// 			-Math.sin( rotationX ),
// 			Math.cos( rotationY ) * Math.cos( rotationX )
// 		);