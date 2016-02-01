using UnityEngine;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System;
using System.ComponentModel;
#if UNITY_ANDROID
using MediabrixPlatformPlugin = MediabrixPluginAndroid;
#elif UNITY_IPHONE
using MediabrixPlatformPlugin = MediabrixPluginIOS;
#elif UNITY_WP8
using MediabrixPlatformPlugin = MediabrixPluginWP8;
#elif UNITY_METRO
using MediabrixPlatformPlugin = MediabrixPluginWin81;
#endif

public interface MediaBrixAdEvents {

    void OnStarted(string statusText);
    void OnAdRewardConfirmation(string zone);
    void OnAdUnavailable(string zone);
    void OnAdClosed(string zone);
    void OnAdReady(string zone);

}

public class MediabrixPlugin : MonoBehaviour {
		
    public static void Initialize(string url, string appId, MediaBrixAdEvents callbacks) {
        MediabrixPlatformPlugin.Initialize(url, appId, callbacks);
    }

	public static void Load(string target, Dictionary<string,string> mbrixVars) {
		MediabrixPlatformPlugin.Load(target, mbrixVars);
	}

	public static void Show(string target) {
		MediabrixPlatformPlugin.Show(target);
	}
	
	public static void Pause() {
		MediabrixPlatformPlugin.Pause();
	}
	
	public static void Resume() {
		MediabrixPlatformPlugin.Resume();
	}
	
	public static void Destroy() {
		MediabrixPlatformPlugin.Destroy();
	}
	
}


