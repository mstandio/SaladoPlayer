/*
Copyright 2010 Zephyr Renner.

This file is part of PanoSalado.

PanoSalado is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

PanoSalado is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with PanoSalado. If not, see <http://www.gnu.org/licenses/>.
*/
package com.panosalado.model{
	
	import com.panosalado.events.ReadyEvent;
	import com.panosalado.events.ViewEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	/**
	* Model class. Uses a getter/setter + public underlying property style implementation to allow fast access to properties.
	* The properties should NEVER be set directly using the "_" prefixed property. The setters for all of the properties 
	* invalidate the stage, (which causes a RENDER dispatch to redraw the panorama), in addition to setting the invalid properties
	* of this class itself (invalid, invalidTransform, invalidPerspective), and setting of properties must happen via the setter
	* function for the change to be reflected in the rendered panorama.
	*/
	public class ViewData extends Sprite {
		
		/**
		* Minimum renderable field of view
		* @default 0.1
		*/
		public static const MINIMUM_FOV:Number = 0.1;
		
		/**
		* Maximum renderable field of view
		* @default 179.9
		*/
		public static const MAXIMUM_FOV:Number = 179.9;
		
		/**
		* Matrix3D recomposed from pan and tilt angles. For internal use.
		*/
		public var transformMatrix3D:Matrix3D;
		
		/**
		* PerspectiveProjection set from field of view, boundsWidth and boundsHeight. For internal use.
		*/
		public var perspectiveProjection:PerspectiveProjection;
		
		/**
		* Matrix3D from perspectiveProjection.toMatrix3d(). For internal use.
		*/
		public var perspectiveMatrix3D:Matrix3D;
		
		/**
		* Left frustum plane as determined by field of view. For internal use.
		*/
		public var frustumLeft:Vector3D;
		
		/**
		* Right frustum plane as determined by field of view. For internal use.
		*/
		public var frustumRight:Vector3D;
		
		/**
		* Top frustum plane as determined by field of view. For internal use.
		*/
		public var frustumTop:Vector3D;
		
		/**
		* Bottom frustum plane as determined by field of view. For internal use.
		*/
		public var frustumBottom:Vector3D;
		
		/**
		* Pixels per degree as determined from field of view, boundsWidth and boundsHeight. For internal use.
		*/
		public var pixelsPerDegree:Number;
		
		/**
		* Pan angle. Can be used in place of getter for faster access. Do NOT use in place of setter.
		* @see pan
		*/
		public var _pan:Number;
		
		/**
		* Tilt angle. Can be used in place of getter for faster access. Do NOT use in place of setter.
		* @see tilt
		*/
		public var _tilt:Number;
		
		/**
		* Field of view. Can be used in place of getter for faster access. Do NOT use in place of setter.
		* @see fieldOfView
		*/
		public var _fieldOfView:Number;
		
		/**
		* Tier threshold. Can be used in place of getter for faster access. Do NOT use in place of setter.
		* @see tierThreshold
		*/
		public var _tierThreshold:Number;
		
		/**
		* Width of panorama. Can be used in place of getter for faster access. Do NOT use in place of setter.
		* @see boundsWidth
		*/
		public var _boundsWidth:Number;
		
		/**
		* Height of panorama. Can be used in place of getter for faster access. Do NOT use in place of setter.
		* @see boundsHeight
		*/
		public var _boundsHeight:Number;
		
		/**
		* Path for panorama. Can be used in place of getter for faster access. Do NOT use in place of setter.
		* @see path
		*/
		public var _path:String;
		
		/**
		* Tile. Can be used in place of getter for faster access. Do NOT use in place of setter.
		* @see tile
		*/
		public var _tile:Tile;
		
		/**
		* Minimum field of view. Can be used in place of getter for faster access. Do NOT use in place of setter.
		* @see minimumFieldOfView
		*/
		public var _minimumFieldOfView:Number;
		
		/**
		* Maximum field of view. Can be used in place of getter for faster access. Do NOT use in place of setter.
		* @see maximumFieldOfView
		*/
		public var _maximumFieldOfView:Number;
		
		/**
		* Minimum pan. Can be used in place of getter for faster access. Do NOT use in place of setter.
		* @see minimumPan
		*/
		public var _minimumPan:Number;
		
		/**
		* Maximum pan. Can be used in place of getter for faster access. Do NOT use in place of setter.
		* @see maximumPan
		*/
		public var _maximumPan:Number;
		
		/**
		* Minimum tilt. Can be used in place of getter for faster access. Do NOT use in place of setter.
		* @see minimumTilt
		*/
		public var _minimumTilt:Number;
		
		/**
		* Maximum tilt. Can be used in place of getter for faster access. Do NOT use in place of setter.
		* @see maximumTilt
		*/
		public var _maximumTilt:Number;
		
		/**
		* Minimum horizontal field of view. Can be used in place of getter for faster access. Do NOT use in place of setter.
		* @see minimumHorizontalFieldOfView
		*/
		public var _minimumHorizontalFieldOfView:Number;
		
		/**
		* Maximum horizontal field of view. Can be used in place of getter for faster access. Do NOT use in place of setter.
		* @see maximumHorizontalFieldOfView
		*/
		public var _maximumHorizontalFieldOfView:Number;
		
		/**
		* Minimum vertical field of view. Can be used in place of getter for faster access. Do NOT use in place of setter.
		* @see minimumVerticalFieldOfView
		*/
		public var _minimumVerticalFieldOfView:Number;
		
		/**
		* Maximum vertical field of view. Can be used in place of getter for faster access. Do NOT use in place of setter.
		* @see maximumVerticalFieldOfView
		*/
		public var _maximumVerticalFieldOfView:Number;
		
		/**
		* Maximum pixel zoom. Can be used in place of getter for faster access. Do NOT use in place of setter.
		* @see maximumVerticalFieldOfView
		*/
		public var _maximumPixelZoom:Number;
		
		/**
		* Invalidation flag for all properties. i.e. if one of them is invalid, this must be invalid as well.
		*/
		public var invalid:Boolean;
		
		/**
		* Invalidation flag for pan and tilt, which determine the transformMatrix3D
		*/
		public var invalidTransform:Boolean;
		
		/**
		* Invalidation flag for field of view, boundsWidth and boundsHeight, which determine perspectiveProjection and perspectiveMatrix3D
		*/
		public var invalidPerspective:Boolean;
		
		/**
		* Secondary ViewData, which is used for the secondary (outgoing) panorama.
		* @see DependentViewData
		*/
		public var secondaryViewData:DependentViewData;
		
		protected var constructed:Boolean;
		
		/**
		* Constructor.
		* @param constructSecondaryViewData Boolean true. When a DependentViewData object is constructed it will pass 
		* false so that the DendentViewData object does not create its own DependentViewData into an infinite loop.
		*/
		public function ViewData(constructSecondaryViewData:Boolean = true) {
			
			super();
			
			transformMatrix3D = new Matrix3D();
			perspectiveProjection = new PerspectiveProjection();
			perspectiveMatrix3D = new Matrix3D();
			perspectiveProjection.projectionCenter = new Point(0,0);
			frustumLeft = new Vector3D(0,0,0,0);
			frustumRight = new Vector3D(0,0,0,0);
			frustumTop = new Vector3D(0,0,0,0);
			frustumBottom = new Vector3D(0,0,0,0);
			
			// initialize all vars with "default" values 
			invalid = false;
			invalidTransform = false;
			invalidPerspective = false;
			
			if (constructSecondaryViewData) secondaryViewData = new DependentViewData(this);
			
			pan = 0;
			tilt = 0;
			fieldOfView = 90;
			boundsWidth = 500; // Must be default stage size (500) to calculate FOV correctly.
			boundsHeight = 375;
			path = null;
			minimumFieldOfView = MINIMUM_FOV;
			maximumFieldOfView = MAXIMUM_FOV;
			minimumPan = Number.NEGATIVE_INFINITY;
			maximumPan = Number.POSITIVE_INFINITY;
			minimumTilt = Number.NEGATIVE_INFINITY;
			maximumTilt = Number.POSITIVE_INFINITY;
			tierThreshold = 1.0;
		}
		
		/**
		* Pan angle.
		* @default 0
		*/
		public function get pan():Number { return _pan; }
		/**
		* @private
		*/
		public function set pan(value:Number):void {
			//clamp values to -180 to 180. camera controller can do further clamping if desired.
			if (value == _pan || isNaN(value)) return;
			if (value <= -180) value = (((value + 180) % 360) + 180);
			if (value > 180) value = (((value + 180) % 360) - 180);
			if (value < _minimumPan) value = _minimumPan;
			if (value > _maximumPan) value = _maximumPan;
			_pan = value;
			invalidTransform = invalid = true;
			if (stage) stage.invalidate();
		}
		
		/**
		* Tilt angle.
		* @default 0
		*/
		public function get tilt():Number { return _tilt; }
		/**
		* @private
		*/
		public function set tilt(value:Number):void {
			//clamp values to -180 to 180. camera controller can do further clamping if desired.
			if (value == _tilt || isNaN(value) ) return; 
			if (value <= -180) value = (((value + 180) % 360) + 180);
			if (value > 180) value = (((value + 180) % 360) - 180);
			if (value < _minimumTilt) value = _minimumTilt;
			if (value > _maximumTilt) value = _maximumTilt;
			_tilt = value;
			invalidTransform = invalid = true;
			if (stage) stage.invalidate();
		}
		
		/**
		* Field of view.
		* @default 90
		*/
		public function get fieldOfView():Number { return _fieldOfView; }
		/**
		* @private
		*/
		public function set fieldOfView(value:Number):void{
			if (value == _fieldOfView || isNaN(value)) return;
			if (value < _minimumFieldOfView) value = _minimumFieldOfView;
			if (value > _maximumFieldOfView) value = _maximumFieldOfView;
			if (_fieldOfView == value) return;
			_fieldOfView = value;
			adjustLimits();
			
			invalidPerspective = invalid = true;
			if (stage) stage.invalidate();
		}
		
		/**
		* Width of rendered panorama.
		* @default 500
		*/
		public function get boundsWidth():Number { return _boundsWidth;}
		/**
		* @private
		*/
		public function set boundsWidth(value:Number):void{
			if ( _boundsWidth == value || isNaN(value) ) return;
			_boundsWidth = value;
			updateMinimumFieldOfView();
			invalidPerspective = invalid = true;
			if (stage) stage.invalidate();
			adjustLimits();
			
			dispatchEvent(new ViewEvent(ViewEvent.BOUNDS_CHANGED));
		}
		
		/**
		* Height of rendered panorama. 
		* @default 375
		*/
		public function get boundsHeight():Number { return _boundsHeight;}
		/**
		* @private
		*/
		public function set boundsHeight(value:Number):void{
			if ( _boundsHeight == value || isNaN(value) ) return;
			_boundsHeight = value;
			invalidPerspective = invalid = true;
			if (stage) stage.invalidate();
			adjustLimits();
			
			dispatchEvent(new ViewEvent(ViewEvent.BOUNDS_CHANGED));
		}
		
		/**
		* Tier Threshold. Specifies multiplier on pixels per degree which is used in the rendering cycle to 
		* determine which tier of tiles to display/load.  Can be used to blur or sharpen the 
		* rendering by forcing use of higher or lower resolution tiles.  E.g a value of 1.5 will blur the panorama. 
		* @default 1
		*/
		public function get tierThreshold():Number { return _tierThreshold; }
		/**
		* @private
		*/
		public function set tierThreshold(value:Number):void{
			if ( _tierThreshold == value || isNaN(value) ) return;
			_tierThreshold = value;
			invalidPerspective = invalid = true;
		}
		
		private function updateMinimumFieldOfView():void {
			//if ( _tile != null && (_tile.tilePyramid != null && (!isNaN(_tile.tilePyramid.width))) )   // COREMOD
			//minimumFieldOfView = (_boundsWidth / _tile.tilePyramid.width) * 90;                 // TODO:  check why i had to comment this out
		}
		
		/**
		* Path. Depending on the type of panorama images (tiled, QTVR, etc) the path will differ.
		* Note that this property changes asynchronously. In other words, after you set it,
		* accessing the value will return the previous value until the new panorama has loaded
		* sufficiently to display.
		* DeepZoom Style cubic: front face xml descriptor file
		* Zoomify cubic: front face xml descriptor file
		* cubic: front face image file
		* QTVR: .mov file
		* @default null
		*/
		public function get path():String { return _path;}
		/**
		* @private
		*/
		public function set path(value:String):void{
			if (_path == value && value != null) return;
			
			if (value == null) { //delete current tile.
				_tile = null;
				_path = null;
				invalid = true;
				if (stage) stage.invalidate();
				dispatchEvent(new ViewEvent(ViewEvent.NULL_PATH));
				return;
			}
			
			//var panoramaImageType:String = guessPanoramaImageType(value);
			//if ( panoramaImageType == null ) 
			//throw new Error("Given path: " + value + " can not be resolved to one of the types in PanoramaImageType by com.panosalado.controller.guessPanoramaImageType()");
			
			var qtc:QuadTreeCube = new QuadTreeCube(value);
			if (qtc.ready) commitPath( new ReadyEvent(ReadyEvent.READY,qtc.tilePyramid) );
			else qtc.addEventListener(ReadyEvent.READY, commitPath); //NB: do NOT use a weak event listener; tile will be gc'ed.
			/*NB: path is NOT committed yet, since it could result in unrenderable data if QuadTreeCube 
			has to load a descriptor file before it can initialize. path will be committed in commitPath
			called synchronously if quadtree cube shows ready flag after instantiation or asynchronously
			if not ready (loading descriptor).
			*/
		}
		/**
		* this is called when the QuadTreeCube, TilePyramid and root tile bitmaps are ready.
		* @private
		*/
		protected function commitPath(e:ReadyEvent,updateFOV:Boolean=true):void { 
			var tile:QuadTreeCube = e.target as QuadTreeCube;
			var path:String = e.tilePyramid.path;
			
			tile.removeEventListener(ReadyEvent.READY, commitPath); //NB: strongly referenced; must remove
			
			//push current values to secondary
			secondaryViewData._path = _path;
			secondaryViewData._tile = _tile;
			secondaryViewData.invalidTransform = secondaryViewData.invalidPerspective = secondaryViewData.invalid = true;
			
			//set current with new values
			_path = path
			_tile = tile;
			if (updateFOV) updateMinimumFieldOfView();
			invalidTransform = invalidPerspective = invalid = true;
			if (stage) stage.invalidate();
			
			//default behavior is to immediately dispose of the secondary panorama.
			//So any transition class needs to listen for the PATH event and call preventDefault() 
			//on the event object in the listener handler function
			var event:Event = new ViewEvent(ViewEvent.PATH, null, true); //NB: 3rd arg is cancelable, must be true. transitions call preventDefault().
			var success:Boolean = dispatchEvent(event);
			dispatchEvent( new Event(Event.COMPLETE));
			if (!success && (event.isDefaultPrevented())) return;
			secondaryViewData.path = null;
			
			adjustLimits();
		}
		
		/**
		* The root tile in the tile linked list data structure. Read-only. It is dependent on the path.
		*/
		public function get tile():Tile { return _tile; }
		
		/**
		* minimumFieldOfView
		* @default 0.1
		*/
		public function get minimumFieldOfView():Number { return _minimumFieldOfView; }
		/**
		* @private
		*/
		public function set minimumFieldOfView(value:Number):void {
			if (value == _minimumFieldOfView || isNaN(value)) return;
			if (value < MINIMUM_FOV) value = MINIMUM_FOV;
			if (value > MAXIMUM_FOV) value = MAXIMUM_FOV;
			if (_fieldOfView < value) fieldOfView = value;
			_minimumFieldOfView = value;
			if (_fieldOfView < value) fieldOfView = value; //check against current fieldOfView and use setter
		}
		
		/**
		* maximumFieldOfView
		* @default 179.9
		*/
		public function get maximumFieldOfView():Number { return _maximumFieldOfView; }
		/**
		* @private
		*/
		public function set maximumFieldOfView(value:Number):void{
			if (value == _maximumFieldOfView || isNaN(value)) return;
			if (value < MINIMUM_FOV) value = MINIMUM_FOV;
			if (value > MAXIMUM_FOV) value = MAXIMUM_FOV;
			_maximumFieldOfView = value;
			if (_fieldOfView > value) fieldOfView = value;  //check against current fieldOfView and use setter
		}
		
		/**
		* minimumPan
		* @default Number.NEGATIVE_INFINITY
		*/
		public function get minimumPan():Number { return _minimumPan; }
		/**
		* @private
		*/
		public function set minimumPan(value:Number):void {
			if (value == _minimumPan || isNaN(value)) return;
			_minimumPan = value;
			if (_pan < value) pan = value;
		}
		
		/**
		* maximumPan
		* @default Number.POSITIVE_INFINITY
		*/
		public function get maximumPan():Number { return _maximumPan; }
		/**
		* @private
		*/
		public function set maximumPan(value:Number):void {
			if (_maximumPan == value || isNaN(value)) return;
			_maximumPan = value;
			if (_pan > value) pan = value;
		}
		
		/**
		* minimumTilt
		* @default Number.NEGATIVE_INFINITY
		*/
		public function get minimumTilt():Number { return _minimumTilt; }
		/**
		* @private
		*/
		public function set minimumTilt(value:Number):void {
			if (value == _minimumTilt || isNaN(value)) return;
			_minimumTilt = value;
			if (_tilt < value) tilt = value;
		}
		
		/**
		* maximumTilt
		* @default Number.POSITIVE_INFINITY
		*/
		public function get maximumTilt():Number { return _maximumTilt; }
		/**
		* @private
		*/
		public function set maximumTilt(value:Number):void {
			if (value == _maximumTilt || isNaN(value)) return;
			_maximumTilt = value;
			if (_tilt > value) tilt = value;
		}
		
		/**
		* minimumHorizontalFieldOfView
		* @default NaN
		*/
		public function get minimumHorizontalFieldOfView():Number { return _minimumHorizontalFieldOfView; }
		/**
		* @private
		*/
		public function set minimumHorizontalFieldOfView(value:Number):void {
			if (value == _minimumHorizontalFieldOfView || isNaN(value)) return;
			_minimumHorizontalFieldOfView = value;
			adjustLimits();
		}
		
		/**
		* maximumHorizontalFieldOfView
		* @default NaN
		*/
		public function get maximumHorizontalFieldOfView():Number { return _maximumHorizontalFieldOfView; }
		/**
		* @private
		*/
		public function set maximumHorizontalFieldOfView(value:Number):void {
			if (value == _maximumHorizontalFieldOfView || isNaN(value)) return;
			_maximumHorizontalFieldOfView = value;
			adjustLimits();
		}
		
		/**
		* minimumVerticalFieldOfView
		* @default NaN
		*/
		public function get minimumVerticalFieldOfView():Number { return _minimumVerticalFieldOfView; }
		/**
		* @private
		*/
		public function set minimumVerticalFieldOfView(value:Number):void {
			if (value == _minimumVerticalFieldOfView || isNaN(value)) return;
			_minimumVerticalFieldOfView = value;
			adjustLimits();
		}
		
		/**
		* maximumVerticalFieldOfView
		* @default NaN
		*/
		public function get maximumVerticalFieldOfView():Number { return _maximumVerticalFieldOfView; }
		/**
		* @private
		*/
		public function set maximumVerticalFieldOfView(value:Number):void {
			if (value == _maximumVerticalFieldOfView || isNaN(value)) return;
			_maximumVerticalFieldOfView = value;
			adjustLimits();
		}
		
		/**
		* maximumPixelZoom
		* @default 1.0
		*/
		public function get maximumPixelZoom():Number { return _maximumPixelZoom; }
		/**
		* @private
		*/
		public function set maximumPixelZoom(value:Number):void {
			if (value == _maximumPixelZoom || isNaN(value)) return;
			_maximumPixelZoom = value;
			adjustLimits();
		}
		
		/**
		* Clones the properties of this view data object into another. If into arg is not null it will
		* clone into that ViewData object, otherwise it will clone into a new ViewData
		* @param into ViewData to clone into (optional, will create new if null)
		* @returns ViewData
		*/
		public function clone(into:ViewData = null):ViewData {
			var ret:ViewData = (into == null) ? new ViewData() : into;
			
			ret.secondaryViewData = secondaryViewData;
			
			ret._pan = _pan;
			ret._tilt = _tilt;
			ret._fieldOfView = _fieldOfView;
			ret._boundsWidth = _boundsWidth;
			ret._boundsHeight = _boundsHeight;
			ret._tierThreshold = _tierThreshold;
			ret._path = _path;
			ret._tile = _tile;
			ret._minimumFieldOfView = _minimumFieldOfView;
			ret._maximumFieldOfView = _maximumFieldOfView;
			ret._minimumPan = _minimumPan;
			ret._maximumPan = _maximumPan;
			ret._minimumTilt = _minimumTilt;
			ret._maximumTilt = _maximumTilt;
			ret._minimumVerticalFieldOfView = _minimumVerticalFieldOfView;
			ret._maximumVerticalFieldOfView = _maximumVerticalFieldOfView;
			ret._minimumHorizontalFieldOfView = _minimumHorizontalFieldOfView;
			ret._maximumHorizontalFieldOfView = _maximumHorizontalFieldOfView;
			ret._maximumPixelZoom = _maximumPixelZoom;
			
			ret.invalidTransform = invalidTransform;
			ret.invalidPerspective = invalidPerspective;
			ret.invalid = invalid;
			return ret;
		}
		
		/**
		* Sets minimumTilt, maximumTilt and maximumFieldOfView
		* according to minimumVerticalFieldOfView and maximumVerticalFieldOfView
		* needs to be called whenever panorama is loaded
		*/
		private function adjustLimits():void {
			
			if (isNaN(_boundsWidth) || isNaN(_boundsHeight) || isNaN(_fieldOfView)) return;
			
			if (!isNaN(_minimumVerticalFieldOfView) && !isNaN(_maximumVerticalFieldOfView) &&
				(_maximumVerticalFieldOfView - _minimumVerticalFieldOfView) < 180){
				maximumFieldOfView = (180.0/Math.PI) * 2 *
					Math.atan((_boundsWidth/_boundsHeight) *
					Math.tan((Math.PI/180) * 0.5 *
					(_maximumVerticalFieldOfView - _minimumVerticalFieldOfView)));
			}
			
			var cameraVFOV:Number = (180.0/Math.PI) * 2 *
				Math.atan((_boundsHeight/_boundsWidth) *
				Math.tan((Math.PI/180.0) * 0.5 *
				_fieldOfView));
			
			if (!isNaN(_minimumVerticalFieldOfView)) minimumTilt = _minimumVerticalFieldOfView + cameraVFOV / 2;
			if (!isNaN(_maximumVerticalFieldOfView)) maximumTilt = _maximumVerticalFieldOfView - cameraVFOV / 2;
			
			if (!isNaN(_minimumHorizontalFieldOfView)) minimumPan = _minimumHorizontalFieldOfView + _fieldOfView / 2;
			if (!isNaN(_maximumHorizontalFieldOfView)) maximumPan = _maximumHorizontalFieldOfView - _fieldOfView / 2;
			
			if (tile != null && tile.tilePyramid != null){
				var boundsDiagonal:Number = Math.sqrt(_boundsWidth * _boundsWidth + _boundsHeight * _boundsHeight);
				minimumFieldOfView = 2 * 180 / Math.PI * Math.atan(Math.tan(boundsDiagonal /
					(tile.tilePyramid.width * Math.PI * _maximumPixelZoom / 90 * _tierThreshold * 2) * Math.PI / 180 ) *
					_boundsWidth / boundsDiagonal);
			}
		}
	}
}