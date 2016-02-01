#if UNITY_IPHONE
using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;
using System.Collections.Generic;

public class MediabrixPluginIOS : MonoBehaviour
{
	#region	Interface to native implementation
	
	[DllImport ("__Internal")]
	private static extern void mb_initialize_unity(string flagKey, string flagValue, string callbackHandlerName);
		
	[DllImport("__Internal")]
	private static extern void mb_load_ad_with_identifier(string identifier, string key_value_pairs_null_terminated);
	
	[DllImport ("__Internal")]
	private static extern void mb_show_ad_with_identifier(string identifier);

	#endregion
	
	#region Declarations for non-native
	
	private static string componentSeparatedStringFromDictionaryWithSeparator(Dictionary<string,string> dictionary, string separator) {
		string result = "";
		foreach (KeyValuePair<string,string> kv in dictionary) {
			result += kv.Key + separator + kv.Value + separator;
		}
		return result;
	}
	
	public static void Initialize(string url, string appId, MediaBrixAdEvents callbacks) {
		mb_initialize_unity(url, appId, callbacks.GetType().FullName);
	}
	
	public static void Load(string target, Dictionary<string,string> mbrixVars) {
		if (mbrixVars == null) {
			mb_load_ad_with_identifier(target, null);
			return;
		}
		
		string builder = "";
		foreach (KeyValuePair<string,string> kv in mbrixVars) {
			builder += kv.Key;
			builder += "|";
			builder += kv.Value;
			builder += "|";
		}
		mb_load_ad_with_identifier(target, builder);
	}

	public static void Show(string target) {
		mb_show_ad_with_identifier(target);
	}
	
	public static void Pause() {
	}
	
	public static void Resume() {
	}
	
	public static void Destroy() {
	}

    #endregion
}
#endif
