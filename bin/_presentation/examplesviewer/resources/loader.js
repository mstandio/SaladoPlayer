function onLoaded(xmlContent){
	var newtext = document.createTextNode(xmlContent);
	returnObjById('contentArea').appendChild(newtext);
	SyntaxHighlighter.highlight();
}

function returnObjById( id ){
	if (document.getElementById)
		var returnVar = document.getElementById(id);
	else if (document.all)
		var returnVar = document.all[id];
	else if (document.layers)
		var returnVar = document.layers[id];
	return returnVar;
}