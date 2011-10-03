if (window.location.search.substring(1) != "") {
	var panoId = querySt("pano");
	if (panoId != "") {
		search = panoId.split("-")
		for (var i = 0; i < (lgpx2.features.length - 1); i++) {
			feature = lgpx2.features[i];
			if (feature.attributes.ts == search[0] && feature.attributes.subsecond == search[1]) {
				showPanorama(feature);
				break;
			}
		}
	}
}
