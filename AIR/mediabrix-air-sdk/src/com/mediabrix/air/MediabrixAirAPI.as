package com.mediabrix.air {

	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;


	public final class MediabrixAirAPI extends EventDispatcher implements IMediabrixAPI {
		
		private static var _instance:MediabrixAirAPI = null;
		private var extContext:ExtensionContext = null;
		private var _listener:IAdEventsListener = null;
		
		public static function get instance():MediabrixAirAPI {
			if ( !_instance ) {
				_instance = new MediabrixAirAPI();
			} else {
				trace("[MBRIX] AirAPI - using existing _instance of MediabrixAirAPI singleton");
			}
			
			return _instance;
		}

		public function MediabrixAirAPI() {
			super();
			trace("[MBRIX] AirAPI - Creating MediabrixAirAPI singleton");
			extContext = ExtensionContext.createExtensionContext( "com.mediabrix.air", "" );
			
			if ( !extContext ) {
				trace("[MBRIX] AirAPI - ext context is null!");
				throw new Error( "mediabrix api air native extension is not supported on this platform." );
			}
			
			extContext.addEventListener( StatusEvent.STATUS, onStatus );
		
		}
		
		private function onStatus( event:StatusEvent ):void {
			trace("[MBRIX] AirAPI - Event:" + event.code);
			try {
				if (_listener == null) {
					trace("[MBRIX] AirAPI - IAdEventsListener not set cannot process event " + event);
					return;
				}
		 		switch (event.code) {
					case "MediabrixAirAPI_onAdReady":
						_listener.onAdReady(event.level);
						return;
					case "MediabrixAirAPI_onAdClosed":
						_listener.onAdClosed(event.level);
						return;
					case "MediabrixAirAPI_onAdRewardConfirmation":
						_listener.onAdRewardConfirmation(event.level);
						return;
					case "MediabrixAirAPI_onAdUnavailable":
						_listener.onAdUnavailable(event.level);
						return;
					case "MediabrixAirAPI_onStarted":
						_listener.onStarted(event.level);
						return;
					default:
						trace("[MBRIX] AirAPI - unknown event.code received: " + event.code);
		 		}
			} catch (error:Error) {
				trace("[MBRIX] AirAPI - problem encountered processing status event " + event, error);
			}
		}
		
		public function dispose():void { 
			trace("[MBRIX] AirAPI - Dispose");
			extContext.dispose(); 
		}
		
		public function load(zone:String, mbrixVars:Object):void {
			trace("[MBRIX] AirAPI - Load:" + zone);
			extContext.call("load", zone, mbrixVars );
		}
		
		public function show(zone:String):void {
			trace("[MBRIX] AirAPI - Show:"+ zone);
			extContext.call("show", zone );
		}
		
		public function initialize(baseURL:String, appID:String, listener:IAdEventsListener):void {
			trace("[MBRIX] AirAPI - initialize:" + baseURL + appID);
			_listener = listener;
			extContext.call("initialize",baseURL, appID);
		}
		
		public function onPause():void {
			trace("[MBRIX] AirAPI - onPause");
			extContext.call("onPause");			
		}
		
		public function onResume():void {
			trace("[MBRIX] AirAPI - onResume");
			extContext.call("onResume");			
		}
		
		public function onDestroy():void {
			trace("[MBRIX] AirAPI - onDestroy");
			extContext.call("onDestroy");			
		}

	}
	
}