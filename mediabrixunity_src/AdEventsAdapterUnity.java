package com.mediabrix.unityExample;

import android.util.Log;

import com.mediabrix.android.api.IAdEventsListener;
import com.unity3d.player.UnityPlayer;

public class AdEventsAdapterUnity implements IAdEventsListener {

	final String unityClassName;
	
	public AdEventsAdapterUnity(String unityClassName) {
		this.unityClassName = unityClassName;
		try {
			Class.forName("com.unity3d.player.UnityPlayer");
		} catch (ClassNotFoundException e) {
			throw new RuntimeException(e);
		}
	}

	@Override
	public void onAdRewardConfirmation(String target) {
		Log.d("mediabrix-unity","ad reward confirmation received for " + unityClassName + " - target: " + target);
		UnityPlayer.UnitySendMessage(unityClassName, "OnAdRewardConfirmation", target);
	}

	@Override
	public void onAdClosed(String target) {
		Log.d("mediabrix-unity","ad closed event received for " + unityClassName + " - target: " + target);
		UnityPlayer.UnitySendMessage(unityClassName, "OnAdClosed", target);
	}

	@Override
	public void onAdReady(String target) {
		Log.d("mediabrix-unity","ad ready event received for " + unityClassName + " - target: " + target);
		UnityPlayer.UnitySendMessage(unityClassName, "OnAdReady", target);
	}

	@Override
	public void onAdUnavailable(String target) {
		Log.d("mediabrix-unity","ad unavailable event received for " + unityClassName + " - target: " + target);
		UnityPlayer.UnitySendMessage(unityClassName, "OnAdUnavailable", target);
	}

	@Override
	public void onStarted(String status) {
		Log.d("mediabrix-unity","started event received for " + unityClassName + " - status: " + status);
		UnityPlayer.UnitySendMessage(unityClassName, "OnStarted", status);
	}

}
