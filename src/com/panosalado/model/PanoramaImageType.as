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
package com.panosalado.model
{

import flash.utils.Dictionary;
import com.panosalado.model.*;

public class PanoramaImageType
{	
	public static var DEEP_ZOOM_CUBE			:String = "deepZoomCube";
	//public static var ZOOMIFY_CUBE				:String = "zoomifyCube";
	//public static var DEEP_ZOOM_EQUIRECTANGULAR	:String = "deepZoomEquirectangular";
	//public static var ZOOMIFY_EQUIRECTANGULAR	:String = "deepZoomEquirectangular";
	public static var CUBE						:String = "cube";
	//public static var EQUIRECTANGULAR			:String = "equirectangular";
	//public static var QTVR						:String = "qtvr";
	//public static var CYLINDER					:String = "cylinder";
	
	public static var concordance:Dictionary = new Dictionary();
	{
		//TODO: implement commented classes.
		concordance[DEEP_ZOOM_CUBE] 			= DeepZoomTilePyramid;
// 		concordance[ZOOMIFY_CUBE] 				= ZoomifyTilePyramid;
// 		concordance[DEEP_ZOOM_EQUIRECTANGULAR] 	= DeepZoomTilePyramid;
// 		concordance[ZOOMIFY_EQUIRECTANGULAR] 	= ZoomifyTilePyramid;
// 		concordance[CUBE] 						= EquirectangularTilePyramid;
// 		concordance[EQUIRECTANGULAR] 			= EquirectangularTilePyramid;
// 		concordance[QTVR] 						= QTVRTilePyramid;
// 		concordance[CYLINDER] 					= EquirectangularTilePyramid;
	}
}
}