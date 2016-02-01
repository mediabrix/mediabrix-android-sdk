Mediabrix Unity Support.
=======

This projects Sample Project, cSharp code for unity, and Objective-C wrappers for the Mediabrix Objective-C SDK.

Requirements:
========

The lowest Target iOS Version should be 5.0;

Sample Project
========

To run:

 - Open the file *MediabrixPlugin/Assets/MediabrixPlugin/SampleScene/MediabrixUnitySample.unity* in Unity.
 - Open the "Build Settings" window: File -> Build Settings.
 - Switch your platform to iOS, and click the "Player Settings..." button.
 - Set the "Bundle Identifier" to com.mediabrix.unityExample.  
 - Select the MainScene game object, make sure that it has the MainScene c# file added to it, and that there are no warnings. If  there are any warning remove the MainScene from the inspector and drag the MainScene file onto MainScene again.

Building for iOS
================

Unity executes the /Editor/PostprocessBuildPlayer script after it is finished with building it own binaries, and have completed configuring the Xcode project. The /Editor/PostprocessBuildPlayer file in the sample Project is written in perl. It executes all available PostprocessBuildPlayer_* scripts.
The PostprocessBuildPlayer_Mediabrix script run the MediabrixXcodeUpdatePostBuild.pyc.

MediabrixXcodeUpdatePostBuild.pyc modifies the Xcode project:

####**Add** the following files manually from the mediabrix-ios-sdk:

 - Assets/Editor/mediabrix-ios-sdk/src/Mediabrix.h
 - Assets/Editor/mediabrix-ios-sdk/src/libMediaBrix.a
 - Assets/Editor/mediabrix-ios-sdk/bundles/MediaBrix.bundle

####The following files do not need to be manually added:
 
 - Assets/Editor/MediabrixUnityPlugin/MediabrixPlugin.mm
 - Assets/Editor/MediabrixUnityPlugin/MediabrixPlugin.h
 - Assets/Editor/MediabrixUnityPlugin/MBSettingDelegate.h
 - Assets/Editor/MediabrixUnityPlugin/MBSettingDelegate.m

####The following Frameworks will be added:

 - Twitter.framework  (Required)
 - MediaPlayer.framework  (Required)
 - QuartzCore.framework	  (Required)
 - AVFoundation.framework  (Required)
 - UIKit.framework		  (Required)
 - Foundation.framework	  (Required)
 - CoreGraphics.framework  (Required)
 - CoreTelephony.framework (required)
 - MobileCoreServices.framework (required)
 - SystemConfiguration.framework (required)
 - Social.framework  (Optional)
 - Accounts.framework  (Optional)
 - AdSupport.framework  (Optional)
####The following Dynamic libraries will be added:

 - libsqlite3.dylib  (Required)
 - libxml2.dylib	  (Required)

The script will also add the -ObjC and -all_load linker flags.

The MediabrixXcodeUpdatePostBuild.log will be available in your project folder to look at the results of the update to your xcode project.

If you can't use all_load in your project you can set "-force_load Assets/Editor/mediabrix-ios-sdk/src/libMediaBrix.a".
If you use the -force_load flag you must also remove libMediaBrix.a from "Build Phases"->"Link Binary With Libraries".