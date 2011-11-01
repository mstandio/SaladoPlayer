function getFlashMovie(movieName) {
	var isIE = navigator.appName.indexOf("Microsoft") != -1;
	return (isIE) ? window[movieName] : document[movieName];
}

/* This is a callback. Called on any pano change. */
function viewChanged(panoId, pan, tilt, fieldOfView){
  var features = [];
	// loop through features to find the matching one
	found ='';

	// alert("lgpx.features.length: " + lgpx.features.length);

	for (var i = 0; i < (lgpx.features.length - 1); i++) {
		feature = lgpx.features[i];
		lookingfor = feature.data.pano.slice(0, - 4)
		lookingfor = lookingfor.slice(- 6)

		// in case of match
		if (lookingfor == panoId) {

			// Display some info from the map_data.txt file about this feature
			document.getElementById("nation").innerHTML  = feature.data.nation;
			document.getElementById("country").innerHTML = feature.data.country;
			document.getElementById("town").innerHTML    = feature.data.town;
			document.getElementById("street").innerHTML  = feature.data.street;

			var	mapdirection = parseFloat(feature.data.imgdirection);
			var mapdirection = (mapdirection - pan);
			
			// projection for vectors layer
			proj1=new OpenLayers.Projection("EPSG:4326");
		  proj2=new OpenLayers.Projection("EPSG:3857");
			position=new OpenLayers.LonLat(feature.geometry.x,feature.geometry.y);
			position.transform(proj1,proj2);
			
			if (typeof indicator=="undefined") {
				indicator = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Point(feature.geometry.x,feature.geometry.y).transform(proj1,proj2),{angle: mapdirection});
				vectors.addFeatures(indicator);
			} else {
				indicator.destroy();
				indicator = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Point(feature.geometry.x,feature.geometry.y).transform(proj1,proj2),{angle: mapdirection});
				vectors.addFeatures(indicator);
			};

			// re-center map on new coordinates
	    map.setCenter(position);

			// end loop when feature found
			found = 1;
		} // end of if
		// end loop when feature found
	  if (found == 1) {
	    break;
	  };
	} // end of for
} // end of viewChanged

/* Click on map load a pano.*/
function callPano(panoId) {
	getFlashMovie("DIY_streetview_player").callPano(panoId);
}

/* in future to be used for map permalink that shows a pano "with a view".*/
function callPanoView(panoId, pan, tilt, fov) {
	getFlashMovie("DIY_streetview_player").callPanoView(panoId, pan, tilt, fov);
}

/* This is a callback. Called on loading a new pano. */
function panoChanged(panoId){
//	alert(panoId);
}

