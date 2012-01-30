var xmlPath = 'resources/description_content.xml';

var currentPanoramaId;
var xmlDescription;

function onEnter(panoramaId) {
	currentPanoramaId = panoramaId;
	if (xmlDescription == null) return;
	var description = '';
	$(xmlDescription).find('description').each(function(){
		if($(this).attr('id') == currentPanoramaId){
			description = $(this).text();
		}
	});
	$('#panoDescriptionDiv').html(description);
}

$(document).ready(function () {
	$.ajax({
		type: 'GET',
		url: xmlPath,
		dataType: 'xml',
		success: onXmlLoaded,
		error: function(){alert('Could not load: '+xmlPath);}
	});
});

function onXmlLoaded(xml) {
	xmlDescription = xml;
	if (currentPanoramaId != null){
		onEnter(currentPanoramaId);
	}
}