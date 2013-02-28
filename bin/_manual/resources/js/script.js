window.onload = function() {
	if (location.search) {
		var parts = location.search.substring(1).split('?');
		if (parts.length > 0) {
			document.getElementById('content').src = "resources/"+parts[0];
		}
	}
}