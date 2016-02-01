package com.mediabrix.unityExample;

import com.unity3d.player.UnityPlayerActivity;

public class MediabrixUnityPlayerActivity extends UnityPlayerActivity {

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
