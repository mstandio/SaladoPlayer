function getFlashMovie(movieName) {
	var isIE = navigator.appName.indexOf("Microsoft") != -1;
	return (isIE) ? window[movieName] : document[movieName];
}


/* loads given pano*/
function callPano(panoId) {
	getFlashMovie("DIY_streetview_player").callPano(panoId);
} 


/*called on loading new pano*/
function panoChanged(panoId){
	var pano_box = document.getElementById('a_tbox');
	if (pano_box){
		pano_box.value = panoId;
	}	
	mapdata();
//	alert(panoId);
}

function viewChanged(pan, tilt, fieldOfView){	
	var tbox = document.getElementById('b_tbox');
	if (tbox){
		tbox.value = pan+" "+tilt+" "+fieldOfView;
	}	
}

