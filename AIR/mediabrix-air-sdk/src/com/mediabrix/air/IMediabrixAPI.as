package com.mediabrix.air {

	public interface IMediabrixAPI {
				
		function load(target:String, mbrixVars:Object):void;		
		function show(target:String):void;		
		function initialize(baseURL:String, appID:String, listener:IAdEventsListener):void;		
		function onPause():void;		
		function onResume():void;
		function onDestroy():void;	
	}
	
}