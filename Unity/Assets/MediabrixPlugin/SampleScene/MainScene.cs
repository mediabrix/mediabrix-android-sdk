using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System;

public class MainScene : MonoBehaviour , MediaBrixAdEvents
{
	//This is the current staging mobile manifest
	
	public static string serverURL = "http://mobile.mediabrix.com/v2/manifest/";
//	public static string serverURL = "http://staging-mobile-manifest.mediabrix.com/v2/manifest/";

#if UNITY_METRO
    public static string appID = "bX6gANb9jt"; //"Rewu8ptiGf";//"k4L77F6VrC"; // use for PROD and MBQA
#else
	public static string appID = "TwwvxoFnJn"; //"Rewu8ptiGf";//"k4L77F6VrC"; // use for PROD and MBQA
#endif

 public static string BUILD_DATE="v1.8.0.027";

#if UNITY_IOS
	const string ViewsIdentifier = "mig_rally";
	const string FlexIdentifier = "mig_rescue";
	const string RewardsIdentifier = "mig_reward";

#elif UNITY_ANDROID
	const string ViewsIdentifier = "mig_rally";
	const string FlexIdentifier = "mig_rescue";
	const string RewardsIdentifier = "mig_reward";
#elif UNITY_WP8
    const string ViewsIdentifier = "QA_Window_Phone_Views";
    const string FlexIdentifier = "QA_Window_Phone_Flex";
    const string RewardsIdentifier = "QA_Window_Phone_Rewards";
#elif UNITY_METRO
    const string ViewsIdentifier = "QA_Windows_Views";
    const string FlexIdentifier = "QA_Windows_Flex";
    const string RewardsIdentifier = "QA_Windows_Rewards";
#endif

	const string LoadViewsTitle = "Load mig_rally";
	const string LoadingViewsTitle = "Loading mig_rally";
	const string ShowViewsTitle = "Show mig_rally";
	
	const string LoadFlexTitle = "Load mig_rescue";
	const string LoadingFlexTitle = "Loading mig_rescue";
	const string ShowFlexTitle = "Show mig_rescue";
	
	const string LoadRewardsTitle = "Load mig_reward";
	const string LoadingRewardsTitle = "Loading mig_reward";
	const string ShowRewardsTitle = "Show mig_reward";
	Dictionary<string,string> mbrixVars = new Dictionary<string, string>();
    Dictionary<string, string> DefaultMbrixVars = new Dictionary<string, string>();

	string rewardConfirmationLabel = "";
	string viewsButtonLabel = "";
	string flexButtonLabel = "";
	string rewardsButtonLabel = "";
		
	bool serviceAvailable = false;
	bool serviceConnecting = false;

	bool flexAdLoading = false;
	bool flexAdLoaded = false;
	bool flexAdShowing = false;

	bool viewsAdLoading = false;
	bool viewsAdLoaded = false;
	bool viewsAdShowing = false;
	
	bool rewardsAdLoading = false;
	bool rewardsAdLoaded = false;
	bool rewardsAdShowing = false;
	
	int viewsRewardCount = 0;
	int rewardsRewardCount = 0;
    int indexOffset = 0;

	bool useMbrixVars  = false;
	
	bool autoRotate = true;	
	bool toggleAutoRotate = true;
	
	string[] mbTextVarNames = {
						  "enticeText"
						, "title"
						, "loadingText"
						, "rescueText"
						, "rescueTitle"
						, "rewardText"
						, "rewardIcon"
						, "iconURL"
						, "useMBbutton"
						, "showConfirmation"
						, "achievementText"
						, "optinbuttonText"	
						, "useMBbutton"
						, "gameName"
                        , "top"
                        , "myfacebookid"
	};
	
	GUIStyle LabelStyle;
	GUIStyle TextStyle;

	public MainScene() {
        DefaultMbrixVars["gameName"] = "mediabrix";
        DefaultMbrixVars["uid"] = "developer";
	}
	
	public void Start () {
        Camera.main.backgroundColor = UnityEngine.Color.blue;
		float scale = Screen.width > 320.0 ? 2 : 1;
		
		LabelStyle = new GUIStyle();
		LabelStyle.alignment = TextAnchor.MiddleRight;
		LabelStyle.fontSize = (int)(12 * scale);

		TextStyle = new GUIStyle();
		TextStyle.alignment = TextAnchor.MiddleLeft;
		GUIStyleState active = new GUIStyleState();	
		active.textColor = Color.white;
		TextStyle.active = active;
		TextStyle.normal = active;
		TextStyle.focused = active;
		TextStyle.fontSize = (int)(12 * scale);
		
		mbrixVars["useMBbutton"] = "true";
        mbrixVars["enticeText"] = "test Watch this video to receive your reward!";
        mbrixVars["title"] = "test Congrats! Please watch this message from our sponsor while your next level is loading.";
        mbrixVars["rewardText"] = "test Congratulations!  Your reward is received";
        mbrixVars["rewardIcon"] = "https://mediabrix.hs.llnwd.net/o38/rewards/brands/QA_Web_Property/mediabrix/rewards_footer.png";
        mbrixVars["iconURL"] = "https://mediabrix.hs.llnwd.net/o38/rewards/brands/QA_Web_Property/mediabrix/rewards_footer.png";
		mbrixVars["showConfirmation"] = "true";
        mbrixVars["achievementText"] = "test achievement text";
        mbrixVars["loadingText"] = "test loading text";
        mbrixVars["optinbuttonText"] = "test opt in text";
        mbrixVars["rescueTitle"] = "test opt in text";
		mbrixVars["rescueText"] = "test rescue text";
        mbrixVars["top"] = "0";
        mbrixVars["myfacebookid"] = "tech@mediabrix.com";
        mbrixVars["gameName"] = "mediabrix";
        mbrixVars["uid"] = "developer";
        Screen.orientation = ScreenOrientation.AutoRotation;
        Screen.autorotateToPortrait = true;
        Screen.autorotateToLandscapeRight = true;
        Screen.autorotateToLandscapeLeft = true;
        Screen.autorotateToPortraitUpsideDown = true;
		MediabrixPlugin.Initialize(serverURL, appID, this);		
		serviceConnecting = true;
	}
	
	public void SetOrientation() {
		
		if (toggleAutoRotate != autoRotate) {
			autoRotate = toggleAutoRotate;
            Screen.orientation = autoRotate ? ScreenOrientation.AutoRotation : Screen.orientation;
            Screen.autorotateToPortrait = autoRotate;
            Screen.autorotateToLandscapeRight = autoRotate;
            Screen.autorotateToLandscapeLeft = autoRotate;
            Screen.autorotateToPortraitUpsideDown = autoRotate;
		}
		
	}
			
	public void OnStarted(string status) {
		serviceConnecting = false;
		serviceAvailable = true;
		viewsButtonLabel = LoadViewsTitle;
		flexButtonLabel = LoadFlexTitle;
		rewardsButtonLabel = LoadRewardsTitle;
		flexAdLoading = false;
		rewardsAdLoading = false;
		viewsAdLoading = false;
		print("OnStarted:" + status);
	}
	public void OnAdShown(string target){
		print ("jason: onAdShown"+target);
		if(target.Equals(ViewsIdentifier)){
			viewsButtonLabel = target +" onAdShown";
		}else if(target.Equals(FlexIdentifier)){
			flexButtonLabel = target +" onAdShown";	
		}else if(target.Equals(RewardsIdentifier)){
			rewardsButtonLabel = target +" onAdShown";
		}
	}

	public void OnAdReady(string target) {
		if (string.IsNullOrEmpty(target)) return;
		if (target.Equals(ViewsIdentifier)) {
			viewsAdLoading = false;
			viewsAdLoaded = true;
			viewsButtonLabel = ShowViewsTitle;
		} else if (target.Equals(FlexIdentifier)) {
			flexAdLoading = false;
			flexAdLoaded = true;
			flexButtonLabel = ShowFlexTitle;
		} else if (target.Equals(RewardsIdentifier)) {
			rewardsAdLoading = false;
			rewardsAdLoaded = true;
			rewardsButtonLabel = ShowRewardsTitle;
		}
		print("OnAdReady: " + target);
	}

	public void OnAdRewardConfirmation(string zone) {
		print("OnAdRewardConfirmation for Zone: " + zone);
		if (zone == null) {
			rewardConfirmationLabel = "Warning Zone NULL";
			return;
		}
		if (zone.Equals(ViewsIdentifier)) {
			viewsRewardCount++;
			rewardConfirmationLabel = "reward from " + zone + ": " + viewsRewardCount;		
		} else if (zone.Equals(RewardsIdentifier)) {
			rewardsRewardCount++;
			rewardConfirmationLabel = "reward from " + zone + ": " + rewardsRewardCount;
		}

	}
	
	public void OnAdClosed(String target) {
        Camera.main.backgroundColor = UnityEngine.Color.blue;
		if (target.Equals(ViewsIdentifier)) {
			viewsAdLoading = false;
			viewsAdLoaded = false;
			viewsAdShowing = false;
			viewsButtonLabel = LoadViewsTitle;
			print("setting ViewsButtonLabel to " + viewsButtonLabel);
		} else if (target.Equals(FlexIdentifier)) {
			flexAdLoading = false;
			flexAdLoaded = false;
			flexAdShowing = false;
			flexButtonLabel = LoadFlexTitle;
			print("setting FlexButtonLabel to " + flexButtonLabel);
		} else if (target.Equals(RewardsIdentifier)) {
			rewardsAdLoading = false;
			rewardsAdLoaded = false;
			rewardsAdShowing = false;
			rewardsButtonLabel = LoadRewardsTitle;
			print("setting RewardsButtonLabel to " + rewardsButtonLabel);
		}
		print("OnAdClosed: " + target);
	}
	
	public void OnAdUnavailable(String target) {
		if(string.IsNullOrEmpty(target)) return;

		if(target.Equals(ViewsIdentifier)) {
			viewsAdLoading = false;
			viewsAdLoaded = false;
			viewsAdShowing = false;
			viewsButtonLabel = LoadViewsTitle;
		} else if(target.Equals(FlexIdentifier)) {
			flexAdLoading = false;
			flexAdLoaded = false;
			flexAdShowing = false;
			flexButtonLabel = LoadFlexTitle;
		} else if(target.Equals(RewardsIdentifier)) {
			rewardsAdLoading = false;
			rewardsAdLoaded = false;
			rewardsAdShowing = false;
			rewardsButtonLabel = LoadRewardsTitle;
		}
		
		print("OnAdUnavailable: " + target);		
	}	
		
	public void onFlexButtonClick() {
		if (flexAdLoading) {
			flexButtonLabel = LoadingFlexTitle;
		} else if (flexAdLoaded && !flexAdShowing) {
			flexAdShowing = true;
			flexAdLoading = false;
			MediabrixPlugin.Show(FlexIdentifier);
			flexButtonLabel = "";
		} else if (!flexAdLoading) {
			flexAdLoading = true;
			flexAdShowing = false;
#if UNITY_IOS
			if (useMbrixVars) MediabrixPlugin.Load(FlexIdentifier, mbrixVars);
			else MediabrixPlugin.Load(FlexIdentifier,null);
#else
            MediabrixPlugin.Load(FlexIdentifier, useMbrixVars ? mbrixVars : DefaultMbrixVars);
#endif
			flexButtonLabel = LoadingFlexTitle;
		}
	}
	
	public void onViewsButtonClick() {
		if(viewsAdLoading) {
			viewsButtonLabel = LoadingViewsTitle;
		} else if(viewsAdLoaded && !viewsAdShowing) {
			viewsAdShowing = true;
			viewsAdLoading = false;
			MediabrixPlugin.Show(ViewsIdentifier);
			viewsButtonLabel = "";
		} else if (!viewsAdLoading) {
			viewsAdLoading = true;
			viewsAdShowing = false;
			#if UNITY_IOS
			if (useMbrixVars) MediabrixPlugin.Load(ViewsIdentifier, mbrixVars);
			else MediabrixPlugin.Load(ViewsIdentifier,null);
			#else
			MediabrixPlugin.Load(ViewsIdentifier, useMbrixVars ? mbrixVars : DefaultMbrixVars);
			#endif
			viewsButtonLabel = LoadingViewsTitle;
		}
	}

    public void onMBrixVarsCycleClicked() {
        indexOffset = (indexOffset + 1) % mbTextVarNames.Length;
    }

	public void onRewardsButtonClick() {
		if (rewardsAdLoading) {
			rewardsButtonLabel = LoadingRewardsTitle;
		} else if(rewardsAdLoaded && !rewardsAdShowing) {
			rewardsAdShowing = true;
			rewardsAdLoading = false;
			MediabrixPlugin.Show(RewardsIdentifier);
			rewardsButtonLabel = "";
		} else if (!rewardsAdLoading) {
			rewardsAdLoading = true;
			rewardsAdShowing = false;
			#if UNITY_IOS
			if (useMbrixVars) MediabrixPlugin.Load(RewardsIdentifier, mbrixVars);
			else MediabrixPlugin.Load(RewardsIdentifier, null);
			#else
			MediabrixPlugin.Load(RewardsIdentifier, useMbrixVars ? mbrixVars : DefaultMbrixVars);
			#endif
			rewardsButtonLabel = LoadingRewardsTitle;
		}
	}
	
	void OnGUI() {
		float scale = Screen.width > 320.0 ? 2 : 1;
		
		GUIStyle labelStyle = new GUIStyle();
		labelStyle.alignment = TextAnchor.MiddleCenter;
		labelStyle.normal.textColor = Color.white;
		labelStyle.fontSize = (int)(16 * scale);
		
		float centerx = Screen.width / 2;
		float verticalSpacing = 60 * scale;
		float buttonWidth = 300 * scale;
		float buttonHeight = 50* scale;
		float fontSize = 60 * scale;
		float spacing = 10;
		float labelWidth = 400 * scale;
		float labelHeight = 150 * scale;

		GUI.Label(new Rect(0, spacing, Screen.width, 20*scale), BUILD_DATE, labelStyle);
		spacing += 20*scale;
		
		GUI.Label(new Rect(0, spacing, Screen.width, 20*scale), serverURL, labelStyle);
		
		spacing += 20*scale;
		
		GUI.Label(new Rect(0, spacing, Screen.width, 20*scale), appID, labelStyle);
		
		spacing += 20*scale;
				
		//string label = serviceAvailable ? socialViewsButtonLabel : "Loading";
		if(serviceConnecting)
		{
			GUI.Label(new Rect(centerx - (labelWidth/2), 5, labelWidth, labelHeight), "Connecting", labelStyle);
		}
		else if(!serviceAvailable && !serviceConnecting)
		{	
			
			GUI.Label(new Rect(centerx - (labelWidth/2), spacing, labelWidth, labelHeight), "Service Not Available", labelStyle);

			spacing += verticalSpacing;

			if (GUI.Button(new Rect(centerx - (buttonWidth / 2), spacing, buttonWidth, buttonHeight), viewsButtonLabel, labelStyle))
			{
				serviceConnecting = true;
			}
		}
		else
		{
			if (GUI.Button(new Rect(centerx - (buttonWidth / 2), spacing, buttonWidth, buttonHeight), flexButtonLabel, labelStyle))
			{
				this.onFlexButtonClick();
			}
			
			spacing += verticalSpacing;
			
			if (GUI.Button(new Rect(centerx - (buttonWidth / 2), spacing, buttonWidth, buttonHeight), viewsButtonLabel, labelStyle))
			{
				this.onViewsButtonClick();
			}
			
			spacing += verticalSpacing;
			
			if (GUI.Button(new Rect(centerx - (buttonWidth / 2), spacing, buttonWidth, buttonHeight), rewardsButtonLabel, labelStyle))
			{
				this.onRewardsButtonClick();
			}

			spacing += verticalSpacing;

			GUI.Label(new Rect(Screen.width/2 - 100, spacing - verticalSpacing/2 , 100, 50), rewardConfirmationLabel, labelStyle);
			
			OrientationButtons(Screen.width/2,spacing);
           
            MBVarsText(0, spacing);
			
		}	
	
		// Display status
	}
	
	public void OrientationButtons(float x, float y) {
        float scale = Screen.width > 320.0 ? 2 : 1;
        GUIStyle style = new GUIStyle();
        style.alignment = TextAnchor.MiddleCenter;
        style.normal.textColor = Color.white;
        style.fontSize = (int)(16 * scale);
        toggleAutoRotate = GUI.Toggle(new Rect(x - 100, y, 200, 50), toggleAutoRotate, "Auto Rotate " + (autoRotate ? "ON" : "OFF"), style);
        SetOrientation();
	}
	
	public void MBVarsText(float x, float y) {
        float scale = Screen.width > 320.0 ? 2 : 1;
        GUIStyle style = new GUIStyle();
        style.alignment = TextAnchor.MiddleRight;
        style.normal.textColor = Color.white;
        style.fontSize = (int)(16 * scale);

        GUIStyle style2 = new GUIStyle();
        style2.alignment = TextAnchor.MiddleLeft;
        style2.normal.textColor = Color.white;
        style2.fontSize = (int)(16 * scale);

		float width = 200;
        useMbrixVars = GUI.Toggle(new Rect(x, y, 200, 50), useMbrixVars, "Mbrix Vars " + (useMbrixVars ? "ON" : "OFF"), style2);
        if (GUI.Button(new Rect(Screen.width - 200, y, 200, 50), "Cycle Vars >>", style)) {
            this.onMBrixVarsCycleClicked();
        }

		if (!useMbrixVars) return;
		for (int i=indexOffset; i < mbTextVarNames.Length + indexOffset; i++) {
            int j = i % mbTextVarNames.Length;
            GUI.Label(new Rect(x, y + (i - indexOffset + 1) * 50, width, 50), mbTextVarNames[j] + ":", style2);
            mbrixVars[mbTextVarNames[j]] = GUI.TextField(new Rect(width + 5, y + (i - indexOffset + 1) * 50, Screen.width - width - 5, 50), mbrixVars[mbTextVarNames[j]]);
		}
	}
	
}
