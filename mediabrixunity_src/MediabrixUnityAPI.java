package com.mediabrix.unityExample;

import java.util.HashMap;

import android.os.Handler;
import android.util.Log;

import com.mediabrix.android.api.MediabrixAPI;
import com.unity3d.player.UnityPlayer;

public class MediabrixUnityAPI {

	public static void load(String target, String mbrixVarsKeyValuePairs) {

		if (mbrixVarsKeyValuePairs == null) {
			MediabrixAPI.getInstance().load(UnityPlayer.currentActivity, target, null);
			return;
		}
		Log.d("mediabrix-unity", "received mbrixVars: " + mbrixVarsKeyValuePairs);
		HashMap<String,String> mbrixVars = new HashMap<String,String>();
		String[] parts = mbrixVarsKeyValuePairs.split("\\|");
		Log.d("mediabrix-unity", "key value pairs size is " + parts.length);
		// truncates trailing pipe and empty key if present...
		int size = parts.length / 2;
		
		for (int i = 0 ; i < size*2; i += 2) {
			String key = parts[i];
			String value = parts[i+1];
			mbrixVars.put(key, value);
		}
		
		
		MediabrixAPI.getInstance().load(UnityPlayer.currentActivity, target, mbrixVars);

		
		final Handler handler = new Handler();
		handler.postDelayed(new Runnable() {
		  @Override
		  public void run() {
		    //Do something after 100ms
			//  UnityPlayer.currentActivity.
		  }
		}, 1500);
	}

	public static void show(String target) {
		MediabrixAPI.getInstance().show(UnityPlayer.currentActivity, target);		
	}

	public static void initialize(String baseURL, String appID, String unityClassName) {
		MediabrixAPI.getInstance().initialize(UnityPlayer.currentActivity, baseURL, appID, new AdEventsAdapterUnity(unityClassName));
	}

	public static void onResume() {
		MediabrixAPI.getInstance().onResume(UnityPlayer.currentActivity);
	}

	public static void onPause() {
		MediabrixAPI.getInstance().onPause(UnityPlayer.currentActivity);
	}

	public static void onDestroy() {
		MediabrixAPI.getInstance().onDestroy(UnityPlayer.currentActivity);
	}

}
