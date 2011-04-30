function getURLParam(strParamName){
	var strReturn = "";
	var strHref = window.location.href;
	if ( strHref.indexOf("?") > -1 ){
		var strQueryString = strHref.substr(strHref.indexOf("?")).toLowerCase();
		var aQueryString = strQueryString.split("&");
		for ( var iParam = 0; iParam < aQueryString.length; iParam++ ){
			if (aQueryString[iParam].indexOf(strParamName + "=") > -1 ){
				var aParam = aQueryString[iParam].split("=");
				strReturn = aParam[1];
				break;
			}
		}
	}
	return strReturn;
}