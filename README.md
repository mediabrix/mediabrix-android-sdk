# Mediabrix Android SDK
## Please review the "Testing / Release Settings" section for new guidelines on testing and deploying your integration.

## Getting Started 

Download the latest version of the MediaBrix SDK. MediaBrix currently supports Android versions 2.3 and up.
* mediabrix-sdk-FBless.jar

### Integrating the MediaBrix SDK into Android Studio
You can either add the MediaBrix SDK jar to your project's lib folder or pull the SDK from our Maven repo. 

If you choose to add the SDK to your project's lib folder, add the following to your module-level build.gradle file:

```
dependencies {
    compile 'com.android.support:appcompat-v7:+'//At least 25.1.0 is required
    compile 'com.google.android.gms:play-services-ads:9.6.1'//At least 9.6.1 is required
    compile files('libs/mediabrix-sdk-FBless.jar')
}
```
## Modifying AndroidManifest.xml

Add the following permissions:
```
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

// WRITE_EXTERNAL_STORAGE permissions only required for API Level 18 and below
```

The following permissions are **optional**, but for increased revenue opportunity add the following permissions:
```
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.WRITE_CALENDAR"/>
```

Add the following elements within your project's Application tag:
```
<activity
     android:name="com.mediabrix.android.service.AdViewActivity"
     android:configChanges="orientation|screenSize|keyboard"
     android:hardwareAccelerated="true"
     android:theme="@android:style/Theme.Translucent.NoTitleBar.Fullscreen" >
</activity>
<activity
     android:name="com.mediabrix.android.service.ClickOutActivity"
     android:configChanges="orientation|screenSize|keyboard"
     android:hardwareAccelerated="true"
     android:theme="@android:style/Theme.Translucent.NoTitleBar.Fullscreen" >
</activity>
<service
      android:name="com.mediabrix.android.service.MediaBrixService" >
</service> 
```

## Implementing the MediaBrix SDK
 
The class in which you would like to display ads will need to implement the ``IAdEventsListener`` interface. The methods that the class will implement provides the Activity with information regarding the SDK's ad state. 


### Initialization

To initialize the MediaBrix SDK you will need to create an instance of the MediaBrixAPI object in your Activity's `onCreate()` method:
```
   MediabrixAPI.getInstance().initialize(context, BASE_URL, APP_ID, this); 
   // 'this' refers to class that is implementing IAdEventsListener
```
Your `APP_ID` will be provided to you during the MediaBrix onboarding process. Please see the next section for the appropriate `BASE_URL`.

### Testing / Release Settings

To facilitate integrations and QA around the globe, MediaBrix has deployed an open Base URL for all of our world wide network partners to use while testing the MediaBrix SDK. This Test Base URL will eliminate the need for proxying your device to the US and ensure your app receives 100% fill during testing.

* **Test Base URL:** `https://test-mobile.mediabrix.com/v2/manifest/`

* **Production Base URL:** `https://mobile.mediabrix.com/v2/manifest/`

`https://test-mobile.mediabrix.com/v2/manifest/` should **ONLY** be used for testing purposes, as it will not deliver live campaigns to your app.

It is important to ensure that after testing, the Release build of your app uses the Production Base URL. **If you release your app using the Test Base URL, your app will not receive payable MediaBrix ads.**


### The SDK Lifecycle 

The MediaBrix SDK follows the lifecycle of the Activity that will be displaying ads. The following methods are used to register, or unregister the MediaBrix service. **NOTE: if MediabrixAPI.getInstance().onResume(this) is not called you will not receive any callback methods**
```
@Override 
public void onResume() {
       MediabrixAPI.getInstance().onResume(this) ; // Registers the MediaBrix service. 
                                                   // 'this' refers Activity's context
       
       /* Only required if loading/showing ads from a secondary activity */
       MediabrixAPI.getInstance().initialize(this, BASE_URL, APP_ID, this);

       super.onResume();
} 
 
@Override
protected void onPause() {
    MediabrixAPI.getInstance().onPause(this); // Unregisters the MediaBrix service. 
                                              // 'this' refers Activity's context       
    super.onPause();
}
 
@Override
public void onDestroy() { 
 
    /* Call onDestroy if this is the LAST or ONLY activity for loading/showing ads */
 
    MediabrixAPI.getInstance().onDestroy(this);
    // 'this' refers Activity's context 
    
    super.onDestroy();
}
```

### SDK Callback Methods

Now that the lifecycle methods have implemented, the Activity can now receive callbacks from the SDK. 
```
@Override
public void onStarted(String status) {
   // MediaBrix SDK has been initialized successfully, and can now attempt to load ads.
}
 
//The target refers to zone that you are attempting to load/show 

@Override
public void onAdReady(String target) {
   // The SDK has successfully downloaded an ad, and is ready to show
}
 
@Override
public void onAdUnavailable(String target) {
  // The SDK was not able to download an ad
}

@Override
public void onAdShown(String target){
   // The user is currently viewing the ad
}
 
@Override
public void onAdRewardConfirmation(String target) {
  // The user has watched an ad that offers an incentive. 
  // The user should be granted some award. 
}

@Override
public void onAdClicked(String target){
 // The user has clicked on the ad
}
 
@Override
public void onAdClosed(String target) {
  // The ad that was being displayed to the user has been closed
}
```

### Loading an Ad
After receiving the `onStarted()` callback, the SDK is now ready to load ads. To load an ad call the method below:
```
MediabrixAPI.getInstance().load(context, target); 
//target represents the string of the zone you want to load
```
Please note, if the `onStarted()` callback has not been returned, **the ad load will automatically fail**. Ensure that you have setup your SDK callback methods as shown above, and that you are calling load only after the `onStarted()` callback has been returned.

### Showing an Ad
After receiving the `onAdReady()` callback, the SDK is ready to show the ad that you have loaded. To show an ad call the method below:
```
MediabrixAPI.getInstance().show(Context context, target); 
//target represents the string of the zone you want to show
```

### Verbose Logging
The MediaBrix SDK prints out logs to reflect what state it is in. To turn off logs printed out by the SDK use the following command:
```
MediabrixAPI.setDebug(false); //By setting setDebug to false, the SDK will not output any logs. 
```

### Proguard

Copy the following to your Proguard following:
```
-keepattributes Signature

-keep class com.mediabrix.** { *; }
-keep class com.moat.** { *; }
-keep class mdos.** { *; }

-dontwarn com.mediabrix.** 
-dontwarn com.moat.** 
-dontwarn mdos.** 
```
