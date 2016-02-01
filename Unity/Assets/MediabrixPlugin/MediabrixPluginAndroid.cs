#if UNITY_ANDROID
using UnityEngine;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System;

public class MediabrixPluginAndroid : MonoBehaviour
{
		
	public static String flexZone 					= null;
	public static String rewardsZone 				= null;
	public static String viewsZone 					= null;
	
	private static AndroidJavaClass mediabrixClass;
	private static AndroidJavaClass _mediabrixClass151;
	
	public static AndroidJavaClass MediabrixClass151 {
		get {
			if (_mediabrixClass151 == null) {
			 AndroidJavaClass jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer"); 
			 return _mediabrixClass151 = new AndroidJavaClass("com.mediabrix.android.api.unity.MediabrixUnityAPI");
			}
			return _mediabrixClass151;
		}
	}

    public static void Initialize(string url, string appId, MediaBrixAdEvents callbacks) {
		if (Application.platform == RuntimePlatform.Android) {
			UnityEngine.AndroidJNI.AttachCurrentThread();
			print("UnityEngine.AndroidJNI.AttachCurrentThread()");
		}
		MediabrixClass151.CallStatic("initialize", url, appId, callbacks.GetType().FullName);
	}
	
	public static void Load(string target, Dictionary<string,string> mbrixVars) {
		if (mbrixVars == null) {
			MediabrixClass151.CallStatic("load", target, null);
			return;
		}
		
		string builder = "";
		foreach (KeyValuePair<string,string> kv in mbrixVars) {
			builder += kv.Key;
			builder += "|";
			builder += kv.Value;
			builder += "|";
		}
		MediabrixClass151.CallStatic("load", target, builder);
	}

	public static void Show(string target) {
		MediabrixClass151.CallStatic("show", target);
	}
	
	public static void Pause() {
		MediabrixClass151.CallStatic("onPause");
	}
	
	public static void Resume() {
		MediabrixClass151.CallStatic("onResume");
	}
	
	public static void Destroy() {
		MediabrixClass151.CallStatic("onDestroy");
	}

}
#endif