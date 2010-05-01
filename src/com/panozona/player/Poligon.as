package com.panozona.player {
	
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	import com.panozona.player.manager.*;
	import com.panosalado.model.KeyboardCameraData;
	
	/**
	 * ...
	 * @author mstandio
	 */
	public class Poligon extends Sprite {
		
		private var txt:TextField;
		
		public function Poligon():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			txt = new TextField();						
			txt.width = 300;
			txt.height = 300;						
			txt.background = true;
			txt.backgroundColor = 0xffffff;
			addChild(txt);
			
			var xmlLoader:URLLoader = new URLLoader();    		
    		xmlLoader.load(new URLRequest( "settings.xml"));
    		xmlLoader.addEventListener(Event.COMPLETE, onXMLLoaded);			
		}
		
		private function onXMLLoaded(e:Event):void{
			var settings:XML = XML(e.target.data);			
			var managerDataTranslatorXML:ManagerDataTranslatorXML = new ManagerDataTranslatorXML();
			var managerData:ManagerData = managerDataTranslatorXML.getManagerData(settings);						
			txt.appendText("panoramas length: " + managerData.panoramas.length);				
			
			txt.appendText("\nfirst panorama: " + managerData.firtstPanorama);				
			txt.appendText("\nkeyboardCamera: " + managerData.keyboardCameraData.enabled);
			txt.appendText("\nkeyboardCamera sens: " + managerData.keyboardCameraData.sensitivity);
			txt.appendText("\ninertialmaouse: " + managerData.inertialMouseCameraData.enabled);
			txt.appendText("\npano1 onEnter: " + managerData.panoramas[0].onEnter);
			
			txt.appendText("\npano1 hotspots: " + managerData.panoramas[0].children.length);
			txt.appendText("\npano1 hotspots: " + managerData.panoramas[0].children[0].positionData.pan);
			
			txt.appendText("\n\n");
			txt.appendText("\nfunction: " + managerData.getActionById("act1").id);
			txt.appendText("\nfunction: " + managerData.getActionById("act1").functions.length);
			txt.appendText("\nfunction: " + managerData.getActionById("act1").functions[0].target);
			txt.appendText("\nfunction: " + managerData.getActionById("act1").functions[0].name);
			txt.appendText("\nfunction: " + managerData.getActionById("act1").functions[0].params);
			
			
						
			
			/*
			var keyboardCam:KeyboardCameraData = new KeyboardCameraData();
			var ass:Object = new Object();			
			var subAttributes:String = "sensitivity:asss, friction:666, enabled:false, sensitivity:777, neww:asssss";			
			applySubAttributes(subAttributes, keyboardCam);
			applySubAttributes(subAttributes, ass, true);			
			txt.appendText("\nsensitivity " + keyboardCam.sensitivity);
			txt.appendText("\nfriction " + keyboardCam.friction);
			txt.appendText("\nenabled " + keyboardCam.enabled);			
			txt.appendText("\nneww " +ass["neww"]);			
			*/
		}		
		
		/*		
		private function applySubAttributes(subAttributes:String, object:Object, forceNewAttributes:Boolean = false):void {
			if (subAttributes != null && subAttributes.length>0 && object != null) {				
				var subAttributesArray:Array = subAttributes.match(/([^,|\s]+):([^,|\s]+)/g); // TODO: allow spaces inside subAttribute								
				var subAttrArray:Array;
				var buffer:*;
				for (var i:Number=0; i < subAttributesArray.length ; i++ ){									
					subAttrArray = subAttributesArray[i].match(/((\w)*[^:])/g);										
					if (subAttrArray != null && subAttrArray.length == 2 ) {
						if (object.hasOwnProperty(subAttrArray[0])){
							buffer = object[subAttrArray[0]];							
							object[subAttrArray[0]] = subAttrArray[1];
							if (subAttrArray[1] == "true" || subAttrArray[1] == "false") {
								object[subAttrArray[0]] = subAttrArray[1] == "true" ? true : false;
							}							
							if (isNaN(object[subAttrArray[0]] as Number)) {
								object[subAttrArray[0]] = buffer;
							}							
							if (object[subAttrArray[0]] == null) {
								object[subAttrArray[0]] = buffer;
							}
						}else if (forceNewAttributes) {
							try{
								object[subAttrArray[0]] = subAttrArray[1];								
							}catch (errObject:Error) {
								trace("could not add property: "+subAttrArray[0]);
							}							
						}						
					}
				}				
			}
		}
		
		private static function getClass(obj:Object):Class {
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
		*/		
	}	
}