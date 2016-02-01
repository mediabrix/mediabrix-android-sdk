#if UNITY_WP8
using UnityEngine;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System;

public class MediabrixPluginWP8 : MonoBehaviour {
		
	private static MediaBrixAdEvents callbacks;
				
	public static void Initialize(string url, string appId, MediaBrixAdEvents callbacks) {
        MediabrixPluginWP8.callbacks = callbacks;
        MediaBrixUnityPlugin.MediabrixAPI.SetOnAdClosedDelegate(OnAdClosed);
        MediaBrixUnityPlugin.MediabrixAPI.SetOnAdReadyDelegate(OnAdReady);
        MediaBrixUnityPlugin.MediabrixAPI.SetOnAdRewardConfirmationDelegate(OnAdRewardConfirmation);
        MediaBrixUnityPlugin.MediabrixAPI.SetOnAdUnavailableDelegate(OnAdUnavailable);
        MediaBrixUnityPlugin.MediabrixAPI.SetOnStartedDelegate(OnStarted);
        MediaBrixUnityPlugin.MediabrixAPI.Initialize(url, appId);
	}
	
	public static void Load(string target, Dictionary<string, string> mbrixVars) {
        MediaBrixUnityPlugin.MediabrixAPI.Load(target, mbrixVars);
	}

	public static void Show(string target) {
        MediaBrixUnityPlugin.MediabrixAPI.Show(target);
	}

    public static void OnStarted(string statusText) {
        if (callbacks == null) return;
        callbacks.OnStarted(statusText);
    }

    public static void OnAdUnavailable(string zone, string reason) {
        if (callbacks == null) return;
        callbacks.OnAdUnavailable(zone);
    }

    public static void OnAdClosed(string zone) {
        if (callbacks == null) return;
        callbacks.OnAdClosed(zone);
    }

    public static void OnAdReady(string zone) {
        if (callbacks == null) return;
        callbacks.OnAdReady(zone);
    }

    public static void OnAdRewardConfirmation(string zone) {
        if (callbacks == null) return;
        callbacks.OnAdRewardConfirmation(zone);
    }
	
	public static void Pause() {
	}
	
	public static void Resume() {
	}
	
	public static void Destroy() {
	}

}
#endif