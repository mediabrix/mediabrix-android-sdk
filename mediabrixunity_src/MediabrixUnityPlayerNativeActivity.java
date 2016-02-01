package com.mediabrix.unityExample;


import com.unity3d.player.UnityPlayerNativeActivity;

public class MediabrixUnityPlayerNativeActivity extends UnityPlayerNativeActivity {
	
	@Override
	protected void onDestroy() {
		MediabrixUnityAPI.onDestroy();
		super.onDestroy();
	}

	@Override
	protected void onPause() {
		MediabrixUnityAPI.onPause();
		super.onPause();
	}

	@Override
	protected void onResume() {
		super.onResume();
		MediabrixUnityAPI.onResume();
	}

}
