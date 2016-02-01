package com.mediabrix.air {
	
	public interface IAdEventsListener {
		
		function onAdRewardConfirmation(zone:String):void;
		function onAdClosed(zone:String):void;
		function onAdReady(zone:String):void;
		function onAdUnavailable(zone:String):void;
		function onStarted(message:String):void;
		
	}

}